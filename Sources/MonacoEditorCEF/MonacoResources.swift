//
//  MonacoResources.swift
//  MonacoEditorCEF
//
//  Where the editor page's files are. How the page is then served to the
//  browser that shows it is per platform: a loopback server for CEF
//  (MonacoResources+MacOS.swift), the page the app runs in for the browser
//  build (MonacoResources+Web.swift).
//

import Foundation

extension MonacoResources {

    /// The web bundle: `NUCLEANT_MONACO_WEB_DIR` when set (a webpack output
    /// directory, for working on the page without rebuilding the package),
    /// else the `Resources` this target was built with.
    static var bundleDirectory: URL? {
        if let path = ProcessInfo.processInfo.environment["NUCLEANT_MONACO_WEB_DIR"] {
            return URL(fileURLWithPath: path, isDirectory: true)
        }
        // `.copy("Resources")` keeps the folder — but a flat bundle with a
        // top-level `Resources` folder reports that folder as its
        // `resourceURL`, so it may be either level.
        guard let resources = Bundle.module.resourceURL else { return nil }
        let nested = resources.appendingPathComponent("Resources", isDirectory: true)
        let page = nested.appendingPathComponent("index.html").path
        return FileManager.default.fileExists(atPath: page) ? nested : resources
    }
}
