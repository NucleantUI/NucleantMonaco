
/// Monaco-compatible code action (quick fix) type
/// Compatible with monaco.languages.CodeAction
public struct CodeAction: Codable, Sendable {
    /// The title of the code action (shown in UI)
    public let title: String
    
    /// The kind of code action (e.g., "quickfix", "refactor")
    public let kind: CodeActionKind?
    
    /// The diagnostics that this code action resolves
    public let diagnostics: [Diagnostic]?
    
    /// The workspace edit to apply
    public let edit: WorkspaceEdit?
    
    /// Whether this action is preferred among all actions
    public let isPreferred: Bool?
    
    public init(
        title: String,
        kind: CodeActionKind? = nil,
        diagnostics: [Diagnostic]? = nil,
        edit: WorkspaceEdit? = nil,
        isPreferred: Bool? = nil
    ) {
        self.title = title
        self.kind = kind
        self.diagnostics = diagnostics
        self.edit = edit
        self.isPreferred = isPreferred
    }
}

/// Code action kind
public struct CodeActionKind: Codable, Sendable, Equatable {
    public let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public static let quickfix = CodeActionKind("quickfix")
    public static let refactor = CodeActionKind("refactor")
    public static let refactorExtract = CodeActionKind("refactor.extract")
    public static let refactorInline = CodeActionKind("refactor.inline")
    public static let refactorRewrite = CodeActionKind("refactor.rewrite")
    public static let source = CodeActionKind("source")
    public static let sourceOrganizeImports = CodeActionKind("source.organizeImports")
}

/// A workspace edit represents changes to many resources
public struct WorkspaceEdit: Codable, Sendable {
    /// Holds changes to existing resources (file URI -> array of text edits)
    public let changes: [String: [TextEdit]]?
    
    public init(changes: [String: [TextEdit]]?) {
        self.changes = changes
    }
}

/// A text edit represents an edit operation on a text document
public struct TextEdit: Codable, Sendable {
    /// The range to replace
    public let range: IDERange
    
    /// The new text
    public let newText: String
    
    public init(range: IDERange, newText: String) {
        self.range = range
        self.newText = newText
    }
}
