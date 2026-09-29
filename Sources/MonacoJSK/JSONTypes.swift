import JavaScriptKit
import MonacoApi

// MARK: - JSON Diagnostics Options

extension JSONDiagnosticsOptions: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let validate = validate {
            obj.validate = validate.jsValue
        }
        if let allowComments = allowComments {
            obj.allowComments = allowComments.jsValue
        }
        if let schemas = schemas, !schemas.isEmpty {
            obj.schemas = schemas.jsValue
        }
        if let enableSchemaRequest = enableSchemaRequest {
            obj.enableSchemaRequest = enableSchemaRequest.jsValue
        }
        if let schemaValidation = schemaValidation {
            obj.schemaValidation = schemaValidation.rawValue.jsValue
        }
        if let schemaRequest = schemaRequest {
            obj.schemaRequest = schemaRequest.rawValue.jsValue
        }
        
        return obj.jsValue
    }
}



// MARK: - JSON Schema

extension JSONSchema: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.uri = uri.jsValue
        
        if let fileMatch = fileMatch, !fileMatch.isEmpty {
            let matchArray = JSObject()
            for (index, pattern) in fileMatch.enumerated() {
                matchArray[index] = pattern.jsValue
            }
            obj.fileMatch = matchArray.jsValue
        }
        if let schema = schema {
            obj.schema = schema.jsValue
        }
        
        return obj.jsValue
    }
}

extension JSONSchemaObject: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let id = id {
            obj["$id"] = id.jsValue
        }
        if let schema = schema {
            obj["$schema"] = schema.jsValue
        }
        if let title = title {
            obj.title = title.jsValue
        }
        if let description = description {
            obj["description"] = description.jsValue
        }
        if let type = type {
            obj.type = type.jsValue
        }
        if let properties = properties, !properties.isEmpty {
            let propsObj = JSObject()
            for (key, value) in properties {
                propsObj[key] = value.jsValue
            }
            obj.properties = propsObj.jsValue
        }
        if let required = required, !required.isEmpty {
            let reqArray = JSObject()
            for (index, prop) in required.enumerated() {
                reqArray[index] = prop.jsValue
            }
            obj.required = reqArray.jsValue
        }
        if let additionalProperties = additionalProperties {
            obj.additionalProperties = additionalProperties.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - JSON Mode Configuration

extension JSONModeConfiguration: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let documentFormattingEdits = documentFormattingEdits {
            obj.documentFormattingEdits = documentFormattingEdits.jsValue
        }
        if let documentRangeFormattingEdits = documentRangeFormattingEdits {
            obj.documentRangeFormattingEdits = documentRangeFormattingEdits.jsValue
        }
        if let completionItems = completionItems {
            obj.completionItems = completionItems.jsValue
        }
        if let hovers = hovers {
            obj.hovers = hovers.jsValue
        }
        if let documentSymbols = documentSymbols {
            obj.documentSymbols = documentSymbols.jsValue
        }
        if let tokens = tokens {
            obj.tokens = tokens.jsValue
        }
        if let colors = colors {
            obj.colors = colors.jsValue
        }
        if let foldingRanges = foldingRanges {
            obj.foldingRanges = foldingRanges.jsValue
        }
        if let diagnostics = diagnostics {
            obj.diagnostics = diagnostics.jsValue
        }
        if let selectionRanges = selectionRanges {
            obj.selectionRanges = selectionRanges.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - JSON Formatting Options

extension JSONFormattingOptions: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let tabSize = tabSize {
            obj.tabSize = tabSize.jsValue
        }
        if let insertSpaces = insertSpaces {
            obj.insertSpaces = insertSpaces.jsValue
        }
        if let printWidth = printWidth {
            obj.printWidth = printWidth.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - Language Service Defaults

extension JSONLanguageServiceDefaults: ConvertibleToJSValue {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let diagnosticsOptions = diagnosticsOptions {
            obj.diagnosticsOptions = diagnosticsOptions.jsValue
        }
        if let modeConfiguration = modeConfiguration {
            obj.modeConfiguration = modeConfiguration.jsValue
        }
        
        return obj.jsValue
    }
}
