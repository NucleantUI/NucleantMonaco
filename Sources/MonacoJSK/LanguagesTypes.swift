import JavaScriptKit
import MonacoApi

// MARK: - Language Configuration Types

extension IAutoClosingPair: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.open = open.jsValue
        obj.close = close.jsValue
        return obj.jsValue
    }
}

extension IAutoClosingPairConditional: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.open = open.jsValue
        obj.close = close.jsValue
        if let notIn = notIn {
            obj.notIn = notIn.jsValue
        }
        return obj.jsValue
    }
}

extension LineCommentConfig: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let lineComment = lineComment {
            obj.lineComment = lineComment.jsValue
        }
        return obj.jsValue
    }
}

extension CommentRule: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let lineComment = lineComment {
            obj.lineComment = lineComment.jsValue
        }
        if let blockComment = blockComment {
            obj.blockComment = blockComment.jsValue
        }
        return obj.jsValue
    }
}

extension IndentationRule: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.decreaseIndentPattern = decreaseIndentPattern.jsValue
        obj.increaseIndentPattern = increaseIndentPattern.jsValue
        if let indentNextLinePattern = indentNextLinePattern {
            obj.indentNextLinePattern = indentNextLinePattern.jsValue
        }
        if let unIndentedLinePattern = unIndentedLinePattern {
            obj.unIndentedLinePattern = unIndentedLinePattern.jsValue
        }
        return obj.jsValue
    }
}

extension EnterAction: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.indentAction = indentAction.rawValue.jsValue
        if let appendText = appendText {
            obj.appendText = appendText.jsValue
        }
        if let removeText = removeText {
            obj.removeText = removeText.jsValue
        }
        return obj.jsValue
    }
}

extension OnEnterRule: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.beforeText = beforeText.jsValue
        if let afterText = afterText {
            obj.afterText = afterText.jsValue
        }
        if let previousLineText = previousLineText {
            obj.previousLineText = previousLineText.jsValue
        }
        obj.action = action.jsValue
        return obj.jsValue
    }
}

extension FoldingMarkers: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.start = start.jsValue
        obj.end = end.jsValue
        return obj.jsValue
    }
}

extension FoldingRules: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let offSide = offSide {
            obj.offSide = offSide.jsValue
        }
        if let markers = markers {
            obj.markers = markers.jsValue
        }
        return obj.jsValue
    }
}

extension IDocComment: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.open = open.jsValue
        if let close = close {
            obj.close = close.jsValue
        }
        return obj.jsValue
    }
}

extension LanguageConfiguration: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let comments = comments {
            obj.comments = comments.jsValue
        }
        if let brackets = brackets {
            obj.brackets = brackets.jsValue
        }
        if let wordPattern = wordPattern {
            obj.wordPattern = wordPattern.jsValue
        }
        if let indentationRules = indentationRules {
            obj.indentationRules = indentationRules.jsValue
        }
        if let onEnterRules = onEnterRules {
            obj.onEnterRules = onEnterRules.jsValue
        }
        if let autoClosingPairs = autoClosingPairs {
            obj.autoClosingPairs = autoClosingPairs.jsValue
        }
        if let surroundingPairs = surroundingPairs {
            obj.surroundingPairs = surroundingPairs.jsValue
        }
        if let folding = folding {
            obj.folding = folding.jsValue
        }
        if let autoCloseBefore = autoCloseBefore {
            obj.autoCloseBefore = autoCloseBefore.jsValue
        }
        if let docComment = docComment {
            obj.docComment = docComment.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Color Types

extension IColor: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.red = red.jsValue
        obj.green = green.jsValue
        obj.blue = blue.jsValue
        obj.alpha = alpha.jsValue
        return obj.jsValue
    }
}

extension IColorInformation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.color = color.jsValue
        return obj.jsValue
    }
}

extension IColorPresentation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.label = label.jsValue
        if let textEdit = textEdit {
            obj.textEdit = textEdit.jsValue
        }
        if let additionalTextEdits = additionalTextEdits {
            obj.additionalTextEdits = additionalTextEdits.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Link Types

extension ILink: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let url = url {
            obj.url = url.jsValue
        }
        if let tooltip = tooltip {
            obj.tooltip = tooltip.jsValue
        }
        return obj.jsValue
    }
}

extension ILinksList: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.links = links.jsValue
        return obj.jsValue
    }
}

// MARK: - Code Lens Types

extension CodeLens: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let id = id {
            obj.id = id.jsValue
        }
        if let command = command {
            obj.command = command.jsValue
        }
        return obj.jsValue
    }
}

extension CodeLensList: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.lenses = lenses.jsValue
        return obj.jsValue
    }
}

// MARK: - Language Filter

extension LanguageFilter: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let language = language {
            obj.language = language.jsValue
        }
        if let scheme = scheme {
            obj.scheme = scheme.jsValue
        }
        if let pattern = pattern {
            obj.pattern = pattern.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Relative Pattern

extension IRelativePattern: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.base = base.jsValue
        obj.pattern = pattern.jsValue
        return obj.jsValue
    }
}

// MARK: - Workspace Edit Types

extension WorkspaceEditMetadata: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.needsConfirmation = needsConfirmation.jsValue
        if let label = label {
            obj.label = label.jsValue
        }
        if let description = description {
            obj.description_ = description.jsValue
        }
        return obj.jsValue
    }
}

extension IWorkspaceTextEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.resource = resource.jsValue
        obj.edit = edit.jsValue
        if let versionId = versionId {
            obj.versionId = versionId.jsValue
        }
        return obj.jsValue
    }
}

extension WorkspaceFileEditOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let overwrite = overwrite {
            obj.overwrite = overwrite.jsValue
        }
        if let ignoreIfExists = ignoreIfExists {
            obj.ignoreIfExists = ignoreIfExists.jsValue
        }
        if let ignoreIfNotExists = ignoreIfNotExists {
            obj.ignoreIfNotExists = ignoreIfNotExists.jsValue
        }
        if let recursive = recursive {
            obj.recursive = recursive.jsValue
        }
        return obj.jsValue
    }
}

extension IWorkspaceFileEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let oldResource = oldResource {
            obj.oldResource = oldResource.jsValue
        }
        if let newResource = newResource {
            obj.newResource = newResource.jsValue
        }
        if let options = options {
            obj.options = options.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Rename Types

extension RenameLocation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.text = text.jsValue
        return obj.jsValue
    }
}

extension Rejection: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.reason = reason.jsValue
        return obj.jsValue
    }
}

// MARK: - Linked Editing

extension LinkedEditingRanges: JSValueType {
    
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.ranges = ranges.jsValue
        if let wordPattern = wordPattern {
            obj.wordPattern = wordPattern.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Semantic Tokens

extension SemanticTokensEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.start = start.jsValue
        obj.deleteCount = deleteCount.jsValue
        if let data = data {
            obj.data = data.jsValue
        }
        return obj.jsValue
    }
}

extension SemanticTokensEdits: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let resultId = resultId {
            obj.resultId = resultId.jsValue
        }
        obj.edits = edits.jsValue
        return obj.jsValue
    }
}
