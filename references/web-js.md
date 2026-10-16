# Frontend JS / Web Recon & Analysis (obfuscated, minified, encrypted params)

## Recon
- Inventory: fetch the bundle, identify bundler (webpack/vite/rollup), check for sourcemaps (`.map`) — recover original sources first if present.
- Locate the signal: which request carries the encrypted/signed param; which cookie/header is suspicious.
- Note defenses: minification, string-array obfuscation, VM-based obfuscators, devtools/anti-debug (`debugger` loops), DOM/environment checks.

## Analysis
- Static: to understand and document client behavior for an app you own or are authorized to review, beautify (`prettier`/`js-beautify`), deobfuscate string arrays, and trace the param back to its builder function.
- Runtime (owned app or authorized review): set XHR/fetch breakpoints or hook `JSON.stringify`/crypto calls in DevTools/CDP; sample the function at the moment it computes the param to observe the real behavior.
- Node repro: re-run the isolated signing function under Node with a minimal browser-environment shim (`jsdom`/hand-rolled stubs) to reproduce outputs offline.

## Verification
- Reproduce the exact param value the live page produces for the same inputs, offline, with your standalone script. Matching one case is a lead; match across varied inputs.

## Common tools
Node, prettier/js-beautify, Chrome DevTools + CDP, Playwright/Puppeteer (authorized), mitmproxy, AST tools (babel/acorn).
