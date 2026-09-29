
// MARK: - Hover Provider Types

/// Hover information for a symbol
/// Corresponds to Monaco's `monaco.languages.Hover`
public struct Hover: Codable, Sendable {
    /// The hover contents
    public let contents: [HoverContent]
    
    /// The range to which the hover applies
    /// If omitted, applies to the word at the position
    public let range: IDERange?
    
    public init(contents: [HoverContent], range: IDERange? = nil) {
        self.contents = contents
        self.range = range
    }
}

/// Content for hover information
/// Corresponds to Monaco's `monaco.IMarkdownString` or plain string
public enum HoverContent: Codable, Sendable {
    case markdown(MarkdownString)
    case plainText(String)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let markdown = try? container.decode(MarkdownString.self) {
            self = .markdown(markdown)
        } else if let text = try? container.decode(String.self) {
            self = .plainText(text)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Expected MarkdownString or String"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .markdown(let md):
            try container.encode(md)
        case .plainText(let text):
            try container.encode(text)
        }
    }
}

/// Markdown string with support for code blocks
/// Corresponds to Monaco's `monaco.IMarkdownString`
public struct MarkdownString: Codable, Sendable {
    /// The markdown value
    public let value: String
    
    /// Indicates that this markdown string is from a trusted source
    public let isTrusted: Bool?
    
    /// Indicates that this markdown string contains raw HTML tags
    public let supportHtml: Bool?
    
    /// Base URI for relative links
    public let baseUri: String?
    
    public init(
        value: String,
        isTrusted: Bool? = nil,
        supportHtml: Bool? = nil,
        baseUri: String? = nil
    ) {
        self.value = value
        self.isTrusted = isTrusted
        self.supportHtml = supportHtml
        self.baseUri = baseUri
    }
}

// MARK: - Helper Extensions

extension Hover {
    /// Create a hover with plain text content
    public static func plainText(_ text: String, range: IDERange? = nil) -> Hover {
        Hover(contents: [.plainText(text)], range: range)
    }
    
    /// Create a hover with markdown content
    public static func markdown(_ markdown: String, range: IDERange? = nil) -> Hover {
        Hover(contents: [.markdown(MarkdownString(value: markdown))], range: range)
    }
    
    /// Create a hover with code block
    public static func code(_ code: String, language: String = "python", range: IDERange? = nil) -> Hover {
        let markdown = """
        ```\(language)
        \(code)
        ```
        """
        return .markdown(markdown, range: range)
    }
}

extension MarkdownString {
    /// Create a markdown string with a code block
    public static func codeBlock(_ code: String, language: String = "python") -> MarkdownString {
        MarkdownString(value: """
        ```\(language)
        \(code)
        ```
        """)
    }
}
