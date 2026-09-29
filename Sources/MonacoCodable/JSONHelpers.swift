import Foundation
import MonacoApi

// MARK: - JSON Encoding/Decoding Extensions

/// Extension providing convenient JSON encoding for Monaco types
extension Encodable {
    /// Encodes this Monaco type to JSON data
    ///
    /// - Parameter encoder: Optional custom JSONEncoder (uses default if nil)
    /// - Returns: JSON data representation
    /// - Throws: EncodingError if encoding fails
    public func toJSON(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
    
    /// Encodes this Monaco type to a JSON string
    ///
    /// - Parameter encoder: Optional custom JSONEncoder (uses default if nil)
    /// - Returns: JSON string representation
    /// - Throws: EncodingError if encoding fails
    public func toJSONString(encoder: JSONEncoder = JSONEncoder()) throws -> String {
        let data = try toJSON(encoder: encoder)
        guard let string = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(
                self,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert JSON data to UTF-8 string"
                )
            )
        }
        return string
    }
}

/// Extension providing convenient JSON decoding for Monaco types
extension Decodable {
    /// Decodes this Monaco type from JSON data
    ///
    /// - Parameters:
    ///   - data: JSON data to decode
    ///   - decoder: Optional custom JSONDecoder (uses default if nil)
    /// - Returns: Decoded instance
    /// - Throws: DecodingError if decoding fails
    public static func fromJSON(_ data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
    
    /// Decodes this Monaco type from a JSON string
    ///
    /// - Parameters:
    ///   - string: JSON string to decode
    ///   - decoder: Optional custom JSONDecoder (uses default if nil)
    /// - Returns: Decoded instance
    /// - Throws: DecodingError if decoding fails
    public static func fromJSONString(_ string: String, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        guard let data = string.data(using: .utf8) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert string to UTF-8 data"
                )
            )
        }
        return try fromJSON(data, decoder: decoder)
    }
}

// MARK: - Convenience Encoder/Decoder Configurations

extension JSONEncoder {
    /// A JSON encoder configured for Monaco Editor compatibility
    ///
    /// Uses:
    /// - No pretty printing (compact JSON)
    /// - ISO8601 date encoding (if dates are added in future)
    public static let monacoEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    
    /// A pretty-printed JSON encoder for debugging
    public static let prettyMonacoEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
}

extension JSONDecoder {
    /// A JSON decoder configured for Monaco Editor compatibility
    ///
    /// Uses:
    /// - ISO8601 date decoding (if dates are added in future)
    public static let monacoDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

// MARK: - Specific Type Extensions

extension CompletionItem {
    /// Creates a CompletionItem from Monaco's JSON representation
    ///
    /// Example usage:
    /// ```swift
    /// let json = """
    /// {
    ///   "label": "myFunction",
    ///   "kind": 1,
    ///   "insertText": "myFunction()",
    ///   "detail": "void myFunction()"
    /// }
    /// """
    /// let item = try CompletionItem.fromMonacoJSON(json)
    /// ```
    public static func fromMonacoJSON(_ json: String) throws -> CompletionItem {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this CompletionItem to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}

extension Diagnostic {
    /// Creates a Diagnostic from Monaco's JSON representation
    public static func fromMonacoJSON(_ json: String) throws -> Diagnostic {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this Diagnostic to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}

extension Hover {
    /// Creates a Hover from Monaco's JSON representation
    public static func fromMonacoJSON(_ json: String) throws -> Hover {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this Hover to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}

extension DocumentSymbol {
    /// Creates a DocumentSymbol from Monaco's JSON representation
    public static func fromMonacoJSON(_ json: String) throws -> DocumentSymbol {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this DocumentSymbol to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}

extension SignatureHelp {
    /// Creates a SignatureHelp from Monaco's JSON representation
    public static func fromMonacoJSON(_ json: String) throws -> SignatureHelp {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this SignatureHelp to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}

extension CodeAction {
    /// Creates a CodeAction from Monaco's JSON representation
    public static func fromMonacoJSON(_ json: String) throws -> CodeAction {
        return try fromJSONString(json, decoder: .monacoDecoder)
    }
    
    /// Converts this CodeAction to Monaco's JSON format
    public func toMonacoJSON() throws -> String {
        return try toJSONString(encoder: .monacoEncoder)
    }
}
