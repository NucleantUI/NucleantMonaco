import JavaScriptKit
import PySwiftAST
import PyAstVisitors
import PySwiftCodeGen
import PythonASTCore
import MonacoApi

/// WASM wrapper for ASTCore - handles JavaScriptKit integration
public class ASTManager {
    private let core = ASTCore()
    
    #if canImport(JavaScriptKit)
    private var timeoutId: JSValue?
    #endif
    
    public var currentAST: Module? {
        return core.currentAST
    }
    
    /// Parse Python code synchronously (for testing)
    public func parseCodeSync(_ code: String) {
        do {
            try core.parseCode(code)
            log("✅ AST parsed synchronously")
        } catch {
            log("❌ AST parsing error: \(error)")
        }
    }
    
    #if canImport(JavaScriptKit)
    /// Parse Python code with a 1000ms throttle
    public func parseCode(_ code: String) {
        // Cancel any pending timeout
        if let timeoutId = timeoutId, !timeoutId.isUndefined {
            _ = JSObject.global.clearTimeout.function?(timeoutId)
        }
        
        log("⏳ Scheduling AST parse for \(code.count) chars...")
        
        // Schedule parse with JavaScript setTimeout (1000ms delay)
        let parseCallback = JSClosure { [weak self] (_: [JSValue]) -> JSValue in
            self?.performParse(code)
            return JSValue.undefined
        }
        
        timeoutId = JSObject.global.setTimeout.function?(parseCallback.jsValue, 1000.jsValue)
    }
    
    /// Perform the actual parsing
    private func performParse(_ code: String) {
        log("✅ AST parsing initiated for \(code.count) characters")
        
        // Measure parse time
        let start = JSObject.global.performance.now().number ?? 0
        
        do {
            try core.parseCode(code)
            let end = JSObject.global.performance.now().number ?? 0
            let duration = end - start
            
            log("🎯 AST parsed successfully in \(String(format: "%.1f", duration))ms")
            
            // Update performance monitor
            updateParseMonitor(duration: duration)
        } catch {
            log("❌ AST parsing error: \(error)")
        }
    }
    
    /// Update the performance monitor for parsing
    private func updateParseMonitor(duration: Double) {
        // Call into MonacoEditorWasm's PerformanceTracker
        let updateFn = JSObject.global.updateParseMetrics.function
        _ = updateFn?(duration.jsValue)
    }
    #endif
    
    /// Get the current AST (for debugging)
    public func getCurrentAST() -> Module? {
        return core.currentAST
    }
    
    /// Get the type of a variable from the AST with scope awareness
    public func getVariableType(_ name: String, at lineNumber: Int? = nil) -> String? {
        log("🔍 Looking for variable type: \(name) at line \(lineNumber ?? -1)")
        
        if let type = core.getVariableType(name, at: lineNumber) {
            log("    ✅ Found \(name) with type: \(type)")
            return type
        }
        
        log("    ❌ Variable \(name) not found")
        return nil
    }
    
    /// Get the type of an attribute access (e.g., self.method, instance.property)
    public func getAttributeType(object: String, attribute: String, at lineNumber: Int) -> String? {
        log("🔍 Looking for attribute type: \(object).\(attribute) at line \(lineNumber)")
        
        if let type = core.getAttributeType(object: object, attribute: attribute, at: lineNumber) {
            log("    ✅ Found \(object).\(attribute) with type: \(type)")
            return type
        }
        
        log("    ❌ Attribute \(object).\(attribute) not found")
        return nil
    }
    
    /// Check if a variable exists anywhere in the AST
    public func variableExistsAnywhere(_ name: String) -> Bool {
        return core.variableExistsAnywhere(name)
    }
    
    /// Get the type of a class property
    public func getPropertyType(className: String, propertyName: String) -> String? {
        return core.getPropertyType(className: className, propertyName: propertyName)
    }
    
    /// Get class context for a line number
    public func getClassContext(lineNumber: Int) -> String? {
        return core.getClassContext(lineNumber: lineNumber)
    }
    
    /// Get class definition and generated code
    public func getClassDefinition(lineNumber: Int) -> (name: String, code: String)? {
        return core.getClassDefinition(lineNumber: lineNumber)
    }
    
    /// Get class definition by name
    public func getClassDefinitionByName(className: String) -> (name: String, code: String)? {
        return core.getClassDefinitionByName(className)
    }
    
    /// Get global constant value
    public func getGlobalConstant(name: String) -> (type: String, value: String)? {
        return core.getGlobalConstant(name)
    }
    
    /// Get all variables in scope at a line number
    public func getAllVariablesInScope(at lineNumber: Int) -> [String: String] {
        return core.getAllVariablesInScope(at: lineNumber)
    }
    
    /// Get all properties of the class at a line number
    public func getClassProperties(at lineNumber: Int) -> [String: String] {
        return core.getClassProperties(at: lineNumber)
    }
    
    /// Get all methods of the class at a line number
    public func getClassMethods(at lineNumber: Int) -> [String: String] {
        return core.getClassMethods(at: lineNumber)
    }
    
    /// Get method definition from a class
    public func getMethodDefinition(className: String, methodName: String) -> (signature: String, code: String)? {
        return core.getMethodDefinition(className: className, methodName: methodName)
    }
    
    /// Validate code and return diagnostics
    public func validateCode(_ code: String) -> [Diagnostic] {
        var diagnostics: [Diagnostic] = []
        
        // Try to parse and analyze
        do {
            try core.parseCode(code)
            log("✅ Code validated successfully")
        } catch {
            // Syntax error
            let errorMessage = "\(error)"
            let range = IDERange(startLineNumber: 1, startColumn: 1, endLineNumber: 1, endColumn: 1)
            
            diagnostics.append(Diagnostic(
                severity: .error,
                message: "Syntax error: \(errorMessage)",
                range: range,
                source: "PySwiftAST",
                code: "syntax-error"
            ))
            
            log("❌ Syntax error: \(errorMessage)")
        }
        
        // TODO: Add TypeChecker warnings once TypeChecker exposes them
        // Currently TypeChecker doesn't have a public warnings API
        
        return diagnostics
    }
    
    /// Helper for logging
    public func log(_ message: String) {
        #if canImport(JavaScriptKit)
        _ = JSObject.global.console.log(message.jsValue)
        #else
        print(message)
        #endif
    }
}

// Remove global instance - each model has its own
