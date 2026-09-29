import JavaScriptKit
import MonacoApi

// MARK: - Symbol Types

// use JSValueType instead of MonacoObject
extension Location: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.uri = uri
        obj.range = range
        return obj.jsValue
    }
}

extension LocationLink: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.targetUri = targetUri
        obj.targetRange = targetRange
        obj.targetSelectionRange = targetSelectionRange
        
        if let originSelectionRange = originSelectionRange {
            obj.originSelectionRange = originSelectionRange
        }
        
        return obj.jsValue
    }
}

extension DocumentSymbol: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.name = name
        obj.kind = kind
        obj.range = range
        obj.selectionRange = selectionRange
        
        if let detail = detail {
            obj.detail = detail.jsValue
        }
        if let tags = tags, !tags.isEmpty {
            obj.tags = tags
        }
        if let children = children, !children.isEmpty {
            // Recursive conversion for child symbols
            obj.children = children
        }
        
        return obj.jsValue
    }
}

extension SymbolKind: JSValueType {
    public var jsValue: JSValue {
        return JSValue(integerLiteral: Int32(rawValue))
    }
}

extension SymbolTag: JSValueType {
    public var jsValue: JSValue {
        return JSValue(integerLiteral: Int32(rawValue))
    }
}

extension DocumentHighlightKind: JSValueType {
    public var jsValue: JSValue {
        return JSValue(integerLiteral: Int32(rawValue))
    }
}

extension SelectionRange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range
        
        if let parent = parent {
            obj.parent = parent
        }
        
        return obj.jsValue
    }
}

extension DocumentHighlight: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range
        
        if let kind = kind {
            obj.kind = kind
        }
        
        return obj.jsValue
    }
}

extension ReferenceContext: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.includeDeclaration = includeDeclaration
        return obj.jsValue
    }
}

// MARK: - Signature Help Types

extension ParameterInformation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.label = label
        
        if let documentation = documentation {
            obj.documentation = documentation
        }
        
        return obj.jsValue
    }
}

extension SignatureInformation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.label = label
        
        if let documentation = documentation {
            obj.documentation = documentation
        }
        if let parameters = parameters, !parameters.isEmpty {
            obj.parameters = parameters
        }
        if let activeParameter = activeParameter {
            obj.activeParameter = activeParameter
        }
        
        return obj.jsValue
    }
}

extension SignatureHelp: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.signatures = signatures
        
        if let activeSignature = activeSignature {
            obj.activeSignature = activeSignature
        }
        if let activeParameter = activeParameter {
            obj.activeParameter = activeParameter
        }
        
        return obj.jsValue
    }
}

// MARK: - Formatting Types

extension FoldingRangeKind: JSValueType {}

extension FormattingOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.tabSize = tabSize
        obj.insertSpaces = insertSpaces
        return obj.jsValue
    }
}

// MARK: - Folding Types

extension FoldingRange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.start = start
        obj.end = end
        
        if let kind = kind {
            obj.kind = kind.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - Semantic Tokens Types

extension SemanticTokensLegend: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.tokenTypes = tokenTypes
        obj.tokenModifiers = tokenModifiers
        return obj.jsValue
    }
}

extension SemanticTokens: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let resultId = resultId {
            obj.resultId = resultId
        }
        
        obj.data = data
        
        return obj.jsValue
    }
}

// MARK: - Inlay Hints Types

extension InlayHintKind: JSValueType {}

extension InlayHint: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.position = position
        obj.label = label
        
        if let kind = kind {
            obj.kind = kind.jsValue
        }
        if let tooltip = tooltip {
            obj.tooltip = tooltip
        }
        if let paddingLeft = paddingLeft {
            obj.paddingLeft = paddingLeft
        }
        if let paddingRight = paddingRight {
            obj.paddingRight = paddingRight
        }
        
        return obj.jsValue
    }
}

// MARK: - Inline Completion Types

extension InlineCompletion: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.insertText = insertText
        
        if let insertTextFormat = insertTextFormat {
            obj.insertTextFormat = insertTextFormat.jsValue
        }
        if let additionalTextEdits = additionalTextEdits, !additionalTextEdits.isEmpty {
            obj.additionalTextEdits = additionalTextEdits
        }
        if let command = command {
            obj.command = command
        }
        if let range = range {
            obj.range = range
        }
        
        return obj.jsValue
    }
}

extension InlineCompletionList: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.items = items
        
        if let commands = commands, !commands.isEmpty {
            obj.commands = commands
        }
        
        return obj.jsValue
    }
}

// MARK: - Completion Context Types

extension CompletionContext: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.triggerKind = triggerKind.jsValue
        
        if let triggerCharacter = triggerCharacter {
            obj.triggerCharacter = triggerCharacter
        }
        
        return obj.jsValue
    }
}
