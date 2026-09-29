/// Monaco Editor JSON Language Support Types
///
/// Based on: https://microsoft.github.io/monaco-editor/docs.html#modules/json.html

// MARK: - JSON Diagnostics Options

/// Options for JSON diagnostics/validation
public struct JSONDiagnosticsOptions: Codable, Sendable {
    /// If enabled, the JSON language service will provide validation
    public let validate: Bool?
    
    /// If enabled, comments are allowed in JSON
    public let allowComments: Bool?
    
    /// JSON schemas for validation
    public let schemas: [JSONSchema]?
    
    /// Enable schema request service
    public let enableSchemaRequest: Bool?
    
    /// Schema validation mode
    public let schemaValidation: SchemaValidation?
    
    /// Schema request service
    public let schemaRequest: SchemaRequest?
    
    public init(
        validate: Bool? = nil,
        allowComments: Bool? = nil,
        schemas: [JSONSchema]? = nil,
        enableSchemaRequest: Bool? = nil,
        schemaValidation: SchemaValidation? = nil,
        schemaRequest: SchemaRequest? = nil
    ) {
        self.validate = validate
        self.allowComments = allowComments
        self.schemas = schemas
        self.enableSchemaRequest = enableSchemaRequest
        self.schemaValidation = schemaValidation
        self.schemaRequest = schemaRequest
    }
}

/// Schema validation mode
public enum SchemaValidation: String, Codable, Sendable {
    case error
    case warning
    case ignore
}

/// Schema request options
public enum SchemaRequest: String, Codable, Sendable {
    case enable
    case ignore
}

// MARK: - JSON Schema

/// JSON Schema definition for validation
public struct JSONSchema: Codable, Sendable {
    /// URI of the schema
    public let uri: String
    
    /// File match pattern(s) for this schema
    public let fileMatch: [String]?
    
    /// The JSON schema object
    public let schema: JSONSchemaObject?
    
    public init(
        uri: String,
        fileMatch: [String]? = nil,
        schema: JSONSchemaObject? = nil
    ) {
        self.uri = uri
        self.fileMatch = fileMatch
        self.schema = schema
    }
}

/// JSON Schema object definition
/// This is a simplified representation - full JSON Schema is very complex
public struct JSONSchemaObject: Codable, Sendable {
    public let id: String?
    public let schema: String?
    public let title: String?
    public let description: String?
    public let type: String?
    public let properties: [String: JSONSchemaObject]?
    public let required: [String]?
    public let additionalProperties: Bool?
    
    public init(
        id: String? = nil,
        schema: String? = nil,
        title: String? = nil,
        description: String? = nil,
        type: String? = nil,
        properties: [String: JSONSchemaObject]? = nil,
        required: [String]? = nil,
        additionalProperties: Bool? = nil
    ) {
        self.id = id
        self.schema = schema
        self.title = title
        self.description = description
        self.type = type
        self.properties = properties
        self.required = required
        self.additionalProperties = additionalProperties
    }
}

// MARK: - JSON Mode Configuration

/// Configuration for JSON language features
public struct JSONModeConfiguration: Codable, Sendable {
    /// Enable/disable document formatting
    public let documentFormattingEdits: Bool?
    
    /// Enable/disable range formatting
    public let documentRangeFormattingEdits: Bool?
    
    /// Enable/disable completions
    public let completionItems: Bool?
    
    /// Enable/disable hover
    public let hovers: Bool?
    
    /// Enable/disable document symbols
    public let documentSymbols: Bool?
    
    /// Enable/disable tokens (syntax highlighting)
    public let tokens: Bool?
    
    /// Enable/disable colors
    public let colors: Bool?
    
    /// Enable/disable folding ranges
    public let foldingRanges: Bool?
    
    /// Enable/disable diagnostics
    public let diagnostics: Bool?
    
    /// Enable/disable selection ranges
    public let selectionRanges: Bool?
    
    public init(
        documentFormattingEdits: Bool? = nil,
        documentRangeFormattingEdits: Bool? = nil,
        completionItems: Bool? = nil,
        hovers: Bool? = nil,
        documentSymbols: Bool? = nil,
        tokens: Bool? = nil,
        colors: Bool? = nil,
        foldingRanges: Bool? = nil,
        diagnostics: Bool? = nil,
        selectionRanges: Bool? = nil
    ) {
        self.documentFormattingEdits = documentFormattingEdits
        self.documentRangeFormattingEdits = documentRangeFormattingEdits
        self.completionItems = completionItems
        self.hovers = hovers
        self.documentSymbols = documentSymbols
        self.tokens = tokens
        self.colors = colors
        self.foldingRanges = foldingRanges
        self.diagnostics = diagnostics
        self.selectionRanges = selectionRanges
    }
}

// MARK: - JSON Formatting Options

/// Options for JSON document formatting
public struct JSONFormattingOptions: Codable, Sendable {
    /// Number of spaces for indentation
    public let tabSize: Int?
    
    /// Use spaces instead of tabs
    public let insertSpaces: Bool?
    
    /// Keep lines within this length
    public let printWidth: Int?
    
    public init(
        tabSize: Int? = nil,
        insertSpaces: Bool? = nil,
        printWidth: Int? = nil
    ) {
        self.tabSize = tabSize
        self.insertSpaces = insertSpaces
        self.printWidth = printWidth
    }
}

// MARK: - Language Service Defaults

/// Global defaults for JSON language service
public struct JSONLanguageServiceDefaults: Codable, Sendable {
    /// Diagnostics options
    public let diagnosticsOptions: JSONDiagnosticsOptions?
    
    /// Mode configuration
    public let modeConfiguration: JSONModeConfiguration?
    
    public init(
        diagnosticsOptions: JSONDiagnosticsOptions? = nil,
        modeConfiguration: JSONModeConfiguration? = nil
    ) {
        self.diagnosticsOptions = diagnosticsOptions
        self.modeConfiguration = modeConfiguration
    }
}
