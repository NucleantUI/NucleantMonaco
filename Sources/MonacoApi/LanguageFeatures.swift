
// MARK: - Signature Help Provider Types

/// Signature help represents the signature of something callable
/// Corresponds to Monaco's `monaco.languages.SignatureHelp`
public struct SignatureHelp: Codable, Sendable {
    /// One or more signatures
    public let signatures: [SignatureInformation]
    
    /// The active signature
    public let activeSignature: Int?
    
    /// The active parameter of the active signature
    public let activeParameter: Int?
    
    public init(
        signatures: [SignatureInformation],
        activeSignature: Int? = nil,
        activeParameter: Int? = nil
    ) {
        self.signatures = signatures
        self.activeSignature = activeSignature
        self.activeParameter = activeParameter
    }
}

/// Represents the signature of a callable
/// Corresponds to Monaco's `monaco.languages.SignatureInformation`
public struct SignatureInformation: Codable, Sendable {
    /// The label of this signature
    public let label: String
    
    /// The human-readable documentation of this signature
    public let documentation: HoverContent?
    
    /// The parameters of this signature
    public let parameters: [ParameterInformation]?
    
    /// The index of the active parameter
    public let activeParameter: Int?
    
    public init(
        label: String,
        documentation: HoverContent? = nil,
        parameters: [ParameterInformation]? = nil,
        activeParameter: Int? = nil
    ) {
        self.label = label
        self.documentation = documentation
        self.parameters = parameters
        self.activeParameter = activeParameter
    }
}

/// Represents a parameter of a callable signature
/// Corresponds to Monaco's `monaco.languages.ParameterInformation`
public struct ParameterInformation: Codable, Sendable {
    /// The label of this parameter
    public let label: String
    
    /// The human-readable documentation of this parameter
    public let documentation: HoverContent?
    
    public init(label: String, documentation: HoverContent? = nil) {
        self.label = label
        self.documentation = documentation
    }
}

// MARK: - Formatting Provider Types

/// A format edit represents a text edit that should be applied during formatting
/// Corresponds to Monaco's `monaco.languages.TextEdit`
public typealias FormattingEdit = TextEdit

/// Options for document formatting
/// Corresponds to Monaco's `monaco.languages.FormattingOptions`
public struct FormattingOptions: Codable, Sendable {
    /// Size of a tab in spaces
    public let tabSize: Int
    
    /// Prefer spaces over tabs
    public let insertSpaces: Bool
    
    public init(tabSize: Int = 4, insertSpaces: Bool = true) {
        self.tabSize = tabSize
        self.insertSpaces = insertSpaces
    }
}

// MARK: - Folding Provider Types

/// A folding range represents a region that can be folded
/// Corresponds to Monaco's `monaco.languages.FoldingRange`
public struct FoldingRange: Codable, Sendable {
    /// The one-based start line of the range to fold
    public let start: Int
    
    /// The one-based end line of the range to fold
    public let end: Int
    
    /// The kind of folding range
    public let kind: FoldingRangeKind?
    
    public init(start: Int, end: Int, kind: FoldingRangeKind? = nil) {
        self.start = start
        self.end = end
        self.kind = kind
    }
}

/// Folding range kinds
/// Corresponds to Monaco's `monaco.languages.FoldingRangeKind`
public enum FoldingRangeKind: String, Codable, Sendable {
    case comment = "comment"
    case imports = "imports"
    case region = "region"
}

// MARK: - Semantic Tokens Provider Types

/// Legend for semantic tokens
/// Corresponds to Monaco's `monaco.languages.SemanticTokensLegend`
public struct SemanticTokensLegend: Codable, Sendable {
    /// The token types
    public let tokenTypes: [String]
    
    /// The token modifiers
    public let tokenModifiers: [String]
    
    public init(tokenTypes: [String], tokenModifiers: [String]) {
        self.tokenTypes = tokenTypes
        self.tokenModifiers = tokenModifiers
    }
}

/// Semantic tokens for a document
/// Corresponds to Monaco's `monaco.languages.SemanticTokens`
public struct SemanticTokens: Codable, Sendable {
    /// The result id of the tokens
    public let resultId: String?
    
    /// The actual tokens data
    /// Array of 5n integers: deltaLine, deltaStartChar, length, tokenType, tokenModifiers
    public let data: [Int]
    
    public init(resultId: String? = nil, data: [Int]) {
        self.resultId = resultId
        self.data = data
    }
}

/// Standard semantic token types
public enum SemanticTokenType: String, Codable, Sendable, CaseIterable {
    case namespace, type, `class`, `enum`, interface, `struct`, typeParameter
    case parameter, variable, property, enumMember, event
    case function, method, macro, keyword, modifier, comment
    case string, number, regexp, `operator`, decorator
    
    public var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

/// Standard semantic token modifiers
public enum SemanticTokenModifier: String, Codable, Sendable, CaseIterable {
    case declaration, definition, readonly, `static`, deprecated
    case abstract, async, modification, documentation, defaultLibrary
    
    public var bit: Int {
        1 << Self.allCases.firstIndex(of: self)!
    }
}

/// Helper for building semantic tokens
public final class SemanticTokensBuilder {
    private var tokens: [(line: Int, startChar: Int, length: Int, tokenType: Int, tokenModifiers: Int)] = []
    
    public init() {}
    
    public func push(line: Int, startChar: Int, length: Int, tokenType: SemanticTokenType, tokenModifiers: [SemanticTokenModifier] = []) {
        let modifierBits = tokenModifiers.reduce(0) { $0 | $1.bit }
        tokens.append((line, startChar, length, tokenType.index, modifierBits))
    }
    
    public func build() -> [Int] {
        let sorted = tokens.sorted { a, b in
            a.line != b.line ? a.line < b.line : a.startChar < b.startChar
        }
        
        var result: [Int] = []
        var prevLine = 0, prevStartChar = 0
        
        for token in sorted {
            let deltaLine = token.line - prevLine
            let deltaStartChar = deltaLine == 0 ? token.startChar - prevStartChar : token.startChar
            
            result.append(contentsOf: [deltaLine, deltaStartChar, token.length, token.tokenType, token.tokenModifiers])
            
            prevLine = token.line
            prevStartChar = token.startChar
        }
        
        return result
    }
}

// MARK: - Inlay Hints Provider Types

/// Inlay hints provide additional information inline with the code
/// Corresponds to Monaco's `monaco.languages.InlayHint`
public struct InlayHint: Codable, Sendable {
    /// The position of this hint
    public let position: Position
    
    /// The label of this hint
    public let label: String
    
    /// The kind of this hint
    public let kind: InlayHintKind?
    
    /// Tooltip text when hovering over this hint
    public let tooltip: String?
    
    /// Render padding before the hint
    public let paddingLeft: Bool?
    
    /// Render padding after the hint
    public let paddingRight: Bool?
    
    public init(
        position: Position,
        label: String,
        kind: InlayHintKind? = nil,
        tooltip: String? = nil,
        paddingLeft: Bool? = nil,
        paddingRight: Bool? = nil
    ) {
        self.position = position
        self.label = label
        self.kind = kind
        self.tooltip = tooltip
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
    }
}

/// Position in a text document
/// Corresponds to Monaco's `monaco.IPosition`
public struct Position: Codable, Sendable {
    /// Line position in a document (one-based)
    public let lineNumber: Int
    
    /// Character offset on a line in a document (one-based)
    public let column: Int
    
    public init(lineNumber: Int, column: Int) {
        self.lineNumber = lineNumber
        self.column = column
    }
}

/// Inlay hint kinds
/// Corresponds to Monaco's `monaco.languages.InlayHintKind`
public enum InlayHintKind: Int, Codable, Sendable {
    case type = 1
    case parameter = 2
}

// MARK: - Helper Extensions

extension SignatureHelp {
    /// Create signature help for a Python function
    public static func function(
        name: String,
        parameters: [(name: String, type: String?, doc: String?)],
        activeParameter: Int? = nil,
        documentation: String? = nil
    ) -> SignatureHelp {
        let paramInfo = parameters.map { param in
            let label = param.type.map { "\(param.name): \($0)" } ?? param.name
            return ParameterInformation(
                label: label,
                documentation: param.doc.map { .plainText($0) }
            )
        }
        
        let paramLabels = paramInfo.map { $0.label }.joined(separator: ", ")
        let signature = SignatureInformation(
            label: "\(name)(\(paramLabels))",
            documentation: documentation.map { .plainText($0) },
            parameters: paramInfo,
            activeParameter: activeParameter
        )
        
        return SignatureHelp(
            signatures: [signature],
            activeSignature: 0,
            activeParameter: activeParameter
        )
    }
}

extension InlayHint {
    /// Create a type hint
    public static func typeHint(
        at position: Position,
        type: String,
        tooltip: String? = nil
    ) -> InlayHint {
        InlayHint(
            position: position,
            label: ": \(type)",
            kind: .type,
            tooltip: tooltip,
            paddingLeft: false,
            paddingRight: true
        )
    }
    
    /// Create a parameter name hint
    public static func parameterHint(
        at position: Position,
        name: String,
        tooltip: String? = nil
    ) -> InlayHint {
        InlayHint(
            position: position,
            label: "\(name): ",
            kind: .parameter,
            tooltip: tooltip,
            paddingLeft: false,
            paddingRight: false
        )
    }
}

extension FoldingRange {
    /// Create a folding range for a function or class
    public static func block(start: Int, end: Int) -> FoldingRange {
        FoldingRange(start: start, end: end)
    }
    
    /// Create a folding range for comments
    public static func comment(start: Int, end: Int) -> FoldingRange {
        FoldingRange(start: start, end: end, kind: .comment)
    }
    
    /// Create a folding range for imports
    public static func imports(start: Int, end: Int) -> FoldingRange {
        FoldingRange(start: start, end: end, kind: .imports)
    }
}

// MARK: - Document Link Provider Types

/// A document link represents a clickable link in the editor
/// Corresponds to Monaco's `monaco.languages.ILink`
public struct DocumentLink: Codable, Sendable {
    /// The range this link applies to
    public let range: IDERange
    
    /// The uri this link points to
    public let url: String?
    
    /// The tooltip text when hovering over this link
    public let tooltip: String?
    
    public init(range: IDERange, url: String? = nil, tooltip: String? = nil) {
        self.range = range
        self.url = url
        self.tooltip = tooltip
    }
}

// MARK: - Color Provider Types

/// Color information represents a color in the document
/// Corresponds to Monaco's `monaco.languages.IColorInformation`
public struct ColorInformation: Codable, Sendable {
    /// The range in the document where this color appears
    public let range: IDERange
    
    /// The color value
    public let color: Color
    
    public init(range: IDERange, color: Color) {
        self.range = range
        self.color = color
    }
}

/// Represents a color
/// Corresponds to Monaco's `monaco.languages.IColor`
public struct Color: Codable, Sendable {
    /// Red component in the range [0, 1]
    public let red: Double
    
    /// Green component in the range [0, 1]
    public let green: Double
    
    /// Blue component in the range [0, 1]
    public let blue: Double
    
    /// Alpha component in the range [0, 1]
    public let alpha: Double
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}

/// Color presentation represents how a color should be displayed
/// Corresponds to Monaco's `monaco.languages.IColorPresentation`
public struct ColorPresentation: Codable, Sendable {
    /// The label of this color presentation
    public let label: String
    
    /// An optional text edit
    public let textEdit: TextEdit?
    
    /// Additional text edits
    public let additionalTextEdits: [TextEdit]?
    
    public init(label: String, textEdit: TextEdit? = nil, additionalTextEdits: [TextEdit]? = nil) {
        self.label = label
        self.textEdit = textEdit
        self.additionalTextEdits = additionalTextEdits
    }
}

// MARK: - Call Hierarchy Provider Types

/// Call hierarchy item represents a function or method in the call hierarchy
/// Corresponds to Monaco's `monaco.languages.CallHierarchyItem`
public struct CallHierarchyItem: Codable, Sendable {
    /// The name of this item
    public let name: String
    
    /// The kind of this item
    public let kind: SymbolKind
    
    /// Tags for this item
    public let tags: [Int]?
    
    /// More detail for this item
    public let detail: String?
    
    /// The resource identifier of this item
    public let uri: String
    
    /// The range enclosing this symbol
    public let range: IDERange
    
    /// The range that should be selected
    public let selectionRange: IDERange
    
    /// Data that should be preserved between calls
    public let data: String?
    
    public init(
        name: String,
        kind: SymbolKind,
        tags: [Int]? = nil,
        detail: String? = nil,
        uri: String,
        range: IDERange,
        selectionRange: IDERange,
        data: String? = nil
    ) {
        self.name = name
        self.kind = kind
        self.tags = tags
        self.detail = detail
        self.uri = uri
        self.range = range
        self.selectionRange = selectionRange
        self.data = data
    }
}

/// Represents an incoming call in the call hierarchy
/// Corresponds to Monaco's `monaco.languages.CallHierarchyIncomingCall`
public struct CallHierarchyIncomingCall: Codable, Sendable {
    /// The item that makes the call
    public let from: CallHierarchyItem
    
    /// The ranges at which the calls appear
    public let fromRanges: [IDERange]
    
    public init(from: CallHierarchyItem, fromRanges: [IDERange]) {
        self.from = from
        self.fromRanges = fromRanges
    }
}

/// Represents an outgoing call in the call hierarchy
/// Corresponds to Monaco's `monaco.languages.CallHierarchyOutgoingCall`
public struct CallHierarchyOutgoingCall: Codable, Sendable {
    /// The item that is called
    public let to: CallHierarchyItem
    
    /// The ranges at which the calls appear
    public let fromRanges: [IDERange]
    
    public init(to: CallHierarchyItem, fromRanges: [IDERange]) {
        self.to = to
        self.fromRanges = fromRanges
    }
}

// MARK: - Type Hierarchy Provider Types

/// Type hierarchy item represents a type in the hierarchy
/// Corresponds to Monaco's `monaco.languages.TypeHierarchyItem`
public struct TypeHierarchyItem: Codable, Sendable {
    /// The name of this item
    public let name: String
    
    /// The kind of this item
    public let kind: SymbolKind
    
    /// Tags for this item
    public let tags: [Int]?
    
    /// More detail for this item
    public let detail: String?
    
    /// The resource identifier of this item
    public let uri: String
    
    /// The range enclosing this symbol
    public let range: IDERange
    
    /// The range that should be selected
    public let selectionRange: IDERange
    
    /// Data that should be preserved between calls
    public let data: String?
    
    public init(
        name: String,
        kind: SymbolKind,
        tags: [Int]? = nil,
        detail: String? = nil,
        uri: String,
        range: IDERange,
        selectionRange: IDERange,
        data: String? = nil
    ) {
        self.name = name
        self.kind = kind
        self.tags = tags
        self.detail = detail
        self.uri = uri
        self.range = range
        self.selectionRange = selectionRange
        self.data = data
    }
}

// MARK: - Inline Values Provider Types

/// Inline value represents a value shown inline during debugging
/// Corresponds to Monaco's `monaco.languages.InlineValue`
public enum InlineValue: Codable, Sendable {
    case text(InlineValueText)
    case variableLookup(InlineValueVariableLookup)
    case evaluatableExpression(InlineValueEvaluatableExpression)
}

/// Inline value as text
public struct InlineValueText: Codable, Sendable {
    /// The document range for which the inline value applies
    public let range: IDERange
    
    /// The text of the inline value
    public let text: String
    
    public init(range: IDERange, text: String) {
        self.range = range
        self.text = text
    }
}

/// Inline value through a variable lookup
public struct InlineValueVariableLookup: Codable, Sendable {
    /// The document range for which the inline value applies
    public let range: IDERange
    
    /// The variable name to look up
    public let variableName: String?
    
    /// If true, case-sensitive lookup
    public let caseSensitiveLookup: Bool
    
    public init(range: IDERange, variableName: String? = nil, caseSensitiveLookup: Bool = true) {
        self.range = range
        self.variableName = variableName
        self.caseSensitiveLookup = caseSensitiveLookup
    }
}

/// Inline value through an expression evaluation
public struct InlineValueEvaluatableExpression: Codable, Sendable {
    /// The document range for which the inline value applies
    public let range: IDERange
    
    /// The expression to evaluate
    public let expression: String?
    
    public init(range: IDERange, expression: String? = nil) {
        self.range = range
        self.expression = expression
    }
}

extension SemanticTokensLegend {
    /// Create a standard legend with all token types and modifiers
    public static var standard: SemanticTokensLegend {
        SemanticTokensLegend(
            tokenTypes: SemanticTokenType.allCases.map(\.rawValue),
            tokenModifiers: SemanticTokenModifier.allCases.map(\.rawValue)
        )
    }
}

// NOTE: Color hex parsing extensions (fromHex, toHex) have been moved to MonacoCodable
// target as they require Foundation APIs (Scanner, String.trimmingCharacters, String(format:)).

