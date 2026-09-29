// Bundles the MonacoEditorCEF page into ../Sources/MonacoEditorCEF/Resources:
// index.html, bundle.js (Monaco + the page's code + the wasm module's JS
// runtime), Monaco's workers, and the gzipped wasm module from build/output
// (scripts/build_web.sh puts it there).
const path = require('path');
const MonacoWebpackPlugin = require('monaco-editor-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
  entry: './index.js',
  devtool: false,
  output: {
    path: path.resolve(__dirname, '../Sources/MonacoEditorCEF/Resources'),
    filename: 'bundle.js',
    // Workers and chunks load relative to bundle.js — the page is served
    // under a per-process path prefix.
    publicPath: 'auto',
    globalObject: 'self',
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.ttf$/,
        type: 'asset/resource',
      },
    ],
  },
  plugins: [
    new CleanWebpackPlugin({
      cleanOnceBeforeBuildPatterns: ['**/*', '!README.md'],
    }),
    new HtmlWebpackPlugin({
      template: './index.html',
      inject: 'body',
    }),
    new MonacoWebpackPlugin({
      languages: ['python', 'swift', 'markdown', 'yaml', 'shell'],
    }),
    new CopyWebpackPlugin({
      patterns: [
        { from: 'build/output/MonacoEditorWasm.wasm.gz', to: '.' },
      ],
    }),
  ],
  resolve: {
    extensions: ['.js', '.json'],
    fallback: {
      // The WASI shim's Node paths, unused in a browser.
      path: false,
      fs: false,
    },
  },
  performance: {
    // Monaco and the wasm module are big by nature.
    hints: false,
  },
};
