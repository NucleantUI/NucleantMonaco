import PySwiftAST
import PySwiftCodeGen
import PyChecking

/// Core AST analysis without JavaScriptKit dependencies
/// Now delegates to TypeChecker for all analysis instead of duplicating logic
public class ASTCore {
    public private(set) var currentAST: Module?
    private var typeChecker: TypeChecker?
    
    /// Last parsing error (for diagnostics)
    public private(set) var lastParseError: Error?
    
    public init() {}
    
    /// Parse Python code synchronously
    /// - Parameter code: The Python source code
    public func parseCode(_ code: String) throws {
        lastParseError = nil
        
        do {
            let module: Module = try parsePython(code)
            currentAST = module
            
            // Run type checker to perform analysis once
            let checker = TypeChecker()
            _ = checker.check(module)
            self.typeChecker = checker
        } catch {
            lastParseError = error
            throw error
        }
    }
    
    /// Access to TypeChecker for diagnostics (warnings)
    public var checker: TypeChecker? {
        return typeChecker
    }
    
    /// Get the type of a variable from the AST with scope awareness
    /// - Parameters:
    ///   - name: Variable name to look up
    ///   - lineNumber: Line number where the variable is referenced (for scope determination)
    /// - Returns: Type information string if found
    public func getVariableType(_ name: String, at lineNumber: Int?) -> String? {
        guard let checker = typeChecker else { return nil }
        
        // Query TypeChecker instead of re-analyzing
        return checker.getTypeAt(name: name, line: lineNumber ?? 0, column: 0)?.toDisplayString()
    }
    
    /// Get the type of an attribute access (e.g., self.method, instance.property)
    /// - Parameters:
    ///   - object: Object name (e.g., "self", "this", "instance")
    ///   - attribute: Attribute name (e.g., "method", "property")
    ///   - lineNumber: Line number for context
    /// - Returns: Type information string if found
    public func getAttributeType(object: String, attribute: String, at lineNumber: Int) -> String? {
        guard let checker = typeChecker else { return nil }
        
        return checker.getAttributeTypeString(object: object, attribute: attribute, line: lineNumber, column: 0)
    }
    
    /// Check if a variable exists anywhere in the AST (ignoring scope)
    /// - Parameter name: Variable name to look up
    /// - Returns: True if the variable exists anywhere, false otherwise
    public func variableExistsAnywhere(_ name: String) -> Bool {
        guard let checker = typeChecker else { return false }
        
        // Check if variable exists at any scope level
        return checker.getTypeAt(name: name, line: 999999, column: 0) != nil
    }
    
    /// Get the type of a class property
    /// - Parameters:
    ///   - className: Name of the class
    ///   - propertyName: Name of the property
    /// - Returns: Type information string if found
    public func getPropertyType(className: String, propertyName: String) -> String? {
        guard let checker = typeChecker else { return nil }
        
        // Query TypeChecker for class member
        return checker.getPropertyType(className: className, propertyName: propertyName)
    }
    
    /// Get class context for a line number
    /// - Parameter lineNumber: Line number (1-indexed)
    /// - Returns: Class name if the line is inside a class definition
    public func getClassContext(lineNumber: Int) -> String? {
        guard let checker = typeChecker else {
            return nil
        }
        
        // Use TypeChecker.getScopeAt() (now fully implemented in PySwiftAST)
        if let scope = checker.getScopeAt(line: lineNumber, column: 0) {
            // If we're directly in a class scope, return it
            if case .classScope = scope.kind {
                return scope.name
            }
            
            // If we're in a function scope, check if it's a method inside a class
            // by looking at the AST structure
            if case .function = scope.kind {
                // Walk the AST to find if this line is inside a class
                guard case let .module(statements) = currentAST else {
                    return nil
                }
                
                for statement in statements {
                    if case let .classDef(classDef) = statement {
                        // PySwiftAST now correctly sets endLineno (commit c6a75cf)
                        let classEndLine = classDef.endLineno ?? classDef.lineno
                        
                        if lineNumber >= classDef.lineno && lineNumber <= classEndLine {
                            return classDef.name
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    // Debug helper for ASTManager to log scope info
    public func getDebugScopeInfo(lineNumber: Int) -> String {
        guard let checker = typeChecker else {
            return "No typeChecker"
        }
        
        guard let scope = checker.getScopeAt(line: lineNumber, column: 0) else {
            return "getScopeAt returned nil"
        }
        
        let scopeName = scope.name ?? "unnamed"
        var info = "Scope: kind=\(scope.kind), name=\(scopeName), lines=\(scope.startLine)-\(scope.endLine)"
        
        // Also check what classes exist in AST
        if case let .module(statements) = currentAST {
            info += " | AST has \(statements.count) statements"
            for statement in statements {
                if case let .classDef(classDef) = statement {
                    let endLine = classDef.endLineno ?? classDef.lineno
                    info += " | Class '\(classDef.name)' at lines \(classDef.lineno)-\(endLine)"
                }
            }
        }
        
        return info
    }
    
    /// Get class definition and generated code
    /// - Parameter lineNumber: Line number (1-indexed)
    /// - Returns: Tuple of (className, generatedCode) if found
    public func getClassDefinition(lineNumber: Int) -> (name: String, code: String)? {
        guard let checker = typeChecker,
              case let .module(statements) = currentAST else {
            return nil
        }
        
        // Use TypeChecker.getScopeAt() (now fully implemented in PySwiftAST)
        if let scope = checker.getScopeAt(line: lineNumber, column: 0),
           case .classScope = scope.kind,
           let className = scope.name {
            
            if let classDef = findClassByName(className, in: statements) {
                let statement = Statement.classDef(classDef)
                let context = CodeGenContext(indentLevel: 0, indentSize: 4)
                let code = statement.toPythonCode(context: context)
                return (name: className, code: code)
            }
        }
        
        return nil
    }
    
    /// Get class definition by name
    /// - Parameter className: Name of the class
    /// - Returns: Tuple of (className, generatedCode) if found
    public func getClassDefinitionByName(_ className: String) -> (name: String, code: String)? {
        guard case let .module(statements) = currentAST else {
            return nil
        }
        
        if let classDef = findClassByName(className, in: statements) {
            let statement = Statement.classDef(classDef)
            let context = CodeGenContext(indentLevel: 0, indentSize: 4)
            let code = statement.toPythonCode(context: context)
            return (name: className, code: code)
        }
        
        return nil
    }
    
    /// Helper to find a class by name
    private func findClassByName(_ name: String, in statements: [Statement]) -> ClassDef? {
        for statement in statements {
            if case let .classDef(classDef) = statement, classDef.name == name {
                return classDef
            }
            // Check nested classes
            if case let .classDef(classDef) = statement,
               let nested = findClassByName(name, in: classDef.body) {
                return nested
            }
            if case let .functionDef(funcDef) = statement,
               let nested = findClassByName(name, in: funcDef.body) {
                return nested
            }
        }
        return nil
    }
    
    /// Get all variables in scope at a given line number
    /// - Parameter lineNumber: Line number to check scope
    /// - Returns: Dictionary of variable names to their types
    public func getAllVariablesInScope(at lineNumber: Int) -> [String: String] {
        guard let checker = typeChecker else { return [:] }
        
        // Query TypeChecker for all symbols at this line
        let symbols = checker.getSymbolsAt(line: lineNumber, column: 0)
        var result: [String: String] = [:]
        for (name, type) in symbols {
            result[name] = type.toDisplayString()
        }
        return result
    }
    
    /// Get all properties of the class at a given line number
    /// - Parameter lineNumber: Line number inside a class
    /// - Returns: Dictionary of property names to their types
    public func getClassProperties(at lineNumber: Int) -> [String: String] {
        guard let checker = typeChecker else { return [:] }
        
        // Query TypeChecker - it returns [String: String] directly
        return checker.getClassProperties(at: lineNumber)
    }
    
    /// Get all methods of the class at a given line number
    /// - Parameter lineNumber: Line number inside a class
    /// - Returns: Dictionary of method names to their signatures
    public func getClassMethods(at lineNumber: Int) -> [String: String] {
        guard let checker = typeChecker,
              let className = checker.getClassContext(lineNumber: lineNumber) else {
            return [:]
        }
        
        let members = checker.getClassMembers(className: className)
        var methods: [String: String] = [:]
        for member in members where member.kind == .method {
            methods[member.name] = member.type.toDisplayString()
        }
        return methods
    }
    
    /// Get method definition from a class
    /// - Parameters:
    ///   - className: Name of the class
    ///   - methodName: Name of the method
    /// - Returns: Tuple of (signature, code) if found
    public func getMethodDefinition(className: String, methodName: String) -> (signature: String, code: String)? {
        guard case let .module(statements) = currentAST,
              let classDef = findClassByName(className, in: statements) else {
            return nil
        }
        
        // Find the method in the class body
        for statement in classDef.body {
            if case let .functionDef(funcDef) = statement, funcDef.name == methodName {
                // Use PySwiftCodeGen's built-in code generation
                let context = CodeGenContext(indentLevel: 0, indentSize: 4)
                let signature = generateFunctionSignature(funcDef, context: context)
                let code = statement.toPythonCode(context: context)
                return (signature: signature, code: code)
            }
        }
        
        return nil
    }
    
    /// Generate a function signature string (just the def line, no body)
    private func generateFunctionSignature(_ funcDef: FunctionDef, context: CodeGenContext) -> String {
        var signature = "def \(funcDef.name)("
        signature += funcDef.args.toPythonCode(context: context)
        signature += ")"
        
        if let returns = funcDef.returns {
            signature += " -> " + returns.toPythonCode(context: context)
        }
        
        return signature + ":"
    }
    
    /// Get global constant value by name
    /// - Parameter name: Name of the global constant
    /// - Returns: Tuple of (type, value) if found
    public func getGlobalConstant(_ name: String) -> (type: String, value: String)? {
        guard case let .module(statements) = currentAST else {
            return nil
        }
        
        // Look for top-level assignments
        for statement in statements {
            if case let .assign(assign) = statement {
                // Check if any target matches the name
                for target in assign.targets {
                    if case let .name(nameExpr) = target, nameExpr.id == name {
                        // Use PySwiftCodeGen's built-in expression code generation
                        let context = CodeGenContext(indentLevel: 0, indentSize: 4)
                        let valueCode = assign.value.toPythonCode(context: context)
                        
                        // Try to get type from TypeChecker
                        if let checker = typeChecker,
                           let type = checker.getTypeAt(name: name, line: assign.lineno, column: 0) {
                            return (type: type.toDisplayString(), value: valueCode)
                        }
                        
                        // Fallback: infer type from value
                        let inferredType = inferTypeFromExpression(assign.value)
                        return (type: inferredType, value: valueCode)
                    }
                }
            }
        }
        
        return nil
    }
    
    /// Infer type from expression (simple cases)
    private func inferTypeFromExpression(_ expr: PySwiftAST.Expression) -> String {
        switch expr {
        case .constant(let constant):
            switch constant.value {
            case .int: return "int"
            case .float: return "float"
            case .string: return "str"
            case .bool: return "bool"
            case .none: return "None"
            default: return "Any"
            }
        case .list:
            return "list"
        case .dict:
            return "dict"
        case .set:
            return "set"
        case .tuple:
            return "tuple"
        default:
            return "Any"
        }
    }
}
