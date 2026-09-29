//
//  JSValueExtensions.swift
//  MonacoWasmIDE
//
//  Created by CodeBuilder on 02/12/2025.
//

import JavaScriptKit


extension RawRepresentable where RawValue: ConvertibleToJSValue {
    public var jsValue: JSValue { rawValue.jsValue }
}


extension JSObject {
    @_disfavoredOverload
    public subscript<T: ConvertibleToJSValue & ConstructibleFromJSValue>(dynamicMember name: String) -> T? {
        get { .construct(from: jsValue) }
        set { self[name] = newValue.jsValue }
    }
}


public protocol JSValueType: ConvertibleToJSValue, ConstructibleFromJSValue {}

extension JSValueType where Self: ConvertibleToJSValue {
    public static func construct(from value: JSValue) -> Self? {
        
        fatalError("\(Self.self) not Implemented as ConvertibleToJSValue")
    }
}
