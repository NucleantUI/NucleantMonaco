import Foundation

// MARK: - Python Keywords and Built-ins

/// Python keywords and built-in functions for quick lookup
/// Stored as a Set for O(1) lookup performance
public let pythonKeywords: Set<String> = [
    // Keywords
    "and", "as", "assert", "async", "await", "break", "class", "continue",
    "def", "del", "elif", "else", "except", "finally", "for", "from",
    "global", "if", "import", "in", "is", "lambda", "nonlocal", "not",
    "or", "pass", "raise", "return", "try", "while", "with", "yield",
    // Built-in functions
    "print", "len", "range", "str", "int", "float", "list", "dict",
    "set", "tuple", "bool", "type", "isinstance", "hasattr", "getattr",
    "setattr", "dir", "help", "open", "input", "sorted", "sum", "min",
    "max", "abs", "all", "any", "enumerate", "zip", "map", "filter",
    // Special methods and parameters
    "self", "cls", "__init__", "__str__", "__repr__", "__len__", "__call__",
    "__iter__", "__next__", "__enter__", "__exit__", "__getitem__", "__setitem__",
    // Constants
    "True", "False", "None"
]

/// Check if a word is a Python keyword or built-in
public func isPythonKeywordOrBuiltin(_ word: String) -> Bool {
    return pythonKeywords.contains(word)
}

// MARK: - Keyword Documentation

/// Get documentation for Python keywords and built-ins
public func getKeywordDocumentation(_ word: String) -> String? {
    switch word {
    case "def":
        return "**def** *keyword*\n\nDefines a function.\n\n```python\ndef function_name(parameters):\n    # function body\n    pass\n```"
    case "class":
        return "**class** *keyword*\n\nDefines a class.\n\n```python\nclass ClassName:\n    def __init__(self):\n        pass\n```"
    case "print":
        return "**print**(*objects, sep=' ', end='\\n', file=sys.stdout, flush=False)\n\nPrint objects to the text stream file, separated by sep and followed by end."
    case "for":
        return "**for** *keyword*\n\nLoop over a sequence.\n\n```python\nfor item in sequence:\n    # loop body\n    pass\n```"
    case "if":
        return "**if** *keyword*\n\nConditional statement.\n\n```python\nif condition:\n    # if block\n    pass\n```"
    case "elif":
        return "**elif** *keyword*\n\nElse-if conditional statement.\n\n```python\nif condition1:\n    pass\nelif condition2:\n    pass\n```"
    case "else":
        return "**else** *keyword*\n\nElse clause for conditionals and loops."
    case "while":
        return "**while** *keyword*\n\nWhile loop.\n\n```python\nwhile condition:\n    # loop body\n    pass\n```"
    case "import":
        return "**import** *keyword*\n\nImport modules or packages.\n\n```python\nimport module_name\nfrom package import module\n```"
    case "from":
        return "**from** *keyword*\n\nImport specific items from a module.\n\n```python\nfrom module import item\n```"
    case "return":
        return "**return** *keyword*\n\nReturn a value from a function."
    case "pass":
        return "**pass** *keyword*\n\nNull operation - does nothing. Used as a placeholder."
    case "break":
        return "**break** *keyword*\n\nExit the current loop."
    case "continue":
        return "**continue** *keyword*\n\nSkip to the next iteration of the loop."
    case "try":
        return "**try** *keyword*\n\nBegin exception handling block.\n\n```python\ntry:\n    # risky code\nexcept Exception:\n    # error handling\n```"
    case "except":
        return "**except** *keyword*\n\nHandle exceptions in a try block."
    case "finally":
        return "**finally** *keyword*\n\nCode that always runs after try/except."
    case "raise":
        return "**raise** *keyword*\n\nRaise an exception."
    case "with":
        return "**with** *keyword*\n\nContext manager.\n\n```python\nwith open('file.txt') as f:\n    content = f.read()\n```"
    case "as":
        return "**as** *keyword*\n\nAlias in import or exception handling."
    case "lambda":
        return "**lambda** *keyword*\n\nAnonymous function.\n\n```python\nlambda x: x * 2\n```"
    case "yield":
        return "**yield** *keyword*\n\nProduce a value in a generator."
    case "in":
        return "**in** *keyword*\n\nMembership test or loop iteration."
    case "is":
        return "**is** *keyword*\n\nIdentity comparison."
    case "and":
        return "**and** *keyword*\n\nLogical AND operator."
    case "or":
        return "**or** *keyword*\n\nLogical OR operator."
    case "not":
        return "**not** *keyword*\n\nLogical NOT operator."
    case "True":
        return "**True** *constant*\n\nBoolean true value."
    case "False":
        return "**False** *constant*\n\nBoolean false value."
    case "None":
        return "**None** *constant*\n\nRepresents absence of a value."
    case "__init__":
        return "**__init__**(self, ...)\n\nClass constructor method. Called when creating a new instance of the class."
    case "len":
        return "**len**(obj)\n\nReturn the length (number of items) of an object."
    case "range":
        return "**range**(stop) or **range**(start, stop[, step])\n\nReturn a sequence of numbers."
    case "str":
        return "**str**(object)\n\nReturn a string version of object."
    case "int":
        return "**int**(x)\n\nConvert a number or string to an integer."
    case "float":
        return "**float**(x)\n\nConvert a string or number to a floating point number."
    case "list":
        return "**list**([iterable])\n\nCreate a list from an iterable."
    case "dict":
        return "**dict**(**kwarg)\n\nCreate a new dictionary."
    case "set":
        return "**set**([iterable])\n\nCreate a new set."
    case "tuple":
        return "**tuple**([iterable])\n\nCreate a tuple from an iterable."
    case "bool":
        return "**bool**(x)\n\nConvert a value to a Boolean."
    default:
        return nil
    }
}
