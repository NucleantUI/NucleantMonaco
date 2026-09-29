# MonacoEditorCEF web bundle

`scripts/build_web.sh` writes the editor page here: the webpack bundle from
`npm_cef` (Monaco, the page's bridge, the console panel) and the gzipped
`MonacoEditorWasm` module. `MonacoEditor` serves this folder to its CEF page.

Until it has been built, `MonacoEditorView` says so instead of showing an
editor.
