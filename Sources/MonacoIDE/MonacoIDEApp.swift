//
//  MonacoIDEApp.swift
//  MonacoIDE
//
//  A small code editor on NucleantUI + CEF: a project folder's files in a
//  sidebar, tabs, Monaco (driven by the Swift wasm module) in a CEF view,
//  saving back to disk, and an output console.
//
//  Build the editor page first, then the app and CEF's helper executable
//  (a product of NucleantCEF, so it is built by name):
//
//      scripts/build_web.sh
//      swift build && swift build --product NucleantCEFHelper
//      .build/debug/MonacoIDE [folder]
//
//  With no folder, a sample project is made in
//  ~/Library/Application Support/MonacoIDE.
//

import NucleantUI

@main
struct MonacoIDEApp: NucleantApp {
    var body: some Scene {
        WindowGroup("MonacoIDE", width: 1200, height: 780) {
            IDEScreen(workspace: .shared)
        }
        .commands {
            IDECommands(workspace: .shared)
        }
    }
}

struct IDECommands: Commands {
    let workspace: Workspace

    var body: some Commands {
        CommandGroup(before: .saveItem) {
            Button("Save") { workspace.saveActive() }
                .keyboardShortcut("s")
            Button("Save All") { workspace.saveAll() }
                .keyboardShortcut("s", modifiers: [.command, .option])
            Button("Revert to Saved") { workspace.revertActive() }
        }
        CommandMenu("View") {
            Button("Toggle Output") { workspace.editor.console.toggle() }
                .keyboardShortcut("j")
            Button("Bigger") { workspace.changeFontSize(by: 1) }
                .keyboardShortcut("=")
            Button("Smaller") { workspace.changeFontSize(by: -1) }
                .keyboardShortcut("-")
            Button("Reload Editor") { workspace.editor.reloadEditor() }
                .keyboardShortcut("r", modifiers: [.command, .shift])
        }
    }
}
