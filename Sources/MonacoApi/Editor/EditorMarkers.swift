
// MARK: - Marker Severity

/// The severity of a marker
public enum MarkerSeverity: Int, Codable, Sendable {
    /// A hint
    case hint = 1
    /// An info
    case info = 2
    /// A warning
    case warning = 4
    /// An error
    case error = 8
}

// MARK: - Marker Tag

/// A tag for a marker
public enum MarkerTag: Int, Codable, Sendable {
    /// Unnecessary code
    case unnecessary = 1
    /// Deprecated code
    case deprecated = 2
}

// MARK: - Related Information

/// Represents a related message and source code location for a diagnostic
public struct IRelatedInformation: Codable, Sendable {
    /// The resource where the related information is located
    public let resource: String
    /// The starting line number
    public let startLineNumber: Int
    /// The starting column
    public let startColumn: Int
    /// The ending line number
    public let endLineNumber: Int
    /// The ending column
    public let endColumn: Int
    /// The message
    public let message: String
    
    public init(
        resource: String,
        startLineNumber: Int,
        startColumn: Int,
        endLineNumber: Int,
        endColumn: Int,
        message: String
    ) {
        self.resource = resource
        self.startLineNumber = startLineNumber
        self.startColumn = startColumn
        self.endLineNumber = endLineNumber
        self.endColumn = endColumn
        self.message = message
    }
}

// MARK: - Marker Data

/// A structure defining a problem/warning/etc.
public struct IMarkerData: Codable, Sendable {
    /// The error code
    public let code: String?
    /// The severity of the marker
    public let severity: MarkerSeverity
    /// The message
    public let message: String
    /// The source of the marker
    public let source: String?
    /// The starting line number
    public let startLineNumber: Int
    /// The starting column
    public let startColumn: Int
    /// The ending line number
    public let endLineNumber: Int
    /// The ending column
    public let endColumn: Int
    /// Related information
    public let relatedInformation: [IRelatedInformation]?
    /// Tags for the marker
    public let tags: [MarkerTag]?
    
    public init(
        code: String? = nil,
        severity: MarkerSeverity,
        message: String,
        source: String? = nil,
        startLineNumber: Int,
        startColumn: Int,
        endLineNumber: Int,
        endColumn: Int,
        relatedInformation: [IRelatedInformation]? = nil,
        tags: [MarkerTag]? = nil
    ) {
        self.code = code
        self.severity = severity
        self.message = message
        self.source = source
        self.startLineNumber = startLineNumber
        self.startColumn = startColumn
        self.endLineNumber = endLineNumber
        self.endColumn = endColumn
        self.relatedInformation = relatedInformation
        self.tags = tags
    }
}

// MARK: - Marker

/// A marker in the editor
public struct IMarker: Codable, Sendable {
    /// The owner of this marker
    public let owner: String
    /// The resource
    public let resource: String
    /// The severity
    public let severity: MarkerSeverity
    /// The error code
    public let code: String?
    /// The message
    public let message: String
    /// The source
    public let source: String?
    /// The starting line number
    public let startLineNumber: Int
    /// The starting column
    public let startColumn: Int
    /// The ending line number
    public let endLineNumber: Int
    /// The ending column
    public let endColumn: Int
    /// Related information
    public let relatedInformation: [IRelatedInformation]?
    /// Tags for the marker
    public let tags: [MarkerTag]?
    
    public init(
        owner: String,
        resource: String,
        severity: MarkerSeverity,
        code: String? = nil,
        message: String,
        source: String? = nil,
        startLineNumber: Int,
        startColumn: Int,
        endLineNumber: Int,
        endColumn: Int,
        relatedInformation: [IRelatedInformation]? = nil,
        tags: [MarkerTag]? = nil
    ) {
        self.owner = owner
        self.resource = resource
        self.severity = severity
        self.code = code
        self.message = message
        self.source = source
        self.startLineNumber = startLineNumber
        self.startColumn = startColumn
        self.endLineNumber = endLineNumber
        self.endColumn = endColumn
        self.relatedInformation = relatedInformation
        self.tags = tags
    }
}

// MARK: - Resource Text Edit

/// A text edit applicable to a text model
public struct IResourceTextEdit: Codable, Sendable {
    /// The resource to edit
    public let resource: String
    /// The edit to apply
    public let edit: TextEdit
    /// The version ID expected
    public let versionId: Int?
    
    public init(resource: String, edit: TextEdit, versionId: Int? = nil) {
        self.resource = resource
        self.edit = edit
        self.versionId = versionId
    }
}

// MARK: - Resource File Edit

/// A file operation edit
public struct IResourceFileEdit: Codable, Sendable {
    /// The old resource (for rename/move)
    public let oldResource: String?
    /// The new resource
    public let newResource: String
    /// Options for the file operation
    public let options: FileOperationOptions?
    
    public init(oldResource: String? = nil, newResource: String, options: FileOperationOptions? = nil) {
        self.oldResource = oldResource
        self.newResource = newResource
        self.options = options
    }
}

// MARK: - File Operation Options

/// Options for file operations
public struct FileOperationOptions: Codable, Sendable {
    /// Overwrite existing file
    public let overwrite: Bool?
    /// Ignore if file doesn't exist
    public let ignoreIfNotExists: Bool?
    /// Ignore if file exists
    public let ignoreIfExists: Bool?
    /// Recursive operation
    public let recursive: Bool?
    
    public init(
        overwrite: Bool? = nil,
        ignoreIfNotExists: Bool? = nil,
        ignoreIfExists: Bool? = nil,
        recursive: Bool? = nil
    ) {
        self.overwrite = overwrite
        self.ignoreIfNotExists = ignoreIfNotExists
        self.ignoreIfExists = ignoreIfExists
        self.recursive = recursive
    }
}

// MARK: - Workspace Edit

/// A workspace edit contains text edits and file operations
public struct IWorkspaceEdit: Codable, Sendable {
    /// Text edits to apply
    public let edits: [IResourceTextEdit]?
    /// File operations to apply
    public let fileOperations: [IResourceFileEdit]?
    
    public init(edits: [IResourceTextEdit]? = nil, fileOperations: [IResourceFileEdit]? = nil) {
        self.edits = edits
        self.fileOperations = fileOperations
    }
}
