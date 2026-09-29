
// MARK: - Editor Configuration

/// Complete configuration options for Monaco editor
public struct EditorConfiguration: Codable, Sendable {
    // MARK: - Content
    /// The initial value of the editor
    public let value: String?
    /// The initial language of the editor
    public let language: String?
    
    // MARK: - Appearance
    /// The theme to be used for rendering
    public let theme: String?
    /// Control the rendering of line numbers
    public let lineNumbers: String?
    /// Render vertical lines at specified columns
    public let rulers: [Int]?
    /// Enable word wrap
    public let wordWrap: String?
    /// Columns at which to wrap
    public let wordWrapColumn: Int?
    /// Wrapping indent
    public let wrappingIndent: WrappingIndent?
    /// Control the behavior of line decorations
    public let lineDecorationsWidth: Int?
    /// Whether to render whitespace
    public let renderWhitespace: String?
    /// Control the rendering of control characters
    public let renderControlCharacters: Bool?
    /// Control the rendering of indent guides
    public let renderIndentGuides: Bool?
    /// Control highlighting of bracket matches
    public let matchBrackets: String?
    /// Minimap configuration
    public let minimap: EditorMinimapOptions?
    /// Scrollbar configuration
    public let scrollbar: EditorScrollbarOptions?
    /// Padding configuration
    public let padding: EditorPaddingOptions?
    
    // MARK: - Behavior
    /// Whether the editor is readonly
    public let readOnly: Bool?
    /// Tab size
    public let tabSize: Int?
    /// Insert spaces instead of tabs
    public let insertSpaces: Bool?
    /// Detect indentation from content
    public let detectIndentation: Bool?
    /// Auto indent
    public let autoIndent: EditorAutoIndentStrategy?
    /// Trim auto whitespace
    public let trimAutoWhitespace: Bool?
    
    // MARK: - Cursor
    /// Cursor style
    public let cursorStyle: TextEditorCursorStyle?
    /// Cursor blinking
    public let cursorBlinking: TextEditorCursorBlinkingStyle?
    /// Cursor width
    public let cursorWidth: Int?
    /// Cursor smooth caret animation
    public let cursorSmoothCaretAnimation: String?
    
    // MARK: - Scrolling
    /// Enable smooth scrolling
    public let smoothScrolling: Bool?
    /// Number of extra lines to scroll beyond last line
    public let scrollBeyondLastLine: Bool?
    /// Number of extra columns to scroll beyond last column
    public let scrollBeyondLastColumn: Int?
    
    // MARK: - Selection
    /// Enable selection highlighting
    public let selectionHighlight: Bool?
    /// Enable occurrence highlighting
    public let occurrencesHighlight: String?
    /// Whether to use multiple cursors
    public let multiCursorModifier: String?
    /// Whether to paste as multi-line when multiple cursors
    public let multiCursorPaste: String?
    
    // MARK: - Find
    /// Find widget configuration
    public let find: EditorFindOptions?
    
    // MARK: - Hover
    /// Hover configuration
    public let hover: EditorHoverOptions?
    
    // MARK: - Suggestions
    /// Quick suggestions
    public let quickSuggestions: QuickSuggestionsOptions?
    /// Quick suggestions delay in milliseconds
    public let quickSuggestionsDelay: Int?
    /// Suggest configuration
    public let suggest: SuggestOptions?
    /// Parameter hints configuration
    public let parameterHints: EditorParameterHintOptions?
    /// Accept suggestion on commit character
    public let acceptSuggestionOnCommitCharacter: Bool?
    /// Accept suggestion on enter
    public let acceptSuggestionOnEnter: String?
    /// Tab completion
    public let tabCompletion: String?
    /// Suggest on trigger characters
    public let suggestOnTriggerCharacters: Bool?
    
    // MARK: - Code Actions
    /// Lightbulb configuration
    public let lightbulb: EditorLightbulbOptions?
    
    // MARK: - Accessibility
    /// Accessibility support
    public let accessibilitySupport: AccessibilitySupport?
    /// Whether to announce editor content changes to screen readers
    public let screenReaderAnnounceInlineSuggestion: Bool?
    
    // MARK: - Formatting
    /// Format on paste
    public let formatOnPaste: Bool?
    /// Format on type
    public let formatOnType: Bool?
    /// Auto closing brackets
    public let autoClosingBrackets: String?
    /// Auto closing quotes
    public let autoClosingQuotes: String?
    /// Auto surround
    public let autoSurround: String?
    
    // MARK: - Guides
    /// Guides configuration
    public let guides: GuidesOptions?
    /// Bracket pair colorization
    public let bracketPairColorization: BracketPairColorizationOptions?
    
    // MARK: - Font
    /// Font family
    public let fontFamily: String?
    /// Font weight
    public let fontWeight: String?
    /// Font size
    public let fontSize: Int?
    /// Line height
    public let lineHeight: Int?
    /// Letter spacing
    public let letterSpacing: Double?
    
    // MARK: - Dimensions
    /// Editor width
    public let width: Int?
    /// Editor height
    public let height: Int?
    /// Automatic layout
    public let automaticLayout: Bool?
    
    // MARK: - Performance
    /// Stop rendering when editor is not visible
    public let stopRenderingLineAfter: Int?
    /// Disable monospace optimizations
    public let disableMonospaceOptimizations: Bool?
    
    public init(
        value: String? = nil,
        language: String? = nil,
        theme: String? = nil,
        lineNumbers: String? = nil,
        rulers: [Int]? = nil,
        wordWrap: String? = nil,
        wordWrapColumn: Int? = nil,
        wrappingIndent: WrappingIndent? = nil,
        lineDecorationsWidth: Int? = nil,
        renderWhitespace: String? = nil,
        renderControlCharacters: Bool? = nil,
        renderIndentGuides: Bool? = nil,
        matchBrackets: String? = nil,
        minimap: EditorMinimapOptions? = nil,
        scrollbar: EditorScrollbarOptions? = nil,
        padding: EditorPaddingOptions? = nil,
        readOnly: Bool? = nil,
        tabSize: Int? = nil,
        insertSpaces: Bool? = nil,
        detectIndentation: Bool? = nil,
        autoIndent: EditorAutoIndentStrategy? = nil,
        trimAutoWhitespace: Bool? = nil,
        cursorStyle: TextEditorCursorStyle? = nil,
        cursorBlinking: TextEditorCursorBlinkingStyle? = nil,
        cursorWidth: Int? = nil,
        cursorSmoothCaretAnimation: String? = nil,
        smoothScrolling: Bool? = nil,
        scrollBeyondLastLine: Bool? = nil,
        scrollBeyondLastColumn: Int? = nil,
        selectionHighlight: Bool? = nil,
        occurrencesHighlight: String? = nil,
        multiCursorModifier: String? = nil,
        multiCursorPaste: String? = nil,
        find: EditorFindOptions? = nil,
        hover: EditorHoverOptions? = nil,
        quickSuggestions: QuickSuggestionsOptions? = nil,
        quickSuggestionsDelay: Int? = nil,
        suggest: SuggestOptions? = nil,
        parameterHints: EditorParameterHintOptions? = nil,
        acceptSuggestionOnCommitCharacter: Bool? = nil,
        acceptSuggestionOnEnter: String? = nil,
        tabCompletion: String? = nil,
        suggestOnTriggerCharacters: Bool? = nil,
        lightbulb: EditorLightbulbOptions? = nil,
        accessibilitySupport: AccessibilitySupport? = nil,
        screenReaderAnnounceInlineSuggestion: Bool? = nil,
        formatOnPaste: Bool? = nil,
        formatOnType: Bool? = nil,
        autoClosingBrackets: String? = nil,
        autoClosingQuotes: String? = nil,
        autoSurround: String? = nil,
        guides: GuidesOptions? = nil,
        bracketPairColorization: BracketPairColorizationOptions? = nil,
        fontFamily: String? = nil,
        fontWeight: String? = nil,
        fontSize: Int? = nil,
        lineHeight: Int? = nil,
        letterSpacing: Double? = nil,
        width: Int? = nil,
        height: Int? = nil,
        automaticLayout: Bool? = nil,
        stopRenderingLineAfter: Int? = nil,
        disableMonospaceOptimizations: Bool? = nil
    ) {
        self.value = value
        self.language = language
        self.theme = theme
        self.lineNumbers = lineNumbers
        self.rulers = rulers
        self.wordWrap = wordWrap
        self.wordWrapColumn = wordWrapColumn
        self.wrappingIndent = wrappingIndent
        self.lineDecorationsWidth = lineDecorationsWidth
        self.renderWhitespace = renderWhitespace
        self.renderControlCharacters = renderControlCharacters
        self.renderIndentGuides = renderIndentGuides
        self.matchBrackets = matchBrackets
        self.minimap = minimap
        self.scrollbar = scrollbar
        self.padding = padding
        self.readOnly = readOnly
        self.tabSize = tabSize
        self.insertSpaces = insertSpaces
        self.detectIndentation = detectIndentation
        self.autoIndent = autoIndent
        self.trimAutoWhitespace = trimAutoWhitespace
        self.cursorStyle = cursorStyle
        self.cursorBlinking = cursorBlinking
        self.cursorWidth = cursorWidth
        self.cursorSmoothCaretAnimation = cursorSmoothCaretAnimation
        self.smoothScrolling = smoothScrolling
        self.scrollBeyondLastLine = scrollBeyondLastLine
        self.scrollBeyondLastColumn = scrollBeyondLastColumn
        self.selectionHighlight = selectionHighlight
        self.occurrencesHighlight = occurrencesHighlight
        self.multiCursorModifier = multiCursorModifier
        self.multiCursorPaste = multiCursorPaste
        self.find = find
        self.hover = hover
        self.quickSuggestions = quickSuggestions
        self.quickSuggestionsDelay = quickSuggestionsDelay
        self.suggest = suggest
        self.parameterHints = parameterHints
        self.acceptSuggestionOnCommitCharacter = acceptSuggestionOnCommitCharacter
        self.acceptSuggestionOnEnter = acceptSuggestionOnEnter
        self.tabCompletion = tabCompletion
        self.suggestOnTriggerCharacters = suggestOnTriggerCharacters
        self.lightbulb = lightbulb
        self.accessibilitySupport = accessibilitySupport
        self.screenReaderAnnounceInlineSuggestion = screenReaderAnnounceInlineSuggestion
        self.formatOnPaste = formatOnPaste
        self.formatOnType = formatOnType
        self.autoClosingBrackets = autoClosingBrackets
        self.autoClosingQuotes = autoClosingQuotes
        self.autoSurround = autoSurround
        self.guides = guides
        self.bracketPairColorization = bracketPairColorization
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.width = width
        self.height = height
        self.automaticLayout = automaticLayout
        self.stopRenderingLineAfter = stopRenderingLineAfter
        self.disableMonospaceOptimizations = disableMonospaceOptimizations
    }
}

// MARK: - Text Model Options

/// Options for text model creation and updates
public struct TextModelOptions: Codable, Sendable {
    /// Tab size
    public let tabSize: Int?
    /// Whether to insert spaces
    public let insertSpaces: Bool?
    /// Whether to detect indentation from content
    public let detectIndentation: Bool?
    /// Whether to trim trailing whitespace
    public let trimAutoWhitespace: Bool?
    /// Default end of line sequence
    public let defaultEOL: DefaultEndOfLine?
    
    public init(
        tabSize: Int? = nil,
        insertSpaces: Bool? = nil,
        detectIndentation: Bool? = nil,
        trimAutoWhitespace: Bool? = nil,
        defaultEOL: DefaultEndOfLine? = nil
    ) {
        self.tabSize = tabSize
        self.insertSpaces = insertSpaces
        self.detectIndentation = detectIndentation
        self.trimAutoWhitespace = trimAutoWhitespace
        self.defaultEOL = defaultEOL
    }
}

// MARK: - Scroll Position

/// Represents a scroll position
public struct ScrollPosition: Codable, Sendable {
    /// Scroll left position
    public let scrollLeft: Int?
    /// Scroll top position
    public let scrollTop: Int?
    
    public init(scrollLeft: Int? = nil, scrollTop: Int? = nil) {
        self.scrollLeft = scrollLeft
        self.scrollTop = scrollTop
    }
}

// MARK: - Editor Layout Info

/// Layout information about the editor
public struct EditorLayoutInfo: Codable, Sendable {
    /// Total editor width
    public let width: Int
    /// Total editor height
    public let height: Int
    /// Glyph margin left position
    public let glyphMarginLeft: Int
    /// Glyph margin width
    public let glyphMarginWidth: Int
    /// Line numbers left position
    public let lineNumbersLeft: Int
    /// Line numbers width
    public let lineNumbersWidth: Int
    /// Line decorations left position
    public let decorationsLeft: Int
    /// Line decorations width
    public let decorationsWidth: Int
    /// Content left position
    public let contentLeft: Int
    /// Content width
    public let contentWidth: Int
    /// Content height
    public let contentHeight: Int
    /// Minimap left position
    public let minimapLeft: Int
    /// Minimap width
    public let minimapWidth: Int
    /// Vertical scrollbar width
    public let verticalScrollbarWidth: Int
    /// Horizontal scrollbar height
    public let horizontalScrollbarHeight: Int
    /// Overview ruler position
    public let overviewRuler: OverviewRulerPosition
    
    public init(
        width: Int,
        height: Int,
        glyphMarginLeft: Int,
        glyphMarginWidth: Int,
        lineNumbersLeft: Int,
        lineNumbersWidth: Int,
        decorationsLeft: Int,
        decorationsWidth: Int,
        contentLeft: Int,
        contentWidth: Int,
        contentHeight: Int,
        minimapLeft: Int,
        minimapWidth: Int,
        verticalScrollbarWidth: Int,
        horizontalScrollbarHeight: Int,
        overviewRuler: OverviewRulerPosition
    ) {
        self.width = width
        self.height = height
        self.glyphMarginLeft = glyphMarginLeft
        self.glyphMarginWidth = glyphMarginWidth
        self.lineNumbersLeft = lineNumbersLeft
        self.lineNumbersWidth = lineNumbersWidth
        self.decorationsLeft = decorationsLeft
        self.decorationsWidth = decorationsWidth
        self.contentLeft = contentLeft
        self.contentWidth = contentWidth
        self.contentHeight = contentHeight
        self.minimapLeft = minimapLeft
        self.minimapWidth = minimapWidth
        self.verticalScrollbarWidth = verticalScrollbarWidth
        self.horizontalScrollbarHeight = horizontalScrollbarHeight
        self.overviewRuler = overviewRuler
    }
}

// MARK: - Overview Ruler Position

/// Position information for the overview ruler
public struct OverviewRulerPosition: Codable, Sendable {
    /// Top position
    public let top: Int
    /// Width
    public let width: Int
    /// Height
    public let height: Int
    
    public init(top: Int, width: Int, height: Int) {
        self.top = top
        self.width = width
        self.height = height
    }
}
