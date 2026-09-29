
// MARK: - Editor Scrollbar Options

/// Configuration options for the editor's scrollbar
public struct EditorScrollbarOptions: Codable, Sendable {
    /// Whether arrows are visible on scrollbars
    public let arrowSize: Int?
    /// Vertical scrollbar visibility
    public let vertical: ScrollbarVisibility?
    /// Horizontal scrollbar visibility
    public let horizontal: ScrollbarVisibility?
    /// Whether to use shadow below the scrollbar
    public let useShadows: Bool?
    /// Vertical scrollbar size
    public let verticalScrollbarSize: Int?
    /// Horizontal scrollbar size
    public let horizontalScrollbarSize: Int?
    /// Vertical slider size
    public let verticalSliderSize: Int?
    /// Horizontal slider size
    public let horizontalSliderSize: Int?
    /// Whether scrollbar handles mouse wheel events
    public let handleMouseWheel: Bool?
    /// Always consume mouse wheel events
    public let alwaysConsumeMouseWheel: Bool?
    /// Scrolls by page when clicking on scrollbar track
    public let scrollByPage: Bool?
    
    public init(
        arrowSize: Int? = nil,
        vertical: ScrollbarVisibility? = nil,
        horizontal: ScrollbarVisibility? = nil,
        useShadows: Bool? = nil,
        verticalScrollbarSize: Int? = nil,
        horizontalScrollbarSize: Int? = nil,
        verticalSliderSize: Int? = nil,
        horizontalSliderSize: Int? = nil,
        handleMouseWheel: Bool? = nil,
        alwaysConsumeMouseWheel: Bool? = nil,
        scrollByPage: Bool? = nil
    ) {
        self.arrowSize = arrowSize
        self.vertical = vertical
        self.horizontal = horizontal
        self.useShadows = useShadows
        self.verticalScrollbarSize = verticalScrollbarSize
        self.horizontalScrollbarSize = horizontalScrollbarSize
        self.verticalSliderSize = verticalSliderSize
        self.horizontalSliderSize = horizontalSliderSize
        self.handleMouseWheel = handleMouseWheel
        self.alwaysConsumeMouseWheel = alwaysConsumeMouseWheel
        self.scrollByPage = scrollByPage
    }
}

// MARK: - Editor Find Options

/// Configuration options for find widget
public struct EditorFindOptions: Codable, Sendable {
    /// Whether find in selection is turned on in the find widget
    public let seedSearchStringFromSelection: String?
    /// Whether find in selection is auto-filled in the find widget
    public let autoFindInSelection: String?
    /// Whether to add extra lines around matches
    public let addExtraSpaceOnTop: Bool?
    /// Whether to loop back to the beginning when reaching the end
    public let loop: Bool?
    
    public init(
        seedSearchStringFromSelection: String? = nil,
        autoFindInSelection: String? = nil,
        addExtraSpaceOnTop: Bool? = nil,
        loop: Bool? = nil
    ) {
        self.seedSearchStringFromSelection = seedSearchStringFromSelection
        self.autoFindInSelection = autoFindInSelection
        self.addExtraSpaceOnTop = addExtraSpaceOnTop
        self.loop = loop
    }
}

// MARK: - Editor Minimap Options

/// Configuration options for the editor's minimap
public struct EditorMinimapOptions: Codable, Sendable {
    /// Whether minimap is enabled
    public let enabled: Bool?
    /// Whether minimap is always visible
    public let autohide: Bool?
    /// Minimap position
    public let side: MinimapPosition?
    /// Whether to show sliders on minimap
    public let showSlider: String?
    /// How to render minimap content
    public let renderCharacters: Bool?
    /// Maximum number of columns minimap can render
    public let maxColumn: Int?
    /// Scale factor for minimap
    public let scale: Int?
    /// How to render minimap
    public let size: String?
    
    public init(
        enabled: Bool? = nil,
        autohide: Bool? = nil,
        side: MinimapPosition? = nil,
        showSlider: String? = nil,
        renderCharacters: Bool? = nil,
        maxColumn: Int? = nil,
        scale: Int? = nil,
        size: String? = nil
    ) {
        self.enabled = enabled
        self.autohide = autohide
        self.side = side
        self.showSlider = showSlider
        self.renderCharacters = renderCharacters
        self.maxColumn = maxColumn
        self.scale = scale
        self.size = size
    }
}

// MARK: - Editor Padding Options

/// Configuration options for editor padding
public struct EditorPaddingOptions: Codable, Sendable {
    /// Padding at the top of the editor
    public let top: Int?
    /// Padding at the bottom of the editor
    public let bottom: Int?
    
    public init(top: Int? = nil, bottom: Int? = nil) {
        self.top = top
        self.bottom = bottom
    }
}

// MARK: - Quick Suggestions Options

/// Configuration options for quick suggestions
public struct QuickSuggestionsOptions: Codable, Sendable {
    /// Enable quick suggestions in other contexts
    public let other: Bool?
    /// Enable quick suggestions in comments
    public let comments: Bool?
    /// Enable quick suggestions in strings
    public let strings: Bool?
    
    public init(other: Bool? = nil, comments: Bool? = nil, strings: Bool? = nil) {
        self.other = other
        self.comments = comments
        self.strings = strings
    }
}

// MARK: - Suggest Options

/// Configuration options for IntelliSense suggestions
public struct SuggestOptions: Codable, Sendable {
    /// Whether to show inline suggestions
    public let insertMode: String?
    /// Filter suggestions
    public let filterGraceful: Bool?
    /// Show snippets
    public let snippetsPreventQuickSuggestions: Bool?
    /// Whether to show local before global suggestions
    public let localityBonus: Bool?
    /// Whether to share suggestions
    public let shareSuggestSelections: Bool?
    /// Whether to show icons in suggestions
    public let showIcons: Bool?
    /// Maximum number of suggestions to show
    public let maxVisibleSuggestions: Int?
    /// Whether to show methods
    public let showMethods: Bool?
    /// Whether to show functions
    public let showFunctions: Bool?
    /// Whether to show constructors
    public let showConstructors: Bool?
    /// Whether to show fields
    public let showFields: Bool?
    /// Whether to show variables
    public let showVariables: Bool?
    /// Whether to show classes
    public let showClasses: Bool?
    /// Whether to show structs
    public let showStructs: Bool?
    /// Whether to show interfaces
    public let showInterfaces: Bool?
    /// Whether to show modules
    public let showModules: Bool?
    /// Whether to show properties
    public let showProperties: Bool?
    /// Whether to show events
    public let showEvents: Bool?
    /// Whether to show operators
    public let showOperators: Bool?
    /// Whether to show units
    public let showUnits: Bool?
    /// Whether to show values
    public let showValues: Bool?
    /// Whether to show constants
    public let showConstants: Bool?
    /// Whether to show enums
    public let showEnums: Bool?
    /// Whether to show enum members
    public let showEnumMembers: Bool?
    /// Whether to show keywords
    public let showKeywords: Bool?
    /// Whether to show text suggestions
    public let showWords: Bool?
    /// Whether to show color suggestions
    public let showColors: Bool?
    /// Whether to show file suggestions
    public let showFiles: Bool?
    /// Whether to show reference suggestions
    public let showReferences: Bool?
    /// Whether to show folder suggestions
    public let showFolders: Bool?
    /// Whether to show type parameter suggestions
    public let showTypeParameters: Bool?
    /// Whether to show snippet suggestions
    public let showSnippets: Bool?
    
    public init(
        insertMode: String? = nil,
        filterGraceful: Bool? = nil,
        snippetsPreventQuickSuggestions: Bool? = nil,
        localityBonus: Bool? = nil,
        shareSuggestSelections: Bool? = nil,
        showIcons: Bool? = nil,
        maxVisibleSuggestions: Int? = nil,
        showMethods: Bool? = nil,
        showFunctions: Bool? = nil,
        showConstructors: Bool? = nil,
        showFields: Bool? = nil,
        showVariables: Bool? = nil,
        showClasses: Bool? = nil,
        showStructs: Bool? = nil,
        showInterfaces: Bool? = nil,
        showModules: Bool? = nil,
        showProperties: Bool? = nil,
        showEvents: Bool? = nil,
        showOperators: Bool? = nil,
        showUnits: Bool? = nil,
        showValues: Bool? = nil,
        showConstants: Bool? = nil,
        showEnums: Bool? = nil,
        showEnumMembers: Bool? = nil,
        showKeywords: Bool? = nil,
        showWords: Bool? = nil,
        showColors: Bool? = nil,
        showFiles: Bool? = nil,
        showReferences: Bool? = nil,
        showFolders: Bool? = nil,
        showTypeParameters: Bool? = nil,
        showSnippets: Bool? = nil
    ) {
        self.insertMode = insertMode
        self.filterGraceful = filterGraceful
        self.snippetsPreventQuickSuggestions = snippetsPreventQuickSuggestions
        self.localityBonus = localityBonus
        self.shareSuggestSelections = shareSuggestSelections
        self.showIcons = showIcons
        self.maxVisibleSuggestions = maxVisibleSuggestions
        self.showMethods = showMethods
        self.showFunctions = showFunctions
        self.showConstructors = showConstructors
        self.showFields = showFields
        self.showVariables = showVariables
        self.showClasses = showClasses
        self.showStructs = showStructs
        self.showInterfaces = showInterfaces
        self.showModules = showModules
        self.showProperties = showProperties
        self.showEvents = showEvents
        self.showOperators = showOperators
        self.showUnits = showUnits
        self.showValues = showValues
        self.showConstants = showConstants
        self.showEnums = showEnums
        self.showEnumMembers = showEnumMembers
        self.showKeywords = showKeywords
        self.showWords = showWords
        self.showColors = showColors
        self.showFiles = showFiles
        self.showReferences = showReferences
        self.showFolders = showFolders
        self.showTypeParameters = showTypeParameters
        self.showSnippets = showSnippets
    }
}

// MARK: - Hover Options

/// Configuration options for hover
public struct EditorHoverOptions: Codable, Sendable {
    /// Whether hover is enabled
    public let enabled: Bool?
    /// Delay before showing hover in milliseconds
    public let delay: Int?
    /// Whether hover stays visible when mouse moves away
    public let sticky: Bool?
    /// Above content or below content
    public let above: Bool?
    
    public init(
        enabled: Bool? = nil,
        delay: Int? = nil,
        sticky: Bool? = nil,
        above: Bool? = nil
    ) {
        self.enabled = enabled
        self.delay = delay
        self.sticky = sticky
        self.above = above
    }
}

// MARK: - Parameter Hint Options

/// Configuration options for parameter hints
public struct EditorParameterHintOptions: Codable, Sendable {
    /// Whether parameter hints are enabled
    public let enabled: Bool?
    /// Whether to cycle through overloads
    public let cycle: Bool?
    
    public init(enabled: Bool? = nil, cycle: Bool? = nil) {
        self.enabled = enabled
        self.cycle = cycle
    }
}

// MARK: - Lightbulb Options

/// Configuration options for code action lightbulb
public struct EditorLightbulbOptions: Codable, Sendable {
    /// Whether lightbulb is enabled
    public let enabled: Bool?
    
    public init(enabled: Bool? = nil) {
        self.enabled = enabled
    }
}

// MARK: - Bracket Pair Colorization Options

/// Configuration options for bracket pair colorization
public struct BracketPairColorizationOptions: Codable, Sendable {
    /// Whether bracket pair colorization is enabled
    public let enabled: Bool?
    /// Whether independent colorization is enabled
    public let independentColorPoolPerBracketType: Bool?
    
    public init(
        enabled: Bool? = nil,
        independentColorPoolPerBracketType: Bool? = nil
    ) {
        self.enabled = enabled
        self.independentColorPoolPerBracketType = independentColorPoolPerBracketType
    }
}

// MARK: - Guides Options

/// Configuration options for editor guides
public struct GuidesOptions: Codable, Sendable {
    /// Whether to show bracket pair guides
    public let bracketPairs: Bool?
    /// Whether to show bracket pair colorization for active line
    public let bracketPairsHorizontal: Bool?
    /// Whether to show highlighted active bracket pair
    public let highlightActiveBracketPair: Bool?
    /// Whether to show indentation guides
    public let indentation: Bool?
    /// Whether to highlight active indentation guide
    public let highlightActiveIndentation: Bool?
    
    public init(
        bracketPairs: Bool? = nil,
        bracketPairsHorizontal: Bool? = nil,
        highlightActiveBracketPair: Bool? = nil,
        indentation: Bool? = nil,
        highlightActiveIndentation: Bool? = nil
    ) {
        self.bracketPairs = bracketPairs
        self.bracketPairsHorizontal = bracketPairsHorizontal
        self.highlightActiveBracketPair = highlightActiveBracketPair
        self.indentation = indentation
        self.highlightActiveIndentation = highlightActiveIndentation
    }
}
