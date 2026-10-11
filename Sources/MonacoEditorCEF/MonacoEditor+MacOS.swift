//
//  MonacoEditor+MacOS.swift
//  MonacoEditorCEF
//
//  Links the editor page wants opened in a new window go to the system's
//  browser. In the browser build there is nothing to do: the page is in an
//  iframe, and the browser opens such a link in a tab of its own without
//  asking the app.
//

#if os(macOS)
import AppKit
import NucleantCEF

extension MonacoEditor {

    // MARK: - CEFLifeSpanHandler

    /// Links that want a new window (in hovers, say) open in the system's
    /// browser — the editor page stays where it is.
    public func newWindowRequested(_ url: String) {
        guard let url = URL(string: url), ["http", "https"].contains(url.scheme?.lowercased()) else { return }
        NSWorkspace.shared.open(url)
    }
}
#endif
