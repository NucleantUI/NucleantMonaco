# make CEF version of https://github.com/touchBayProject/SwiftyMonacoIDE

the following targets should just be copied directly 
* MonacoApi
* MonacoCodable
* MonacoConsole
* MonacoJSK
* MonacoTerminal

it boths needs to build for working between NucleantUI and CEF
but also as wasm module inside the cefview

* MonacoEditorWasm

the rest i guess figure out what is relavant for this or not... 

was original designed for TouchBayUI, so dont directly include whatever api was intended for that..

