
// MARK: - Dimension

/// Represents a dimension
public struct IDimension: Codable, Sendable {
    /// Width
    public let width: Int
    /// Height
    public let height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

// MARK: - Selection

/// Represents a selection in the editor
public struct Selection: Codable, Sendable {
    /// Selection start line number (1-based)
    public let selectionStartLineNumber: Int
    /// Selection start column (1-based)
    public let selectionStartColumn: Int
    /// Position line number (1-based)
    public let positionLineNumber: Int
    /// Position column (1-based)
    public let positionColumn: Int
    
    public init(
        selectionStartLineNumber: Int,
        selectionStartColumn: Int,
        positionLineNumber: Int,
        positionColumn: Int
    ) {
        self.selectionStartLineNumber = selectionStartLineNumber
        self.selectionStartColumn = selectionStartColumn
        self.positionLineNumber = positionLineNumber
        self.positionColumn = positionColumn
    }
}

// MARK: - Change

/// Represents a change
public struct IChange: Codable, Sendable {
    /// Original start line number
    public let originalStartLineNumber: Int
    /// Original end line number
    public let originalEndLineNumber: Int
    /// Modified start line number
    public let modifiedStartLineNumber: Int
    /// Modified end line number
    public let modifiedEndLineNumber: Int
    
    public init(
        originalStartLineNumber: Int,
        originalEndLineNumber: Int,
        modifiedStartLineNumber: Int,
        modifiedEndLineNumber: Int
    ) {
        self.originalStartLineNumber = originalStartLineNumber
        self.originalEndLineNumber = originalEndLineNumber
        self.modifiedStartLineNumber = modifiedStartLineNumber
        self.modifiedEndLineNumber = modifiedEndLineNumber
    }
}

// MARK: - Character Change

/// Represents a character level change
public struct ICharChange: Codable, Sendable {
    /// Original start line number
    public let originalStartLineNumber: Int
    /// Original start column
    public let originalStartColumn: Int
    /// Original end line number
    public let originalEndLineNumber: Int
    /// Original end column
    public let originalEndColumn: Int
    /// Modified start line number
    public let modifiedStartLineNumber: Int
    /// Modified start column
    public let modifiedStartColumn: Int
    /// Modified end line number
    public let modifiedEndLineNumber: Int
    /// Modified end column
    public let modifiedEndColumn: Int
    
    public init(
        originalStartLineNumber: Int,
        originalStartColumn: Int,
        originalEndLineNumber: Int,
        originalEndColumn: Int,
        modifiedStartLineNumber: Int,
        modifiedStartColumn: Int,
        modifiedEndLineNumber: Int,
        modifiedEndColumn: Int
    ) {
        self.originalStartLineNumber = originalStartLineNumber
        self.originalStartColumn = originalStartColumn
        self.originalEndLineNumber = originalEndLineNumber
        self.originalEndColumn = originalEndColumn
        self.modifiedStartLineNumber = modifiedStartLineNumber
        self.modifiedStartColumn = modifiedStartColumn
        self.modifiedEndLineNumber = modifiedEndLineNumber
        self.modifiedEndColumn = modifiedEndColumn
    }
}

// MARK: - Line Change

/// Represents a line change in diff
public struct ILineChange: Codable, Sendable {
    /// Original start line number
    public let originalStartLineNumber: Int
    /// Original end line number
    public let originalEndLineNumber: Int
    /// Modified start line number
    public let modifiedStartLineNumber: Int
    /// Modified end line number
    public let modifiedEndLineNumber: Int
    /// Character changes within the line
    public let charChanges: [ICharChange]?
    
    public init(
        originalStartLineNumber: Int,
        originalEndLineNumber: Int,
        modifiedStartLineNumber: Int,
        modifiedEndLineNumber: Int,
        charChanges: [ICharChange]? = nil
    ) {
        self.originalStartLineNumber = originalStartLineNumber
        self.originalEndLineNumber = originalEndLineNumber
        self.modifiedStartLineNumber = modifiedStartLineNumber
        self.modifiedEndLineNumber = modifiedEndLineNumber
        self.charChanges = charChanges
    }
}

// MARK: - Cursor State

/// Represents cursor state
public struct ICursorState: Codable, Sendable {
    /// In selection mode
    public let inSelectionMode: Bool
    /// Selection start
    public let selectionStart: Position
    /// Position
    public let position: Position
    
    public init(inSelectionMode: Bool, selectionStart: Position, position: Position) {
        self.inSelectionMode = inSelectionMode
        self.selectionStart = selectionStart
        self.position = position
    }
}

// MARK: - View State

/// Represents the view state of an editor
public struct IViewState: Codable, Sendable {
    /// Scroll position
    public let scrollTop: Int?
    /// Scroll position
    public let scrollLeft: Int?
    /// First visible line
    public let firstPosition: Position?
    /// First visible line fully visible
    public let firstPositionDeltaTop: Int?
    
    public init(
        scrollTop: Int? = nil,
        scrollLeft: Int? = nil,
        firstPosition: Position? = nil,
        firstPositionDeltaTop: Int? = nil
    ) {
        self.scrollTop = scrollTop
        self.scrollLeft = scrollLeft
        self.firstPosition = firstPosition
        self.firstPositionDeltaTop = firstPositionDeltaTop
    }
}

// MARK: - Code Editor View State

/// The view state of a code editor
public struct ICodeEditorViewState: Codable, Sendable {
    /// Cursor state
    public let cursorState: [ICursorState]?
    /// View state
    public let viewState: IViewState?
    /// Contribution state
    public let contributionsState: [String: String]?
    
    public init(
        cursorState: [ICursorState]? = nil,
        viewState: IViewState? = nil,
        contributionsState: [String: String]? = nil
    ) {
        self.cursorState = cursorState
        self.viewState = viewState
        self.contributionsState = contributionsState
    }
}

// MARK: - Diff Editor View State

/// The view state of a diff editor
public struct IDiffEditorViewState: Codable, Sendable {
    /// Original editor view state
    public let original: ICodeEditorViewState?
    /// Modified editor view state
    public let modified: ICodeEditorViewState?
    
    public init(original: ICodeEditorViewState? = nil, modified: ICodeEditorViewState? = nil) {
        self.original = original
        self.modified = modified
    }
}

// MARK: - New Scroll Position

/// New scroll position
public struct INewScrollPosition: Codable, Sendable {
    /// Scroll left
    public let scrollLeft: Int?
    /// Scroll top
    public let scrollTop: Int?
    
    public init(scrollLeft: Int? = nil, scrollTop: Int? = nil) {
        self.scrollLeft = scrollLeft
        self.scrollTop = scrollTop
    }
}

// MARK: - Content Size Changed Event

/// An event describing content size changes
public struct IContentSizeChangedEvent: Codable, Sendable {
    /// Content width
    public let contentWidth: Int
    /// Content height
    public let contentHeight: Int
    /// Content width changed
    public let contentWidthChanged: Bool
    /// Content height changed
    public let contentHeightChanged: Bool
    
    public init(
        contentWidth: Int,
        contentHeight: Int,
        contentWidthChanged: Bool,
        contentHeightChanged: Bool
    ) {
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
        self.contentWidthChanged = contentWidthChanged
        self.contentHeightChanged = contentHeightChanged
    }
}

// MARK: - Cursor Position Changed Event

/// An event describing cursor position change
public struct ICursorPositionChangedEvent: Codable, Sendable {
    /// Position
    public let position: Position
    /// Secondary positions
    public let secondaryPositions: [Position]?
    /// Reason
    public let reason: CursorChangeReason
    /// Source
    public let source: String?
    
    public init(
        position: Position,
        secondaryPositions: [Position]? = nil,
        reason: CursorChangeReason,
        source: String? = nil
    ) {
        self.position = position
        self.secondaryPositions = secondaryPositions
        self.reason = reason
        self.source = source
    }
}

// MARK: - Cursor Selection Changed Event

/// An event describing cursor selection change
public struct ICursorSelectionChangedEvent: Codable, Sendable {
    /// Selection
    public let selection: Selection
    /// Secondary selections
    public let secondarySelections: [Selection]?
    /// Model version ID
    public let modelVersionId: Int?
    /// Old selections
    public let oldSelections: [Selection]?
    /// Old model version ID
    public let oldModelVersionId: Int?
    /// Source
    public let source: String?
    /// Reason
    public let reason: CursorChangeReason
    
    public init(
        selection: Selection,
        secondarySelections: [Selection]? = nil,
        modelVersionId: Int? = nil,
        oldSelections: [Selection]? = nil,
        oldModelVersionId: Int? = nil,
        source: String? = nil,
        reason: CursorChangeReason
    ) {
        self.selection = selection
        self.secondarySelections = secondarySelections
        self.modelVersionId = modelVersionId
        self.oldSelections = oldSelections
        self.oldModelVersionId = oldModelVersionId
        self.source = source
        self.reason = reason
    }
}

// MARK: - Model Changed Event

/// An event describing model changes
public struct IModelChangedEvent: Codable, Sendable {
    /// Old model URI
    public let oldModelUrl: String?
    /// New model URI
    public let newModelUrl: String?
    
    public init(oldModelUrl: String? = nil, newModelUrl: String? = nil) {
        self.oldModelUrl = oldModelUrl
        self.newModelUrl = newModelUrl
    }
}

// MARK: - Model Language Changed Event

/// An event describing a language change
public struct IModelLanguageChangedEvent: Codable, Sendable {
    /// Old language
    public let oldLanguage: String
    /// New language
    public let newLanguage: String
    
    public init(oldLanguage: String, newLanguage: String) {
        self.oldLanguage = oldLanguage
        self.newLanguage = newLanguage
    }
}

// MARK: - Model Language Configuration Changed Event

/// An event describing language configuration changes
public struct IModelLanguageConfigurationChangedEvent: Codable, Sendable {
    /// Language ID
    public let languageId: String
    
    public init(languageId: String) {
        self.languageId = languageId
    }
}

// MARK: - Model Options Changed Event

/// An event describing model options changes
public struct IModelOptionsChangedEvent: Codable, Sendable {
    /// Tab size changed
    public let tabSize: Bool
    /// Indent size changed
    public let indentSize: Bool
    /// Insert spaces changed
    public let insertSpaces: Bool
    /// Trim auto whitespace changed
    public let trimAutoWhitespace: Bool
    
    public init(
        tabSize: Bool,
        indentSize: Bool,
        insertSpaces: Bool,
        trimAutoWhitespace: Bool
    ) {
        self.tabSize = tabSize
        self.indentSize = indentSize
        self.insertSpaces = insertSpaces
        self.trimAutoWhitespace = trimAutoWhitespace
    }
}

// MARK: - Model Decorations Changed Event

/// An event describing decoration changes
public struct IModelDecorationsChangedEvent: Codable, Sendable {
    /// Affected range
    public let affectsMinimap: Bool
    /// Affects overview ruler
    public let affectsOverviewRuler: Bool
    /// Affects glyph margin
    public let affectsGlyphMargin: Bool
    /// Affects line numbers
    public let affectsLineNumber: Bool
    
    public init(
        affectsMinimap: Bool,
        affectsOverviewRuler: Bool,
        affectsGlyphMargin: Bool,
        affectsLineNumber: Bool
    ) {
        self.affectsMinimap = affectsMinimap
        self.affectsOverviewRuler = affectsOverviewRuler
        self.affectsGlyphMargin = affectsGlyphMargin
        self.affectsLineNumber = affectsLineNumber
    }
}

// MARK: - Text Model Update Options

/// Options for updating a text model
public struct ITextModelUpdateOptions: Codable, Sendable {
    /// Tab size
    public let tabSize: Int?
    /// Indent size
    public let indentSize: Int?
    /// Insert spaces
    public let insertSpaces: Bool?
    /// Trim auto whitespace
    public let trimAutoWhitespace: Bool?
    
    public init(
        tabSize: Int? = nil,
        indentSize: Int? = nil,
        insertSpaces: Bool? = nil,
        trimAutoWhitespace: Bool? = nil
    ) {
        self.tabSize = tabSize
        self.indentSize = indentSize
        self.insertSpaces = insertSpaces
        self.trimAutoWhitespace = trimAutoWhitespace
    }
}

// MARK: - Word At Position

/// A word at a position (type alias for compatibility)
public typealias IWordAtPosition = WordAtPosition

// MARK: - Decoration Options

/// Options for decorations
public struct IDecorationOptions: Codable, Sendable {
    /// Range
    public let range: IRange
    /// Hover message
    public let hoverMessage: String?
    /// Render options
    public let renderOptions: IDecorationRenderOptions?
    
    public init(range: IRange, hoverMessage: String? = nil, renderOptions: IDecorationRenderOptions? = nil) {
        self.range = range
        self.hoverMessage = hoverMessage
        self.renderOptions = renderOptions
    }
}

// MARK: - Decoration Render Options

/// Rendering options for decorations
public struct IDecorationRenderOptions: Codable, Sendable {
    /// CSS class name
    public let className: String?
    /// Before content options
    public let before: IContentDecorationRenderOptions?
    /// After content options
    public let after: IContentDecorationRenderOptions?
    
    public init(
        className: String? = nil,
        before: IContentDecorationRenderOptions? = nil,
        after: IContentDecorationRenderOptions? = nil
    ) {
        self.className = className
        self.before = before
        self.after = after
    }
}

// MARK: - Content Decoration Render Options

/// Rendering options for content decorations
public struct IContentDecorationRenderOptions: Codable, Sendable {
    /// Content text
    public let contentText: String?
    /// Content icon path
    public let contentIconPath: String?
    /// Margin
    public let margin: String?
    /// Width
    public let width: String?
    /// Height
    public let height: String?
    
    public init(
        contentText: String? = nil,
        contentIconPath: String? = nil,
        margin: String? = nil,
        width: String? = nil,
        height: String? = nil
    ) {
        self.contentText = contentText
        self.contentIconPath = contentIconPath
        self.margin = margin
        self.width = width
        self.height = height
    }
}

// MARK: - Ruler Option

/// Ruler configuration
public struct IRulerOption: Codable, Sendable {
    /// Column number
    public let column: Int
    /// Color
    public let color: String?
    
    public init(column: Int, color: String? = nil) {
        self.column = column
        self.color = color
    }
}

// MARK: - Editor Wrapping Info

/// Information about editor wrapping
public struct EditorWrappingInfo: Codable, Sendable {
    /// Is viewport wrapping
    public let isViewportWrapping: Bool
    /// Wrapping column
    public let wrappingColumn: Int
    
    public init(isViewportWrapping: Bool, wrappingColumn: Int) {
        self.isViewportWrapping = isViewportWrapping
        self.wrappingColumn = wrappingColumn
    }
}

// MARK: - Editor Minimap Layout Info

/// Layout information for minimap
public struct EditorMinimapLayoutInfo: Codable, Sendable {
    /// Render minimap
    public let renderMinimap: RenderMinimap
    /// Minimap left
    public let minimapLeft: Int
    /// Minimap width
    public let minimapWidth: Int
    /// Minimap height
    public let minimapHeight: Int
    /// Minimap canvas inner width
    public let minimapCanvasInnerWidth: Int
    /// Minimap canvas inner height
    public let minimapCanvasInnerHeight: Int
    /// Minimap canvas outer width
    public let minimapCanvasOuterWidth: Int
    /// Minimap canvas outer height
    public let minimapCanvasOuterHeight: Int
    
    public init(
        renderMinimap: RenderMinimap,
        minimapLeft: Int,
        minimapWidth: Int,
        minimapHeight: Int,
        minimapCanvasInnerWidth: Int,
        minimapCanvasInnerHeight: Int,
        minimapCanvasOuterWidth: Int,
        minimapCanvasOuterHeight: Int
    ) {
        self.renderMinimap = renderMinimap
        self.minimapLeft = minimapLeft
        self.minimapWidth = minimapWidth
        self.minimapHeight = minimapHeight
        self.minimapCanvasInnerWidth = minimapCanvasInnerWidth
        self.minimapCanvasInnerHeight = minimapCanvasInnerHeight
        self.minimapCanvasOuterWidth = minimapCanvasOuterWidth
        self.minimapCanvasOuterHeight = minimapCanvasOuterHeight
    }
}

// MARK: - Theme Color

/// Represents a theme color
public struct ThemeColor: Codable, Sendable {
    /// Color ID
    public let id: String
    
    public init(id: String) {
        self.id = id
    }
}

// MARK: - Theme Icon

/// Represents a theme icon
public struct ThemeIcon: Codable, Sendable {
    /// Icon ID
    public let id: String
    /// Color
    public let color: ThemeColor?
    
    public init(id: String, color: ThemeColor? = nil) {
        self.id = id
        self.color = color
    }
}

// MARK: - Injected Text Options

/// Options for injected text
public struct InjectedTextOptions: Codable, Sendable {
    /// Content
    public let content: String
    /// Inline class name
    public let inlineClassName: String?
    /// Inline class name affects letter spacing
    public let inlineClassNameAffectsLetterSpacing: Bool?
    
    public init(
        content: String,
        inlineClassName: String? = nil,
        inlineClassNameAffectsLetterSpacing: Bool? = nil
    ) {
        self.content = content
        self.inlineClassName = inlineClassName
        self.inlineClassNameAffectsLetterSpacing = inlineClassNameAffectsLetterSpacing
    }
}

// MARK: - Action Descriptor

/// Describes an action
public struct IActionDescriptor: Codable, Sendable {
    /// Action ID
    public let id: String
    /// Label
    public let label: String
    /// Aliases
    public let aliases: [String]?
    /// Precondition
    public let precondition: String?
    /// Keybindings
    public let keybindings: [Int]?
    /// Keybinding context
    public let keybindingContext: String?
    /// Context menu group ID
    public let contextMenuGroupId: String?
    /// Context menu order
    public let contextMenuOrder: Double?
    
    public init(
        id: String,
        label: String,
        aliases: [String]? = nil,
        precondition: String? = nil,
        keybindings: [Int]? = nil,
        keybindingContext: String? = nil,
        contextMenuGroupId: String? = nil,
        contextMenuOrder: Double? = nil
    ) {
        self.id = id
        self.label = label
        self.aliases = aliases
        self.precondition = precondition
        self.keybindings = keybindings
        self.keybindingContext = keybindingContext
        self.contextMenuGroupId = contextMenuGroupId
        self.contextMenuOrder = contextMenuOrder
    }
}
