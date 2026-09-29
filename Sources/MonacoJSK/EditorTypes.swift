import JavaScriptKit
import MonacoApi

// MARK: - ITextModel

extension ITextModel: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.uri = uri.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelContentChange

extension IModelContentChange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.rangeOffset = rangeOffset.jsValue
        obj.rangeLength = rangeLength.jsValue
        obj.text = text.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelContentChangedEvent

extension IModelContentChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.changes = changes.jsValue
        obj.eol = eol.jsValue
        obj.versionId = versionId.jsValue
        obj.isUndoing = isUndoing.jsValue
        obj.isRedoing = isRedoing.jsValue
        obj.isFlush = isFlush.jsValue
        return obj.jsValue
    }
}

// MARK: - FindMatch

extension FindMatch: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let matches = matches {
            let arr = JSObject()
            for (index, match) in matches.enumerated() {
                arr[index] = match.jsValue
            }
            obj.matches = arr.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - WordAtPosition

extension WordAtPosition: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.word = word.jsValue
        obj.startColumn = startColumn.jsValue
        obj.endColumn = endColumn.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelDecoration

extension IModelDecoration: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.ownerId = ownerId.jsValue
        obj.range = range.jsValue
        obj.options = options.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelDecorationOptions

extension IModelDecorationOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let stickiness = stickiness {
            obj.stickiness = stickiness.rawValue.jsValue
        }
        if let className = className {
            obj.className = className.jsValue
        }
        if let glyphMarginClassName = glyphMarginClassName {
            obj.glyphMarginClassName = glyphMarginClassName.jsValue
        }
        if let hoverMessage = hoverMessage {
            obj.hoverMessage = hoverMessage.jsValue
        }
        if let overviewRuler = overviewRuler {
            obj.overviewRuler = overviewRuler.jsValue
        }
        if let glyphMarginHoverMessage = glyphMarginHoverMessage {
            obj.glyphMarginHoverMessage = glyphMarginHoverMessage.jsValue
        }
        if let glyphMarginText = glyphMarginText {
            obj.glyphMarginText = glyphMarginText.jsValue
        }
        if let glyphMarginLane = glyphMarginLane {
            obj.glyphMarginLane = glyphMarginLane.rawValue.jsValue
        }
        if let minimap = minimap {
            obj.minimap = minimap.jsValue
        }
        if let inlineClassName = inlineClassName {
            obj.inlineClassName = inlineClassName.jsValue
        }
        if let beforeContentClassName = beforeContentClassName {
            obj.beforeContentClassName = beforeContentClassName.jsValue
        }
        if let afterContentClassName = afterContentClassName {
            obj.afterContentClassName = afterContentClassName.jsValue
        }
        if let before = before {
            obj.before = before.jsValue
        }
        if let after = after {
            obj.after = after.jsValue
        }
        if let isWholeLine = isWholeLine {
            obj.isWholeLine = isWholeLine.jsValue
        }
        if let showIfCollapsed = showIfCollapsed {
            obj.showIfCollapsed = showIfCollapsed.jsValue
        }
        if let collapseOnReplaceEdit = collapseOnReplaceEdit {
            obj.collapseOnReplaceEdit = collapseOnReplaceEdit.jsValue
        }
        if let zIndex = zIndex {
            obj.zIndex = zIndex.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IModelDecorationOverviewRulerOptions

extension IModelDecorationOverviewRulerOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.color = color.jsValue
        obj.position = position.rawValue.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelDecorationMinimapOptions

extension IModelDecorationMinimapOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.color = color.jsValue
        obj.position = position.rawValue.jsValue
        return obj.jsValue
    }
}

// MARK: - IModelDecorationContentTextOptions

extension IModelDecorationContentTextOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.content = content.jsValue
        if let inlineClassName = inlineClassName {
            obj.inlineClassName = inlineClassName.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IModelDeltaDecoration

extension IModelDeltaDecoration: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        obj.options = options.jsValue
        return obj.jsValue
    }
}

// MARK: - IValidEditOperation

extension IValidEditOperation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let text = text {
            obj.text = text.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IIdentifiedSingleEditOperation

extension IIdentifiedSingleEditOperation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let text = text {
            obj.text = text.jsValue
        }
        if let forceMoveMarkers = forceMoveMarkers {
            obj.forceMoveMarkers = forceMoveMarkers.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - ISingleEditOperation

extension ISingleEditOperation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let text = text {
            obj.text = text.jsValue
        }
        if let forceMoveMarkers = forceMoveMarkers {
            obj.forceMoveMarkers = forceMoveMarkers.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IEditorAction

extension IEditorAction: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.label = label.jsValue
        if let alias = alias {
            obj.alias = alias.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - ICommand

extension ICommand: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.title = title.jsValue
        if let arguments = arguments {
            let arr = JSObject()
            for (index, arg) in arguments.enumerated() {
                arr[index] = arg.jsValue
            }
            obj.arguments = arr.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - EditorContribution

extension EditorContribution: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.enabled = enabled.jsValue
        return obj.jsValue
    }
}

// MARK: - IViewZone

extension IViewZone: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.afterLineNumber = afterLineNumber.jsValue
        if let afterColumn = afterColumn {
            obj.afterColumn = afterColumn.jsValue
        }
        if let suppressMouseDown = suppressMouseDown {
            obj.suppressMouseDown = suppressMouseDown.jsValue
        }
        if let heightInLines = heightInLines {
            obj.heightInLines = heightInLines.jsValue
        }
        if let minWidth = minWidth {
            obj.minWidth = minWidth.jsValue
        }
        if let domNode = domNode {
            obj.domNode = domNode.jsValue
        }
        if let onDomNodeTop = onDomNodeTop {
            obj.onDomNodeTop = onDomNodeTop.jsValue
        }
        if let onComputedHeight = onComputedHeight {
            obj.onComputedHeight = onComputedHeight.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IContentWidgetPosition

extension IContentWidgetPosition: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.position = position.jsValue
        if let preference = preference {
            let arr = JSObject()
            for (index, pref) in preference.enumerated() {
                arr[index] = pref.rawValue.jsValue
            }
            obj.preference = arr.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IContentWidget

extension IContentWidget: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        if let domNode = domNode {
            obj.domNode = domNode.jsValue
        }
        if let position = position {
            obj.position = position.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IOverlayWidgetPosition

extension IOverlayWidgetPosition: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let preference = preference {
            obj.preference = preference.rawValue.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IOverlayWidget

extension IOverlayWidget: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        if let domNode = domNode {
            obj.domNode = domNode.jsValue
        }
        if let position = position {
            obj.position = position.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IMouseTarget

extension IMouseTarget: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let element = element {
            obj.element = element.jsValue
        }
        obj.type = type.rawValue.jsValue
        obj.mouseColumn = mouseColumn.jsValue
        if let position = position {
            obj.position = position.jsValue
        }
        if let range = range {
            obj.range = range.jsValue
        }
        if let detail = detail {
            obj.detail = detail.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IEditorMouseEvent

extension IEditorMouseEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.event = event.jsValue
        obj.target = target.jsValue
        return obj.jsValue
    }
}

// MARK: - IPartialEditorMouseEvent

extension IPartialEditorMouseEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.event = event.jsValue
        if let target = target {
            obj.target = target.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IRelatedInformation

extension IRelatedInformation: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.resource = resource.jsValue
        obj.startLineNumber = startLineNumber.jsValue
        obj.startColumn = startColumn.jsValue
        obj.endLineNumber = endLineNumber.jsValue
        obj.endColumn = endColumn.jsValue
        obj.message = message.jsValue
        return obj.jsValue
    }
}

// MARK: - IMarkerData

extension IMarkerData: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let code = code {
            obj.code = code.jsValue
        }
        obj.severity = severity.rawValue.jsValue
        obj.message = message.jsValue
        if let source = source {
            obj.source = source.jsValue
        }
        obj.startLineNumber = startLineNumber.jsValue
        obj.startColumn = startColumn.jsValue
        obj.endLineNumber = endLineNumber.jsValue
        obj.endColumn = endColumn.jsValue
        if let relatedInformation = relatedInformation {
            obj.relatedInformation = relatedInformation.jsValue
        }
        if let tags = tags {
            let arr = JSObject()
            for (index, tag) in tags.enumerated() {
                arr[index] = tag.rawValue.jsValue
            }
            obj.tags = arr.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IMarker

extension IMarker: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.owner = owner.jsValue
        obj.resource = resource.jsValue
        obj.severity = severity.rawValue.jsValue
        if let code = code {
            obj.code = code.jsValue
        }
        obj.message = message.jsValue
        if let source = source {
            obj.source = source.jsValue
        }
        obj.startLineNumber = startLineNumber.jsValue
        obj.startColumn = startColumn.jsValue
        obj.endLineNumber = endLineNumber.jsValue
        obj.endColumn = endColumn.jsValue
        if let relatedInformation = relatedInformation {
            obj.relatedInformation = relatedInformation.jsValue
        }
        if let tags = tags {
            let arr = JSObject()
            for (index, tag) in tags.enumerated() {
                arr[index] = tag.rawValue.jsValue
            }
            obj.tags = arr.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IResourceTextEdit

extension IResourceTextEdit: JSValueType {
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

// MARK: - IResourceFileEdit

extension IResourceFileEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let oldResource = oldResource {
            obj.oldResource = oldResource.jsValue
        }
        obj.newResource = newResource.jsValue
        if let options = options {
            obj.options = options.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - FileOperationOptions

extension FileOperationOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let overwrite = overwrite {
            obj.overwrite = overwrite.jsValue
        }
        if let ignoreIfNotExists = ignoreIfNotExists {
            obj.ignoreIfNotExists = ignoreIfNotExists.jsValue
        }
        if let ignoreIfExists = ignoreIfExists {
            obj.ignoreIfExists = ignoreIfExists.jsValue
        }
        if let recursive = recursive {
            obj.recursive = recursive.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - IWorkspaceEdit

extension IWorkspaceEdit: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let edits = edits {
            obj.edits = edits.jsValue
        }
        if let fileOperations = fileOperations {
            obj.fileOperations = fileOperations.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Editor Interfaces

extension IDimension: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.width = width.jsValue
        obj.height = height.jsValue
        return obj.jsValue
    }
}

extension Selection: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.selectionStartLineNumber = selectionStartLineNumber.jsValue
        obj.selectionStartColumn = selectionStartColumn.jsValue
        obj.positionLineNumber = positionLineNumber.jsValue
        obj.positionColumn = positionColumn.jsValue
        return obj.jsValue
    }
}

extension IChange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.originalStartLineNumber = originalStartLineNumber.jsValue
        obj.originalEndLineNumber = originalEndLineNumber.jsValue
        obj.modifiedStartLineNumber = modifiedStartLineNumber.jsValue
        obj.modifiedEndLineNumber = modifiedEndLineNumber.jsValue
        return obj.jsValue
    }
}

extension ICharChange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.originalStartLineNumber = originalStartLineNumber.jsValue
        obj.originalStartColumn = originalStartColumn.jsValue
        obj.originalEndLineNumber = originalEndLineNumber.jsValue
        obj.originalEndColumn = originalEndColumn.jsValue
        obj.modifiedStartLineNumber = modifiedStartLineNumber.jsValue
        obj.modifiedStartColumn = modifiedStartColumn.jsValue
        obj.modifiedEndLineNumber = modifiedEndLineNumber.jsValue
        obj.modifiedEndColumn = modifiedEndColumn.jsValue
        return obj.jsValue
    }
}

extension ILineChange: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.originalStartLineNumber = originalStartLineNumber.jsValue
        obj.originalEndLineNumber = originalEndLineNumber.jsValue
        obj.modifiedStartLineNumber = modifiedStartLineNumber.jsValue
        obj.modifiedEndLineNumber = modifiedEndLineNumber.jsValue
        if let charChanges = charChanges {
            obj.charChanges = charChanges.jsValue
        }
        return obj.jsValue
    }
}

extension ICursorState: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.inSelectionMode = inSelectionMode.jsValue
        obj.selectionStart = selectionStart.jsValue
        obj.position = position.jsValue
        return obj.jsValue
    }
}

extension IViewState: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let scrollTop = scrollTop {
            obj.scrollTop = scrollTop.jsValue
        }
        if let scrollLeft = scrollLeft {
            obj.scrollLeft = scrollLeft.jsValue
        }
        if let firstPosition = firstPosition {
            obj.firstPosition = firstPosition.jsValue
        }
        if let firstPositionDeltaTop = firstPositionDeltaTop {
            obj.firstPositionDeltaTop = firstPositionDeltaTop.jsValue
        }
        return obj.jsValue
    }
}

extension ICodeEditorViewState: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let cursorState = cursorState {
            obj.cursorState = cursorState.jsValue
        }
        if let viewState = viewState {
            obj.viewState = viewState.jsValue
        }
        if let contributionsState = contributionsState {
            let contributions = JSObject()
            for (key, value) in contributionsState {
                contributions[key] = value.jsValue
            }
            obj.contributionsState = contributions.jsValue
        }
        return obj.jsValue
    }
}

extension IDiffEditorViewState: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let original = original {
            obj.original = original.jsValue
        }
        if let modified = modified {
            obj.modified = modified.jsValue
        }
        return obj.jsValue
    }
}

extension INewScrollPosition: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let scrollLeft = scrollLeft {
            obj.scrollLeft = scrollLeft.jsValue
        }
        if let scrollTop = scrollTop {
            obj.scrollTop = scrollTop.jsValue
        }
        return obj.jsValue
    }
}

extension IContentSizeChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.contentWidth = contentWidth.jsValue
        obj.contentHeight = contentHeight.jsValue
        obj.contentWidthChanged = contentWidthChanged.jsValue
        obj.contentHeightChanged = contentHeightChanged.jsValue
        return obj.jsValue
    }
}

extension ICursorPositionChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.position = position.jsValue
        if let secondaryPositions = secondaryPositions {
            obj.secondaryPositions = secondaryPositions.jsValue
        }
        obj.reason = reason.rawValue.jsValue
        if let source = source {
            obj.source = source.jsValue
        }
        return obj.jsValue
    }
}

extension ICursorSelectionChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.selection = selection.jsValue
        if let secondarySelections = secondarySelections {
            obj.secondarySelections = secondarySelections.jsValue
        }
        if let modelVersionId = modelVersionId {
            obj.modelVersionId = modelVersionId.jsValue
        }
        if let oldSelections = oldSelections {
            obj.oldSelections = oldSelections.jsValue
        }
        if let oldModelVersionId = oldModelVersionId {
            obj.oldModelVersionId = oldModelVersionId.jsValue
        }
        if let source = source {
            obj.source = source.jsValue
        }
        obj.reason = reason.rawValue.jsValue
        return obj.jsValue
    }
}

extension IModelChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let oldModelUrl = oldModelUrl {
            obj.oldModelUrl = oldModelUrl.jsValue
        }
        if let newModelUrl = newModelUrl {
            obj.newModelUrl = newModelUrl.jsValue
        }
        return obj.jsValue
    }
}

extension IModelLanguageChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.oldLanguage = oldLanguage.jsValue
        obj.newLanguage = newLanguage.jsValue
        return obj.jsValue
    }
}

extension IModelLanguageConfigurationChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.languageId = languageId.jsValue
        return obj.jsValue
    }
}

extension IModelOptionsChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.tabSize = tabSize.jsValue
        obj.indentSize = indentSize.jsValue
        obj.insertSpaces = insertSpaces.jsValue
        obj.trimAutoWhitespace = trimAutoWhitespace.jsValue
        return obj.jsValue
    }
}

extension IModelDecorationsChangedEvent: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.affectsMinimap = affectsMinimap.jsValue
        obj.affectsOverviewRuler = affectsOverviewRuler.jsValue
        obj.affectsGlyphMargin = affectsGlyphMargin.jsValue
        obj.affectsLineNumber = affectsLineNumber.jsValue
        return obj.jsValue
    }
}

extension ITextModelUpdateOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let tabSize = tabSize {
            obj.tabSize = tabSize.jsValue
        }
        if let indentSize = indentSize {
            obj.indentSize = indentSize.jsValue
        }
        if let insertSpaces = insertSpaces {
            obj.insertSpaces = insertSpaces.jsValue
        }
        if let trimAutoWhitespace = trimAutoWhitespace {
            obj.trimAutoWhitespace = trimAutoWhitespace.jsValue
        }
        return obj.jsValue
    }
}

extension IDecorationOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.range = range.jsValue
        if let hoverMessage = hoverMessage {
            obj.hoverMessage = hoverMessage.jsValue
        }
        if let renderOptions = renderOptions {
            obj.renderOptions = renderOptions.jsValue
        }
        return obj.jsValue
    }
}

extension IDecorationRenderOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let className = className {
            obj.className = className.jsValue
        }
        if let before = before {
            obj.before = before.jsValue
        }
        if let after = after {
            obj.after = after.jsValue
        }
        return obj.jsValue
    }
}

extension IContentDecorationRenderOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let contentText = contentText {
            obj.contentText = contentText.jsValue
        }
        if let contentIconPath = contentIconPath {
            obj.contentIconPath = contentIconPath.jsValue
        }
        if let margin = margin {
            obj.margin = margin.jsValue
        }
        if let width = width {
            obj.width = width.jsValue
        }
        if let height = height {
            obj.height = height.jsValue
        }
        return obj.jsValue
    }
}

extension IRulerOption: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.column = column.jsValue
        if let color = color {
            obj.color = color.jsValue
        }
        return obj.jsValue
    }
}

extension EditorWrappingInfo: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.isViewportWrapping = isViewportWrapping.jsValue
        obj.wrappingColumn = wrappingColumn.jsValue
        return obj.jsValue
    }
}

extension EditorMinimapLayoutInfo: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.renderMinimap = renderMinimap.rawValue.jsValue
        obj.minimapLeft = minimapLeft.jsValue
        obj.minimapWidth = minimapWidth.jsValue
        obj.minimapHeight = minimapHeight.jsValue
        obj.minimapCanvasInnerWidth = minimapCanvasInnerWidth.jsValue
        obj.minimapCanvasInnerHeight = minimapCanvasInnerHeight.jsValue
        obj.minimapCanvasOuterWidth = minimapCanvasOuterWidth.jsValue
        obj.minimapCanvasOuterHeight = minimapCanvasOuterHeight.jsValue
        return obj.jsValue
    }
}

extension ThemeColor: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        return obj.jsValue
    }
}

extension ThemeIcon: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        if let color = color {
            obj.color = color.jsValue
        }
        return obj.jsValue
    }
}

extension InjectedTextOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.content = content.jsValue
        if let inlineClassName = inlineClassName {
            obj.inlineClassName = inlineClassName.jsValue
        }
        if let inlineClassNameAffectsLetterSpacing = inlineClassNameAffectsLetterSpacing {
            obj.inlineClassNameAffectsLetterSpacing = inlineClassNameAffectsLetterSpacing.jsValue
        }
        return obj.jsValue
    }
}

extension IActionDescriptor: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        obj.id = id.jsValue
        obj.label = label.jsValue
        if let aliases = aliases {
            let arr = JSObject()
            for (index, alias) in aliases.enumerated() {
                arr[index] = alias.jsValue
            }
            obj.aliases = arr.jsValue
        }
        if let precondition = precondition {
            obj.precondition = precondition.jsValue
        }
        if let keybindings = keybindings {
            let arr = JSObject()
            for (index, keybinding) in keybindings.enumerated() {
                arr[index] = keybinding.jsValue
            }
            obj.keybindings = arr.jsValue
        }
        if let keybindingContext = keybindingContext {
            obj.keybindingContext = keybindingContext.jsValue
        }
        if let contextMenuGroupId = contextMenuGroupId {
            obj.contextMenuGroupId = contextMenuGroupId.jsValue
        }
        if let contextMenuOrder = contextMenuOrder {
            obj.contextMenuOrder = contextMenuOrder.jsValue
        }
        return obj.jsValue
    }
}

// MARK: - Editor Options

extension EditorScrollbarOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let arrowSize = arrowSize {
            obj.arrowSize = arrowSize.jsValue
        }
        if let vertical = vertical {
            obj.vertical = vertical.rawValue.jsValue
        }
        if let horizontal = horizontal {
            obj.horizontal = horizontal.rawValue.jsValue
        }
        if let useShadows = useShadows {
            obj.useShadows = useShadows.jsValue
        }
        if let verticalScrollbarSize = verticalScrollbarSize {
            obj.verticalScrollbarSize = verticalScrollbarSize.jsValue
        }
        if let horizontalScrollbarSize = horizontalScrollbarSize {
            obj.horizontalScrollbarSize = horizontalScrollbarSize.jsValue
        }
        if let verticalSliderSize = verticalSliderSize {
            obj.verticalSliderSize = verticalSliderSize.jsValue
        }
        if let horizontalSliderSize = horizontalSliderSize {
            obj.horizontalSliderSize = horizontalSliderSize.jsValue
        }
        if let handleMouseWheel = handleMouseWheel {
            obj.handleMouseWheel = handleMouseWheel.jsValue
        }
        if let alwaysConsumeMouseWheel = alwaysConsumeMouseWheel {
            obj.alwaysConsumeMouseWheel = alwaysConsumeMouseWheel.jsValue
        }
        if let scrollByPage = scrollByPage {
            obj.scrollByPage = scrollByPage.jsValue
        }
        return obj.jsValue
    }
}

extension EditorFindOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let seedSearchStringFromSelection = seedSearchStringFromSelection {
            obj.seedSearchStringFromSelection = seedSearchStringFromSelection.jsValue
        }
        if let autoFindInSelection = autoFindInSelection {
            obj.autoFindInSelection = autoFindInSelection.jsValue
        }
        if let addExtraSpaceOnTop = addExtraSpaceOnTop {
            obj.addExtraSpaceOnTop = addExtraSpaceOnTop.jsValue
        }
        if let loop = loop {
            obj.loop = loop.jsValue
        }
        return obj.jsValue
    }
}

extension EditorMinimapOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let enabled = enabled {
            obj.enabled = enabled.jsValue
        }
        if let autohide = autohide {
            obj.autohide = autohide.jsValue
        }
        if let side = side {
            obj.side = side.rawValue.jsValue
        }
        if let showSlider = showSlider {
            obj.showSlider = showSlider.jsValue
        }
        if let renderCharacters = renderCharacters {
            obj.renderCharacters = renderCharacters.jsValue
        }
        if let maxColumn = maxColumn {
            obj.maxColumn = maxColumn.jsValue
        }
        if let scale = scale {
            obj.scale = scale.jsValue
        }
        if let size = size {
            obj.size = size.jsValue
        }
        return obj.jsValue
    }
}

extension EditorPaddingOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let top = top {
            obj.top = top.jsValue
        }
        if let bottom = bottom {
            obj.bottom = bottom.jsValue
        }
        return obj.jsValue
    }
}

extension QuickSuggestionsOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let other = other {
            obj.other = other.jsValue
        }
        if let comments = comments {
            obj.comments = comments.jsValue
        }
        if let strings = strings {
            obj.strings = strings.jsValue
        }
        return obj.jsValue
    }
}

extension SuggestOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let insertMode = insertMode {
            obj.insertMode = insertMode.jsValue
        }
        if let filterGraceful = filterGraceful {
            obj.filterGraceful = filterGraceful.jsValue
        }
        if let snippetsPreventQuickSuggestions = snippetsPreventQuickSuggestions {
            obj.snippetsPreventQuickSuggestions = snippetsPreventQuickSuggestions.jsValue
        }
        if let localityBonus = localityBonus {
            obj.localityBonus = localityBonus.jsValue
        }
        if let shareSuggestSelections = shareSuggestSelections {
            obj.shareSuggestSelections = shareSuggestSelections.jsValue
        }
        if let showIcons = showIcons {
            obj.showIcons = showIcons.jsValue
        }
        if let maxVisibleSuggestions = maxVisibleSuggestions {
            obj.maxVisibleSuggestions = maxVisibleSuggestions.jsValue
        }
        if let showMethods = showMethods {
            obj.showMethods = showMethods.jsValue
        }
        if let showFunctions = showFunctions {
            obj.showFunctions = showFunctions.jsValue
        }
        if let showConstructors = showConstructors {
            obj.showConstructors = showConstructors.jsValue
        }
        if let showFields = showFields {
            obj.showFields = showFields.jsValue
        }
        if let showVariables = showVariables {
            obj.showVariables = showVariables.jsValue
        }
        if let showClasses = showClasses {
            obj.showClasses = showClasses.jsValue
        }
        if let showStructs = showStructs {
            obj.showStructs = showStructs.jsValue
        }
        if let showInterfaces = showInterfaces {
            obj.showInterfaces = showInterfaces.jsValue
        }
        if let showModules = showModules {
            obj.showModules = showModules.jsValue
        }
        if let showProperties = showProperties {
            obj.showProperties = showProperties.jsValue
        }
        if let showEvents = showEvents {
            obj.showEvents = showEvents.jsValue
        }
        if let showOperators = showOperators {
            obj.showOperators = showOperators.jsValue
        }
        if let showUnits = showUnits {
            obj.showUnits = showUnits.jsValue
        }
        if let showValues = showValues {
            obj.showValues = showValues.jsValue
        }
        if let showConstants = showConstants {
            obj.showConstants = showConstants.jsValue
        }
        if let showEnums = showEnums {
            obj.showEnums = showEnums.jsValue
        }
        if let showEnumMembers = showEnumMembers {
            obj.showEnumMembers = showEnumMembers.jsValue
        }
        if let showKeywords = showKeywords {
            obj.showKeywords = showKeywords.jsValue
        }
        if let showWords = showWords {
            obj.showWords = showWords.jsValue
        }
        if let showColors = showColors {
            obj.showColors = showColors.jsValue
        }
        if let showFiles = showFiles {
            obj.showFiles = showFiles.jsValue
        }
        if let showReferences = showReferences {
            obj.showReferences = showReferences.jsValue
        }
        if let showFolders = showFolders {
            obj.showFolders = showFolders.jsValue
        }
        if let showTypeParameters = showTypeParameters {
            obj.showTypeParameters = showTypeParameters.jsValue
        }
        if let showSnippets = showSnippets {
            obj.showSnippets = showSnippets.jsValue
        }
        return obj.jsValue
    }
}

extension EditorHoverOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let enabled = enabled {
            obj.enabled = enabled.jsValue
        }
        if let delay = delay {
            obj.delay = delay.jsValue
        }
        if let sticky = sticky {
            obj.sticky = sticky.jsValue
        }
        if let above = above {
            obj.above = above.jsValue
        }
        return obj.jsValue
    }
}

extension EditorParameterHintOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let enabled = enabled {
            obj.enabled = enabled.jsValue
        }
        if let cycle = cycle {
            obj.cycle = cycle.jsValue
        }
        return obj.jsValue
    }
}

extension EditorLightbulbOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let enabled = enabled {
            obj.enabled = enabled.jsValue
        }
        return obj.jsValue
    }
}

extension BracketPairColorizationOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let enabled = enabled {
            obj.enabled = enabled.jsValue
        }
        if let independentColorPoolPerBracketType = independentColorPoolPerBracketType {
            obj.independentColorPoolPerBracketType = independentColorPoolPerBracketType.jsValue
        }
        return obj.jsValue
    }
}

extension GuidesOptions: JSValueType {
    public var jsValue: JSValue {
        let obj = JSObject()
        if let bracketPairs = bracketPairs {
            obj.bracketPairs = bracketPairs.jsValue
        }
        if let bracketPairsHorizontal = bracketPairsHorizontal {
            obj.bracketPairsHorizontal = bracketPairsHorizontal.jsValue
        }
        if let highlightActiveBracketPair = highlightActiveBracketPair {
            obj.highlightActiveBracketPair = highlightActiveBracketPair.jsValue
        }
        if let indentation = indentation {
            obj.indentation = indentation.jsValue
        }
        if let highlightActiveIndentation = highlightActiveIndentation {
            obj.highlightActiveIndentation = highlightActiveIndentation.jsValue
        }
        return obj.jsValue
    }
}
