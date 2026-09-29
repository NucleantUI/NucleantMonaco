import JavaScriptKit
import MonacoApi
import Foundation

public class MonacoEditorModel: ConvertibleToJSValue {
    public let id: Int64
    public var jsValue: JSValue
    
    // Each model has its own AST manager
    public let astManager: ASTManager
    private weak var manager: MonacoEditorManager?
    
    public init(monaco: JSObject, id: Int64, content: String, language: String = "python", manager: MonacoEditorManager) {
        self.id = id
        self.astManager = ASTManager()
        self.manager = manager
        
        // Create URI with custom scheme (not file-based)
        let uri = monaco.Uri.parse("inmemory://\(id)".jsValue)
        
        // Create model
        self.jsValue = monaco.editor.createModel(content.jsValue, language.jsValue, uri)
        
        // Parse initial content for Python
        if language == "python" {
            self.astManager.parseCode(content)
        }
    }
    
    /// Get the underlying Monaco model object
    public var object: JSObject? {
        return jsValue.object
    }
    
    /// Get current content
    public var content: String? {
        guard let obj = object else { return nil }
        return obj.getValue!().string
    }
    
    /// Update content
    public func setContent(_ content: String) {
        guard let obj = object else { return }
        _ = obj.setValue!(content.jsValue)
    }
    
    /// Dispose the model
    public func dispose() {
        guard let obj = object else { return }
        _ = obj.dispose!()
    }
    
    deinit {
        dispose()
    }
}