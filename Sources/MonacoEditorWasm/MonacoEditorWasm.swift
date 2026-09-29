import JavaScriptKit
import MonacoApi
import MonacoEditorManager

// MARK: - Global JavaScript Objects
nonisolated(unsafe) let document = JSObject.global.document
nonisolated(unsafe) let console = JSObject.global.console
nonisolated(unsafe) let monaco = JSObject.global.monaco
nonisolated(unsafe) let monaco_console = JSObject.global.monaco_console
// MARK: - Logging Helper
func log(_ message: String) {
    _ = console.log(message.jsValue)
}

func mc_log(_ items: CustomStringConvertible...) {
    let message = items.map { item in
        item.description
    }.joined()
    _ = monaco_console.writeLine(message.jsValue)
}

// MARK: - Sample Code
let samplePythonCode = """
def greet(name: str) -> str:
    \"\"\"Greet a person by name.\"\"\"
    return f"Hello, {name}!"

class Calculator:
    def __init__(self):
        self.result = 0
    
    def add(self, x: int, y: int) -> int:
        self.result = x + y
        return self.result

# Usage
calc = Calculator()
print(calc.add(5, 3))
print(greet("World"))
"""

let sampleJavaScriptCode = """
function greet(name) {
    return `Hello, ${name}!`;
}

class Calculator {
    constructor() {
        this.result = 0;
    }
    
    add(x, y) {
        this.result = x + y;
        return this.result;
    }
}

// Usage
const calc = new Calculator();
console.log(calc.add(5, 3));
console.log(greet("World"));
"""




// MARK: - Main Entry Point
@main
struct MonacoEditorWasm {
    static func main() {
        // Prevent multiple initializations
        if !JSObject.global.swiftyMonacoInitialized.isUndefined {
            log("⚠️  SwiftyMonacoIDE already initialized, skipping")
            return
        }
        JSObject.global.swiftyMonacoInitialized = true.jsValue
        
        log("🚀 SwiftyMonacoIDE WASM loaded!")
        log("Version: 1.0.0-b0002")
        
        log("✅ Monaco Editor library detected!")
                
        // Check if editor already exists (avoid recreating on hot reload)
        if !JSObject.global.monacoEditor.isUndefined {
            log("⚠️  Editor already exists, skipping creation")
            return
        }

        let container: JSValue = document.getElementById("editor-container")
        if !container.isUndefined {
            
            // Initialize MonacoEditorManager
            let manager = MonacoEditorManager.shared
            let options = [
                "padding": ["top": 10, "bottom": 10].jsValue
            ]
            // Create editor using MonacoEditorManager
            let success = manager.createEditor(container: container, options: options)
            if !success {
                log("❌ Failed to create editor")
                return
            }
            
            // Store reference for backward compatibility
            JSObject.global.monacoEditor = manager.editorInstance ?? .undefined
            
            log("✅ Monaco Editor created via MonacoEditorManager!")
            log("✅ editorManager exposed globally with createModel() and focusModel()")
            log("🎉 Python editor ready!")
            
            // Expose console functions to Swift
            exposeConsoleFunctions()
            
            // Expose a test function to JavaScript
            JSObject.global.swiftTest = JSClosure { (_: [JSValue]) -> JSValue in
                log("✅ Swift WASM is working!")
                
                mc_log("[INFO] Swift WASM test successful!\n")
                // Test console
                // if let consoleWrite = JSObject.global.swiftyMonaco.object?.console.object?.writeLine.function {
                //     _ = consoleWrite("[INFO] Swift WASM test successful!\n".jsValue)
                // }
                
                return "Hello from Swift WASM!".jsValue
            }.jsValue
        } else {
            log("❌ Editor container not found!")
        }
    }
}


// MARK: - Console Functions

func exposeConsoleFunctions() {
    guard let swiftyMonaco = JSObject.global.swiftyMonaco.object,
          let consoleObj = swiftyMonaco.console.object else {
        log("⚠️  Console functions not available")
        return
    }
    
    // Store console functions globally for easy access
    JSObject.global.consoleWrite = consoleObj.write
    JSObject.global.consoleWriteLine = consoleObj.writeLine
    JSObject.global.consoleClear = consoleObj.clear
    JSObject.global.consoleShow = consoleObj.show
    JSObject.global.consoleHide = consoleObj.hide
    
    log("✅ Console functions exposed to Swift")
}

// MARK: - Console Helper Extension

extension MonacoEditorWasm {
    /// Write to Monaco console
    static func consoleWrite(_ text: String) {
        if let write = JSObject.global.consoleWrite.function {
            _ = write(text.jsValue)
        }
    }
    
    /// Write line to Monaco console
    static func consoleWriteLine(_ text: String) {
        if let writeLine = JSObject.global.consoleWriteLine.function {
            _ = writeLine(text.jsValue)
        }
    }
    
    /// Clear Monaco console
    static func consoleClear() {
        if let clear = JSObject.global.consoleClear.function {
            _ = clear()
        }
    }
    
    /// Show Monaco console
    static func consoleShow() {
        if let show = JSObject.global.consoleShow.function {
            _ = show()
        }
    }
    
    /// Hide Monaco console
    static func consoleHide() {
        if let hide = JSObject.global.consoleHide.function {
            _ = hide()
        }
    }
}
