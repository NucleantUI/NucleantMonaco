//
//  Workspace.swift
//  MonacoIDE
//
//  The IDE's data: a project folder on disk, its files, and the one editor
//  they open in. Each file keeps what was last saved, so an edit in the
//  editor shows as unsaved until it is written back.
//

import Foundation
import Observation
import MonacoApi
import MonacoEditorCEF

/// One file of the project, and its document in the editor.
@MainActor
@Observable
final class ProjectFile: Identifiable {
    let id: Int64
    let url: URL
    /// Relative to the project folder.
    let path: String
    let document: CodeModel
    /// The text on disk, as last read or written.
    private(set) var savedText: String

    var name: String { url.lastPathComponent }
    var isEdited: Bool { document.text != savedText }

    init(url: URL, path: String, text: String) {
        self.url = url
        self.path = path
        self.document = CodeModel(name: url.lastPathComponent, language: ProjectFile.language(for: url), text: text)
        self.id = document.id
        self.savedText = text
    }

    func markSaved(_ text: String) {
        savedText = text
    }

    /// A Monaco language ID for the file's extension — one of the languages
    /// the page is bundled with (npm_cef/webpack.config.js).
    static func language(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "py", "pyi": "python"
        case "swift": "swift"
        case "md", "markdown": "markdown"
        case "yml", "yaml": "yaml"
        case "sh", "bash", "zsh": "shell"
        default: "plaintext"
        }
    }
}

/// The open project: a folder's text files, the editor, and what the status
/// bar says.
@MainActor
@Observable
final class Workspace {
    /// The one project this app window shows — shared with the menu
    /// commands, which live outside the view tree.
    static let shared = Workspace(folder: Workspace.startFolder())

    let folder: URL
    let editor: MonacoEditor
    private(set) var files: [ProjectFile] = []

    /// The sidebar's new-file field.
    var newFileName = ""

    /// The last thing that happened, for the status bar.
    private(set) var message: String?

    private(set) var fontSize = 13

    var name: String { folder.lastPathComponent }

    /// The file showing in the editor.
    var activeFile: ProjectFile? {
        guard let document = editor.activeDocument else { return nil }
        return file(for: document)
    }

    /// The files open in the editor, in tab order.
    var openFiles: [ProjectFile] {
        editor.documents.compactMap { file(for: $0) }
    }

    var hasEdits: Bool { files.contains { $0.isEdited } }

    init(folder: URL) {
        self.folder = folder
        self.editor = MonacoEditor(configuration: Workspace.configuration(fontSize: 13))
        files = Workspace.readFiles(in: folder)
        if let first = files.first(where: { $0.document.language == "python" }) ?? files.first {
            editor.open(first.document, focus: false)
        }
        editor.console.writeLine("[INFO] Opened \(folder.path) — \(files.count) file\(files.count == 1 ? "" : "s")")
    }

    func file(for document: CodeModel) -> ProjectFile? {
        files.first { $0.document === document }
    }

    // MARK: - Files

    func open(_ file: ProjectFile) {
        editor.open(file.document)
    }

    /// Close the file's tab. Unsaved edits stay with the file (the sidebar
    /// still marks it) until it is saved or reverted.
    func close(_ file: ProjectFile) {
        editor.close(file.document)
    }

    func save(_ file: ProjectFile) {
        let text = file.document.text
        do {
            try text.write(to: file.url, atomically: true, encoding: .utf8)
            file.markSaved(text)
            report("Saved \(file.path)")
        } catch {
            report("Could not save \(file.path): \(error.localizedDescription)", isError: true)
        }
    }

    func saveActive() {
        if let file = activeFile { save(file) }
    }

    func saveAll() {
        let edited = files.filter(\.isEdited)
        for file in edited { save(file) }
        if edited.isEmpty { report("Nothing to save") }
    }

    /// Put the file back to what is on disk.
    func revert(_ file: ProjectFile) {
        guard let text = try? String(contentsOf: file.url, encoding: .utf8) else {
            report("Could not read \(file.path)", isError: true)
            return
        }
        file.markSaved(text)
        editor.setText(text, for: file.document)
        report("Reverted \(file.path)")
    }

    func revertActive() {
        if let file = activeFile { revert(file) }
    }

    /// Make the file named in the new-file field, and open it.
    func createFile() {
        let name = newFileName.trimmingCharacters(in: .whitespaces)
        guard !name.isEmpty else { return }
        guard !name.contains("/"), !name.hasPrefix(".") else {
            report("“\(name)” is not a plain file name", isError: true)
            return
        }
        let url = folder.appendingPathComponent(name)
        if let existing = files.first(where: { $0.url == url }) {
            newFileName = ""
            open(existing)
            return
        }
        guard !FileManager.default.fileExists(atPath: url.path) else {
            report("\(name) already exists", isError: true)
            return
        }
        do {
            try "".write(to: url, atomically: true, encoding: .utf8)
        } catch {
            report("Could not create \(name): \(error.localizedDescription)", isError: true)
            return
        }
        let file = ProjectFile(url: url, path: name, text: "")
        files.append(file)
        files.sort { $0.path.localizedStandardCompare($1.path) == .orderedAscending }
        newFileName = ""
        open(file)
        report("Created \(name)")
    }

    // MARK: - Editor

    func changeFontSize(by step: Int) {
        let size = min(max(fontSize + step, 9), 32)
        guard size != fontSize else { return }
        fontSize = size
        editor.updateOptions(Workspace.configuration(fontSize: size))
    }

    private static func configuration(fontSize: Int) -> EditorConfiguration {
        EditorConfiguration(
            theme: "vs-dark",
            minimap: EditorMinimapOptions(enabled: true, renderCharacters: false),
            padding: EditorPaddingOptions(top: 8),
            fontFamily: "Menlo, Monaco, 'Courier New', monospace",
            fontSize: fontSize
        )
    }

    /// Show `text` in the status bar, and log it to the output console.
    private func report(_ text: String, isError: Bool = false) {
        message = text
        editor.console.writeLine(isError ? "[ERROR] \(text)" : "[INFO] \(text)")
    }

    // MARK: - Folder

    /// The folder to open: the first argument, else `NUCLEANT_MONACO_PROJECT`,
    /// else a sample project in Application Support (made on first launch).
    static func startFolder() -> URL {
        let arguments = CommandLine.arguments.dropFirst().filter { !$0.hasPrefix("-") }
        if let path = arguments.first ?? ProcessInfo.processInfo.environment["NUCLEANT_MONACO_PROJECT"] {
            return URL(fileURLWithPath: (path as NSString).expandingTildeInPath, isDirectory: true)
        }
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        let sample = support.appendingPathComponent("MonacoIDE/Sample Project", isDirectory: true)
        if !FileManager.default.fileExists(atPath: sample.path) {
            try? FileManager.default.createDirectory(at: sample, withIntermediateDirectories: true)
            for (name, text) in sampleFiles {
                try? text.write(to: sample.appendingPathComponent(name), atomically: true, encoding: .utf8)
            }
        }
        return sample
    }

    /// The folder's text files, sorted by path: UTF-8, under 1 MB, not hidden,
    /// not inside a build or dependency folder.
    private static func readFiles(in folder: URL) -> [ProjectFile] {
        let skipped: Set<String> = ["node_modules", "build", "dist", "__pycache__", "DerivedData"]
        guard let enumerator = FileManager.default.enumerator(
            at: folder,
            includingPropertiesForKeys: [.isRegularFileKey, .isDirectoryKey, .fileSizeKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else { return [] }

        let base = folder.standardizedFileURL.path + "/"
        var files: [ProjectFile] = []
        for case let url as URL in enumerator {
            let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .isDirectoryKey, .fileSizeKey])
            if values?.isDirectory == true {
                if skipped.contains(url.lastPathComponent) { enumerator.skipDescendants() }
                continue
            }
            guard values?.isRegularFile == true, (values?.fileSize ?? 0) < 1_000_000,
                  let text = try? String(contentsOf: url, encoding: .utf8) else { continue }
            let full = url.standardizedFileURL.path
            let path = full.hasPrefix(base) ? String(full.dropFirst(base.count)) : url.lastPathComponent
            files.append(ProjectFile(url: url, path: path, text: text))
            if files.count >= 500 { break }
        }
        return files.sorted { $0.path.localizedStandardCompare($1.path) == .orderedAscending }
    }
}
