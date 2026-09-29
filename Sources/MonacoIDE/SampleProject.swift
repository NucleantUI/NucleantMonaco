//
//  SampleProject.swift
//  MonacoIDE
//
//  What the sample project starts with — the files SwiftyMonacoIDE's local
//  development page opened, and a README.
//

let sampleFiles: [(name: String, text: String)] = [
    ("README.md", """
    # Sample Project

    Made by MonacoIDE on first launch. Edit the Python files: completions,
    hovers and diagnostics come from the Swift wasm module running inside the
    editor page (PySwiftAST, compiled to WebAssembly).

    Open another folder by passing it as the first argument, or with
    `NUCLEANT_MONACO_PROJECT=<folder>`.

    """),
    ("example.py", """
    # Example Python Model
    # Test Python language features

    def greet(name: str) -> str:
        \"\"\"
        Greets someone by name

        Args:
            name: The name to greet

        Returns:
            A greeting message
        \"\"\"
        message = f"Hello, {name}!"
        print(message)
        return message

    class Person:
        \"\"\"A simple Person class\"\"\"

        def __init__(self, name: str, age: int):
            self.name = name
            self.age = age

        def introduce(self) -> str:
            return f"I'm {self.name}, {self.age} years old"

    # Test the code
    person = Person("Alice", 30)
    print(person.introduce())
    result = greet("World")

    """),
    ("calculator.py", """
    # Calculator Module

    class Calculator:
        \"\"\"A simple calculator with basic operations\"\"\"

        def add(self, a: float, b: float) -> float:
            \"\"\"Add two numbers\"\"\"
            return a + b

        def subtract(self, a: float, b: float) -> float:
            \"\"\"Subtract b from a\"\"\"
            return a - b

        def multiply(self, a: float, b: float) -> float:
            \"\"\"Multiply two numbers\"\"\"
            return a * b

        def divide(self, a: float, b: float) -> float:
            \"\"\"Divide a by b\"\"\"
            if b == 0:
                raise ValueError("Cannot divide by zero")
            return a / b

    # Usage example
    calc = Calculator()
    print(calc.add(5, 3))
    print(calc.multiply(4, 7))

    """),
    ("data_processor.py", """
    # Data Processing Module

    from typing import List, Dict, Optional

    def process_data(items: List[Dict[str, any]]) -> List[Dict[str, any]]:
        \"\"\"
        Process a list of data items

        Args:
            items: List of dictionaries containing data

        Returns:
            Processed list of items
        \"\"\"
        processed = []

        for item in items:
            if 'value' in item:
                item['processed_value'] = item['value'] * 2
                processed.append(item)

        return processed

    def filter_data(items: List[Dict[str, any]], threshold: float) -> List[Dict[str, any]]:
        \"\"\"Filter items based on threshold\"\"\"
        return [item for item in items if item.get('value', 0) > threshold]

    # Test data
    test_data = [
        {'id': 1, 'value': 10},
        {'id': 2, 'value': 20},
        {'id': 3, 'value': 5}
    ]

    result = process_data(test_data)
    filtered = filter_data(test_data, 8)
    print(f"Processed: {result}")
    print(f"Filtered: {filtered}")

    """),
]
