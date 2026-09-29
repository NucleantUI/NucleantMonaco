
// MARK: - Text Model

/// Represents a text model in the editor
public struct ITextModel: Codable, Sendable {
    /// The unique identifier of this model
    public let id: String
    /// The URI of this model
    public let uri: String
    
    public init(id: String, uri: String) {
        self.id = id
        self.uri = uri
    }
}

// MARK: - Model Content Change

/// Represents a single change to model content
public struct IModelContentChange: Codable, Sendable {
    /// The range that was replaced
    public let range: IRange
    /// The offset of the range that was replaced
    public let rangeOffset: Int
    /// The length of the range that was replaced
    public let rangeLength: Int
    /// The new text for the range
    public let text: String
    
    public init(range: IRange, rangeOffset: Int, rangeLength: Int, text: String) {
        self.range = range
        self.rangeOffset = rangeOffset
        self.rangeLength = rangeLength
        self.text = text
    }
}

// MARK: - Model Content Changed Event

/// An event describing that model content has changed
public struct IModelContentChangedEvent: Codable, Sendable {
    /// The changes
    public let changes: [IModelContentChange]
    /// The end of line sequence that is being used
    public let eol: String
    /// The new version id the model has transitioned to
    public let versionId: Int
    /// Flag that indicates that this event was generated while undoing
    public let isUndoing: Bool
    /// Flag that indicates that this event was generated while redoing
    public let isRedoing: Bool
    /// Flag that indicates that all decorations were lost with this edit
    public let isFlush: Bool
    
    public init(
        changes: [IModelContentChange],
        eol: String,
        versionId: Int,
        isUndoing: Bool,
        isRedoing: Bool,
        isFlush: Bool
    ) {
        self.changes = changes
        self.eol = eol
        self.versionId = versionId
        self.isUndoing = isUndoing
        self.isRedoing = isRedoing
        self.isFlush = isFlush
    }
}

// MARK: - Find Match

/// A match in the editor
public struct FindMatch: Codable, Sendable {
    /// The range of the match
    public let range: IRange
    /// The matches, if any
    public let matches: [String]?
    
    public init(range: IRange, matches: [String]? = nil) {
        self.range = range
        self.matches = matches
    }
}

// MARK: - Word At Position

/// Word at a specific position
public struct WordAtPosition: Codable, Sendable {
    /// The word
    public let word: String
    /// The column where the word starts
    public let startColumn: Int
    /// The column where the word ends
    public let endColumn: Int
    
    public init(word: String, startColumn: Int, endColumn: Int) {
        self.word = word
        self.startColumn = startColumn
        self.endColumn = endColumn
    }
}

// MARK: - Model Decoration

/// A decoration in the editor model
public struct IModelDecoration: Codable, Sendable {
    /// Identifier for this decoration
    public let id: String
    /// Identifier for the decoration's owner
    public let ownerId: Int
    /// Range that this decoration covers
    public let range: IRange
    /// Options associated with this decoration
    public let options: IModelDecorationOptions
    
    public init(id: String, ownerId: Int, range: IRange, options: IModelDecorationOptions) {
        self.id = id
        self.ownerId = ownerId
        self.range = range
        self.options = options
    }
}

// MARK: - Model Decoration Options

/// Options for decorations
public struct IModelDecorationOptions: Codable, Sendable {
    /// Stickiness of this decoration
    public let stickiness: TrackedRangeStickiness?
    /// CSS class name for this decoration
    public let className: String?
    /// CSS class name for glyphs in the glyph margin
    public let glyphMarginClassName: String?
    /// Hover message for this decoration
    public let hoverMessage: String?
    /// If set, render this decoration in the overview ruler
    public let overviewRuler: IModelDecorationOverviewRulerOptions?
    /// If set, the decoration will be rendered in the glyph margin with this CSS class name
    public let glyphMarginHoverMessage: String?
    /// Array of MarkdownStrings to show when hovering over decoration
    public let glyphMarginText: String?
    /// The position in the glyph margin
    public let glyphMarginLane: GlyphMarginLane?
    /// If set, render this decoration in the minimap
    public let minimap: IModelDecorationMinimapOptions?
    /// If set, the decoration will be rendered inline with the text
    public let inlineClassName: String?
    /// If set, the decoration will be rendered inline with the text before the first character
    public let beforeContentClassName: String?
    /// If set, the decoration will be rendered inline with the text after the last character
    public let afterContentClassName: String?
    /// If set, the decoration will be rendered before the line text
    public let before: IModelDecorationContentTextOptions?
    /// If set, the decoration will be rendered after the line text
    public let after: IModelDecorationContentTextOptions?
    /// If set, indicates that this decoration is for inline completions
    public let isWholeLine: Bool?
    /// If set, render this decoration when typing
    public let showIfCollapsed: Bool?
    /// Collapse text on decoration
    public let collapseOnReplaceEdit: Bool?
    /// Z-index for layering decorations
    public let zIndex: Int?
    
    public init(
        stickiness: TrackedRangeStickiness? = nil,
        className: String? = nil,
        glyphMarginClassName: String? = nil,
        hoverMessage: String? = nil,
        overviewRuler: IModelDecorationOverviewRulerOptions? = nil,
        glyphMarginHoverMessage: String? = nil,
        glyphMarginText: String? = nil,
        glyphMarginLane: GlyphMarginLane? = nil,
        minimap: IModelDecorationMinimapOptions? = nil,
        inlineClassName: String? = nil,
        beforeContentClassName: String? = nil,
        afterContentClassName: String? = nil,
        before: IModelDecorationContentTextOptions? = nil,
        after: IModelDecorationContentTextOptions? = nil,
        isWholeLine: Bool? = nil,
        showIfCollapsed: Bool? = nil,
        collapseOnReplaceEdit: Bool? = nil,
        zIndex: Int? = nil
    ) {
        self.stickiness = stickiness
        self.className = className
        self.glyphMarginClassName = glyphMarginClassName
        self.hoverMessage = hoverMessage
        self.overviewRuler = overviewRuler
        self.glyphMarginHoverMessage = glyphMarginHoverMessage
        self.glyphMarginText = glyphMarginText
        self.glyphMarginLane = glyphMarginLane
        self.minimap = minimap
        self.inlineClassName = inlineClassName
        self.beforeContentClassName = beforeContentClassName
        self.afterContentClassName = afterContentClassName
        self.before = before
        self.after = after
        self.isWholeLine = isWholeLine
        self.showIfCollapsed = showIfCollapsed
        self.collapseOnReplaceEdit = collapseOnReplaceEdit
        self.zIndex = zIndex
    }
}

// MARK: - Model Decoration Overview Ruler Options

/// Options for overview ruler decorations
public struct IModelDecorationOverviewRulerOptions: Codable, Sendable {
    /// CSS color to render in the overview ruler
    public let color: String
    /// Position in the overview ruler
    public let position: OverviewRulerLane
    
    public init(color: String, position: OverviewRulerLane) {
        self.color = color
        self.position = position
    }
}

// MARK: - Model Decoration Minimap Options

/// Options for minimap decorations
public struct IModelDecorationMinimapOptions: Codable, Sendable {
    /// CSS color to render in the minimap
    public let color: String
    /// Position in the minimap
    public let position: MinimapPosition
    
    public init(color: String, position: MinimapPosition) {
        self.color = color
        self.position = position
    }
}

// MARK: - Model Decoration Content Text Options

/// Options for content text decorations
public struct IModelDecorationContentTextOptions: Codable, Sendable {
    /// The content text to render
    public let content: String
    /// The inline CSS styles to apply
    public let inlineClassName: String?
    
    public init(content: String, inlineClassName: String? = nil) {
        self.content = content
        self.inlineClassName = inlineClassName
    }
}

// MARK: - Model Delta Decoration

/// New decorations to be applied to the model
public struct IModelDeltaDecoration: Codable, Sendable {
    /// Range that this decoration covers
    public let range: IRange
    /// Options associated with this decoration
    public let options: IModelDecorationOptions
    
    public init(range: IRange, options: IModelDecorationOptions) {
        self.range = range
        self.options = options
    }
}

// MARK: - Validated Edit Operation

/// A validated edit operation
public struct IValidEditOperation: Codable, Sendable {
    /// Range to replace
    public let range: IRange
    /// Text to insert
    public let text: String?
    
    public init(range: IRange, text: String? = nil) {
        self.range = range
        self.text = text
    }
}

// MARK: - Identified Single Edit Operation

/// A single edit operation with an identifier
public struct IIdentifiedSingleEditOperation: Codable, Sendable {
    /// The range to replace
    public let range: IRange
    /// The text to replace with
    public let text: String?
    /// Whether this edit should be automatically surrounded
    public let forceMoveMarkers: Bool?
    
    public init(range: IRange, text: String? = nil, forceMoveMarkers: Bool? = nil) {
        self.range = range
        self.text = text
        self.forceMoveMarkers = forceMoveMarkers
    }
}

// MARK: - Single Edit Operation

/// A single edit operation
public struct ISingleEditOperation: Codable, Sendable {
    /// The range to replace
    public let range: IRange
    /// The text to replace with
    public let text: String?
    /// Whether this edit should force move markers
    public let forceMoveMarkers: Bool?
    
    public init(range: IRange, text: String? = nil, forceMoveMarkers: Bool? = nil) {
        self.range = range
        self.text = text
        self.forceMoveMarkers = forceMoveMarkers
    }
}
