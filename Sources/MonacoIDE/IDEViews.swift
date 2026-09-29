//
//  IDEViews.swift
//  MonacoIDE
//
//  The window: the project's files down the left, the open files' tabs over
//  the editor, and a status bar with the caret position, the output
//  console's toggle and the last thing that happened.
//

import NucleantUI
import MonacoEditorCEF

enum IDETheme {
    static let background = Color(hex: 0x1E1E1E)
    static let sidebar = Color(hex: 0x252526)
    static let tabBar = Color(hex: 0x2D2D2D)
    static let activeTab = Color(hex: 0x1E1E1E)
    static let selection = Color(hex: 0x37373D)
    static let hover = Color(hex: 0x2A2D2E)
    static let text = Color(hex: 0xCCCCCC)
    static let dimText = Color(hex: 0x8B8B8B)
    static let statusBar = Color(hex: 0x007ACC)
    static let edited = Color(hex: 0xE2C08D)
    static let error = Color(hex: 0xF48771)
}

@View
struct IDEScreen {
    let workspace: Workspace

    var body: some View {
        HStack(spacing: 0) {
            Sidebar(workspace: workspace)
                .frame(width: 240)
            VStack(spacing: 0) {
                EditorTabs(workspace: workspace)
                MonacoEditorView(workspace.editor)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                StatusBar(workspace: workspace)
            }
        }
        .background(IDETheme.background)
        .colorScheme(.dark)
    }
}

// MARK: - Sidebar

@View
struct Sidebar {
    let workspace: Workspace

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(workspace.name.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(IDETheme.dimText)
                .lineLimit(1)
                .padding(horizontal: 14, vertical: 10)
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(workspace.files) { file in
                        FileRow(
                            file: file,
                            isActive: file === workspace.activeFile,
                            open: { workspace.open(file) }
                        )
                    }
                    if workspace.files.isEmpty {
                        Text("No text files in this folder.")
                            .font(.system(size: 12))
                            .foregroundColor(IDETheme.dimText)
                            .padding(14)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: .infinity)
            NewFileField(workspace: workspace)
        }
        .background(IDETheme.sidebar)
    }
}

@View
struct FileRow {
    let file: ProjectFile
    let isActive: Bool
    let open: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 6) {
            Text(file.path)
                .font(.system(size: 13))
                .foregroundColor(IDETheme.text)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            if file.isEdited {
                Circle()
                    .fill(IDETheme.edited)
                    .frame(width: 7, height: 7)
            }
        }
        .padding(horizontal: 14, vertical: 4)
        .background(isActive ? IDETheme.selection : isHovered ? IDETheme.hover : Color.clear)
        .onHover { isHovered = $0 }
        .onTapGesture { open() }
    }
}

/// Type a name, press Return (or Add): the file is made in the project
/// folder and opened.
@View
struct NewFileField {
    let workspace: Workspace

    var body: some View {
        HStack(spacing: 6) {
            TextField("new_file.py", text: Bindable(workspace).newFileName)
                .font(.system(size: 12))
                .onSubmit { workspace.createFile() }
                .frame(maxWidth: .infinity)
            BarButton(title: "Add", color: IDETheme.text) { workspace.createFile() }
        }
        .padding(8)
        .background(IDETheme.tabBar)
    }
}

// MARK: - Tabs

@View
struct EditorTabs {
    let workspace: Workspace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(workspace.openFiles) { file in
                EditorTab(
                    file: file,
                    isActive: file === workspace.activeFile,
                    select: { workspace.open(file) },
                    close: { workspace.close(file) }
                )
            }
            Spacer(minLength: 0)
        }
        .frame(height: 34)
        .background(IDETheme.tabBar)
    }
}

@View
struct EditorTab {
    let file: ProjectFile
    let isActive: Bool
    let select: () -> Void
    let close: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Text(file.name)
                .font(.system(size: 13))
                .foregroundColor(isActive ? Color.white : IDETheme.dimText)
                .lineLimit(1)
                .frame(maxWidth: 180, alignment: .leading)
            // An unsaved file shows a dot where the close button is, until
            // the pointer is over the tab — as in VS Code.
            ZStack {
                if file.isEdited, !isHovered {
                    Circle()
                        .fill(IDETheme.edited)
                        .frame(width: 8, height: 8)
                } else if isHovered || isActive {
                    Text("×")
                        .font(.system(size: 15))
                        .foregroundColor(IDETheme.dimText)
                        .onTapGesture { close() }
                }
            }
            .frame(width: 16, height: 16)
        }
        .padding(horizontal: 12)
        .frame(maxHeight: .infinity)
        .background(isActive ? IDETheme.activeTab : isHovered ? IDETheme.hover : Color.clear)
        .onHover { isHovered = $0 }
        .onTapGesture { select() }
    }
}

// MARK: - Status bar

@View
struct StatusBar {
    let workspace: Workspace

    var body: some View {
        HStack(spacing: 14) {
            Text(phaseText)
                .lineLimit(1)
            if let message = workspace.message {
                Text(message)
                    .lineLimit(1)
            }
            Spacer(minLength: 8)
            if let cursor = workspace.editor.cursor {
                Text("Ln \(cursor.lineNumber), Col \(cursor.column)")
            }
            if let file = workspace.activeFile {
                Text(file.document.language)
            }
            BarButton(title: workspace.editor.isConsoleVisible ? "Hide Output" : "Output", color: .white) {
                workspace.editor.console.toggle()
            }
        }
        .font(.system(size: 12))
        .foregroundColor(.white)
        .padding(horizontal: 10)
        .frame(height: 24)
        .background(IDETheme.statusBar)
    }

    var phaseText: String {
        switch workspace.editor.phase {
        case .loading: "Loading editor…"
        case .ready: workspace.hasEdits ? "Unsaved changes" : "Ready"
        case .failed: "Editor unavailable"
        }
    }
}

/// A plain text button for the bars: lit on hover.
@View
struct BarButton {
    let title: String
    let color: Color
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Text(title)
            .font(.system(size: 12))
            .foregroundColor(color)
            .padding(horizontal: 6, vertical: 2)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isHovered ? Color(white: 1, opacity: 0.15) : Color.clear)
            )
            .onHover { isHovered = $0 }
            .onTapGesture { action() }
    }
}
