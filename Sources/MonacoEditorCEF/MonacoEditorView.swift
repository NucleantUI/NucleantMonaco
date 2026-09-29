//
//  MonacoEditorView.swift
//  MonacoEditorCEF
//
//  A `MonacoEditor` as a NucleantUI view.
//

import NucleantUI
import NucleantCEF

/// Shows `editor`'s page and takes the pointer and keys for it.
///
/// ```swift
/// MonacoEditorView(editor)
///     .frame(maxWidth: .infinity, maxHeight: .infinity)
/// ```
///
/// While the page loads it shows its own spinner; if it can't be shown at
/// all (the web bundle isn't built, the page failed), the reason is drawn
/// over it here.
@View
public struct MonacoEditorView {
    let editor: MonacoEditor

    public init(_ editor: MonacoEditor, _viewID: ViewID = #viewID) {
        self.editor = editor
        self._viewID = _viewID
    }

    public var body: some View {
        CEFView(editor)
            .overlay(alignment: .center) {
                if case .failed(let error) = editor.phase {
                    MonacoFailureNotice(message: error.description)
                }
            }
    }
}

@View
struct MonacoFailureNotice {
    let message: String

    var body: some View {
        Text(message)
            .font(.system(size: 13))
            .foregroundColor(Color(hex: 0xCCCCCC))
            .multilineTextAlignment(.center)
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: 0x1E1E1E))
    }
}
