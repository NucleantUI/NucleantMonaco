#!/bin/bash
#
# Builds the editor page MonacoEditorCEF serves to CEF:
#
#   1. MonacoEditorWasm for WebAssembly (JavaScriptKit's `js` plugin), with a
#      swift.org toolchain and the Swift wasm SDK — Xcode's toolchain can't
#      target wasm.
#   2. gzip -9 of the module into npm_cef/build/output (≈46 MB → ≈18 MB; the
#      page decompresses it with DecompressionStream).
#   3. webpack (npm_cef) into Sources/MonacoEditorCEF/Resources.
#
# Environment:
#   SWIFT_SDK   the wasm SDK to use (default: the newest `*_wasm` installed)
#   SWIFT       the swift executable (default: the swift.org toolchain whose
#               version matches the SDK, under ~/Library/Developer/Toolchains)
#   SKIP_WASM=1 reuse npm_cef/build/output and only run webpack
#
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PRODUCT="MonacoEditorWasm"
WEB="$ROOT/npm_cef"
OUTPUT="$WEB/build/output"
BUILD_PATH="$ROOT/.build-wasm"

if [ "${SKIP_WASM:-0}" != "1" ]; then
    SDK="${SWIFT_SDK:-}"
    if [ -z "$SDK" ]; then
        SDK="$(swift sdk list 2>/dev/null | grep -E '_wasm$' | sort -V | tail -1 || true)"
    fi
    if [ -z "$SDK" ]; then
        echo "error: no Swift wasm SDK installed (swift sdk list) —" \
             "see https://www.swift.org/documentation/articles/wasm-getting-started.html" >&2
        exit 1
    fi

    if [ -z "${SWIFT:-}" ]; then
        VERSION="${SDK%_wasm}"   # swift-6.3.3-RELEASE
        for candidate in \
            "$HOME/Library/Developer/Toolchains/$VERSION.xctoolchain/usr/bin/swift" \
            "/Library/Developer/Toolchains/$VERSION.xctoolchain/usr/bin/swift"; do
            if [ -x "$candidate" ]; then SWIFT="$candidate"; break; fi
        done
        if [ -z "${SWIFT:-}" ]; then
            NUMBER="${VERSION#swift-}"
            echo "error: no $VERSION toolchain for the $SDK SDK —" \
                 "install it with: swiftly install ${NUMBER%-RELEASE}" >&2
            exit 1
        fi
    fi

    echo "▸ Building $PRODUCT with $("$SWIFT" --version 2>/dev/null | head -1) for $SDK"
    "$SWIFT" package \
        --package-path "$ROOT" \
        --build-path "$BUILD_PATH" \
        -c release \
        --swift-sdk "$SDK" \
        js --use-cdn \
        --product "$PRODUCT"

    PACKAGE_OUTPUT="$BUILD_PATH/plugins/PackageToJS/outputs/Package"
    if [ ! -f "$PACKAGE_OUTPUT/$PRODUCT.wasm" ]; then
        echo "error: no $PRODUCT.wasm in $PACKAGE_OUTPUT — the wasm build failed" >&2
        exit 1
    fi

    echo "▸ Copying the module and its JS runtime to npm_cef/build/output"
    rm -rf "$OUTPUT"
    mkdir -p "$OUTPUT"
    cp -R "$PACKAGE_OUTPUT"/. "$OUTPUT"/
    echo "  $(du -h "$OUTPUT/$PRODUCT.wasm" | cut -f1) uncompressed"
    gzip -9 -f "$OUTPUT/$PRODUCT.wasm"
    echo "  $(du -h "$OUTPUT/$PRODUCT.wasm.gz" | cut -f1) gzipped"
fi

if [ ! -f "$OUTPUT/$PRODUCT.wasm.gz" ]; then
    echo "error: no $OUTPUT/$PRODUCT.wasm.gz — run without SKIP_WASM first" >&2
    exit 1
fi

echo "▸ Bundling the page (npm_cef → Sources/MonacoEditorCEF/Resources)"
cd "$WEB"
if [ ! -d node_modules ]; then
    npm install
fi
npx webpack --mode production --config webpack.config.js

echo "✓ Web bundle: $(du -sh "$ROOT/Sources/MonacoEditorCEF/Resources" | cut -f1) in Sources/MonacoEditorCEF/Resources"
