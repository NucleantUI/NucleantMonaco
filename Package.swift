// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

/// Build against the sibling checkouts (`../NucleantUI`, `../NucleantCEF`) or
/// against GitHub.
///
/// Decided the same way in every Nucleant package, so one setting covers the
/// whole chain: `NUCLEANT_LOCAL_DEV=1|0` in the environment wins; otherwise
/// local when the sibling checkout exists next to this package — true in a
/// development tree, false for a clone SwiftPM made under `.build/checkouts`.
let devMode: Bool = {
    if let flag = ProcessInfo.processInfo.environment["NUCLEANT_LOCAL_DEV"] {
        return ["1", "true", "yes"].contains(flag.lowercased())
    }
    let siblings = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
    return FileManager.default.fileExists(atPath: siblings.appendingPathComponent("NucleantCEF").path)
}()

/// WebAssembly (`WASM_BUILD=1`, the opt-in every Nucleant package reads):
/// MonacoEditorCEF's page is then served by the page the app runs in, and
/// found there through NucleantApplication's `Platform_Wasm`
/// (`MonacoResources+Web.swift`). Without it the manifest is the desktop's
/// as it was.
let isWasm = ProcessInfo.processInfo.environment["WASM_BUILD"] == "1"

func getDependencies() -> [Package.Dependency] {
    let shared: [Package.Dependency] = [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit.git", from: "0.19.0"),
        .package(url: "https://github.com/Py-Swift/PySwiftAST.git", branch: "master"),
    ]
    let nucleant = ["NucleantUI", "NucleantCEF"] + (isWasm ? ["NucleantApplication"] : [])
    return shared + nucleant.map { name in
        devMode
            ? .package(path: "../\(name)")
            : .package(url: "https://github.com/NucleantUI/\(name).git", branch: "master")
    }
}

/// `BrowserResources`, for the browser build's editor page.
let webOnlyDependencies: [Target.Dependency] = isWasm
    ? [.product(name: "Platform_Wasm", package: "NucleantApplication", condition: .when(platforms: [.wasi]))]
    : []

let package = Package(
    name: "NucleantMonaco",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "MonacoApi", targets: ["MonacoApi"]),
        .library(name: "MonacoCodable", targets: ["MonacoCodable"]),
        .library(name: "MonacoJSK", targets: ["MonacoJSK"]),
        .library(name: "MonacoEditorManager", targets: ["MonacoEditorManager"]),
        .library(name: "MonacoTerminal", targets: ["MonacoTerminal"]),
        .library(name: "MonacoConsole", targets: ["MonacoConsole"]),
        .library(name: "PythonASTCore", targets: ["PythonASTCore"]),
        .executable(name: "MonacoEditorWasm", targets: ["MonacoEditorWasm"]),
        .library(name: "MonacoEditorCEF", targets: ["MonacoEditorCEF"]),
        .executable(name: "MonacoIDE", targets: ["MonacoIDE"]),
    ],
    dependencies: getDependencies(),
    targets: [
        // MARK: Copied from SwiftyMonacoIDE — shared by the app and the wasm module

        // Core Monaco types - Foundation-free, works everywhere
        .target(
            name: "MonacoApi",
            dependencies: []
        ),

        // Codable convenience helpers for Apple platforms
        .target(
            name: "MonacoCodable",
            dependencies: ["MonacoApi"]
        ),

        // JavaScriptKit extensions for Swift WASM
        .target(
            name: "MonacoJSK",
            dependencies: [
                "MonacoApi",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        ),

        // Monaco Editor Manager - Singleton for multi-model management
        .target(
            name: "MonacoEditorManager",
            dependencies: [
                "MonacoApi",
                "MonacoJSK",
                "PythonASTCore",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "PySwiftAST", package: "PySwiftAST"),
                .product(name: "PyAstVisitors", package: "PySwiftAST"),
                .product(name: "PySwiftCodeGen", package: "PySwiftAST"),
            ]
        ),

        // Python AST Core - Pure Swift, no JavaScriptKit
        .target(
            name: "PythonASTCore",
            dependencies: [
                .product(name: "PySwiftAST", package: "PySwiftAST"),
                .product(name: "PyAstVisitors", package: "PySwiftAST"),
                .product(name: "PySwiftCodeGen", package: "PySwiftAST"),
                .product(name: "PyChecking", package: "PySwiftAST"),
            ]
        ),

        // Terminal integration for Monaco Editor
        .target(
            name: "MonacoTerminal",
            dependencies: [
                "MonacoApi",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        ),

        // Console output for Monaco Editor
        .target(
            name: "MonacoConsole",
            dependencies: [
                "MonacoApi",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]
        ),

        // WASM executable for Monaco Editor integration — runs inside the
        // CEF page (`scripts/build_web.sh`).
        .executableTarget(
            name: "MonacoEditorWasm",
            dependencies: [
                "MonacoApi",
                "MonacoJSK",
                "MonacoEditorManager",
                "PythonASTCore",
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "PySwiftAST", package: "PySwiftAST"),
                .product(name: "PyChecking", package: "PySwiftAST"),
                .product(name: "PyAstVisitors", package: "PySwiftAST"),
                .product(name: "PySwiftCodeGen", package: "PySwiftAST"),
            ],
            swiftSettings: [
                .unsafeFlags(["-Xfrontend", "-disable-availability-checking"])
            ]
        ),

        // MARK: The native side — NucleantUI + CEF, in place of the WebKit wrappers

        // Monaco (with MonacoEditorWasm) in a CEF browser, as a NucleantUI
        // model and view. `Resources` is the page `scripts/build_web.sh`
        // builds from npm_cef.
        .target(
            name: "MonacoEditorCEF",
            dependencies: [
                "MonacoApi",
                "MonacoCodable",
                .product(name: "NucleantUI", package: "NucleantUI"),
                .product(name: "NucleantCEF", package: "NucleantCEF"),
            ] + webOnlyDependencies,
            resources: [
                .copy("Resources")
            ]
        ),

        // A small code editor for a project folder, built on MonacoEditorCEF.
        .executableTarget(
            name: "MonacoIDE",
            dependencies: [
                "MonacoApi",
                "MonacoEditorCEF",
                .product(name: "NucleantUI", package: "NucleantUI"),
            ]
        ),
    ]
)
