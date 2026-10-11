//
//  MonacoResources+Web.swift
//  MonacoEditorCEF
//
//  The editor page in the browser build. Its files are part of the app's
//  resource bundles, which the page the app runs in serves already — it
//  fetches them to mount them for the module — so the editor's iframe loads
//  them from there: same origin as the app, which is what lets the bridge
//  script the editor and hand it `window.cefQuery`. No server of our own.
//

#if os(WASI)
import Foundation
import Platform_Wasm

/// Where the editor page is served from.
@MainActor
enum MonacoResources {

    private static var result: Result<URL, MonacoEditorError>?

    /// The page's address. At once: there is no server to wait for.
    static func pageURL(_ completion: @escaping @MainActor (Result<URL, MonacoEditorError>) -> Void) {
        if let result {
            completion(result)
            return
        }
        let result: Result<URL, MonacoEditorError>
        if let directory = bundleDirectory,
           case let page = directory.appendingPathComponent("index.html"),
           FileManager.default.fileExists(atPath: page.path),
           let address = BrowserResources.servedURL(forFile: page.path),
           let url = URL(string: address) {
            result = .success(url)
        } else {
            result = .failure(.webBundleMissing(bundleDirectory?.path ?? "(no resource bundle)"))
        }
        self.result = result
        completion(result)
    }

    /// Whether `url` is a page of the editor's — only those may use the
    /// bridge.
    static func isServed(_ url: String) -> Bool {
        guard case .success(let page)? = result else { return false }
        return url.hasPrefix(page.deletingLastPathComponent().absoluteString)
    }
}
#endif
