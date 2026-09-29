
// MARK: - Completion Provider Types

/// A completion item represents a suggestion for code completion
/// Corresponds to Monaco's `monaco.languages.CompletionItem`
public struct CompletionItem: Codable, Sendable {
    /// The label of this completion item
    public let label: String
    
    /// Detailed label (alternative to simple label)
    public let labelDetails: CompletionItemLabel?
    
    /// The kind of this completion item
    public let kind: CompletionItemKind
    
    /// Tags for this completion item
    public let tags: [CompletionItemTag]?
    
    /// A human-readable string with additional information
    public let detail: String?
    
    /// A human-readable string that represents a doc-comment
    public let documentation: HoverContent?
    
    /// A string or snippet that should be inserted
    public let insertText: String
    
    /// The format of the insert text
    public let insertTextFormat: InsertTextFormat?
    
    /// Insert text rules
    public let insertTextRules: InsertTextRule?
    
    /// The range to replace
    public let range: CompletionItemRange?
    
    /// An optional array of additional text edits
    public let additionalTextEdits: [TextEdit]?
    
    /// A command that should be run after insertion
    public let command: Command?
    
    /// Optional commit characters
    public let commitCharacters: [String]?
    
    /// Sort text for ordering completions
    public let sortText: String?
    
    /// Filter text for narrowing completions
    public let filterText: String?
    
    /// Select this item when showing
    public let preselect: Bool?
    
    /// Keep whitespace on accept
    public let keepWhitespace: Bool?
    
    public init(
        label: String,
        labelDetails: CompletionItemLabel? = nil,
        kind: CompletionItemKind,
        tags: [CompletionItemTag]? = nil,
        detail: String? = nil,
        documentation: HoverContent? = nil,
        insertText: String,
        insertTextFormat: InsertTextFormat? = nil,
        insertTextRules: InsertTextRule? = nil,
        range: CompletionItemRange? = nil,
        additionalTextEdits: [TextEdit]? = nil,
        command: Command? = nil,
        commitCharacters: [String]? = nil,
        sortText: String? = nil,
        filterText: String? = nil,
        preselect: Bool? = nil,
        keepWhitespace: Bool? = nil
    ) {
        self.label = label
        self.labelDetails = labelDetails
        self.kind = kind
        self.tags = tags
        self.detail = detail
        self.documentation = documentation
        self.insertText = insertText
        self.insertTextFormat = insertTextFormat
        self.insertTextRules = insertTextRules
        self.range = range
        self.additionalTextEdits = additionalTextEdits
        self.command = command
        self.commitCharacters = commitCharacters
        self.sortText = sortText
        self.filterText = filterText
        self.preselect = preselect
        self.keepWhitespace = keepWhitespace
    }
}

/// Completion item kinds
/// Corresponds to Monaco's `monaco.languages.CompletionItemKind`
public enum CompletionItemKind: Int, Codable, Sendable {
    case method = 0
    case function = 1
    case constructor = 2
    case field = 3
    case variable = 4
    case `class` = 5
    case `struct` = 6
    case interface = 7
    case module = 8
    case property = 9
    case event = 10
    case `operator` = 11
    case unit = 12
    case value = 13
    case constant = 14
    case `enum` = 15
    case enumMember = 16
    case keyword = 17
    case text = 18
    case color = 19
    case file = 20
    case reference = 21
    case customcolor = 22
    case folder = 23
    case typeParameter = 24
    case user = 25
    case issue = 26
    case snippet = 27
}

/// Completion item tags
/// Corresponds to Monaco's `monaco.languages.CompletionItemTag`
public enum CompletionItemTag: Int, Codable, Sendable {
    case deprecated = 1
}

/// Insert text format
/// Corresponds to Monaco's `monaco.languages.InsertTextFormat`
public enum InsertTextFormat: Int, Codable, Sendable {
    case plainText = 1
    case snippet = 2
}

/// Insert text rules
/// Corresponds to Monaco's `monaco.languages.CompletionItemInsertTextRule`
public enum InsertTextRule: Int, Codable, Sendable {
    /// Adjust whitespace/indentation of multiline insert texts to match current line
    case keepWhitespace = 1
    /// Insert text is a snippet
    case insertAsSnippet = 4
}

/// Range for completion item replacement
public enum CompletionItemRange: Codable, Sendable {
    case single(IDERange)
    case insertReplace(insert: IDERange, replace: IDERange)
    
    private enum CodingKeys: String, CodingKey {
        case insert, replace
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.insert) && container.contains(.replace) {
            let insert = try container.decode(IDERange.self, forKey: .insert)
            let replace = try container.decode(IDERange.self, forKey: .replace)
            self = .insertReplace(insert: insert, replace: replace)
        } else {
            let range = try IDERange(from: decoder)
            self = .single(range)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .single(let range):
            try range.encode(to: encoder)
        case .insertReplace(let insert, let replace):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(insert, forKey: .insert)
            try container.encode(replace, forKey: .replace)
        }
    }
}

/// A command that can be executed
/// Corresponds to Monaco's `monaco.languages.Command`
public struct Command: Codable, Sendable {
    /// Title of the command
    public let title: String
    
    /// The identifier of the actual command handler
    public let command: String
    
    /// Arguments that the command should be invoked with
    public let arguments: [String]?
    
    public init(title: String, command: String, arguments: [String]? = nil) {
        self.title = title
        self.command = command
        self.arguments = arguments
    }
}

/// A list of completion items
/// Corresponds to Monaco's `monaco.languages.CompletionList`
public struct CompletionList: Codable, Sendable {
    /// The completion items
    public let suggestions: [CompletionItem]
    
    /// Incomplete flag indicates more results are available
    public let incomplete: Bool?
    
    /// Dispose function for cleanup
    public let dispose: String?
    
    public init(suggestions: [CompletionItem], incomplete: Bool? = nil, dispose: String? = nil) {
        self.suggestions = suggestions
        self.incomplete = incomplete
        self.dispose = dispose
    }
}

// MARK: - Suggest Options (for IntelliSense configuration)

/// Options for the suggest widget
/// Corresponds to Monaco's suggest widget configuration
public struct CompletionTriggerOptions: Codable, Sendable {
    /// Trigger kind
    public let triggerKind: CompletionTriggerKind
    
    /// Trigger character (if triggered by a character)
    public let triggerCharacter: String?
    
    public init(triggerKind: CompletionTriggerKind, triggerCharacter: String? = nil) {
        self.triggerKind = triggerKind
        self.triggerCharacter = triggerCharacter
    }
}

/// How a completion was triggered
public enum CompletionTriggerKind: Int, Codable, Sendable {
    /// Completion was triggered by typing an identifier or via API
    case invoke = 0
    /// Completion was triggered by a trigger character
    case triggerCharacter = 1
    /// Completion was re-triggered as the current completion list is incomplete
    case triggerForIncompleteCompletions = 2
}

/// Context provided to completion provider
public struct CompletionContext: Codable, Sendable {
    /// How the completion was triggered
    public let triggerKind: CompletionTriggerKind
    
    /// Character that triggered completion (if applicable)
    public let triggerCharacter: String?
    
    public init(triggerKind: CompletionTriggerKind, triggerCharacter: String? = nil) {
        self.triggerKind = triggerKind
        self.triggerCharacter = triggerCharacter
    }
}

// MARK: - Inline Completions (Copilot-style)

/// Inline completion item (for ghost text suggestions)
/// Corresponds to Monaco's `monaco.languages.InlineCompletion`
public struct InlineCompletion: Codable, Sendable {
    /// The text to insert
    public let insertText: String
    
    /// The format of the insert text
    public let insertTextFormat: InsertTextFormat?
    
    /// An optional array of additional text edits
    public let additionalTextEdits: [TextEdit]?
    
    /// A command to execute after insertion
    public let command: Command?
    
    /// The range to replace
    public let range: IDERange?
    
    public init(
        insertText: String,
        insertTextFormat: InsertTextFormat? = nil,
        additionalTextEdits: [TextEdit]? = nil,
        command: Command? = nil,
        range: IDERange? = nil
    ) {
        self.insertText = insertText
        self.insertTextFormat = insertTextFormat
        self.additionalTextEdits = additionalTextEdits
        self.command = command
        self.range = range
    }
}

/// Inline completion list (for ghost text)
/// Corresponds to Monaco's `monaco.languages.InlineCompletions`
public struct InlineCompletionList: Codable, Sendable {
    /// The inline completion items
    public let items: [InlineCompletion]
    
    /// Commands to execute
    public let commands: [Command]?
    
    public init(items: [InlineCompletion], commands: [Command]? = nil) {
        self.items = items
        self.commands = commands
    }
}

/// Context for inline completions
public struct InlineCompletionContext: Codable, Sendable {
    /// How the completion was triggered
    public let triggerKind: InlineCompletionTriggerKind
    
    /// The selected suggestion info (if completion was triggered by suggestion)
    public let selectedSuggestionInfo: SelectedSuggestionInfo?
    
    public init(
        triggerKind: InlineCompletionTriggerKind,
        selectedSuggestionInfo: SelectedSuggestionInfo? = nil
    ) {
        self.triggerKind = triggerKind
        self.selectedSuggestionInfo = selectedSuggestionInfo
    }
}

/// How inline completion was triggered
public enum InlineCompletionTriggerKind: Int, Codable, Sendable {
    /// Completion was triggered automatically
    case automatic = 0
    /// Completion was triggered explicitly by user
    case explicit = 1
}

/// Information about the selected suggestion
public struct SelectedSuggestionInfo: Codable, Sendable {
    /// The range of the selected suggestion
    public let range: IDERange
    
    /// The text of the selected suggestion
    public let text: String
    
    /// Completion kind
    public let completionKind: CompletionItemKind
    
    /// Is snippet
    public let isSnippetText: Bool
    
    public init(
        range: IDERange,
        text: String,
        completionKind: CompletionItemKind,
        isSnippetText: Bool
    ) {
        self.range = range
        self.text = text
        self.completionKind = completionKind
        self.isSnippetText = isSnippetText
    }
}

// MARK: - Snippet Support

/// A snippet string with placeholders and variables
public struct SnippetString: Codable, Sendable {
    /// The snippet value
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    /// Create a snippet with numbered placeholders
    /// Example: "def ${1:name}(${2:args}):\n\t${0:pass}"
    public static func withPlaceholders(_ template: String) -> SnippetString {
        SnippetString(value: template)
    }
    
    /// Create a snippet with variables
    /// Example: "def ${TM_FILENAME_BASE}():\n\t${0:pass}"
    public static func withVariables(_ template: String) -> SnippetString {
        SnippetString(value: template)
    }
}

// MARK: - Completion Item Label

/// Detailed label for completion item
public struct CompletionItemLabel: Codable, Sendable {
    /// Label text before detail
    public let label: String
    
    /// Optional detail to show
    public let detail: String?
    
    /// Optional description
    public let description: String?
    
    public init(label: String, detail: String? = nil, description: String? = nil) {
        self.label = label
        self.detail = detail
        self.description = description
    }
}

// MARK: - Completion Commit Characters

/// Characters that can commit (accept) a completion
public struct CompletionCommitCharacters: Codable, Sendable {
    /// The commit characters
    public let characters: [String]
    
    public init(characters: [String]) {
        self.characters = characters
    }
    
    /// Common Python commit characters
    public static let python = CompletionCommitCharacters(
        characters: [".", "(", "[", ":", "=", " "]
    )
    
    /// Common JavaScript commit characters
    public static let javascript = CompletionCommitCharacters(
        characters: [".", "(", "[", "{", ":", ";", ",", "=", " "]
    )
}

// MARK: - Signature Help (Parameter Hints)

/// Signature help represents the signature of a callable
/// Corresponds to Monaco's `monaco.languages.SignatureHelp`
public struct SignatureHelpResult: Codable, Sendable {
    /// The active signature
    public let signatures: [SignatureInformation]
    
    /// The active signature index
    public let activeSignature: Int
    
    /// The active parameter index
    public let activeParameter: Int
    
    public init(
        signatures: [SignatureInformation],
        activeSignature: Int = 0,
        activeParameter: Int = 0
    ) {
        self.signatures = signatures
        self.activeSignature = activeSignature
        self.activeParameter = activeParameter
    }
}

/// Context for signature help
public struct SignatureHelpContext: Codable, Sendable {
    /// How signature help was triggered
    public let triggerKind: SignatureHelpTriggerKind
    
    /// Trigger character (if applicable)
    public let triggerCharacter: String?
    
    /// Whether signature help is already showing
    public let isRetrigger: Bool
    
    /// Active signature help
    public let activeSignatureHelp: SignatureHelpResult?
    
    public init(
        triggerKind: SignatureHelpTriggerKind,
        triggerCharacter: String? = nil,
        isRetrigger: Bool = false,
        activeSignatureHelp: SignatureHelpResult? = nil
    ) {
        self.triggerKind = triggerKind
        self.triggerCharacter = triggerCharacter
        self.isRetrigger = isRetrigger
        self.activeSignatureHelp = activeSignatureHelp
    }
}

/// How signature help was triggered
public enum SignatureHelpTriggerKind: Int, Codable, Sendable {
    /// Triggered by API call or typing
    case invoke = 1
    /// Triggered by a trigger character
    case triggerCharacter = 2
    /// Triggered because cursor moved
    case contentChange = 3
}

// MARK: - Suggestion Filtering and Ranking

/// Options for filtering/ranking suggestions
public struct SuggestionFilterOptions: Codable, Sendable {
    /// Filter by kind
    public let kindFilter: Set<CompletionItemKind>?
    
    /// Show only snippets
    public let snippetsOnly: Bool?
    
    /// Maximum suggestions to return
    public let maxSuggestions: Int?
    
    /// Prefer local suggestions
    public let preferLocal: Bool?
    
    public init(
        kindFilter: Set<CompletionItemKind>? = nil,
        snippetsOnly: Bool? = nil,
        maxSuggestions: Int? = nil,
        preferLocal: Bool? = nil
    ) {
        self.kindFilter = kindFilter
        self.snippetsOnly = snippetsOnly
        self.maxSuggestions = maxSuggestions
        self.preferLocal = preferLocal
    }
}

// MARK: - Provider Metadata

/// Metadata about completion provider capabilities
public struct CompletionProviderMetadata: Codable, Sendable {
    /// Trigger characters for this provider
    public let triggerCharacters: [String]?
    
    /// Whether provider provides resolve details
    public let resolveProvider: Bool?
    
    /// All possible commit characters
    public let allCommitCharacters: [String]?
    
    public init(
        triggerCharacters: [String]? = nil,
        resolveProvider: Bool? = nil,
        allCommitCharacters: [String]? = nil
    ) {
        self.triggerCharacters = triggerCharacters
        self.resolveProvider = resolveProvider
        self.allCommitCharacters = allCommitCharacters
    }
    
    /// Python completion provider metadata
    public static let python = CompletionProviderMetadata(
        triggerCharacters: [".", "(", "["],
        resolveProvider: true,
        allCommitCharacters: [".", "(", "[", ":", "=", " "]
    )
}

// MARK: - Helper Extensions

extension CompletionItem {
    /// Create a simple keyword completion
    public static func keyword(_ keyword: String) -> CompletionItem {
        CompletionItem(
            label: keyword,
            kind: CompletionItemKind.keyword,
            detail: "Python keyword",
            insertText: keyword,
            sortText: "0_\(keyword)" // Keywords sort first
        )
    }
    
    /// Create a function completion with snippet
    public static func function(
        name: String,
        parameters: [String],
        detail: String? = nil,
        documentation: String? = nil
    ) -> CompletionItem {
        let paramSnippets = parameters.enumerated().map { "${\($0.offset + 1):\($0.element)}" }
        let snippet = "\(name)(\(paramSnippets.joined(separator: ", ")))"
        
        return CompletionItem(
            label: name,
            kind: CompletionItemKind.function,
            detail: detail ?? "def \(name)(\(parameters.joined(separator: ", ")))",
            documentation: documentation.map { HoverContent.plainText($0) },
            insertText: snippet,
            insertTextFormat: InsertTextFormat.snippet
        )
    }
    
    /// Create a variable completion
    public static func variable(name: String, type: String? = nil) -> CompletionItem {
        CompletionItem(
            label: name,
            kind: CompletionItemKind.variable,
            detail: type.map { "\(name): \($0)" },
            insertText: name
        )
    }
    
    /// Create a class completion
    public static func `class`(name: String, documentation: String? = nil) -> CompletionItem {
        CompletionItem(
            label: name,
            kind: CompletionItemKind.class,
            detail: "class \(name)",
            documentation: documentation.map { HoverContent.plainText($0) },
            insertText: name
        )
    }
    
    /// Create a constant completion
    public static func constant(name: String, value: String, documentation: String? = nil) -> CompletionItem {
        CompletionItem(
            label: name,
            kind: CompletionItemKind.constant,
            detail: "\(name) = \(value)",
            documentation: documentation.map { HoverContent.plainText($0) },
            insertText: name
        )
    }
}
