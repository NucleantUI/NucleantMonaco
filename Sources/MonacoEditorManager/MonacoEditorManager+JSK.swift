import JavaScriptKit
import MonacoJSK
import Foundation


// MARK: - Symbol Types Extensions for JSValueType

extension String {
    var fromBase64: String {
        .init(data: Data(base64Encoded: self)!, encoding: .utf8)!
    }
}

extension MonacoEditorManager: JSValueType {
    public var jsValue: JSValue {
        
        let object = JSObject()
        

        object.createModel = createModelClosure()
        object.focusModel = focusModelClosure()
        
        return object.jsValue
    }
    
}



fileprivate func createModelClosure() -> JSClosure { .init { (args: [JSValue]) -> JSValue in
    guard args.count >= 3 else {
        log("❌ createModel: hashId, content, language required, got \(args.count)")
        return .boolean(false)
    }
    guard let modelId = Int64.construct(from: args[0]) else {
        log("❌ createModel: invalid hash ID Int64")
        return .boolean(false)
    }
    
    guard let content = args[1].string else {
        log("❌ createModel: invalid content")
        return .boolean(false)
    }
    guard let language = args[2].string else {
        log("❌ createModel: invalid language")
        return .boolean(false)
    }

    let _ = MonacoEditorManager.shared.createModel(id: .init(modelId), content: content, language: language)
    log("✅ Created model ID: \(modelId)")
    return .boolean(true)
}}

fileprivate func focusModelClosure() -> JSClosure { .init { (args: [JSValue]) -> JSValue in
    guard 
        let modelId = Int64.construct(from: args[0]),
        let focus = args[1].boolean
    else {
        log("❌ focusModel: hash ID required")
        return .boolean(false)
    }
    
    MonacoEditorManager.shared.switchToModel(modelId, autoFocus: focus)
    log("✅ Focused model ID: \(modelId)")
    return .boolean(true)
}}
