import JavaScriptKit
import MonacoApi
import Foundation




/// Manages multiple Monaco editor models with in-memory content switching
/// Singleton instance for global access
public class MonacoEditorManager {
    
    // MARK: - Singleton
    
    /// Shared instance
    nonisolated(unsafe) public static let shared = MonacoEditorManager()
    
    // MARK: - Properties
    
    private var editor: JSValue?
    private var models: [Int64: MonacoEditorModel] = [:]
    private var activeModelId: Int64?
    private let monaco: JSObject
    
    // MARK: - Initialization
    
    /// Private initializer for singleton
    private init() {
        guard let monacoObj = JSObject.global.monaco.object else {
            fatalError("Monaco editor not loaded")
        }
        self.monaco = monacoObj
        
        JSObject.global.editorManager = self.jsValue
    }
    
    /// Create the Monaco editor instance
    /// - Parameters:
    ///   - containerId: The ID of the container element
    ///   - options: Optional editor configuration
    /// - Returns: true if editor was created successfully
    @discardableResult
    public func createEditor(containerId: Int, options: [String: JSValue] = [:]) -> Bool {
        let document = JSObject.global.document
        guard let container = document.getElementById("editor-\(containerId)".jsValue).object else {
            return false
        }
        
        let editorOptions = JSObject()
        editorOptions.theme = "vs-dark".jsValue
        editorOptions.automaticLayout = true.jsValue
        
        // Apply custom options
        for (key, value) in options {
            editorOptions[key] = value
        }
        
        self.editor = monaco.editor.create(container, editorOptions)
        return true
    }
    
    /// Create the Monaco editor instance with a JSValue container
    /// - Parameters:
    ///   - container: The JSValue container element
    ///   - options: Optional editor configuration
    /// - Returns: true if editor was created successfully
    @discardableResult
    public func createEditor(container: JSValue, options: [String: JSValue] = [:]) -> Bool {
        let editorOptions = JSObject()
        editorOptions.theme = "vs-dark".jsValue
        editorOptions.automaticLayout = true.jsValue
        
        // Apply custom options
        for (key, value) in options {
            editorOptions[key] = value
        }
        
        self.editor = monaco.editor.create(container, editorOptions)
        
        // Automatically set up Python support
        initializePythonSupport()
        
        return true
    }
    
    /// Check if editor instance exists
    public var hasEditor: Bool {
        return editor != nil
    }
    
    // MARK: - Model Creation
    
    /// Create a new model from string content
    @discardableResult
    public func createModel(id: Int64, content: String, language: String = "python") -> MonacoEditorModel {
        let model = MonacoEditorModel(monaco: monaco, id: id, content: content, language: language, manager: self)
        models[id] = model
        return model
    }
    
    /// Create a new model from Data
    @discardableResult
    public func createModel(id: Int64, data: Data, language: String = "python") -> MonacoEditorModel? {
        guard let content = String(data: data, encoding: .utf8) else { return nil }
        return createModel(id: id, content: content, language: language)
    }
    
    /// Create a new model from bytes
    @discardableResult
    public func createModel(id: Int64, bytes: [UInt8], language: String = "python") -> MonacoEditorModel? {
        let data = Data(bytes)
        return createModel(id: id, data: data, language: language)
    }
    
    // MARK: - Model Switching
    
    /// Switch to a specific model
    public func switchToModel(_ id: Int64, autoFocus: Bool) {
        guard let model = models[id],
              let editor = editor,
              let editorObj = editor.object else { return }
        
        _ = editorObj.setModel!(model.jsValue)
        activeModelId = id
        if autoFocus {
            _ = editorObj.focus!()
        }
    }
    
    // MARK: - Content Access (String)
    
    /// Get model content as String
    public func getContent(_ id: Int64) -> String? {
        return models[id]?.content
    }
    
    /// Get active model content as String
    public var activeContent: String? {
        guard let id = activeModelId else { return nil }
        return getContent(id)
    }
    
    /// Update model content with String
    public func updateContent(_ id: Int64, content: String) {
        models[id]?.setContent(content)
    }
    
    // MARK: - Content Access (Data)
    
    /// Get model content as Data
    public func getData(_ id: Int64) -> Data? {
        guard let content = getContent(id) else { return nil }
        return content.data(using: .utf8)
    }
    
    /// Get active model content as Data
    public var activeData: Data? {
        guard let id = activeModelId else { return nil }
        return getData(id)
    }
    
    /// Update model content with Data
    public func updateContent(_ id: Int64, data: Data) {
        guard let content = String(data: data, encoding: .utf8) else { return }
        updateContent(id, content: content)
    }
    
    // MARK: - Content Access (Bytes)
    
    /// Get model content as bytes
    public func getBytes(_ id: Int64) -> [UInt8]? {
        guard let data = getData(id) else { return nil }
        return [UInt8](data)
    }
    
    /// Get active model content as bytes
    public var activeBytes: [UInt8]? {
        guard let id = activeModelId else { return nil }
        return getBytes(id)
    }
    
    /// Update model content with bytes
    public func updateContent(_ id: Int64, bytes: [UInt8]) {
        let data = Data(bytes)
        updateContent(id, data: data)
    }
    
    // MARK: - Model Management
    
    /// Remove a model and dispose of it
    public func removeModel(_ id: Int64) {
        models[id]?.dispose()
        models.removeValue(forKey: id)
        
        if activeModelId == id {
            activeModelId = nil
        }
    }
    
    /// Get the currently active model ID
    public var currentModelId: Int64? {
        return activeModelId
    }
    
    /// Get all model IDs
    public var allModelIds: [Int64] {
        return Array(models.keys)
    }
    
    /// Check if a model exists
    public func hasModel(_ id: Int64) -> Bool {
        return models[id] != nil
    }
    
    /// Get the number of models
    public var modelCount: Int {
        return models.count
    }
    
    // MARK: - Editor Access
    
    /// Get the underlying Monaco editor instance
    public var editorInstance: JSValue? {
        return editor
    }
    
    /// Get a specific model instance
    public func getModel(_ id: Int64) -> MonacoEditorModel? {
        return models[id]
    }
    
    /// Get a specific model's JSValue
    public func getModelJSValue(_ id: Int64) -> JSValue? {
        return models[id]?.jsValue
    }
    
    // MARK: - Editor Operations
    
    /// Focus the editor
    public func focus() {
        guard let editor = editor, let editorObj = editor.object else { return }
        _ = editorObj.focus!()
    }
    
    /// Layout the editor (call after container resize)
    public func layout() {
        guard let editor = editor, let editorObj = editor.object else { return }
        _ = editorObj.layout!()
    }
    
    /// Layout with specific dimensions
    public func layout(width: Int, height: Int) {
        guard let editor = editor, let editorObj = editor.object else { return }
        let dimension = JSObject()
        dimension.width = width.jsValue
        dimension.height = height.jsValue
        _ = editorObj.layout!(dimension)
    }
    
    /// Update editor options
    public func updateOptions(_ options: [String: JSValue]) {
        guard let editor = editor, let editorObj = editor.object else { return }
        let jsOptions = JSObject()
        for (key, value) in options {
            jsOptions[key] = value
        }
        _ = editorObj.updateOptions!(jsOptions)
    }
    
    // MARK: - Language Operations
    
    /// Change the language of a model
    public func setModelLanguage(_ id: Int64, language: String) {
        guard let model = models[id],
              let monaco = JSObject.global.monaco.object else { return }
        
        _ = monaco.editor.setModelLanguage(model.jsValue, language.jsValue)
    }
    
    /// Get the language of a model
    public func getModelLanguage(_ id: Int64) -> String? {
        guard let model = models[id], let obj = model.object else { return nil }
        return obj.getLanguageId!().string
    }
    
    // MARK: - Cleanup
    
    /// Dispose all models and the editor
    public func dispose() {
        // Dispose all models
        for (_, model) in models {
            model.dispose()
        }
        models.removeAll()
        
        // Dispose editor
        if let editor = editor, let editorObj = editor.object {
            _ = editorObj.dispose!()
        }
        
        activeModelId = nil
    }
    
    deinit {
        dispose()
    }
    
    // MARK: - Language Features Registration
    
    /// Register completion provider for a model
    public func registerCompletionProvider(for id: Int64, languageId: String, provider: JSObject) {
        guard models[id] != nil else { return }
        
        let languages = monaco.languages
        _ = languages.registerCompletionItemProvider(
            languageId.jsValue,
            provider
        )
    }
    
    /// Register hover provider for a model
    public func registerHoverProvider(for id: Int64, languageId: String, provider: JSObject) {
        guard models[id] != nil else { return }
        
        let languages = monaco.languages
        _ = languages.registerHoverProvider(
            languageId.jsValue,
            provider
        )
    }
    
    /// Register diagnostics for a model with update closure
    public func registerDiagnostics(for id: Int64, updateHandler: @escaping (String) -> [JSValue]) {
        guard let model = models[id] else { return }
        
        let updateDiagnostics = JSClosure { [weak self, id] (_: [JSValue]) -> JSValue in
            guard let self = self,
                  let content = self.getContent(id) else {
                return .undefined
            }
            
            let markers = updateHandler(content)
            
            // Set markers on the model
            if let model = self.models[id] {
                let editorNS = JSObject.global.monaco.object!.editor
                _ = editorNS.setModelMarkers(
                    model.jsValue,
                    "swift-diagnostics".jsValue,
                    markers.jsValue
                )
            }
            
            return .undefined
        }
        
        // Listen to content changes with throttling
        var timeoutId: JSValue?
        
        let throttledUpdate = JSClosure { (_: [JSValue]) -> JSValue in
            // Clear existing timeout
            if let id = timeoutId, !id.isUndefined {
                _ = JSObject.global.clearTimeout.function?(id)
            }
            
            // Schedule update after 500ms
            timeoutId = JSObject.global.setTimeout.function?(updateDiagnostics.jsValue, 500.jsValue)
            
            return .undefined
        }
        
        // Register listener
        if let modelObj = model.object {
            _ = modelObj.onDidChangeContent!(throttledUpdate.jsValue)
        }
        
        // Run initial validation
        _ = updateDiagnostics(this: JSObject.global, arguments: [])
    }
    
    // MARK: - Model Content Change Listeners
    
    /// Register a content change listener for a specific model
    public func onModelContentChange(for id: Int64, handler: @escaping (String) -> Void) {
        guard let model = models[id], let modelObj = model.object else { return }
        
        let closure = JSClosure { [weak self, id] (_: [JSValue]) -> JSValue in
            guard let self = self,
                  let content = self.getContent(id) else {
                return .undefined
            }
            handler(content)
            return .undefined
        }
        
        _ = modelObj.onDidChangeContent!(closure.jsValue)
    }
    
    /// Register a content change listener for the active model with initial call
    public func setupActiveModelListener(handler: @escaping (String) -> Void) {
        guard let editorInstance = editor,
              let editorObj = editorInstance.object else { return }
        
        let modelValue = editorObj.getModel!()
        guard let modelObj = modelValue.object else { return }
        
        let closure = JSClosure { (_: [JSValue]) -> JSValue in
            let content = modelObj.getValue!()
            if let contentStr = content.string {
                handler(contentStr)
            }
            return .undefined
        }
        
        _ = modelObj.onDidChangeContent!(closure.jsValue)
        
        // Trigger initial call
        let initialContent = modelObj.getValue!()
        if let initialStr = initialContent.string {
            handler(initialStr)
        }
    }
}

// MARK: - Convenience Extensions

extension MonacoEditorManager {
    /// Create multiple models at once
    public func createModels(_ contents: [(id: Int64, content: String, language: String)]) {
        for item in contents {
            createModel(id: item.id, content: item.content, language: item.language)
        }
    }
    
    /// Get all model contents as a dictionary
    public func getAllContents() -> [Int64: String] {
        var contents: [Int64: String] = [:]
        for id in allModelIds {
            if let content = getContent(id) {
                contents[id] = content
            }
        }
        return contents
    }
    
    /// Update multiple models at once
    public func updateModels(_ contents: [Int64: String]) {
        for (id, content) in contents {
            if hasModel(id) {
                updateContent(id, content: content)
            }
        }
    }
    
    /// Switch to next model (circular)
    public func switchToNextModel() {
        guard !allModelIds.isEmpty else { return }
        
        if let currentId = activeModelId,
           let currentIndex = allModelIds.firstIndex(of: currentId) {
            let nextIndex = (currentIndex + 1) % allModelIds.count
            switchToModel(allModelIds[nextIndex], autoFocus: true)
        } else if let firstId = allModelIds.first {
            switchToModel(firstId, autoFocus: true)
        }
    }
    
    /// Switch to previous model (circular)
    public func switchToPreviousModel() {
        guard !allModelIds.isEmpty else { return }
        
        if let currentId = activeModelId,
           let currentIndex = allModelIds.firstIndex(of: currentId) {
            let prevIndex = currentIndex > 0 ? currentIndex - 1 : allModelIds.count - 1
            switchToModel(allModelIds[prevIndex], autoFocus: true)
        } else if let lastId = allModelIds.last {
            switchToModel(lastId, autoFocus: true)
        }
    }
    
    // MARK: - Global Provider Registration
    
    /// Register Python language providers globally (call once)
    public func registerPythonProviders() {
        // Completion provider
        let completionProvider = JSObject()
        completionProvider.triggerCharacters = [".", ":"].jsValue
        completionProvider.provideCompletionItems = JSClosure { [weak self] (args: [JSValue]) -> JSValue in
            guard let self = self,
                  let activeId = self.activeModelId,
                  let model = self.getModel(activeId) else {
                return JSObject().jsValue
            }
            return model.provideCompletions(args: args)
        }.jsValue
        _ = monaco.languages.registerCompletionItemProvider("python".jsValue, completionProvider)
        
        // Hover provider
        let hoverProvider = JSObject()
        hoverProvider.provideHover = JSClosure { [weak self] (args: [JSValue]) -> JSValue in
            guard let self = self,
                  let activeId = self.activeModelId,
                  let model = self.getModel(activeId) else {
                return JSValue.undefined
            }
            return model.provideHover(args: args)
        }.jsValue
        _ = monaco.languages.registerHoverProvider("python".jsValue, hoverProvider)
    }
    
    // MARK: - Automatic Python Support
    
    /// Initialize Python language support (called automatically on editor creation)
    private func initializePythonSupport() {
        // Register Python language providers globally
        registerPythonProviders()
        
        // Set up active model listener to parse code on changes
        setupActiveModelListener { [weak self] codeStr in
            guard let self = self,
                  let activeId = self.activeModelId,
                  let model = self.getModel(activeId) else {
                return
            }
            model.astManager.parseCode(codeStr)
        }
    }
}

