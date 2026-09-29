//
//  log.swift
//  SwiftyMonacoIDE
//
//  Created by CodeBuilder on 09/12/2025.
//
import JavaScriptKit

// MARK: - Global JavaScript Objects
nonisolated(unsafe) let document = JSObject.global.document
nonisolated(unsafe) let console = JSObject.global.console

// MARK: - Logging Helper
func log(_ message: String) {
    _ = console.log(message.jsValue)
}
