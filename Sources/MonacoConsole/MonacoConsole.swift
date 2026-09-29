import JavaScriptKit
import MonacoApi

/// Console output panel for Monaco Editor
/// Provides a read-only output panel similar to VS Code's Output panel
public class MonacoConsole {
    
    private var editor: JSValue?
    private var model: JSValue?
    private let monaco: JSObject
    private let container: JSValue
    private var lineCount: Int = 0
    
    public init(monaco: JSObject, container: JSValue) {
        self.monaco = monaco
        self.container = container
    }
    
    /// Initialize the console editor
    public func initialize() {
        // Create URI for console output
        let uri = monaco.Uri.parse("inmemory://console-output".jsValue)
        
        // Create model with empty content
        model = monaco.editor.createModel("".jsValue, "plaintext".jsValue, uri)
        
        // Create read-only editor
        let options = JSObject()
        options.theme = "vs-dark".jsValue
        options.readOnly = true.jsValue
        options.automaticLayout = true.jsValue
        options.minimap = createMinimapOptions()
        options.scrollBeyondLastLine = false.jsValue
        options.fontSize = 13.jsValue
        options.fontFamily = "Menlo, Monaco, 'Courier New', monospace".jsValue
        options.lineNumbers = "on".jsValue
        options.renderWhitespace = "none".jsValue
        options.wordWrap = "on".jsValue
        
        editor = monaco.editor.create(container, options)
        
        // Set model
        if let ed = editor?.object, let mdl = model {
            _ = ed.setModel!(mdl)
        }
    }
    
    private func createMinimapOptions() -> JSValue {
        let minimap = JSObject()
        minimap.enabled = false.jsValue
        return minimap.jsValue
    }
    
    /// Append text to console
    public func write(_ text: String) {
        guard let ed = editor?.object, let mdl = model?.object else { return }
        
        // Get end position
        let lineCount = mdl.getLineCount!().number ?? 1
        let lastLineLength = mdl.getLineLength!(lineCount.jsValue).number ?? 0
        
        // Create position at end
        let pos = JSObject()
        pos.lineNumber = lineCount.jsValue
        pos.column = (lastLineLength + 1).jsValue
        
        // Use insertText to append at end position
        _ = ed.insertText!(pos.jsValue, text.jsValue)
        
        // Scroll to bottom
        scrollToBottom()
    }
    
    /// Append line to console
    public func writeLine(_ text: String) {
        write(text + "\n")
        lineCount += 1
    }
    
    /// Write with color/style (using ANSI-like markers)
    public func writeColored(_ text: String, color: ConsoleColor) {
        let prefix = colorPrefix(color)
        writeLine(prefix + text)
    }
    
    private func colorPrefix(_ color: ConsoleColor) -> String {
        switch color {
        case .info: return "[INFO] "
        case .warning: return "[WARN] "
        case .error: return "[ERROR] "
        case .success: return "[OK] "
        case .debug: return "[DEBUG] "
        }
    }
    
    /// Clear console
    public func clear() {
        guard let mdl = model?.object else { return }
        _ = mdl.setValue!("".jsValue)
        lineCount = 0
    }
    
    /// Get current content
    public var content: String {
        guard let mdl = model?.object else { return "" }
        return mdl.getValue!().string ?? ""
    }
    
    /// Scroll to bottom
    private func scrollToBottom() {
        guard let ed = editor?.object else { return }
        _ = ed.revealLine!(lineCount.jsValue)
    }
    
    /// Focus console
    public func focus() {
        guard let ed = editor?.object else { return }
        _ = ed.focus!()
    }
    
    /// Layout console
    public func layout() {
        guard let ed = editor?.object else { return }
        _ = ed.layout!()
    }
    
    /// Dispose console
    public func dispose() {
        if let ed = editor?.object {
            _ = ed.dispose!()
        }
        if let mdl = model?.object {
            _ = mdl.dispose!()
        }
    }
}

/// Console output colors/styles
public enum ConsoleColor {
    case info
    case warning
    case error
    case success
    case debug
}
