import JavaScriptKit
import MonacoApi

nonisolated(unsafe) fileprivate var typesDB: [String: String] = [
    "property": "str"
]

/// Simple type inference for Python properties
public struct TypeInference {
    
    /// Infer the type of a variable or property based on its assignment in the document
    /// - Parameters:
    ///   - name: The name of the variable/property (e.g., "a" or "property")
    ///   - lineText: The current line text where the hover is
    ///   - model: The Monaco editor model
    ///   - lineNumber: The line number where the variable is referenced (for scope-aware lookup)
    ///   - astManager: The ASTManager instance to use for type lookups
    /// - Returns: A documentation string with inferred type, or nil if not found
    public static func inferType(name: String, lineText: String, model: JSObject, lineNumber: Int, astManager: ASTManager) -> String? {
        // Handle 'self' specially - don't treat it as a class property
        if name == "self" {
            // This is handled in the hover provider, return nil so it falls through
            return nil
        }
        
        // Check if we're in a class context and this might be a class-level annotation
        if let className = astManager.getClassContext(lineNumber: lineNumber) {
            // Check if line has instance.name pattern (self.make, this.make, etc.)
            // Pattern matches: word.name where name can be followed by ( or whitespace or end of line
            let instancePattern = "\\w+\\.\\(name)(?=\\(|\\s|$)"
            let hasInstanceAccess = lineText.range(of: instancePattern, options: .regularExpression) != nil
            
            // If accessing via instance, prioritize method lookup
            if hasInstanceAccess {
                // First, check if this name is a method in the current class
                if let methodDef = astManager.getMethodDefinition(className: className, methodName: name) {
                    return "**\(name)** *method*\n\n```python\n\(methodDef.code)\n```"
                }
            } else {
                // Not instance access, check properties first
                let properties = astManager.getClassProperties(at: lineNumber)
                if let propertyType = properties[name] {
                    return "**\(name)**: `\(propertyType)`\n\n(class annotation) Field type in class `\(className)`"
                }
                
                // Then check methods
                if let methodDef = astManager.getMethodDefinition(className: className, methodName: name) {
                    return "**\(name)** *method*\n\n```python\n\(methodDef.code)\n```"
                }
            }
        }
        
        // Try AST-based type inference for self.property
        if lineText.contains("self.\(name)") {
            // Get class context for proper property lookup
            if let className = astManager.getClassContext(lineNumber: lineNumber) {
                if let astType = astManager.getPropertyType(className: className, propertyName: name) {
                    return "**\(name)**: `\(astType)`\n\nProperty type in class `\(className)`"
                }
            }
            // Fall back to string-based inference
            return inferPropertyType(propertyName: name, model: model, astManager: astManager)
        }
        
        // Try AST for variable types with scope awareness
        let astResult = astManager.getVariableType(name, at: lineNumber)
        
        // Check if it's specifically a scope issue (variable exists but not in current scope)
        if astResult == nil {
            if astManager.variableExistsAnywhere(name) {
                // Variable exists elsewhere but not in this scope
                return "**\(name)** not found in scope\n\nThis variable is defined in another function or scope and is not accessible here."
            }
        }
        
        if let astType = astResult {
            return "**\(name)**: `\(astType)`"
        }
        
        // Fall back to string-based inference for variables
        return inferVariableType(variableName: name, model: model, astManager: astManager)
    }
    
    /// Infer the type of a variable by tracing its assignment
    /// - Parameters:
    ///   - variableName: The name of the variable (e.g., "a")
    ///   - model: The Monaco editor model
    ///   - astManager: The ASTManager instance to use for type lookups
    /// - Returns: A documentation string with inferred type, or nil if not found
    static func inferVariableType(variableName: String, model: JSObject, astManager: ASTManager) -> String? {
        let lineCountValue = model.getLineCount!()
        guard let lineCountNum = lineCountValue.number else {
            return nil
        }
        
        let lineCount = Int(lineCountNum)
        
        // Search for assignment to this variable
        for i in 1...lineCount {
            let content = model.getLineContent!(JSValue(integerLiteral: Int32(i)))
            guard let contentStr = content.string else {
                continue
            }
            
            // Look for: a = self.property or a = "value" or a = 123, etc.
            if contentStr.contains("\(variableName) =") || contentStr.contains("\(variableName)=") {
                // Extract the value after =
                if let assignmentPart = contentStr.split(separator: "=").last {
                    var value = String(assignmentPart)
                    
                    // Manual trim
                    while value.hasPrefix(" ") || value.hasPrefix("\t") {
                        value = String(value.dropFirst())
                    }
                    while value.hasSuffix(" ") || value.hasSuffix("\t") {
                        value = String(value.dropLast())
                    }
                    
                    // Check if it's assigned from a property (self.something)
                    if value.hasPrefix("self.") {
                        let propertyName = String(value.dropFirst(5)) // Remove "self."
                        // Look up the property type
                        if let propertyType = inferPropertyType(propertyName: propertyName, model: model, astManager: astManager) {
                            // Extract just the type (e.g., "str") from the property type string
                            // Format: "**property**: `str`\n\nString property"
                            if let typeStart = propertyType.firstIndex(of: "`"),
                               let typeEnd = propertyType[propertyType.index(after: typeStart)...].firstIndex(of: "`") {
                                let typeStr = String(propertyType[propertyType.index(after: typeStart)..<typeEnd])
                                let description = propertyType.split(separator: "\n").last.map(String.init) ?? "Variable"
                                return "**\(variableName)**: `\(typeStr)`\n\n\(description)"
                            }
                        }
                    }
                    
                    // Otherwise infer from the literal value
                    return inferTypeFromValue(value, propertyName: variableName)
                }
            }
        }
        
        return nil
    }
    
    /// Infer the type of a property based on its assignment in the document
    /// - Parameters:
    ///   - propertyName: The name of the property (e.g., "property")
    ///   - model: The Monaco editor model
    ///   - astManager: The ASTManager instance to use for type lookups
    /// - Returns: A documentation string with inferred type, or nil if not found
    static func inferPropertyType(propertyName: String, model: JSObject, astManager: ASTManager) -> String? {
        // Get the total line count
        let lineCountValue = model.getLineCount!()
        guard let lineCountNum = lineCountValue.number else {
            return nil
        }
        
        let lineCount = Int(lineCountNum)
        
        // Search for assignment to this property
        for i in 1...lineCount {
            let content = model.getLineContent!(JSValue(integerLiteral: Int32(i)))
            guard let contentStr = content.string else {
                continue
            }
            
            // Look for self.property = "value" or self.property = 123, etc.
            if contentStr.contains("self.\(propertyName)") && contentStr.contains("=") {
                // Extract the value after =
                if let assignmentPart = contentStr.split(separator: "=").last {
                    var value = String(assignmentPart)
                    
                    // Manual trim (Foundation-free)
                    while value.hasPrefix(" ") || value.hasPrefix("\t") {
                        value = String(value.dropFirst())
                    }
                    while value.hasSuffix(" ") || value.hasSuffix("\t") {
                        value = String(value.dropLast())
                    }
                    
                    // Infer type from value
                    return inferTypeFromValue(value, propertyName: propertyName)
                }
            }
        }
        
        return nil
    }
    
    /// Infer Python type from the assigned value
    /// - Parameters:
    ///   - value: The assigned value as a string
    ///   - propertyName: The property name for documentation
    /// - Returns: Documentation string with type annotation
    private static func inferTypeFromValue(_ value: String, propertyName: String) -> String {
        if value.hasPrefix("\"") || value.hasPrefix("'") {
            return "**\(propertyName)**: `str`\n\nString property"
        } else if value.hasPrefix("[") {
            return "**\(propertyName)**: `list`\n\nList property"
        } else if value.hasPrefix("{") {
            return "**\(propertyName)**: `dict`\n\nDictionary property"
        } else if Int(value.split(separator: ".").first ?? "") != nil {
            if value.contains(".") {
                return "**\(propertyName)**: `float`\n\nFloat property"
            } else {
                return "**\(propertyName)**: `int`\n\nInteger property"
            }
        } else if value == "True" || value == "False" {
            return "**\(propertyName)**: `bool`\n\nBoolean property"
        } else if value == "None" {
            return "**\(propertyName)**: `None`\n\nNone value"
        } else {
            return "**\(propertyName)**\n\nInstance property"
        }
    }
}
