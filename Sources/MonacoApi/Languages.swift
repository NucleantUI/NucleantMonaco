
// MARK: - Code Action Types

/// Describes the reason a code action is triggered
public enum CodeActionTriggerType: Int, Codable, Sendable {
    /// Code actions were invoked manually
    case invoke = 1
    /// Code actions were invoked automatically (e.g., on save)
    case auto = 2
}

// MARK: - Completion Item Insert Text Rule

/// Describes how to insert completion text
public enum CompletionItemInsertTextRule: Int, Codable, Sendable {
    /// No special rules
    case none = 0
    /// Keep whitespace
    case keepWhitespace = 1
    /// Insert as snippet
    case insertAsSnippet = 4
}

// MARK: - Hover Verbosity

/// Hover verbosity action
public enum HoverVerbosityAction: Int, Codable, Sendable {
    /// Increase hover verbosity
    case increase = 0
    /// Decrease hover verbosity
    case decrease = 1
}

// MARK: - Indent Action

/// Describes what to do with indentation on enter
public enum IndentAction: Int, Codable, Sendable {
    /// No special indentation
    case none = 0
    /// Indent
    case indent = 1
    /// Indent and outdent
    case indentOutdent = 2
    /// Outdent
    case outdent = 3
}

// MARK: - Inline Completion End of Life Reason

/// Reason why inline completion is no longer shown
public enum InlineCompletionEndOfLifeReasonKind: Int, Codable, Sendable {
    /// Suggestion was accepted
    case accepted = 0
    /// Suggestion was rejected
    case rejected = 1
    /// Suggestion became stale
    case replaced = 2
}

// MARK: - Inline Completion Hint Style

/// Style for inline completion hints
public enum InlineCompletionHintStyle: Int, Codable, Sendable {
    /// No hint
    case none = 0
    /// Show inline hint
    case inline = 1
    /// Show decoration hint
    case decoration = 2
}

// MARK: - New Symbol Name Tag

/// Tags for new symbol names
public enum NewSymbolNameTag: Int, Codable, Sendable {
    /// AI generated name
    case aiGenerated = 1
}

// MARK: - New Symbol Name Trigger Kind

/// What triggered new symbol name request
public enum NewSymbolNameTriggerKind: Int, Codable, Sendable {
    /// Automatic
    case automatic = 0
    /// Invoked manually
    case invoke = 1
}

// MARK: - Partial Accept Trigger Kind

/// What triggered partial accept
public enum PartialAcceptTriggerKind: Int, Codable, Sendable {
    /// Word
    case word = 0
    /// Line
    case line = 1
    /// Suggest
    case suggest = 2
}

// MARK: - Language Configuration Types

/// Auto closing pair configuration
public struct IAutoClosingPair: Codable, Sendable {
    /// Opening string
    public let open: String
    /// Closing string
    public let close: String
    
    public init(open: String, close: String) {
        self.open = open
        self.close = close
    }
}

/// Auto closing pair with conditional configuration
public struct IAutoClosingPairConditional: Codable, Sendable {
    /// Opening string
    public let open: String
    /// Closing string
    public let close: String
    /// When not to auto close
    public let notIn: [String]?
    
    public init(open: String, close: String, notIn: [String]? = nil) {
        self.open = open
        self.close = close
        self.notIn = notIn
    }
}

/// Comment configuration for line comments
public struct LineCommentConfig: Codable, Sendable {
    /// Line comment token
    public let lineComment: String?
    
    public init(lineComment: String?) {
        self.lineComment = lineComment
    }
}

/// Comment rule configuration
public struct CommentRule: Codable, Sendable {
    /// Line comment token
    public let lineComment: String?
    /// Block comment tokens
    public let blockComment: [String]?
    
    public init(lineComment: String? = nil, blockComment: [String]? = nil) {
        self.lineComment = lineComment
        self.blockComment = blockComment
    }
}

/// Indentation rule
public struct IndentationRule: Codable, Sendable {
    /// Decrease indent pattern
    public let decreaseIndentPattern: String
    /// Increase indent pattern
    public let increaseIndentPattern: String
    /// Indent next line pattern
    public let indentNextLinePattern: String?
    /// Unindented line pattern
    public let unIndentedLinePattern: String?
    
    public init(
        decreaseIndentPattern: String,
        increaseIndentPattern: String,
        indentNextLinePattern: String? = nil,
        unIndentedLinePattern: String? = nil
    ) {
        self.decreaseIndentPattern = decreaseIndentPattern
        self.increaseIndentPattern = increaseIndentPattern
        self.indentNextLinePattern = indentNextLinePattern
        self.unIndentedLinePattern = unIndentedLinePattern
    }
}

/// Enter action
public struct EnterAction: Codable, Sendable {
    /// Indentation action
    public let indentAction: IndentAction
    /// Append text
    public let appendText: String?
    /// Remove text
    public let removeText: Int?
    
    public init(indentAction: IndentAction, appendText: String? = nil, removeText: Int? = nil) {
        self.indentAction = indentAction
        self.appendText = appendText
        self.removeText = removeText
    }
}

/// On enter rule
public struct OnEnterRule: Codable, Sendable {
    /// Before text pattern
    public let beforeText: String
    /// After text pattern
    public let afterText: String?
    /// Previous line text pattern
    public let previousLineText: String?
    /// Action to perform
    public let action: EnterAction
    
    public init(
        beforeText: String,
        afterText: String? = nil,
        previousLineText: String? = nil,
        action: EnterAction
    ) {
        self.beforeText = beforeText
        self.afterText = afterText
        self.previousLineText = previousLineText
        self.action = action
    }
}

/// Folding markers
public struct FoldingMarkers: Codable, Sendable {
    /// Start marker
    public let start: String
    /// End marker
    public let end: String
    
    public init(start: String, end: String) {
        self.start = start
        self.end = end
    }
}

/// Folding rules
public struct FoldingRules: Codable, Sendable {
    /// Offside rule
    public let offSide: Bool?
    /// Markers
    public let markers: FoldingMarkers?
    
    public init(offSide: Bool? = nil, markers: FoldingMarkers? = nil) {
        self.offSide = offSide
        self.markers = markers
    }
}

/// Doc comment configuration
public struct IDocComment: Codable, Sendable {
    /// Opening string
    public let open: String
    /// Closing string
    public let close: String?
    
    public init(open: String, close: String? = nil) {
        self.open = open
        self.close = close
    }
}

/// Language configuration
public struct LanguageConfiguration: Codable, Sendable {
    /// Comment configuration
    public let comments: CommentRule?
    /// Brackets
    public let brackets: [[String]]?
    /// Word pattern
    public let wordPattern: String?
    /// Indentation rules
    public let indentationRules: IndentationRule?
    /// On enter rules
    public let onEnterRules: [OnEnterRule]?
    /// Auto closing pairs
    public let autoClosingPairs: [IAutoClosingPairConditional]?
    /// Surrounding pairs
    public let surroundingPairs: [IAutoClosingPair]?
    /// Folding rules
    public let folding: FoldingRules?
    /// Auto closing before
    public let autoCloseBefore: String?
    /// Doc comment configuration
    public let docComment: IDocComment?
    
    public init(
        comments: CommentRule? = nil,
        brackets: [[String]]? = nil,
        wordPattern: String? = nil,
        indentationRules: IndentationRule? = nil,
        onEnterRules: [OnEnterRule]? = nil,
        autoClosingPairs: [IAutoClosingPairConditional]? = nil,
        surroundingPairs: [IAutoClosingPair]? = nil,
        folding: FoldingRules? = nil,
        autoCloseBefore: String? = nil,
        docComment: IDocComment? = nil
    ) {
        self.comments = comments
        self.brackets = brackets
        self.wordPattern = wordPattern
        self.indentationRules = indentationRules
        self.onEnterRules = onEnterRules
        self.autoClosingPairs = autoClosingPairs
        self.surroundingPairs = surroundingPairs
        self.folding = folding
        self.autoCloseBefore = autoCloseBefore
        self.docComment = docComment
    }
}

// MARK: - Color Types

/// A color in RGBA space
public struct IColor: Codable, Sendable {
    /// Red
    public let red: Double
    /// Green
    public let green: Double
    /// Blue
    public let blue: Double
    /// Alpha
    public let alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// Color information
public struct IColorInformation: Codable, Sendable {
    /// Range
    public let range: IRange
    /// Color
    public let color: IColor
    
    public init(range: IRange, color: IColor) {
        self.range = range
        self.color = color
    }
}

/// Color presentation
public struct IColorPresentation: Codable, Sendable {
    /// Label
    public let label: String
    /// Text edit
    public let textEdit: TextEdit?
    /// Additional text edits
    public let additionalTextEdits: [TextEdit]?
    
    public init(label: String, textEdit: TextEdit? = nil, additionalTextEdits: [TextEdit]? = nil) {
        self.label = label
        self.textEdit = textEdit
        self.additionalTextEdits = additionalTextEdits
    }
}

// MARK: - Link Types

/// A link
public struct ILink: Codable, Sendable {
    /// Range
    public let range: IRange
    /// URL
    public let url: String?
    /// Tooltip
    public let tooltip: String?
    
    public init(range: IRange, url: String? = nil, tooltip: String? = nil) {
        self.range = range
        self.url = url
        self.tooltip = tooltip
    }
}

/// List of links
public struct ILinksList: Codable, Sendable {
    /// Links
    public let links: [ILink]
    
    public init(links: [ILink]) {
        self.links = links
    }
}

// MARK: - Code Lens Types

/// Code lens
public struct CodeLens: Codable, Sendable {
    /// Range
    public let range: IRange
    /// ID
    public let id: String?
    /// Command
    public let command: Command?
    
    public init(range: IRange, id: String? = nil, command: Command? = nil) {
        self.range = range
        self.id = id
        self.command = command
    }
}

/// List of code lenses
public struct CodeLensList: Codable, Sendable {
    /// Lenses
    public let lenses: [CodeLens]
    
    public init(lenses: [CodeLens]) {
        self.lenses = lenses
    }
}

// MARK: - Language Filter (using Location/LocationLink from Symbols.swift, ReferenceContext from Symbols.swift)

/// Language filter
public struct LanguageFilter: Codable, Sendable {
    /// Language ID
    public let language: String?
    /// Scheme
    public let scheme: String?
    /// Pattern
    public let pattern: String?
    
    public init(language: String? = nil, scheme: String? = nil, pattern: String? = nil) {
        self.language = language
        self.scheme = scheme
        self.pattern = pattern
    }
}

// MARK: - Relative Pattern

/// Relative pattern
public struct IRelativePattern: Codable, Sendable {
    /// Base
    public let base: String
    /// Pattern
    public let pattern: String
    
    public init(base: String, pattern: String) {
        self.base = base
        self.pattern = pattern
    }
}

// MARK: - Workspace Edit (using WorkspaceEdit from CodeAction.swift)

/// Workspace edit metadata
public struct WorkspaceEditMetadata: Codable, Sendable {
    /// Needs confirmation
    public let needsConfirmation: Bool
    /// Label
    public let label: String?
    /// Description
    public let description: String?
    
    public init(needsConfirmation: Bool, label: String? = nil, description: String? = nil) {
        self.needsConfirmation = needsConfirmation
        self.label = label
        self.description = description
    }
}

/// Workspace file edit
public struct IWorkspaceTextEdit: Codable, Sendable {
    /// Resource
    public let resource: String
    /// Edit
    public let edit: TextEdit
    /// Version ID
    public let versionId: Int?
    
    public init(resource: String, edit: TextEdit, versionId: Int? = nil) {
        self.resource = resource
        self.edit = edit
        self.versionId = versionId
    }
}

/// Workspace file edit options
public struct WorkspaceFileEditOptions: Codable, Sendable {
    /// Overwrite
    public let overwrite: Bool?
    /// Ignore if exists
    public let ignoreIfExists: Bool?
    /// Ignore if not exists
    public let ignoreIfNotExists: Bool?
    /// Recursive
    public let recursive: Bool?
    
    public init(
        overwrite: Bool? = nil,
        ignoreIfExists: Bool? = nil,
        ignoreIfNotExists: Bool? = nil,
        recursive: Bool? = nil
    ) {
        self.overwrite = overwrite
        self.ignoreIfExists = ignoreIfExists
        self.ignoreIfNotExists = ignoreIfNotExists
        self.recursive = recursive
    }
}

/// Workspace file edit
public struct IWorkspaceFileEdit: Codable, Sendable {
    /// Old resource
    public let oldResource: String?
    /// New resource
    public let newResource: String?
    /// Options
    public let options: WorkspaceFileEditOptions?
    
    public init(oldResource: String? = nil, newResource: String? = nil, options: WorkspaceFileEditOptions? = nil) {
        self.oldResource = oldResource
        self.newResource = newResource
        self.options = options
    }
}

// MARK: - Rename Types

/// Rename location
public struct RenameLocation: Codable, Sendable {
    /// Range
    public let range: IRange
    /// Text
    public let text: String
    
    public init(range: IRange, text: String) {
        self.range = range
        self.text = text
    }
}

/// Rejection
public struct Rejection: Codable, Sendable {
    /// Reason for rejection
    public let reason: String
    
    public init(reason: String) {
        self.reason = reason
    }
}

// MARK: - Linked Editing

/// Linked editing ranges
public struct LinkedEditingRanges: Codable, Sendable {
    /// Ranges
    public let ranges: [IRange]
    /// Word pattern
    public let wordPattern: String?
    
    public init(ranges: [IRange], wordPattern: String? = nil) {
        self.ranges = ranges
        self.wordPattern = wordPattern
    }
}

// MARK: - Semantic Tokens (using SemanticTokens from LanguageFeatures.swift)

/// Semantic tokens edit
public struct SemanticTokensEdit: Codable, Sendable {
    /// Start
    public let start: Int
    /// Delete count
    public let deleteCount: Int
    /// Data
    public let data: [Int]?
    
    public init(start: Int, deleteCount: Int, data: [Int]? = nil) {
        self.start = start
        self.deleteCount = deleteCount
        self.data = data
    }
}

/// Semantic tokens edits
public struct SemanticTokensEdits: Codable, Sendable {
    /// Result ID
    public let resultId: String?
    /// Edits
    public let edits: [SemanticTokensEdit]
    
    public init(resultId: String? = nil, edits: [SemanticTokensEdit]) {
        self.resultId = resultId
        self.edits = edits
    }
}

// Note: SemanticTokensLegend is defined in LanguageFeatures.swift
