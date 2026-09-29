
/// Monaco-compatible diagnostic severity levels
/// Maps to monaco.MarkerSeverity
public enum DiagnosticSeverity: Int, Codable, Sendable {
    case hint = 1
    case info = 2
    case warning = 4
    case error = 8
}

/// Monaco-compatible diagnostic (marker) type
/// Compatible with monaco.editor.IMarkerData
public struct Diagnostic: Codable, Sendable {
    /// The severity of the diagnostic
    public let severity: DiagnosticSeverity
    
    /// The primary message for this diagnostic
    public let message: String
    
    /// The range at which the message applies
    public let range: IDERange
    
    /// An optional source identifier (e.g., "PySwiftAST")
    public let source: String?
    
    /// An optional code identifier for the diagnostic
    public let code: String?
    
    /// Optional related information for the diagnostic
    public let relatedInformation: [DiagnosticRelatedInformation]?
    
    /// Optional tags (e.g., unnecessary, deprecated)
    public let tags: [DiagnosticTag]?
    
    public init(
        severity: DiagnosticSeverity,
        message: String,
        range: IDERange,
        source: String? = "PySwiftAST",
        code: String? = nil,
        relatedInformation: [DiagnosticRelatedInformation]? = nil,
        tags: [DiagnosticTag]? = nil
    ) {
        self.severity = severity
        self.message = message
        self.range = range
        self.source = source
        self.code = code
        self.relatedInformation = relatedInformation
        self.tags = tags
    }
}

/// Related information for a diagnostic
public struct DiagnosticRelatedInformation: Codable, Sendable {
    /// The range at which the related information applies
    public let range: IDERange
    
    /// The message of this related information
    public let message: String
    
    public init(range: IDERange, message: String) {
        self.range = range
        self.message = message
    }
}

/// Diagnostic tag
public enum DiagnosticTag: Int, Codable, Sendable {
    case unnecessary = 1
    case deprecated = 2
}
