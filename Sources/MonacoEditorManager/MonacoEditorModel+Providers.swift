import JavaScriptKit
import MonacoApi
import MonacoJSK
import Foundation

extension MonacoEditorModel {
    
    // MARK: - Completion Provider
    
    /// Register completion provider for this model
    public func registerCompletionProvider(manager: MonacoEditorManager) {
        let provider = JSObject()
        
        let triggerChars: JSValue = [".", ":"].jsValue
        provider.triggerCharacters = triggerChars
        
        let provideCompletions = JSClosure { [weak self] (args: [JSValue]) -> JSValue in
            guard let self = self else { return JSObject().jsValue }
            return self.provideCompletions(args: args)
        }
        
        provider.provideCompletionItems = provideCompletions.jsValue
        manager.registerCompletionProvider(for: self.id, languageId: "python", provider: provider)
    }
    
    internal func provideCompletions(args: [JSValue]) -> JSValue {
        guard args.count >= 2 else { return JSObject().jsValue }
        
        guard let model = args[0].object,
              let position = args[1].object else {
            return JSObject().jsValue
        }
        
        guard let lineNumber = position.lineNumber.number,
              let column = position.column.number else {
            return JSObject().jsValue
        }
        
        let lineNum = Int(lineNumber)
        let colNum = Int(column)
        
        let lineContent = model.getLineContent!(JSValue(integerLiteral: Int32(lineNumber)))
        guard let lineText = lineContent.string else {
            return JSObject().jsValue
        }
        
        let beforeCursor = String(lineText.prefix(colNum - 1))
        
        // Check for attribute access
        if let dotMatch = beforeCursor.range(of: #"(\w+)\.\s*$"#, options: .regularExpression) {
            let objectName = String(beforeCursor[dotMatch]).replacingOccurrences(of: ".", with: "").trimmingCharacters(in: .whitespaces)
            return provideAttributeCompletions(objectName: objectName, lineNumber: lineNum)
        }
        
        var suggestions: [CompletionItem] = []
        
        // Variables
        let variables = astManager.getAllVariablesInScope(at: lineNum)
        for (name, type) in variables {
            suggestions.append(CompletionItem(
                label: "\(name): \(type)",
                labelDetails: nil,
                kind: .variable,
                tags: nil,
                detail: type,
                documentation: .plainText("Variable of type \(type)"),
                insertText: name,
                insertTextFormat: nil,
                insertTextRules: nil,
                range: nil,
                additionalTextEdits: nil,
                command: nil,
                commitCharacters: nil,
                sortText: "1_\(name)",
                filterText: nil,
                preselect: nil,
                keepWhitespace: nil
            ))
        }
        
        // Properties
        let properties = astManager.getClassProperties(at: lineNum)
        for (name, type) in properties {
            suggestions.append(CompletionItem(
                label: "\(name): \(type)",
                labelDetails: nil,
                kind: .property,
                tags: nil,
                detail: type,
                documentation: .plainText("Property of type \(type)"),
                insertText: "\(name)",
                insertTextFormat: nil,
                insertTextRules: nil,
                range: nil,
                additionalTextEdits: nil,
                command: nil,
                commitCharacters: nil,
                sortText: "2_\(name)",
                filterText: nil,
                preselect: nil,
                keepWhitespace: nil
            ))
        }
        
        // Methods
        let methods = astManager.getClassMethods(at: lineNum)
        for (name, signature) in methods {
            suggestions.append(CompletionItem(
                label: "\(name)",
                labelDetails: nil,
                kind: .method,
                tags: nil,
                detail: signature,
                documentation: .plainText("Method: \(signature)"),
                insertText: "\(name)",
                insertTextFormat: nil,
                insertTextRules: nil,
                range: nil,
                additionalTextEdits: nil,
                command: nil,
                commitCharacters: nil,
                sortText: "3_\(name)",
                filterText: nil,
                preselect: nil,
                keepWhitespace: nil
            ))
        }
        
        // Snippets
        suggestions.append(CompletionItem(
            label: "def my_function():",
            labelDetails: nil,
            kind: .function,
            tags: nil,
            detail: "Python Function",
            documentation: .markdown(MarkdownString(
                value: "Creates a new Python function",
                isTrusted: nil,
                supportHtml: nil,
                baseUri: nil
            )),
            insertText: "def ${1:my_function}(${2:parameters}):\n    ${3:pass}",
            insertTextFormat: .snippet,
            insertTextRules: .insertAsSnippet,
            range: nil,
            additionalTextEdits: nil,
            command: nil,
            commitCharacters: nil,
            sortText: "9_def",
            filterText: nil,
            preselect: nil,
            keepWhitespace: nil
        ))
        
        suggestions.append(CompletionItem(
            label: "class MyClass:",
            labelDetails: nil,
            kind: .class,
            tags: nil,
            detail: "Python Class",
            documentation: .plainText("Creates a new Python class"),
            insertText: "class ${1:MyClass}:\n    def __init__(self):\n        ${2:pass}",
            insertTextFormat: .snippet,
            insertTextRules: .insertAsSnippet,
            range: nil,
            additionalTextEdits: nil,
            command: nil,
            commitCharacters: nil,
            sortText: nil,
            filterText: nil,
            preselect: nil,
            keepWhitespace: nil
        ))
        
        suggestions.append(CompletionItem(
            label: "for item in items:",
            labelDetails: nil,
            kind: .keyword,
            tags: nil,
            detail: "Python For Loop",
            documentation: .markdown(MarkdownString(
                value: "Creates a Python for loop",
                isTrusted: nil,
                supportHtml: nil,
                baseUri: nil
            )),
            insertText: "for ${1:item} in ${2:items}:\n    ${3:pass}",
            insertTextFormat: .snippet,
            insertTextRules: .insertAsSnippet,
            range: nil,
            additionalTextEdits: nil,
            command: nil,
            commitCharacters: nil,
            sortText: nil,
            filterText: nil,
            preselect: nil,
            keepWhitespace: nil
        ))
        
        let completionList = CompletionList(
            suggestions: suggestions,
            incomplete: false,
            dispose: nil
        )
        
        return completionList.jsValue
    }
    
    private func provideAttributeCompletions(objectName: String, lineNumber: Int) -> JSValue {
        var suggestions: [CompletionItem] = []
        
        if ["self", "this", "me", "cls"].contains(objectName) {
            let methods = astManager.getClassMethods(at: lineNumber)
            for (name, signature) in methods {
                let returnType = astManager.getAttributeType(object: objectName, attribute: name, at: lineNumber) ?? "Any"
                
                suggestions.append(CompletionItem(
                    label: name,
                    labelDetails: nil,
                    kind: .method,
                    tags: nil,
                    detail: "→ \(returnType)",
                    documentation: .plainText("Method: \(signature)"),
                    insertText: name,
                    insertTextFormat: nil,
                    insertTextRules: nil,
                    range: nil,
                    additionalTextEdits: nil,
                    command: nil,
                    commitCharacters: nil,
                    sortText: "1_\(name)",
                    filterText: nil,
                    preselect: nil,
                    keepWhitespace: nil
                ))
            }
            
            let properties = astManager.getClassProperties(at: lineNumber)
            for (name, type) in properties {
                suggestions.append(CompletionItem(
                    label: name,
                    labelDetails: nil,
                    kind: .property,
                    tags: nil,
                    detail: type,
                    documentation: .plainText("Property of type \(type)"),
                    insertText: name,
                    insertTextFormat: nil,
                    insertTextRules: nil,
                    range: nil,
                    additionalTextEdits: nil,
                    command: nil,
                    commitCharacters: nil,
                    sortText: "2_\(name)",
                    filterText: nil,
                    preselect: nil,
                    keepWhitespace: nil
                ))
            }
        }
        
        let completionList = CompletionList(
            suggestions: suggestions,
            incomplete: false,
            dispose: nil
        )
        
        return completionList.jsValue
    }
    
    // MARK: - Hover Provider
    
    /// Register hover provider for this model
    public func registerHoverProvider(manager: MonacoEditorManager) {
        let provider = JSObject()
        
        let provideHover = JSClosure { [weak self] (args: [JSValue]) -> JSValue in
            guard let self = self else { return JSValue.null }
            return self.provideHover(args: args)
        }
        
        provider.provideHover = provideHover.jsValue
        manager.registerHoverProvider(for: self.id, languageId: "python", provider: provider)
    }
    
    internal func provideHover(args: [JSValue]) -> JSValue {
        guard args.count >= 2 else { return JSValue.null }
        
        guard let model = args[0].object,
              let position = args[1].object else {
            return JSValue.null
        }
        
        guard let lineNumber = position.lineNumber.number else {
            return JSValue.null
        }
        
        let lineContent = model.getLineContent!(lineNumber.jsValue)
        guard let lineText = lineContent.string else {
            return JSValue.null
        }
        
        let wordAtPosition = model.getWordAtPosition!(position)
        
        guard !wordAtPosition.isNull,
              let wordObj = wordAtPosition.object,
              let word = wordObj.word.string else {
            return JSValue.null
        }
        
        // Check if inside string literal
        if let column = position.column.number {
            let columnIndex = Int(column) - 1
            if isInsideStringLiteral(line: lineText, column: columnIndex) {
                let doc = "**\"\(word)\"**\n\n`str` literal"
                let hover = Hover(
                    contents: [
                        .markdown(MarkdownString(
                            value: doc,
                            isTrusted: nil,
                            supportHtml: nil,
                            baseUri: nil
                        ))
                    ],
                    range: nil
                )
                return hover.jsValue
            }
        }
        
        let lineNum = Int(lineNumber)
        
        // Try to get documentation
        let documentation = getDocumentation(word: word, lineText: lineText, lineNumber: lineNum, model: model)
        
        guard let doc = documentation else {
            return JSValue.null
        }
        
        let hover = Hover(
            contents: [
                .markdown(MarkdownString(
                    value: doc,
                    isTrusted: nil,
                    supportHtml: nil,
                    baseUri: nil
                ))
            ],
            range: nil
        )
        
        return hover.jsValue
    }
    
    private func getDocumentation(word: String, lineText: String, lineNumber: Int, model: JSObject) -> String? {
        // Class name check
        if let classInfo = astManager.getClassDefinitionByName(className: word) {
            return "*class* **\(word)**\n\n```python\n\(classInfo.code)\n```"
        }
        
        // Attribute access pattern
        let attributePattern = "(\\w+)\\.\(word)(?=\\(|\\s|$|\\))"
        if let match = lineText.range(of: attributePattern, options: .regularExpression) {
            let matchedText = String(lineText[match])
            if let dotIndex = matchedText.firstIndex(of: ".") {
                let objectName = String(matchedText[..<dotIndex])
                
                if let attrType = astManager.getAttributeType(object: objectName, attribute: word, at: lineNumber) {
                    if let className = astManager.getClassContext(lineNumber: lineNumber) {
                        if let methodDef = astManager.getMethodDefinition(className: className, methodName: word) {
                            return "*method* **\(word)** → `\(attrType)`\n\n```python\n\(methodDef.code)\n```"
                        }
                    }
                    
                    let methods = astManager.getClassMethods(at: lineNumber)
                    if methods.keys.contains(word) {
                        if let className = astManager.getClassContext(lineNumber: lineNumber) {
                            if let methodDef = astManager.getMethodDefinition(className: className, methodName: word) {
                                return "*method* **\(word)** → `\(attrType)`\n\n```python\n\(methodDef.code)\n```"
                            }
                        }
                        let signature = methods[word] ?? "(...)"
                        return "*method* **\(word)** → `\(attrType)`\n\n```python\n\(signature)\n```"
                    }
                    
                    return "**\(word)**: `\(attrType)`\n\nAttribute of `\(objectName)`"
                }
            }
        }
        
        // Variable type
        if let variableType = astManager.getVariableType(word, at: lineNumber) {
            if let classInfo = astManager.getClassDefinition(lineNumber: lineNumber) {
                if variableType == classInfo.name {
                    return "**\(word)**: `\(classInfo.name)`\n\nRefers to the current instance of the `\(classInfo.name)` class.\n\n```python\n\(classInfo.code)\n```"
                }
                if variableType.starts(with: "type[") {
                    return "**\(word)**: `\(variableType)`\n\nRefers to the class `\(classInfo.name)` itself. Used in class methods.\n\n```python\n\(classInfo.code)\n```"
                }
            }
            
            if let constant = astManager.getGlobalConstant(name: word) {
                return "**\(word)**: `\(constant.type)` = `\(constant.value)`\n\nGlobal constant"
            }
            
            return "**\(word)**: `\(variableType)`"
        }
        
        // Check for Python keywords and built-ins
        if isPythonKeywordOrBuiltin(word) {
            return getKeywordDocumentation(word)
        }
        
        // Try type inference for user-defined names (fallback)
        if let typeInfo = TypeInference.inferType(name: word, lineText: lineText, model: model, lineNumber: lineNumber, astManager: astManager) {
            return typeInfo
        }
        
        return nil
    }
    
    private func isInsideStringLiteral(line: String, column: Int) -> Bool {
        var inSingleQuote = false
        var inDoubleQuote = false
        var inTripleSingle = false
        var inTripleDouble = false
        var escaped = false
        
        for (index, char) in line.enumerated() {
            if index >= column {
                break
            }
            
            if escaped {
                escaped = false
                continue
            }
            
            if char == "\\" {
                escaped = true
                continue
            }
            
            if index + 2 < line.count {
                let threeChars = String(line[line.index(line.startIndex, offsetBy: index)...line.index(line.startIndex, offsetBy: index + 2)])
                
                if threeChars == "\"\"\"" {
                    if !inSingleQuote && !inTripleSingle {
                        inTripleDouble.toggle()
                        continue
                    }
                } else if threeChars == "'''" {
                    if !inDoubleQuote && !inTripleDouble {
                        inTripleSingle.toggle()
                        continue
                    }
                }
            }
            
            if !inTripleDouble && !inTripleSingle {
                if char == "\"" && !inSingleQuote {
                    inDoubleQuote.toggle()
                } else if char == "'" && !inDoubleQuote {
                    inSingleQuote.toggle()
                }
            }
        }
        
        return inSingleQuote || inDoubleQuote || inTripleSingle || inTripleDouble
    }
    
    // MARK: - Diagnostics Provider
    
    /// Register diagnostics provider for this model
    public func registerDiagnostics(manager: MonacoEditorManager) {
        manager.registerDiagnostics(for: self.id) { [weak self] code in
            guard let self = self else { return [] }
            
            let diagnostics = self.astManager.validateCode(code)
            
            var markers: [JSValue] = []
            for diagnostic in diagnostics {
                let marker = JSObject()
                marker.severity = diagnostic.severity.rawValue.jsValue
                marker.message = diagnostic.message.jsValue
                marker.startLineNumber = diagnostic.range.startLineNumber.jsValue
                marker.startColumn = diagnostic.range.startColumn.jsValue
                marker.endLineNumber = diagnostic.range.endLineNumber.jsValue
                marker.endColumn = diagnostic.range.endColumn.jsValue
                
                if let source = diagnostic.source {
                    marker.source = source.jsValue
                }
                
                if let code = diagnostic.code {
                    marker.code = code.jsValue
                }
                
                markers.append(marker.jsValue)
            }
            
            return markers
        }
    }
}
