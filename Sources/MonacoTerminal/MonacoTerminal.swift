import JavaScriptKit
import MonacoApi

/// Terminal integration for Monaco Editor
/// Provides xterm.js terminal functionality within Monaco
public class MonacoTerminal {
    
    private var terminal: JSValue?
    private let container: JSValue
    
    public init(container: JSValue) {
        self.container = container
    }
    
    /// Initialize the terminal with xterm.js
    public func initialize() {
        guard let Terminal = JSObject.global.Terminal.function else {
            print("❌ xterm.js not loaded")
            return
        }
        
        // Create terminal instance
        let options = JSObject()
        options.cursorBlink = true.jsValue
        options.fontSize = 14.jsValue
        options.fontFamily = "Menlo, Monaco, 'Courier New', monospace".jsValue
        options.theme = createTheme()
        
        terminal = Terminal.new(options).jsValue
        
        // Open terminal in container
        if let term = terminal?.object {
            _ = term.open!(container)
            _ = term.write!("Welcome to MonacoTerminal\r\n$ ".jsValue)
        }
    }
    
    private func createTheme() -> JSValue {
        let theme = JSObject()
        theme.background = "#1e1e1e".jsValue
        theme.foreground = "#cccccc".jsValue
        theme.cursor = "#ffffff".jsValue
        theme.black = "#000000".jsValue
        theme.red = "#cd3131".jsValue
        theme.green = "#0dbc79".jsValue
        theme.yellow = "#e5e510".jsValue
        theme.blue = "#2472c8".jsValue
        theme.magenta = "#bc3fbc".jsValue
        theme.cyan = "#11a8cd".jsValue
        theme.white = "#e5e5e5".jsValue
        theme.brightBlack = "#666666".jsValue
        theme.brightRed = "#f14c4c".jsValue
        theme.brightGreen = "#23d18b".jsValue
        theme.brightYellow = "#f5f543".jsValue
        theme.brightBlue = "#3b8eea".jsValue
        theme.brightMagenta = "#d670d6".jsValue
        theme.brightCyan = "#29b8db".jsValue
        theme.brightWhite = "#ffffff".jsValue
        
        return theme.jsValue
    }
    
    /// Write text to terminal
    public func write(_ text: String) {
        guard let term = terminal?.object else { return }
        _ = term.write!(text.jsValue)
    }
    
    /// Write line to terminal
    public func writeLine(_ text: String) {
        write(text + "\r\n")
    }
    
    /// Clear terminal
    public func clear() {
        guard let term = terminal?.object else { return }
        _ = term.clear!()
    }
    
    /// Focus terminal
    public func focus() {
        guard let term = terminal?.object else { return }
        _ = term.focus!()
    }
    
    /// Register data handler for terminal input
    public func onData(handler: @escaping (String) -> Void) {
        guard let term = terminal?.object else { return }
        
        let closure = JSClosure { (args: [JSValue]) -> JSValue in
            if let data = args.first?.string {
                handler(data)
            }
            return .undefined
        }
        
        _ = term.onData!(closure.jsValue)
    }
    
    /// Dispose terminal
    public func dispose() {
        guard let term = terminal?.object else { return }
        _ = term.dispose!()
    }
}
