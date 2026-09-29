import PySwiftAST

/// Represents a scope chain for variable lookup
public struct ScopeChain {
    let localStatements: [PySwiftAST.Statement]  // Current function/method scope
    let classStatements: [PySwiftAST.Statement]? // Enclosing class scope (if any)
    let globalStatements: [PySwiftAST.Statement] // Module-level scope
    let lineNumber: Int? // Line number for finding the most recent assignment
    
    public init(localStatements: [PySwiftAST.Statement], classStatements: [PySwiftAST.Statement]?, globalStatements: [PySwiftAST.Statement], lineNumber: Int? = nil) {
        self.localStatements = localStatements
        self.classStatements = classStatements
        self.globalStatements = globalStatements
        self.lineNumber = lineNumber
    }
    
    /// Search for a variable in the proper scope order: local -> global
    /// (Class scope is NOT searched for local variables - only self.x is accessible)
    public func findVariable(_ name: String) -> String? {
        return findVariableWithVisited(name, visited: Swift.Set<String>())
    }
    
    /// Get all variables in scope (local + global)
    /// Returns a dictionary of variable names to their types
    public func getAllVariables() -> [String: String] {
        var variables: [String: String] = [:]
        
        // Collect global variables first
        collectVariables(from: globalStatements, into: &variables)
        
        // Collect local variables (overrides globals)
        collectVariables(from: localStatements, into: &variables)
        
        return variables
    }
    
    /// Collect all variables from statements
    private func collectVariables(from statements: [PySwiftAST.Statement], into variables: inout [String: String]) {
        for stmt in statements {
            switch stmt {
            case .assign(let assign):
                // Only consider assignments at or before the line number
                if let queryLine = lineNumber, assign.lineno > queryLine {
                    continue
                }
                
                for target in assign.targets {
                    if case let .name(nameExpr) = target {
                        let type = inferTypeFromExpression(assign.value, visited: Swift.Set<String>())
                        variables[nameExpr.id] = type
                    }
                }
            case .annAssign(let annAssign):
                // Only consider assignments at or before the line number
                if let queryLine = lineNumber, annAssign.lineno > queryLine {
                    continue
                }
                
                if case let .name(target) = annAssign.target {
                    variables[target.id] = describeExpression(annAssign.annotation)
                }
            default:
                break
            }
        }
    }
    
    /// Internal search with cycle detection
    private func findVariableWithVisited(_ name: String, visited: Swift.Set<String>) -> String? {
        // Prevent infinite loops when following variable chains
        if visited.contains(name) {
            return nil
        }
        
        var newVisited = visited
        newVisited.insert(name)
        
        // 1. Search local scope first
        if let type = searchStatements(localStatements, for: name, visited: newVisited) {
            return type
        }
        
        // 2. Search global scope
        if let type = searchStatements(globalStatements, for: name, visited: newVisited) {
            return type
        }
        
        return nil
    }
    
    /// Search statements for a variable assignment
    /// If lineNumber is set, finds the most recent assignment at or before that line
    private func searchStatements(_ statements: [PySwiftAST.Statement], for name: String, visited: Swift.Set<String>) -> String? {
        var mostRecentAssignment: (line: Int, type: String)? = nil
        
        for stmt in statements {
            switch stmt {
            case .assign(let assign):
                for target in assign.targets {
                    if case let .name(nameExpr) = target, nameExpr.id == name {
                        // If we have a line number, only consider assignments at or before it
                        if let queryLine = lineNumber {
                            if assign.lineno <= queryLine {
                                let type = inferTypeFromExpression(assign.value, visited: visited)
                                // Keep the most recent (highest line number) assignment
                                if mostRecentAssignment == nil || assign.lineno > mostRecentAssignment!.line {
                                    mostRecentAssignment = (line: assign.lineno, type: type)
                                }
                            }
                        } else {
                            // No line number filtering - return first match
                            return inferTypeFromExpression(assign.value, visited: visited)
                        }
                    }
                }
            case .annAssign(let annAssign):
                if case let .name(target) = annAssign.target, target.id == name {
                    if let queryLine = lineNumber {
                        if annAssign.lineno <= queryLine {
                            let type = describeExpression(annAssign.annotation)
                            if mostRecentAssignment == nil || annAssign.lineno > mostRecentAssignment!.line {
                                mostRecentAssignment = (line: annAssign.lineno, type: type)
                            }
                        }
                    } else {
                        return describeExpression(annAssign.annotation)
                    }
                }
            default:
                break
            }
        }
        
        return mostRecentAssignment?.type
    }
    
    /// Infer type from an expression
    private func inferTypeFromExpression(_ expr: PySwiftAST.Expression, visited: Swift.Set<String>) -> String {
        switch expr {
        case .constant(let constant):
            switch constant.value {
            case .int(_): return "int"
            case .float(_): return "float"
            case .string(_): return "str"
            case .bool(_): return "bool"
            case .none: return "None"
            default: return "Any"
            }
        case .list(let listExpr):
            // Infer element type from list elements
            return inferListType(listExpr.elts, visited: visited)
        case .dict(let dictExpr):
            // Infer key and value types from dict elements
            return inferDictType(keys: dictExpr.keys, values: dictExpr.values, visited: visited)
        case .tuple(let tupleExpr):
            // Infer element type from tuple elements
            return inferTupleType(tupleExpr.elts, visited: visited)
        case .set(let setExpr):
            // Infer element type from set elements
            return inferSetType(setExpr.elts, visited: visited)
        case .subscriptExpr(let subscriptExpr):
            // Infer type from subscript - extract element type from collection
            return inferSubscriptType(subscriptExpr.value, visited: visited)
        case .name(let nameExpr):
            // Use the full scope chain to resolve the variable
            // This ensures we search local -> global in the proper order
            if let type = findVariableWithVisited(nameExpr.id, visited: visited) {
                return type
            }
            return "Any"
        default:
            return "Any"
        }
    }
    
    /// Infer type from subscript expression (e.g., list[0], dict[key])
    private func inferSubscriptType(_ value: PySwiftAST.Expression, visited: Swift.Set<String>) -> String {
        let collectionType = inferTypeFromExpression(value, visited: visited)
        
        // Extract element type from generic collection types
        if collectionType.hasPrefix("list[") {
            // Extract: "list[str]" -> "str"
            let elementType = extractGenericType(from: collectionType, prefix: "list[")
            return elementType
        } else if collectionType.hasPrefix("set[") {
            // Extract: "set[int]" -> "int"
            let elementType = extractGenericType(from: collectionType, prefix: "set[")
            return elementType
        } else if collectionType.hasPrefix("tuple[") {
            // Extract: "tuple[str, ...]" -> "str"
            let elementType = extractGenericType(from: collectionType, prefix: "tuple[")
            // Remove the ", ..." suffix if present
            if elementType.hasSuffix(", ...") {
                let cleaned = String(elementType.dropLast(5))
                return cleaned
            }
            return elementType
        } else if collectionType.hasPrefix("dict[") {
            // Extract: "dict[int, str]" -> "str" (value type)
            let innerTypes = extractGenericType(from: collectionType, prefix: "dict[")
            // Split by comma to get key and value types
            if let commaIndex = innerTypes.firstIndex(of: ",") {
                let valueType = innerTypes[innerTypes.index(after: commaIndex)...].trimmingCharacters(in: .whitespaces)
                return String(valueType)
            }
            return "Any"
        } else if collectionType == "list" {
            return "Any"  // Non-generic list
        } else if collectionType == "dict" {
            return "Any"  // Non-generic dict
        } else if collectionType == "tuple" {
            return "Any"  // Non-generic tuple
        } else if collectionType == "set" {
            return "Any"  // Non-generic set
        } else if collectionType == "str" {
            return "str"  // String indexing returns str
        }
        
        return "Any"
    }
    
    /// Extract the generic type parameter from a type string
    private func extractGenericType(from typeString: String, prefix: String) -> String {
        guard typeString.hasPrefix(prefix), typeString.hasSuffix("]") else {
            return "Any"
        }
        
        let startIndex = typeString.index(typeString.startIndex, offsetBy: prefix.count)
        let endIndex = typeString.index(before: typeString.endIndex)
        
        guard startIndex < endIndex else {
            return "Any"
        }
        
        return String(typeString[startIndex..<endIndex])
    }
    
    /// Infer list type from elements
    private func inferListType(_ elements: [PySwiftAST.Expression], visited: Swift.Set<String>) -> String {
        guard !elements.isEmpty else {
            return "list"
        }
        
        // Get types of all elements
        var elementTypes = Swift.Set<String>()
        for element in elements {
            let elementType = inferTypeFromExpression(element, visited: visited)
            elementTypes.insert(elementType)
        }
        
        // If all elements have the same type, return list[Type]
        if elementTypes.count == 1, let elementType = elementTypes.first {
            return "list[\(elementType)]"
        }
        
        // Mixed types
        return "list"
    }
    
    /// Infer dict type from keys and values
    private func inferDictType(keys: [PySwiftAST.Expression?], values: [PySwiftAST.Expression], visited: Swift.Set<String>) -> String {
        guard !keys.isEmpty, keys.count == values.count else {
            return "dict"
        }
        
        // Get types of all keys and values (skip None keys for dict unpacking)
        var keyTypes = Swift.Set<String>()
        var valueTypes = Swift.Set<String>()
        
        for key in keys {
            guard let key = key else { continue } // Skip None keys (dict unpacking)
            let keyType = inferTypeFromExpression(key, visited: visited)
            keyTypes.insert(keyType)
        }
        
        for value in values {
            let valueType = inferTypeFromExpression(value, visited: visited)
            valueTypes.insert(valueType)
        }
        
        // If all keys and values have consistent types, return dict[KeyType, ValueType]
        if keyTypes.count == 1, valueTypes.count == 1,
           let keyType = keyTypes.first, let valueType = valueTypes.first {
            return "dict[\(keyType), \(valueType)]"
        }
        
        // Mixed types
        return "dict"
    }
    
    /// Infer tuple type from elements
    private func inferTupleType(_ elements: [PySwiftAST.Expression], visited: Swift.Set<String>) -> String {
        guard !elements.isEmpty else {
            return "tuple"
        }
        
        // For tuples, we could show all element types: tuple[int, str, float]
        // But for simplicity, let's check if all are the same type
        var elementTypes = Swift.Set<String>()
        for element in elements {
            let elementType = inferTypeFromExpression(element, visited: visited)
            elementTypes.insert(elementType)
        }
        
        if elementTypes.count == 1, let elementType = elementTypes.first {
            return "tuple[\(elementType), ...]"
        }
        
        return "tuple"
    }
    
    /// Infer set type from elements
    private func inferSetType(_ elements: [PySwiftAST.Expression], visited: Swift.Set<String>) -> String {
        guard !elements.isEmpty else {
            return "set"
        }
        
        var elementTypes = Swift.Set<String>()
        for element in elements {
            let elementType = inferTypeFromExpression(element, visited: visited)
            elementTypes.insert(elementType)
        }
        
        if elementTypes.count == 1, let elementType = elementTypes.first {
            return "set[\(elementType)]"
        }
        
        return "set"
    }
    
    /// Describe an annotation expression
    private func describeExpression(_ expr: PySwiftAST.Expression) -> String {
        if case let .name(name) = expr {
            return name.id
        }
        return "Any"
    }
}
