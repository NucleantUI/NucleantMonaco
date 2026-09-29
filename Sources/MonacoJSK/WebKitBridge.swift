//
//  WebKitBridge.swift
//  SwiftyMonacoIDE
//
//  Created by CodeBuilder on 07/12/2025.
//


// Sources/JSSwiftUI/WebKit/WebKitBridge.swift
import JavaScriptKit


public final class WebKitBridge {
    private let messageHandlers: JSObject?
    private let _updateText: JSObject?
    
    nonisolated(unsafe) static let shared: WebKitBridge = .init()
    
    private init() {
        let messageHandlers = JSObject.global.webkit.messageHandlers.object
        self._updateText = messageHandlers?.updateText
        self.messageHandlers = messageHandlers
    }
    
    public static func updateText(text: String) {
        guard let _updateText = shared._updateText, let postMessage = _updateText.postMessage.function else {
            return
        }
        
        postMessage(text)
        
        
        
    }
    
    
//    public func send(_ handlerName: String, _ args: JSValue...) -> JSValue {
//        guard let handler = messageHandlers[handlerName].object else {
//            return .undefined
//        }
//        return handler.postMessage(args)
//    }
//    
//    public func send(_ handlerName: String, object: [String: JSValue]) -> JSValue {
//        guard let handler = messageHandlers[handlerName].object else {
//            return .undefined
//        }
//        let jsObj = JSObject()
//        for (key, value) in object {
//            jsObj[key] = value
//        }
//        return handler.postMessage(jsObj)
//    }
}
