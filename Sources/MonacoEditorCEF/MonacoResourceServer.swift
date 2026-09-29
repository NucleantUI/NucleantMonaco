//
//  MonacoResourceServer.swift
//  MonacoEditorCEF
//
//  The editor page's files, served to CEF over loopback HTTP.
//
//  The page needs `fetch` (the gzipped wasm module) and web workers (Monaco's
//  editor worker), and Chromium allows neither for `file://` pages. So the
//  bundle is served from 127.0.0.1 on a port the system picks, under a random
//  path prefix only this process knows — a request without it gets a 404, so
//  nothing else on the machine can read through the server. GET and HEAD
//  only, one request per connection.
//

import Foundation
import Network

/// Where the editor page is served from, once the server is up.
@MainActor
enum MonacoResources {

    /// The web bundle: `NUCLEANT_MONACO_WEB_DIR` when set (a webpack output
    /// directory, for working on the page without rebuilding the package),
    /// else the `Resources` this target was built with.
    static var bundleDirectory: URL? {
        if let path = ProcessInfo.processInfo.environment["NUCLEANT_MONACO_WEB_DIR"] {
            return URL(fileURLWithPath: path, isDirectory: true)
        }
        // `.copy("Resources")` keeps the folder — but a flat bundle with a
        // top-level `Resources` folder reports that folder as its
        // `resourceURL`, so it may be either level.
        guard let resources = Bundle.module.resourceURL else { return nil }
        let nested = resources.appendingPathComponent("Resources", isDirectory: true)
        let page = nested.appendingPathComponent("index.html").path
        return FileManager.default.fileExists(atPath: page) ? nested : resources
    }

    private static var server: MonacoResourceServer?
    private static var result: Result<URL, MonacoEditorError>?
    private static var waiting: [@MainActor (Result<URL, MonacoEditorError>) -> Void] = []

    /// The page's address — at once if the server is up, else when it is.
    static func pageURL(_ completion: @escaping @MainActor (Result<URL, MonacoEditorError>) -> Void) {
        if let result {
            completion(result)
            return
        }
        waiting.append(completion)
        guard server == nil else { return }

        guard let directory = bundleDirectory,
              FileManager.default.fileExists(atPath: directory.appendingPathComponent("index.html").path)
        else {
            finish(.failure(.webBundleMissing(bundleDirectory?.path ?? "(no resource bundle)")))
            return
        }
        let token = UUID().uuidString.lowercased()
        do {
            let server = try MonacoResourceServer(root: directory, token: token) { port in
                Task { @MainActor in
                    guard let port else {
                        MonacoResources.finish(.failure(.serverFailed))
                        return
                    }
                    MonacoResources.finish(.success(URL(string: "http://127.0.0.1:\(port)/\(token)/index.html")!))
                }
            }
            self.server = server
        } catch {
            finish(.failure(.serverFailed))
        }
    }

    private static func finish(_ result: Result<URL, MonacoEditorError>) {
        self.result = result
        let callbacks = waiting
        waiting = []
        for callback in callbacks { callback(result) }
    }

    /// Whether `url` is a page of this server — only those may use the bridge.
    static func isServed(_ url: String) -> Bool {
        guard case .success(let page)? = result else { return false }
        return url.hasPrefix(page.deletingLastPathComponent().absoluteString)
    }
}

/// A minimal read-only HTTP server for one directory, on 127.0.0.1.
final class MonacoResourceServer: Sendable {
    let root: URL
    let token: String
    private let listener: NWListener
    private let queue = DispatchQueue(label: "NucleantMonaco.resources")

    /// Start listening; `ready` gets the port, or nil if listening failed.
    /// Only paths under `/<token>/` are served.
    init(root: URL, token: String, ready: @escaping @Sendable (UInt16?) -> Void) throws {
        self.root = root.standardizedFileURL
        self.token = token

        let parameters = NWParameters.tcp
        parameters.requiredLocalEndpoint = NWEndpoint.hostPort(host: .ipv4(.loopback), port: .any)
        parameters.acceptLocalOnly = true
        let listener = try NWListener(using: parameters)
        self.listener = listener

        listener.stateUpdateHandler = { [listener] state in
            switch state {
            case .ready:
                ready(listener.port?.rawValue)
            case .failed:
                ready(nil)
            default:
                break
            }
        }
        listener.newConnectionHandler = { [self] connection in
            self.serve(connection)
        }
        listener.start(queue: queue)
    }

    deinit {
        listener.cancel()
    }

    // MARK: - Requests

    private static let headerEnd = Data("\r\n\r\n".utf8)
    private static let maximumHeader = 64 * 1024

    private func serve(_ connection: NWConnection) {
        connection.start(queue: queue)
        receive(on: connection, buffered: Data())
    }

    private func receive(on connection: NWConnection, buffered: Data) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: Self.maximumHeader) { [self] data, _, isComplete, error in
            var buffer = buffered
            if let data { buffer.append(data) }
            if let end = buffer.range(of: Self.headerEnd) {
                respond(on: connection, head: buffer[..<end.lowerBound])
            } else if error != nil || isComplete || buffer.count > Self.maximumHeader {
                connection.cancel()
            } else {
                receive(on: connection, buffered: buffer)
            }
        }
    }

    private func respond(on connection: NWConnection, head: Data) {
        let requestLine = String(decoding: head, as: UTF8.self)
            .split(separator: "\r\n", maxSplits: 1).first ?? ""
        let parts = requestLine.split(separator: " ")
        guard parts.count >= 2 else {
            return send(status: "400 Bad Request", on: connection)
        }
        let method = parts[0]
        guard method == "GET" || method == "HEAD" else {
            return send(status: "405 Method Not Allowed", on: connection)
        }
        guard let file = file(for: String(parts[1])),
              let body = try? Data(contentsOf: file) else {
            return send(status: "404 Not Found", on: connection)
        }
        send(status: "200 OK",
             type: Self.contentType(of: file.pathExtension),
             body: body,
             includeBody: method == "GET",
             on: connection)
    }

    /// The file `target` asks for, if it is under the token and inside `root`.
    private func file(for target: String) -> URL? {
        let path = target.split(separator: "?", maxSplits: 1).first.map(String.init) ?? target
        guard let decoded = path.removingPercentEncoding else { return nil }
        let prefix = "/\(token)/"
        guard decoded.hasPrefix(prefix) else { return nil }
        let relative = decoded.dropFirst(prefix.count)
        let components = relative.split(separator: "/")
        guard !components.contains(where: { $0 == ".." || $0 == "." }) else { return nil }

        var file = root
        for component in components {
            file.appendPathComponent(String(component))
        }
        var isDirectory: ObjCBool = false
        if !FileManager.default.fileExists(atPath: file.path, isDirectory: &isDirectory) {
            return nil
        }
        if isDirectory.boolValue {
            file.appendPathComponent("index.html")
        }
        guard file.standardizedFileURL.path.hasPrefix(root.path + "/") else { return nil }
        return file
    }

    private func send(status: String, type: String = "text/plain; charset=utf-8", body: Data = Data(),
                      includeBody: Bool = true, on connection: NWConnection) {
        var response = Data("""
            HTTP/1.1 \(status)\r
            Content-Type: \(type)\r
            Content-Length: \(body.count)\r
            Cache-Control: no-store\r
            X-Content-Type-Options: nosniff\r
            Connection: close\r
            \r

            """.utf8)
        if includeBody { response.append(body) }
        connection.send(content: response, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }

    private static func contentType(of pathExtension: String) -> String {
        switch pathExtension.lowercased() {
        case "html": "text/html; charset=utf-8"
        case "js", "mjs": "text/javascript; charset=utf-8"
        case "css": "text/css; charset=utf-8"
        case "json", "map": "application/json"
        case "wasm": "application/wasm"
        // The page decompresses the module itself — no Content-Encoding.
        case "gz": "application/gzip"
        case "ttf": "font/ttf"
        case "woff": "font/woff"
        case "woff2": "font/woff2"
        case "svg": "image/svg+xml"
        case "png": "image/png"
        case "txt", "md": "text/plain; charset=utf-8"
        default: "application/octet-stream"
        }
    }
}
