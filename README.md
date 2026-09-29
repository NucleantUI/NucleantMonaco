# NucleantMonaco

The Monaco editor in a NucleantUI app, rendered by CEF. It's the CEF version of [SwiftyMonacoIDE](https://github.com/touchBayProject/SwiftyMonacoIDE): the same Swift wasm module drives Monaco inside the page, and the WebKit/SwiftUI host is replaced by a NucleantUI model and view on top of NucleantCEF.

```swift
import NucleantUI
import MonacoEditorCEF

@View
struct Editor {
    @State private var editor = MonacoEditor(documents: [
        CodeModel(name: "main.py", text: "print('hello')\n"),
    ])

    var body: some View {
        MonacoEditorView(editor)
    }
}
```

Every edit updates the document's `text`, so the native side always has the current content. Commands made before the page is ready (opening documents, options, console output) are applied once it is, and again after a reload.

macOS only, like NucleantCEF.

## Build and run

The editor page has to be built first. It needs a swift.org toolchain, the Swift wasm SDK of the same version, and Node:

```sh
scripts/build_web.sh                # MonacoEditorWasm → wasm, gzip, webpack → Sources/MonacoEditorCEF/Resources
swift build
swift build --product NucleantCEFHelper   # CEF's helper is NucleantCEF's product, so build it by name
.build/debug/MonacoIDE [folder]
```

NucleantCEF's CEF distribution must be fetched too (`python3 ../NucleantCEF/scripts/fetch_cef.py`).

`MonacoIDE` is a small code editor for a project folder:
- **Files:** a sidebar with the folder's text files and a field for making new ones.
- **Tabs:** one per open file, with a dot while it has unsaved changes.
- **Menu commands:** ⌘S saves, ⌥⌘S saves all, and Revert to Saved.
- **Output:** a console panel (⌘J).
- **Font size:** ⌘= and ⌘-.
- **Status bar:** the caret position and language.

With no folder argument, it opens a sample project it makes in `~/Library/Application Support/MonacoIDE`. `NUCLEANT_MONACO_PROJECT=<folder>` opens another.

`NUCLEANT_MONACO_WEB_DIR=<dir>` serves a page from `dir` instead of the built `Resources`, which is useful while working on `npm_cef` (`npm run dev` rebuilds into `Resources`).

## Targets

| Target | What it is |
|---|---|
| `MonacoApi`, `MonacoCodable`, `MonacoJSK`, `MonacoConsole`, `MonacoTerminal` | Copied from SwiftyMonacoIDE. All unchanged except one line in `MonacoTerminal`: `Terminal.new(options).jsValue`, since `JSFunction.new` returns a `JSObject` in current JavaScriptKit. It never compiled in the original, because nothing there built `MonacoTerminal`. |
| `MonacoEditorManager`, `PythonASTCore` | Copied unchanged too: `MonacoEditorWasm` needs them. |
| `MonacoEditorWasm` | Copied unchanged. The wasm module that runs inside the page: it creates the editor and provides completions, hovers and diagnostics through PySwiftAST. |
| `MonacoEditorCEF` | New. `MonacoEditor` (the model), `MonacoEditorView`, `CodeModel`, and the page's `Resources`. Uses `MonacoApi`'s types natively, e.g. `EditorConfiguration` for options and `IMarkerData` for markers. |
| `MonacoIDE` | New. The demo app. |

Left out: `MonacoEditorWebKit` and `MonacoConsoleWebKit`, which were the WebKit/SwiftUI/Combine host that `MonacoEditorCEF` replaces. Also `npm_localdev` and `npm_webkit`, whose role `npm_cef` takes, and the test targets, which had fixtures but no tests.

## How it works

- **Serving the page.** Chromium doesn't allow `fetch` or web workers for `file://` pages. So `MonacoEditor` serves `Resources` itself, over HTTP on 127.0.0.1 with a port the system picks. The files sit under a random path prefix that only the process knows, and any other path gets a 404. The page fetches the gzipped module and decompresses it itself, and Monaco's editor worker runs as a real worker.
- **Native → page.** Commands are JSON objects passed to `window.nucleantMonaco.receive(…)` through `evaluateJavaScript`.
- **Page → native.** JSON objects sent with `window.cefQuery({ request })`, CEF's message router, which NucleantCEF installs in every page. `MonacoEditor` receives them as a `CEFQueryHandler`. It takes only queries from the main frame of the page it serves, and refuses anything else (-1).
  - The page also provides `window.webkit.messageHandlers.<name>.postMessage`, so code written for WebKit (MonacoJSK's `WebKitBridge`) reaches `MonacoEditor.onScriptMessage`.
- **The wasm module.** It's the unchanged SwiftyMonacoIDE module: it creates the editor in `#editor-container` and publishes `editorManager`. The page creates and switches models through that. It also listens for edits, cursor moves and model switches and posts them back.

## Not done yet

- **Languages.** The page is bundled with Monaco's Python, Swift, Markdown, YAML and shell grammars only. Other files open as plain text. Add languages in `npm_cef/webpack.config.js`.
- **Analysis after edits.** This is inherited from the copied `MonacoEditorManager`, which re-parses on edits only for the model the editor was created with. Other models are parsed when they're created, so their completions and hovers lag behind edits.
- **`MonacoTerminal`.** It's here but unused, since the page doesn't bundle xterm.js.
- **Quitting with unsaved changes.** MonacoIDE doesn't warn (NucleantUI has no alerts yet), and unsaved edits are lost.
- **Large files.** Each edit sends the whole document to the native side, which is fine for source files but not for multi-megabyte ones.
