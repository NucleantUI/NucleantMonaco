//
//  MonacoEditor.swift
//  MonacoEditorCEF
//
//  Monaco, with the Swift wasm module (MonacoEditorWasm) driving it, in a CEF
//  browser — as a model a NucleantUI view shows.
//

import AppKit
import Observation
import MonacoApi
import NucleantCEF

/// A Monaco editor running in CEF, and the documents it has open.
///
/// ```swift
/// @State private var editor = MonacoEditor(documents: [
///     CodeModel(name: "main.py", text: "print('hello')"),
/// ])
///
/// var body: some View {
///     MonacoEditorView(editor)
/// }
/// ```
///
/// The page is the webpack bundle in `npm_cef` (Monaco plus the wasm module),
/// served to CEF from this process. Commands made before the page is ready —
/// opening documents, options, console output — are applied once it is, and
/// again if the page reloads; `phase` says where it has got to.
///
/// Every edit in the editor updates the document's `text`, so the native
/// side always has the current content without asking the page for it.
@MainActor
@Observable
public final class MonacoEditor: CEFBrowserModel {

    public enum Phase: Equatable, Sendable {
        case loading
        case ready
        case failed(MonacoEditorError)
    }

    @ObservationIgnored public let base: CEFBrowserBase

    public private(set) var phase: Phase = .loading

    /// The documents the editor has open, in the order they were opened.
    public private(set) var documents: [CodeModel]

    /// The document the editor is showing.
    public private(set) var activeDocument: CodeModel?

    /// The caret in the active document, once it has been reported.
    public private(set) var cursor: Position?

    /// Whether the page's console panel is showing.
    public private(set) var isConsoleVisible = false

    /// The options last given to `updateOptions`, re-applied on a reload.
    public private(set) var configuration: EditorConfiguration?

    /// Print the page's console output to stdout.
    @ObservationIgnored public var printsPageConsole = false

    /// Called with what the page posts to `window.webkit.messageHandlers.<name>`
    /// — the handler's name and the posted value as JSON.
    @ObservationIgnored public var onScriptMessage: (@MainActor (_ name: String, _ body: String) -> Void)?

    /// The documents whose models exist on the current page.
    @ObservationIgnored private var modelsOnPage: Set<Int64> = []

    /// Console commands made before the page was ready.
    @ObservationIgnored private var pendingConsole: [BridgeCommand] = []

    /// - Parameters:
    ///   - documents: Open at once; the first is shown.
    ///   - configuration: Editor options (theme, font size …) — Monaco's
    ///     `IEditorOptions`, as MonacoApi models them.
    ///   - options: How CEF renders the page. The default background is the
    ///     editor's dark theme, so nothing flashes white while it loads.
    public init(
        documents: [CodeModel] = [],
        configuration: EditorConfiguration? = nil,
        options: CEFBrowserOptions = CEFBrowserOptions(backgroundColor: 0xFF1E_1E1E)
    ) {
        self.base = CEFBrowserBase(url: "about:blank", options: options)
        self.documents = documents
        self.activeDocument = documents.first
        self.configuration = configuration
        MonacoResources.pageURL { [weak self] result in
            self?.pageAddressResolved(result)
        }
    }

    // MARK: - Documents

    /// Show `document`, opening it first if it isn't open. `focus` gives the
    /// editor the caret on the page (the view still needs the keys — a click
    /// in it, as with any view).
    public func open(_ document: CodeModel, focus: Bool = true) {
        if !documents.contains(where: { $0 === document }) {
            documents.append(document)
        }
        if activeDocument !== document {
            activeDocument = document
            cursor = nil
        }
        guard phase == .ready else { return }
        placeOnPage(document)
        send(.focusModel(id: document.id, focus: focus))
    }

    /// Close `document`, showing its neighbour if it was the one showing.
    /// Its model stays on the page, so opening it again keeps its undo
    /// history.
    public func close(_ document: CodeModel) {
        guard let index = documents.firstIndex(where: { $0 === document }) else { return }
        documents.remove(at: index)
        guard activeDocument === document else { return }
        if documents.isEmpty {
            activeDocument = nil
            cursor = nil
            if phase == .ready { send(.clearModel) }
        } else {
            open(documents[min(index, documents.count - 1)], focus: false)
        }
    }

    /// Replace `document`'s text — on the page too, if it is open there.
    public func setText(_ text: String, for document: CodeModel) {
        document.text = text
        guard phase == .ready, modelsOnPage.contains(document.id) else { return }
        send(.setContent(id: document.id, content: text))
    }

    /// Change `document`'s language (a Monaco language ID).
    public func setLanguage(_ language: String, for document: CodeModel) {
        document.setLanguage(language)
        guard phase == .ready, modelsOnPage.contains(document.id) else { return }
        send(.setLanguage(id: document.id, language: language))
    }

    /// Show `markers` (errors, warnings …) in `document`, replacing any
    /// earlier ones from the same `owner`.
    public func setMarkers(_ markers: [IMarkerData], owner: String, for document: CodeModel) {
        guard phase == .ready, modelsOnPage.contains(document.id) else { return }
        send(.setMarkers(id: document.id, owner: owner, markers: markers))
    }

    // MARK: - Editor

    /// Change the editor's options; the ones left `nil` keep their values.
    public func updateOptions(_ configuration: EditorConfiguration) {
        self.configuration = configuration
        guard phase == .ready else { return }
        send(.updateOptions(configuration))
    }

    /// Scroll to `line` and put the caret there.
    public func reveal(line: Int, column: Int = 1) {
        guard phase == .ready else { return }
        send(.reveal(line: line, column: column))
    }

    /// Give the editor the caret on the page.
    public func focusEditor() {
        guard phase == .ready else { return }
        send(.focus)
    }

    /// Load the page again. Open documents are recreated from their `text`
    /// once it is ready.
    public func reloadEditor() {
        switch phase {
        case .failed(.webBundleMissing), .failed(.serverFailed):
            return  // nothing to load
        default:
            phase = .loading
            reload()
        }
    }

    /// The page's console panel.
    public var console: MonacoEditorConsole {
        MonacoEditorConsole(editor: self)
    }

    func consoleCommand(_ action: String, text: String? = nil) {
        switch action {
        case "show": isConsoleVisible = true
        case "hide": isConsoleVisible = false
        default: break
        }
        let command = BridgeCommand.console(action: action, text: text)
        if phase == .ready {
            send(command)
        } else if action != "show", action != "hide" {
            // Visibility is re-sent on ready from `isConsoleVisible`.
            pendingConsole.append(command)
        }
    }

    // MARK: - Page

    private func pageAddressResolved(_ result: Result<URL, MonacoEditorError>) {
        switch result {
        case .success(let url):
            load(url.absoluteString)
        case .failure(let error):
            phase = .failed(error)
        }
    }

    /// The page's wasm module has made the editor: bring it up to date.
    private func pageDidBecomeReady() {
        phase = .ready
        modelsOnPage = []
        if let configuration {
            send(.updateOptions(configuration))
        }
        for document in documents {
            placeOnPage(document)
        }
        if let activeDocument {
            send(.focusModel(id: activeDocument.id, focus: false))
        }
        if isConsoleVisible {
            send(.console(action: "show", text: nil))
        }
        for command in pendingConsole {
            send(command)
        }
        pendingConsole = []
    }

    private func placeOnPage(_ document: CodeModel) {
        guard !modelsOnPage.contains(document.id) else { return }
        modelsOnPage.insert(document.id)
        send(.createModel(id: document.id, content: document.text, language: document.language))
    }

    private func send(_ command: BridgeCommand) {
        guard let script = MonacoBridge.script(for: command) else { return }
        evaluateJavaScript(script)
    }

    private func receive(_ message: BridgeMessage) {
        switch message.type {
        case "ready":
            pageDidBecomeReady()
        case "error":
            phase = .failed(.pageError(message.message ?? "unknown error"))
        case "contentChange":
            if let document = document(message.id), let content = message.content, document.text != content {
                document.text = content
            }
        case "modelSwitch":
            if let document = document(message.id), activeDocument !== document {
                activeDocument = document
                cursor = nil
            }
        case "cursor":
            if let line = message.line, let column = message.column {
                cursor = Position(lineNumber: line, column: column)
            }
        case "consoleVisibility":
            if let visible = message.visible { isConsoleVisible = visible }
        case "scriptMessage":
            if let name = message.name { onScriptMessage?(name, message.body ?? "null") }
        default:
            break
        }
    }

    private func document(_ id: Int64?) -> CodeModel? {
        guard let id else { return nil }
        return documents.first { $0.id == id }
    }

    // MARK: - CEFDisplayHandler

    public func consoleMessage(_ message: String, level: CEFLogSeverity, source: String, line: Int) {
        if printsPageConsole {
            print("Monaco page [\(level)] \(message)")
        }
    }

    // MARK: - CEFQueryHandler

    /// The page's messages (`window.cefQuery`). Only the main frame of the
    /// served page speaks for the editor.
    public func queryReceived(_ query: CEFQuery) -> Bool {
        guard query.isMainFrame, MonacoResources.isServed(query.frameURL),
              let message = MonacoBridge.message(from: query.request) else { return false }
        receive(message)
        query.succeed()
        return true
    }

    // MARK: - CEFLoadHandler

    public func loadingStateDidChange(isLoading: Bool, canGoBack: Bool, canGoForward: Bool) {
        if isLoading, phase == .ready {
            phase = .loading
        }
    }

    public func loadDidFail(url: String, code: Int, description: String) {
        // -3 is ERR_ABORTED: a load replaced by the next one.
        guard code != -3, MonacoResources.isServed(url) else { return }
        phase = .failed(.pageFailed("\(description) (\(code))"))
    }

    // MARK: - CEFLifeSpanHandler

    /// Links that want a new window (in hovers, say) open in the system's
    /// browser — the editor page stays where it is.
    public func newWindowRequested(_ url: String) {
        guard let url = URL(string: url), ["http", "https"].contains(url.scheme?.lowercased()) else { return }
        NSWorkspace.shared.open(url)
    }
}

/// The console panel under the editor, on the page — the same panel the
/// wasm module writes to (`window.swiftyMonaco.console`).
@MainActor
public struct MonacoEditorConsole {
    let editor: MonacoEditor

    public func write(_ text: String) {
        editor.consoleCommand("write", text: text)
    }

    public func writeLine(_ text: String) {
        editor.consoleCommand("writeLine", text: text)
    }

    public func clear() {
        editor.consoleCommand("clear")
    }

    public func show() {
        editor.consoleCommand("show")
    }

    public func hide() {
        editor.consoleCommand("hide")
    }

    public func toggle() {
        editor.isConsoleVisible ? hide() : show()
    }
}
