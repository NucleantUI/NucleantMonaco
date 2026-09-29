import JavaScriptKit
import MonacoApi

// MARK: - Simple Struct Extensions

extension IDERange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.startLineNumber = startLineNumber.jsValue
        obj.startColumn = startColumn.jsValue
        obj.endLineNumber = endLineNumber.jsValue
        obj.endColumn = endColumn.jsValue
        return obj.jsValue
    }
}

extension Position: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.lineNumber = lineNumber.jsValue
        obj.column = column.jsValue
        return obj.jsValue
    }
}

extension TextEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.newText = newText.jsValue
        return obj.jsValue
    }
}

// MARK: - Enum Extensions
// Note: Enums with Int raw values are typically used directly as property values.
// Example: obj.kind = JSValue(kind.rawValue)
// These MonacoObject conformances are provided for cases where the enum itself
// needs to be converted to a JSObject (rare), but typically you'll just use .rawValue.
