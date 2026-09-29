// The MonacoEditorCEF page: Monaco, the Swift wasm module (MonacoEditorWasm)
// that builds and drives the editor, a console panel, and the bridge to the
// native side (MonacoEditorCEF's `MonacoEditor`).
//
// The page is served over loopback HTTP by the native side, so fetch and web
// workers work as they would on any site — no preloading the module, no
// disabling Monaco's workers.
//
// Bridge (see MonacoBridge.swift):
//   native → page: window.nucleantMonaco.receive({ command, … })
//   page → native: window.cefQuery({ request: JSON }) — CEF's message router,
//                  which the NucleantCEF helper installs in every page.

import * as monaco from 'monaco-editor';
import * as wasiShim from '@bjorn3/browser_wasi_shim';
import { instantiate } from './build/output/instantiate.js';

window.monaco = monaco;
window.BrowserWASI = wasiShim;

// MARK: - Bridge to native

function post(message) {
    if (!window.cefQuery) {
        console.error('MonacoEditorCEF: no window.cefQuery — not running in NucleantCEF');
        return;
    }
    window.cefQuery({
        request: JSON.stringify(message),
        onSuccess: () => {},
        onFailure: (code, error) => console.error('MonacoEditorCEF: message refused', code, error),
    });
}

// WebKit's message handlers, for code written against them — MonacoJSK's
// WebKitBridge posts to window.webkit.messageHandlers.updateText. Any
// handler name works; the native side gets it as a script message.
if (!window.webkit) {
    window.webkit = {
        messageHandlers: new Proxy({}, {
            get(_, name) {
                if (typeof name !== 'string') return undefined;
                return {
                    postMessage(body) {
                        post({ type: 'scriptMessage', name, body: JSON.stringify(body ?? null) });
                    },
                };
            },
        }),
    };
}

// MARK: - Console panel

const consoleContainer = document.getElementById('console-container');
let consoleEditor = null;
let consoleModel = null;

function ensureConsole() {
    if (consoleEditor) return;
    consoleModel = monaco.editor.createModel('', 'plaintext', monaco.Uri.parse('inmemory://console-output'));
    consoleEditor = monaco.editor.create(document.getElementById('console-output'), {
        model: consoleModel,
        theme: 'vs-dark',
        readOnly: true,
        automaticLayout: true,
        minimap: { enabled: false },
        scrollBeyondLastLine: false,
        fontSize: 12,
        fontFamily: 'Menlo, Monaco, "Courier New", monospace',
        lineNumbers: 'off',
        renderWhitespace: 'none',
        wordWrap: 'on',
    });
}

function consoleWrite(text) {
    ensureConsole();
    const line = consoleModel.getLineCount();
    const column = consoleModel.getLineMaxColumn(line);
    consoleModel.applyEdits([{ range: new monaco.Range(line, column, line, column), text: String(text) }]);
    consoleEditor.revealLine(consoleModel.getLineCount());
}

function setConsoleVisible(visible, fromPage) {
    consoleContainer.classList.toggle('visible', visible);
    if (visible) ensureConsole();
    if (fromPage) post({ type: 'consoleVisibility', visible });
}

const outputConsole = {
    write: (text) => consoleWrite(text),
    writeLine: (text) => consoleWrite(String(text) + '\n'),
    clear: () => { if (consoleModel) consoleModel.setValue(''); },
    // From the wasm module or the page: tell the native side too.
    show: () => setConsoleVisible(true, true),
    hide: () => setConsoleVisible(false, true),
};

// The names the wasm module looks for: `swiftyMonaco.console` (its
// exposeConsoleFunctions) and `monaco_console` (its mc_log).
window.swiftyMonaco = { console: outputConsole };
window.monaco_console = outputConsole;

document.getElementById('console-clear').addEventListener('click', () => outputConsole.clear());
document.getElementById('console-close').addEventListener('click', () => outputConsole.hide());

// MARK: - Models

function uriFor(id) {
    return monaco.Uri.parse('inmemory://' + id);
}

function modelFor(id) {
    return monaco.editor.getModel(uriFor(id));
}

function idOf(uri) {
    if (!uri || uri.scheme !== 'inmemory') return null;
    const id = Number(uri.authority);
    return Number.isSafeInteger(id) ? id : null;
}

function editor() {
    return window.monacoEditor;
}

/// True while a change from the native side is applied — it isn't echoed back.
let applyingNativeEdit = false;
const watched = new Set();

function watch(id) {
    if (watched.has(id)) return;
    const model = modelFor(id);
    if (!model) return;
    watched.add(id);
    model.onDidChangeContent(() => {
        if (!applyingNativeEdit) post({ type: 'contentChange', id, content: model.getValue() });
    });
    model.onWillDispose(() => watched.delete(id));
}

// MARK: - Commands from native

const commands = {
    createModel({ id, content, language }) {
        if (!modelFor(id)) window.editorManager.createModel(id, content, language);
        watch(id);
    },
    focusModel({ id, focus }) {
        window.editorManager.focusModel(id, Boolean(focus));
    },
    clearModel() {
        editor().setModel(null);
    },
    setContent({ id, content }) {
        const model = modelFor(id);
        if (!model || model.getValue() === content) return;
        applyingNativeEdit = true;
        try {
            // An edit rather than setValue, so it can be undone.
            model.pushEditOperations([], [{ range: model.getFullModelRange(), text: content }], () => null);
        } finally {
            applyingNativeEdit = false;
        }
    },
    setLanguage({ id, language }) {
        const model = modelFor(id);
        if (model) monaco.editor.setModelLanguage(model, language);
    },
    setMarkers({ id, owner, markers }) {
        const model = modelFor(id);
        if (model) monaco.editor.setModelMarkers(model, owner, markers);
    },
    updateOptions({ options }) {
        if (options.theme) monaco.editor.setTheme(options.theme);
        editor().updateOptions(options);
    },
    reveal({ line, column }) {
        const target = editor();
        target.setPosition({ lineNumber: line, column });
        target.revealLineInCenter(line);
        target.focus();
    },
    focus() {
        editor().focus();
    },
    layout() {
        editor().layout();
        if (consoleEditor) consoleEditor.layout();
    },
    console({ action, text }) {
        switch (action) {
            case 'write': outputConsole.write(text ?? ''); break;
            case 'writeLine': outputConsole.writeLine(text ?? ''); break;
            case 'clear': outputConsole.clear(); break;
            // The native side already knows: no message back.
            case 'show': setConsoleVisible(true, false); break;
            case 'hide': setConsoleVisible(false, false); break;
        }
    },
};

window.nucleantMonaco = {
    receive(command) {
        const handler = commands[command.command];
        if (!handler) {
            console.warn('MonacoEditorCEF: unknown command', command.command);
            return;
        }
        try {
            handler(command);
        } catch (error) {
            console.error('MonacoEditorCEF: command failed', command.command, error);
        }
    },
};

// MARK: - Start

function showFailure(message) {
    const loading = document.getElementById('loading');
    loading.textContent = message;
    loading.classList.add('failed');
}

async function loadWasm() {
    const response = await fetch(new URL('MonacoEditorWasm.wasm.gz', document.baseURI));
    if (!response.ok) {
        throw new Error(`Fetching the wasm module failed: ${response.status} ${response.statusText}`);
    }
    const bytes = await new Response(response.body.pipeThrough(new DecompressionStream('gzip'))).arrayBuffer();
    const module = await WebAssembly.compile(bytes);

    // The module's stdout and stderr go to the page's console.
    const { WASI, File, OpenFile, ConsoleStdout } = wasiShim;
    const output = (log) => ConsoleStdout ? ConsoleStdout.lineBuffered(log) : new OpenFile(new File([]));
    const wasi = new WASI([], [], [
        new OpenFile(new File([])),
        output((line) => console.log(line)),
        output((line) => console.error(line)),
    ]);
    return instantiate({ module, wasi });
}

/// The module's main makes the editor and publishes `editorManager` and
/// `monacoEditor`; wait for both.
function editorPublished(timeout = 10000) {
    return new Promise((resolve, reject) => {
        const start = performance.now();
        (function check() {
            if (window.editorManager && window.monacoEditor) return resolve();
            if (performance.now() - start > timeout) {
                return reject(new Error('The wasm module did not create the editor.'));
            }
            setTimeout(check, 50);
        })();
    });
}

function observeEditor() {
    const target = editor();
    target.onDidChangeModel((event) => {
        const id = idOf(event.newModelUrl);
        if (id !== null) post({ type: 'modelSwitch', id });
    });
    target.onDidChangeCursorPosition((event) => {
        post({ type: 'cursor', line: event.position.lineNumber, column: event.position.column });
    });
}

async function start() {
    try {
        await loadWasm();
        await editorPublished();
        observeEditor();
        document.body.classList.add('loaded');
        post({ type: 'ready' });
    } catch (error) {
        console.error('MonacoEditorCEF: start failed', error);
        showFailure(`Error: ${error.message}`);
        post({ type: 'error', message: String(error.message ?? error) });
    }
}

start();
