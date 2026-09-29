
/// Monaco-compatible range type for marking code regions
/// Compatible with monaco.IRange from the Monaco Editor API
public struct IDERange: Codable, Equatable, Sendable {
    /// The line number on which the range starts (1-based)
    public let startLineNumber: Int
    
    /// The column on which the range starts in line `startLineNumber` (1-based)
    public let startColumn: Int
    
    /// The line number on which the range ends (1-based)
    public let endLineNumber: Int
    
    /// The column on which the range ends in line `endLineNumber` (1-based)
    public let endColumn: Int
    
    public init(
        startLineNumber: Int,
        startColumn: Int,
        endLineNumber: Int,
        endColumn: Int
    ) {
        self.startLineNumber = startLineNumber
        self.startColumn = startColumn
        self.endLineNumber = endLineNumber
        self.endColumn = endColumn
    }
    
    /// Create a range from a single position with optional length
    public static func from(line: Int, column: Int, length: Int = 1) -> IDERange {
        return IDERange(
            startLineNumber: line,
            startColumn: column,
            endLineNumber: line,
            endColumn: column + length
        )
    }
}

/// Type alias for Monaco compatibility
public typealias IRange = IDERange
