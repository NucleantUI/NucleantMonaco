import JavaScriptKit
import MonacoApi

extension InsertTextFormat: JSValueType {}
extension CompletionTriggerKind: JSValueType {}

// MARK: - Hover Types

extension MarkdownString: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.value = value
        
        if let isTrusted = isTrusted {
            obj.isTrusted = isTrusted
        }
        if let supportHtml = supportHtml {
            obj.supportHtml = supportHtml
        }
        if let baseUri = baseUri {
            obj.baseUri = baseUri
        }
        
        return obj.jsValue
    }
}

extension HoverContent: JSValueType {
    public var jsValue: JSValue {
        switch self {
        case .markdown(let md):
            let obj = md.jsValue
            return obj
        case .plainText(let text):
            // Monaco accepts plain string as hover content
            let obj = JSObject()
            obj.value = text
            return obj.jsValue
        }
    }
}

extension Hover: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        // Convert contents array to proper JavaScript array
        obj.contents = contents.map { $0.jsValue }.jsValue
        
        if let range = range {
            obj.range = range.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - Diagnostic Types

extension DiagnosticRelatedInformation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.message = message.jsValue
        return obj.jsValue
    }
}

extension Diagnostic: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.severity = severity.jsValue
        obj.message = message.jsValue
        obj.startLineNumber = range.startLineNumber.jsValue
        obj.startColumn = range.startColumn.jsValue
        obj.endLineNumber = range.endLineNumber.jsValue
        obj.endColumn = range.endColumn.jsValue
        
        if let source = source {
            obj.source = source.jsValue
        }
        if let code = code {
            obj.code = code.jsValue
        }
        if let relatedInformation = relatedInformation, !relatedInformation.isEmpty {
            obj.relatedInformation = relatedInformation.jsValue
        }
        if let tags = tags, !tags.isEmpty {
            let tagsArray = JSObject()
            for (index, tag) in tags.enumerated() {
                tagsArray[index] = tag.jsValue
            }
            obj.tags = tagsArray.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - Completion Types

extension CompletionItemLabel: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.label = label.jsValue
        
        if let detail = detail {
            obj.detail = detail.jsValue
        }
        if let description = description {
            obj["description"] = description.jsValue
        }
        
        return obj.jsValue
    }
}

extension Command: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.title = title.jsValue
        obj.command = command.jsValue
        
        if let arguments = arguments, !arguments.isEmpty {
            let argsArray = JSObject()
            for (index, arg) in arguments.enumerated() {
                argsArray[index] = arg.jsValue
            }
            obj.arguments = argsArray.jsValue
        }
        
        return obj.jsValue
    }
}

extension CompletionItemRange: JSValueType {
    public var jsValue: JSValue {
        switch self {
        case .single(let range):
            return range.jsValue
        case .insertReplace(let insert, let replace):
            let obj = JSObject()
            obj.insert = insert
            obj.replace = replace
            return obj.jsValue
        }
    }
}

extension CompletionItem: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.label = label.jsValue
        obj.kind = kind.jsValue
        obj.insertText = insertText.jsValue
        
        if let labelDetails = labelDetails {
            obj.labelDetails = labelDetails.jsValue
        }
        if let tags = tags, !tags.isEmpty {
            let tagsArray = JSObject()
            for (index, tag) in tags.enumerated() {
                tagsArray[index] = tag.jsValue
            }
            obj.tags = tagsArray.jsValue
        }
        if let detail = detail {
            obj.detail = detail.jsValue
        }
        if let documentation = documentation {
            obj.documentation = documentation.jsValue
        }
        if let insertTextFormat = insertTextFormat {
            obj.insertTextFormat = insertTextFormat.jsValue
        }
        if let insertTextRules = insertTextRules {
            obj.insertTextRules = insertTextRules.jsValue
        }
        if let range = range {
            obj.range = range.jsValue
        }
        if let additionalTextEdits = additionalTextEdits, !additionalTextEdits.isEmpty {
            obj.additionalTextEdits = additionalTextEdits.jsValue
        }
        if let command = command {
            obj.command = command.jsValue
        }
        if let commitCharacters = commitCharacters, !commitCharacters.isEmpty {
            let charsArray = JSObject()
            for (index, char) in commitCharacters.enumerated() {
                charsArray[index] = char.jsValue
            }
            obj.commitCharacters = charsArray.jsValue
        }
        if let sortText = sortText {
            obj.sortText = sortText.jsValue
        }
        if let filterText = filterText {
            obj.filterText = filterText.jsValue
        }
        if let preselect = preselect {
            obj.preselect = preselect.jsValue
        }
        if let keepWhitespace = keepWhitespace {
            obj.keepWhitespace = keepWhitespace.jsValue
        }
        
        return obj.jsValue
    }
}

extension CompletionList: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.suggestions = suggestions.jsValue
        
        if let incomplete = incomplete {
            obj.incomplete = incomplete.jsValue
        }
        if let dispose = dispose {
            obj.dispose = dispose.jsValue
        }
        
        return obj.jsValue
    }
}

// MARK: - Code Action Types

extension CodeActionKind: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.value = value.jsValue
        return obj.jsValue
    }
}

extension WorkspaceEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        
        if let changes = changes, !changes.isEmpty {
            let changesObj = JSObject()
            for (uri, edits) in changes {
                changesObj[uri] = edits.jsValue
            }
            obj.changes = changesObj.jsValue
        }
        
        return obj.jsValue
    }
}

extension CodeAction: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.title = title.jsValue
        
        if let kind = kind {
            obj.kind = kind.value.jsValue
        }
        if let diagnostics = diagnostics, !diagnostics.isEmpty {
            obj.diagnostics = diagnostics.jsValue
        }
        if let edit = edit {
            obj.edit = edit.jsValue
        }
        if let isPreferred = isPreferred {
            obj.isPreferred = isPreferred.jsValue
        }
        
        return obj.jsValue
    }
}
