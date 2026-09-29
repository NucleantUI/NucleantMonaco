//
//  CodeModel.swift
//  MonacoEditorCEF
//
//  One document the editor shows: a Monaco text model on the page, and its
//  text as the native side last heard it.
//

import Observation

/// A document for `MonacoEditor` — one Monaco model inside the page.
///
/// ```swift
/// let main = CodeModel(name: "main.py", text: "print('hello')")
/// editor.open(main)
/// ```
///
/// `text` follows every edit made in the editor, so reading it is how the
/// native side gets the document's content (to save it, say). Replacing it
/// from the native side goes through `MonacoEditor.setText(_:for:)`, which
/// updates the page too.
@MainActor
@Observable
public final class CodeModel: Identifiable {
    /// The model's ID on the page (its URI is `inmemory://<id>`). Kept below
    /// 2^53, so it survives the trip through a JavaScript number.
    public let id: Int64

    public var name: String

    /// A Monaco language ID: "python", "javascript", "plaintext" …
    public private(set) var language: String

    /// The document's text, as of the editor's last edit.
    public internal(set) var text: String

    private static var nextID: Int64 = 1

    public init(name: String, language: String = "python", text: String = "") {
        self.id = CodeModel.nextID
        CodeModel.nextID += 1
        self.name = name
        self.language = language
        self.text = text
    }

    func setLanguage(_ language: String) {
        self.language = language
    }
}
