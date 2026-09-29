
// MARK: - Scroll Type

/// Describes the behavior of scrolling operations
public enum ScrollType: Int, Codable, Sendable {
    /// Smooth scrolling animation
    case smooth = 0
    /// Immediate scrolling without animation
    case immediate = 1
}

// MARK: - Cursor Style

/// The style in which the editor's cursor should be rendered
public enum TextEditorCursorStyle: Int, Codable, Sendable {
    /// As a vertical line (sitting between two characters)
    case line = 1
    /// As a block (sitting on top of a character)
    case block = 2
    /// As a horizontal line (sitting under a character)
    case underline = 3
    /// As a thin vertical line (sitting between two characters)
    case lineThin = 4
    /// As an outlined block (sitting on top of a character)
    case blockOutline = 5
    /// As a thin horizontal line (sitting under a character)
    case underlineThin = 6
}

// MARK: - Cursor Blinking Style

/// Controls the cursor blinking animation style
public enum TextEditorCursorBlinkingStyle: Int, Codable, Sendable {
    /// Hidden cursor
    case hidden = 0
    /// Blinking cursor
    case blink = 1
    /// Smooth blinking animation
    case smooth = 2
    /// Phase-based blinking
    case phase = 3
    /// Expand animation
    case expand = 4
    /// Solid cursor (no blinking)
    case solid = 5
}

// MARK: - End of Line

/// End of line sequence
public enum EndOfLineSequence: Int, Codable, Sendable {
    /// Line Feed '\n'
    case lf = 0
    /// Carriage Return + Line Feed '\r\n'
    case crlf = 1
}

/// End of line preference
public enum EndOfLinePreference: Int, Codable, Sendable {
    /// Use the end of line sequence that is defined in the text
    case textDefined = 0
    /// Use line feed '\n' as the end of line sequence
    case lf = 1
    /// Use carriage return + line feed '\r\n' as the end of line sequence
    case crlf = 2
}

/// Default end of line
public enum DefaultEndOfLine: Int, Codable, Sendable {
    /// Use line feed '\n' as the end of line sequence
    case lf = 1
    /// Use carriage return + line feed '\r\n' as the end of line sequence
    case crlf = 2
}

// MARK: - Render Options

/// Describes how line numbers should be rendered
public enum RenderLineNumbersType: Int, Codable, Sendable {
    /// No line numbers
    case off = 0
    /// Line numbers as absolute number
    case on = 1
    /// Line numbers as relative to cursor
    case relative = 2
    /// Line numbers as interval
    case interval = 3
}

/// Describes how the minimap should be rendered
public enum RenderMinimap: Int, Codable, Sendable {
    /// Do not render minimap
    case none = 0
    /// Render minimap with text content
    case text = 1
    /// Render minimap with blocks
    case blocks = 2
}

// MARK: - Scrollbar

/// Scrollbar visibility options
public enum ScrollbarVisibility: Int, Codable, Sendable {
    /// Scrollbar is always visible
    case auto = 1
    /// Scrollbar is hidden
    case hidden = 2
    /// Scrollbar is visible on hover
    case visible = 3
}

// MARK: - Wrapping

/// Wrapping indent options
public enum WrappingIndent: Int, Codable, Sendable {
    /// No indent
    case none = 0
    /// Indent by one unit
    case same = 1
    /// Indent by one + a half units
    case indent = 2
    /// Indent by two units
    case deepIndent = 3
}

// MARK: - Text Direction

/// Text direction
public enum TextDirection: String, Codable, Sendable {
    /// Left to right
    case ltr = "ltr"
    /// Right to left
    case rtl = "rtl"
}

// MARK: - Accessibility Support

/// Accessibility support option
public enum AccessibilitySupport: Int, Codable, Sendable {
    /// Unknown accessibility support
    case unknown = 0
    /// Accessibility features are disabled
    case disabled = 1
    /// Accessibility features are enabled
    case enabled = 2
}

// MARK: - Editor Options

/// Editor auto indent strategy
public enum EditorAutoIndentStrategy: Int, Codable, Sendable {
    /// No auto indent
    case none = 0
    /// Keep current indentation
    case keep = 1
    /// Use bracket matching
    case brackets = 2
    /// Advanced indentation based on language
    case advanced = 3
    /// Full indentation with all features
    case full = 4
}

// MARK: - Minimap

/// Minimap position in the editor
public enum MinimapPosition: String, Codable, Sendable {
    /// Minimap on the left side
    case left = "left"
    /// Minimap on the right side
    case right = "right"
}

// MARK: - Overview Ruler

/// Overview ruler lanes
public enum OverviewRulerLane: Int, Codable, Sendable {
    /// Left lane
    case left = 1
    /// Center lane
    case center = 2
    /// Right lane
    case right = 4
    /// Full lane
    case full = 7
}

// MARK: - Glyph Margin

/// Glyph margin lanes
public enum GlyphMarginLane: Int, Codable, Sendable {
    /// Left lane
    case left = 1
    /// Center lane
    case center = 2
    /// Right lane (typically for breakpoints)
    case right = 3
}

// MARK: - Content Widget Position

/// Content widget position preference
public enum ContentWidgetPositionPreference: Int, Codable, Sendable {
    /// Position exactly at the specified position
    case exact = 0
    /// Position above the specified position
    case above = 1
    /// Position below the specified position
    case below = 2
}

// MARK: - Overlay Widget Position

/// Overlay widget position preference
public enum OverlayWidgetPositionPreference: Int, Codable, Sendable {
    /// Position at top right
    case topRight = 0
    /// Position at bottom right
    case bottomRight = 1
    /// Position at top center
    case topCenter = 2
}

// MARK: - Mouse Target Type

/// Mouse target types in the editor
public enum MouseTargetType: Int, Codable, Sendable {
    /// Unknown target
    case unknown = 0
    /// Textarea target
    case textarea = 1
    /// Gutter glyph margin
    case gutterGlyphMargin = 2
    /// Gutter line numbers
    case gutterLineNumbers = 3
    /// Gutter line decorations
    case gutterLineDecorations = 4
    /// Gutter view zone
    case gutterViewZone = 5
    /// Content text
    case contentText = 6
    /// Content empty
    case contentEmpty = 7
    /// Content view zone
    case contentViewZone = 8
    /// Content widget
    case contentWidget = 9
    /// Overview ruler
    case overviewRuler = 10
    /// Scrollbar
    case scrollbar = 11
    /// Overlay widget
    case overlayWidget = 12
    /// Outside the editor
    case outsideEditor = 13
}

// MARK: - Tracked Range Stickiness

/// Describes how tracked ranges should behave
public enum TrackedRangeStickiness: Int, Codable, Sendable {
    /// Tracks to both left and right
    case alwaysGrowsWhenTypingAtEdges = 0
    /// Never grows when typing at edges
    case neverGrowsWhenTypingAtEdges = 1
    /// Grows when typing at start
    case growsOnlyWhenTypingBefore = 2
    /// Grows when typing at end
    case growsOnlyWhenTypingAfter = 3
}

// MARK: - Cursor Change Reason

/// Describes what triggered a cursor change
public enum CursorChangeReason: Int, Codable, Sendable {
    /// Unknown or not specified
    case notSet = 0
    /// Cursor changed due to typing
    case contentFlush = 1
    /// Cursor changed due to mouse
    case recoveryFromMarkers = 2
    /// Cursor changed explicitly
    case explicit = 3
    /// Cursor changed due to paste
    case paste = 4
    /// Cursor changed due to undo
    case undo = 5
    /// Cursor changed due to redo
    case redo = 6
}

// MARK: - Position Affinity

/// The affinity of a position
public enum PositionAffinity: Int, Codable, Sendable {
    /// Prefers the left side
    case left = 0
    /// Prefers the right side
    case right = 1
    /// No preference
    case none = 2
}

// MARK: - Injected Text Cursor Stops

/// Describes cursor stops for injected text
public enum InjectedTextCursorStops: Int, Codable, Sendable {
    /// Both before and after
    case both = 0
    /// Right side only
    case right = 1
    /// Left side only
    case left = 2
    /// None
    case none = 3
}

// MARK: - Minimap Section Header Style

/// Style for minimap section headers
public enum MinimapSectionHeaderStyle: Int, Codable, Sendable {
    /// Normal style
    case normal = 1
    /// Underlined style
    case underlined = 2
}

// MARK: - Show Lightbulb Icon Mode

/// When to show the lightbulb icon
public enum ShowLightbulbIconMode: String, Codable, Sendable {
    /// Off
    case off = "off"
    /// On the left
    case on = "on"
    /// On code action
    case onCode = "onCode"
}

// MARK: - Editor Option

/// Editor option identifiers
public enum EditorOption: Int, Codable, Sendable {
    case acceptSuggestionOnCommitCharacter = 0
    case acceptSuggestionOnEnter = 1
    case accessibilitySupport = 2
    case accessibilityPageSize = 3
    case ariaLabel = 4
    case autoClosingBrackets = 5
    case autoClosingDelete = 6
    case autoClosingOvertype = 7
    case autoClosingQuotes = 8
    case autoIndent = 9
    case automaticLayout = 10
    case autoSurround = 11
    case bracketPairColorization = 12
    case guides = 13
    case codeLens = 14
    case codeLensFontFamily = 15
    case codeLensFontSize = 16
    case colorDecorators = 17
    case columnSelection = 18
    case comments = 19
    case contextmenu = 20
    case copyWithSyntaxHighlighting = 21
    case cursorBlinking = 22
    case cursorSmoothCaretAnimation = 23
    case cursorStyle = 24
    case cursorSurroundingLines = 25
    case cursorSurroundingLinesStyle = 26
    case cursorWidth = 27
    case disableLayerHinting = 28
    case disableMonospaceOptimizations = 29
    case domReadOnly = 30
    case dragAndDrop = 31
    case emptySelectionClipboard = 32
    case extraEditorClassName = 33
    case fastScrollSensitivity = 34
    case find = 35
    case fixedOverflowWidgets = 36
    case folding = 37
    case foldingStrategy = 38
    case foldingHighlight = 39
    case foldingImportsByDefault = 40
    case foldingMaximumRegions = 41
    case unfoldOnClickAfterEndOfLine = 42
    case fontFamily = 43
    case fontInfo = 44
    case fontLigatures = 45
    case fontSize = 46
    case fontWeight = 47
    case formatOnPaste = 48
    case formatOnType = 49
    case glyphMargin = 50
    case gotoLocation = 51
    case hideCursorInOverviewRuler = 52
    case hover = 53
    case inDiffEditor = 54
    case inlineSuggest = 55
    case letterSpacing = 56
    case lightbulb = 57
    case lineDecorationsWidth = 58
    case lineHeight = 59
    case lineNumbers = 60
    case lineNumbersMinChars = 61
    case linkedEditing = 62
    case links = 63
    case matchBrackets = 64
    case minimap = 65
    case mouseStyle = 66
    case mouseWheelScrollSensitivity = 67
    case mouseWheelZoom = 68
    case multiCursorMergeOverlapping = 69
    case multiCursorModifier = 70
    case multiCursorPaste = 71
    case multiCursorLimit = 72
    case occurrencesHighlight = 73
    case overviewRulerBorder = 74
    case overviewRulerLanes = 75
    case padding = 76
    case parameterHints = 77
    case peekWidgetDefaultFocus = 78
    case definitionLinkOpensInPeek = 79
    case quickSuggestions = 80
    case quickSuggestionsDelay = 81
    case readOnly = 82
    case renameOnType = 83
    case renderControlCharacters = 84
    case renderFinalNewline = 85
    case renderLineHighlight = 86
    case renderLineHighlightOnlyWhenFocus = 87
    case renderValidationDecorations = 88
    case renderWhitespace = 89
    case revealHorizontalRightPadding = 90
    case roundedSelection = 91
    case rulers = 92
    case scrollbar = 93
    case scrollBeyondLastColumn = 94
    case scrollBeyondLastLine = 95
    case scrollPredominantAxis = 96
    case selectionClipboard = 97
    case selectionHighlight = 98
    case selectOnLineNumbers = 99
    case showFoldingControls = 100
    case showUnused = 101
    case snippetSuggestions = 102
    case smartSelect = 103
    case smoothScrolling = 104
    case stickyScroll = 105
    case stickyTabStops = 106
    case stopRenderingLineAfter = 107
    case suggest = 108
    case suggestFontSize = 109
    case suggestLineHeight = 110
    case suggestOnTriggerCharacters = 111
    case suggestSelection = 112
    case tabCompletion = 113
    case tabIndex = 114
    case unicodeHighlighting = 115
    case unusualLineTerminators = 116
    case useShadowDOM = 117
    case useTabStops = 118
    case wordSeparators = 119
    case wordWrap = 120
    case wordWrapBreakAfterCharacters = 121
    case wordWrapBreakBeforeCharacters = 122
    case wordWrapColumn = 123
    case wordWrapOverride1 = 124
    case wordWrapOverride2 = 125
    case wrappingIndent = 126
    case wrappingStrategy = 127
    case showDeprecated = 128
    case inlayHints = 129
    case editorClassName = 130
    case pixelRatio = 131
    case tabFocusMode = 132
    case layoutInfo = 133
    case wrappingInfo = 134
}
