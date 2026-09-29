
// MARK: - Definition Provider Types

/// Represents a location in a source file
/// Corresponds to Monaco's `monaco.languages.Location`
public struct Location: Codable, Sendable {
    /// The resource identifier of this location
    public let uri: String
    
    /// The range of this location
    public let range: IDERange
    
    public init(uri: String, range: IDERange) {
        self.uri = uri
        self.range = range
    }
}

/// A link to a source location
/// Corresponds to Monaco's `monaco.languages.LocationLink`
public struct LocationLink: Codable, Sendable {
    /// The origin of this link
    public let originSelectionRange: IDERange?
    
    /// The target resource identifier
    public let targetUri: String
    
    /// The full target range of this link
    public let targetRange: IDERange
    
    /// The span inside targetRange that is considered the target
    public let targetSelectionRange: IDERange
    
    public init(
        originSelectionRange: IDERange? = nil,
        targetUri: String,
        targetRange: IDERange,
        targetSelectionRange: IDERange
    ) {
        self.originSelectionRange = originSelectionRange
        self.targetUri = targetUri
        self.targetRange = targetRange
        self.targetSelectionRange = targetSelectionRange
    }
}

// MARK: - Symbol Provider Types

/// Represents programming constructs like variables, classes, functions, etc.
/// Corresponds to Monaco's `monaco.languages.DocumentSymbol`
public struct DocumentSymbol: Codable, Sendable {
    /// The name of this symbol
    public let name: String
    
    /// More detail for this symbol
    public let detail: String?
    
    /// The kind of this symbol
    public let kind: SymbolKind
    
    /// Tags for this symbol
    public let tags: [SymbolTag]?
    
    /// The range enclosing this symbol
    public let range: IDERange
    
    /// The range that should be selected and revealed when this symbol is being picked
    public let selectionRange: IDERange
    
    /// Children of this symbol
    public let children: [DocumentSymbol]?
    
    public init(
        name: String,
        detail: String? = nil,
        kind: SymbolKind,
        tags: [SymbolTag]? = nil,
        range: IDERange,
        selectionRange: IDERange,
        children: [DocumentSymbol]? = nil
    ) {
        self.name = name
        self.detail = detail
        self.kind = kind
        self.tags = tags
        self.range = range
        self.selectionRange = selectionRange
        self.children = children
    }
}

/// Symbol kinds
/// Corresponds to Monaco's `monaco.languages.SymbolKind`
public enum SymbolKind: Int, Codable, Sendable {
    case file = 0
    case module = 1
    case namespace = 2
    case package = 3
    case `class` = 4
    case method = 5
    case property = 6
    case field = 7
    case constructor = 8
    case `enum` = 9
    case interface = 10
    case function = 11
    case variable = 12
    case constant = 13
    case string = 14
    case number = 15
    case boolean = 16
    case array = 17
    case object = 18
    case key = 19
    case null = 20
    case enumMember = 21
    case `struct` = 22
    case event = 23
    case `operator` = 24
    case typeParameter = 25
}

/// Symbol tags
/// Corresponds to Monaco's `monaco.languages.SymbolTag`
public enum SymbolTag: Int, Codable, Sendable {
    case deprecated = 1
}

// MARK: - Reference Provider Types

/// A reference context for finding references
/// Corresponds to Monaco's `monaco.languages.ReferenceContext`
public struct ReferenceContext: Codable, Sendable {
    /// Include the declaration of the symbol in the results
    public let includeDeclaration: Bool
    
    public init(includeDeclaration: Bool) {
        self.includeDeclaration = includeDeclaration
    }
}

// MARK: - Document Highlights Provider Types

/// A document highlight is a range inside a text document which deserves
/// special attention. Usually a document highlight is visualized by changing
/// the background color of its range.
/// Corresponds to Monaco's `monaco.languages.DocumentHighlight`
public struct DocumentHighlight: Codable, Sendable {
    /// The range this highlight applies to
    public let range: IDERange
    
    /// The highlight kind, default is text
    public let kind: DocumentHighlightKind?
    
    public init(range: IDERange, kind: DocumentHighlightKind? = nil) {
        self.range = range
        self.kind = kind
    }
}

/// A document highlight kind
/// Corresponds to Monaco's `monaco.languages.DocumentHighlightKind`
public enum DocumentHighlightKind: Int, Codable, Sendable {
    /// A textual occurrence
    case text = 0
    /// Read-access of a symbol, like reading a variable
    case read = 1
    /// Write-access of a symbol, like writing to a variable
    case write = 2
}

// MARK: - Selection Range Provider Types

/// A selection range represents a range around the cursor that the user
/// might be interested in selecting.
/// Corresponds to Monaco's `monaco.languages.SelectionRange`
public final class SelectionRange: Codable, Sendable {
    /// The range of this selection range
    public let range: IDERange
    
    /// The parent selection range containing this range
    public let parent: SelectionRange?
    
    private enum CodingKeys: String, CodingKey {
        case range, parent
    }
    
    public init(range: IDERange, parent: SelectionRange? = nil) {
        self.range = range
        self.parent = parent
    }
}

// MARK: - Helper Extensions

extension DocumentSymbol {
    /// Create a function symbol
    public static func function(
        name: String,
        parameters: String? = nil,
        range: IDERange,
        selectionRange: IDERange,
        children: [DocumentSymbol]? = nil
    ) -> DocumentSymbol {
        DocumentSymbol(
            name: name,
            detail: parameters.map { "(\($0))" },
            kind: .function,
            range: range,
            selectionRange: selectionRange,
            children: children
        )
    }
    
    /// Create a class symbol
    public static func `class`(
        name: String,
        bases: [String]? = nil,
        range: IDERange,
        selectionRange: IDERange,
        children: [DocumentSymbol]? = nil
    ) -> DocumentSymbol {
        let detail = bases.map { "(\($0.joined(separator: ", ")))" }
        return DocumentSymbol(
            name: name,
            detail: detail,
            kind: .class,
            range: range,
            selectionRange: selectionRange,
            children: children
        )
    }
    
    /// Create a variable symbol
    public static func variable(
        name: String,
        type: String? = nil,
        range: IDERange,
        selectionRange: IDERange
    ) -> DocumentSymbol {
        DocumentSymbol(
            name: name,
            detail: type.map { ": \($0)" },
            kind: .variable,
            range: range,
            selectionRange: selectionRange
        )
    }
    
    /// Create a method symbol
    public static func method(
        name: String,
        parameters: String? = nil,
        range: IDERange,
        selectionRange: IDERange
    ) -> DocumentSymbol {
        DocumentSymbol(
            name: name,
            detail: parameters.map { "(\($0))" },
            kind: .method,
            range: range,
            selectionRange: selectionRange
        )
    }
}

extension Location {
    /// Create a location in the current document
    public static func current(range: IDERange) -> Location {
        Location(uri: "file:///current", range: range)
    }
}

extension DocumentHighlight {
    /// Create a text highlight
    public static func text(at range: IDERange) -> DocumentHighlight {
        DocumentHighlight(range: range, kind: .text)
    }
    
    /// Create a read highlight
    public static func read(at range: IDERange) -> DocumentHighlight {
        DocumentHighlight(range: range, kind: .read)
    }
    
    /// Create a write highlight
    public static func write(at range: IDERange) -> DocumentHighlight {
        DocumentHighlight(range: range, kind: .write)
    }
}

extension SelectionRange {
    /// Create a selection range hierarchy from ranges (innermost to outermost)
    public static func hierarchy(_ ranges: [IDERange]) -> SelectionRange? {
        guard !ranges.isEmpty else { return nil }
        
        var result: SelectionRange?
        for range in ranges.reversed() {
            result = SelectionRange(range: range, parent: result)
        }
        return result
    }
}
