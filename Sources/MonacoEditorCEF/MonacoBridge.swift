//
//  MonacoBridge.swift
//  MonacoEditorCEF
//
//  What goes between the native side and the editor page.
//
//  Native → page: a command object, as JSON, handed to
//  `window.nucleantMonaco.receive(…)` through `evaluateJavaScript`.
//
//  Page → native: a message object, as JSON, sent with CEF's message router —
//  `window.cefQuery({ request: JSON })` — and received as a query
//  (`CEFQueryHandler`). The model takes only queries from the main frame of
//  the page it serves.
//

import Foundation
import MonacoApi

enum MonacoBridge {
    /// The script that hands `command` to the page.
    static func script(for command: BridgeCommand) -> String? {
        guard let data = try? JSONEncoder().encode(command) else { return nil }
        let json = String(decoding: data, as: UTF8.self)
        return "window.nucleantMonaco && window.nucleantMonaco.receive(\(json));"
    }

    /// The message a query from the page carries, if it is one.
    static func message(from request: String) -> BridgeMessage? {
        try? JSONDecoder().decode(BridgeMessage.self, from: Data(request.utf8))
    }
}

/// A command for the page (`receive` in npm_cef/index.js).
enum BridgeCommand: Encodable {
    case createModel(id: Int64, content: String, language: String)
    case focusModel(id: Int64, focus: Bool)
    /// Show no model.
    case clearModel
    case setContent(id: Int64, content: String)
    case setLanguage(id: Int64, language: String)
    case setMarkers(id: Int64, owner: String, markers: [IMarkerData])
    case updateOptions(EditorConfiguration)
    case reveal(line: Int, column: Int)
    case focus
    case layout
    case console(action: String, text: String?)

    private enum Keys: String, CodingKey {
        case command, id, content, language, focus, owner, markers, options, line, column, action, text
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case .createModel(let id, let content, let language):
            try container.encode("createModel", forKey: .command)
            try container.encode(id, forKey: .id)
            try container.encode(content, forKey: .content)
            try container.encode(language, forKey: .language)
        case .focusModel(let id, let focus):
            try container.encode("focusModel", forKey: .command)
            try container.encode(id, forKey: .id)
            try container.encode(focus, forKey: .focus)
        case .clearModel:
            try container.encode("clearModel", forKey: .command)
        case .setContent(let id, let content):
            try container.encode("setContent", forKey: .command)
            try container.encode(id, forKey: .id)
            try container.encode(content, forKey: .content)
        case .setLanguage(let id, let language):
            try container.encode("setLanguage", forKey: .command)
            try container.encode(id, forKey: .id)
            try container.encode(language, forKey: .language)
        case .setMarkers(let id, let owner, let markers):
            try container.encode("setMarkers", forKey: .command)
            try container.encode(id, forKey: .id)
            try container.encode(owner, forKey: .owner)
            try container.encode(markers, forKey: .markers)
        case .updateOptions(let options):
            try container.encode("updateOptions", forKey: .command)
            try container.encode(options, forKey: .options)
        case .reveal(let line, let column):
            try container.encode("reveal", forKey: .command)
            try container.encode(line, forKey: .line)
            try container.encode(column, forKey: .column)
        case .focus:
            try container.encode("focus", forKey: .command)
        case .layout:
            try container.encode("layout", forKey: .command)
        case .console(let action, let text):
            try container.encode("console", forKey: .command)
            try container.encode(action, forKey: .action)
            try container.encodeIfPresent(text, forKey: .text)
        }
    }
}

/// A message from the page. `type` says which of the other fields it has:
///
/// * `ready` — the wasm module has made the editor; commands can follow.
/// * `error` — `message`: the page could not start.
/// * `contentChange` — `id`, `content`: a model's text after an edit.
/// * `modelSwitch` — `id`: the editor now shows that model.
/// * `cursor` — `line`, `column`: where the caret moved.
/// * `consoleVisibility` — `visible`: the console panel was shown or closed
///   from the page.
/// * `scriptMessage` — `name`, `body`: something posted to
///   `window.webkit.messageHandlers.<name>` (the page provides that object,
///   so code written for WebKit, like MonacoJSK's `WebKitBridge`, reaches
///   the native side here too).
struct BridgeMessage: Decodable {
    let type: String
    let id: Int64?
    let content: String?
    let message: String?
    let line: Int?
    let column: Int?
    let visible: Bool?
    let name: String?
    let body: String?
}

/// Why an editor could not be shown.
public enum MonacoEditorError: Error, Equatable, Sendable, CustomStringConvertible {
    /// No built web bundle where one was expected.
    case webBundleMissing(String)
    /// The loopback server for the page could not start.
    case serverFailed
    /// CEF could not load the page.
    case pageFailed(String)
    /// The page loaded, but the wasm module or Monaco failed to start.
    case pageError(String)

    public var description: String {
        switch self {
        case .webBundleMissing(let path):
            "The editor's web bundle is not built (looked in \(path)). Run scripts/build_web.sh."
        case .serverFailed:
            "Could not start the local server for the editor page."
        case .pageFailed(let reason):
            "The editor page failed to load: \(reason)"
        case .pageError(let reason):
            "The editor failed to start: \(reason)"
        }
    }
}
