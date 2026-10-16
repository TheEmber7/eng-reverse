# Mobile / APK Recon & Analysis

Authorization: dynamic analysis requires a scoped, authorized device/emulator. Preserve the original APK and extracted output before any patch or resign.

## Recon
- Unpack: `apktool d app.apk`, `unzip` for raw; decompile Java with `jadx`.
- Inventory: `AndroidManifest.xml` (exported activities/services/receivers/providers, deeplinks, permissions), native `.so` libs, bundled configs, assets, `res/`.
- Note defenses: SSL pinning, root detection, integrity/signature checks, string obfuscation, packers (e.g. commercial reinforcement), feature flags, token storage.
- Decide whether sensitive logic is in Java/Kotlin, JNI/native, or a bundled WebView.

## Analysis
- Static: map package structure, locate login/signing/risk-control/cert-check logic via strings and XREFs in jadx; read `smali` for the exact branch.
- Dynamic (authorized device): Frida to hook the narrowest trust boundary — request signer, crypto helper, keystore access, JNI marshaling, protobuf encode/decode. Record plaintext in, signed string out, headers, nonces.
- Identify and document pinning/root/integrity mechanisms and where they sit in the flow. On an owned or explicitly authorized test device, you may observe the real data path at that trust boundary; scope any such step to that device under the SKILL.md authorization gate, and do not ship a bypass of a third-party protection.
- `.so` present → switch to native analysis (see binary-recon.md).

## Verification
- Verify your reimplementation against your OWN authorized test account/endpoint: reproduce the client sequence (local state → nonce → body → signature → headers) and confirm it interoperates with the real format. Use only accounts and endpoints you own or are authorized to test.
- Keep hook logs, captured request shapes, and storage paths tied to one session/account.

## Common tools
apktool, jadx, frida/frida-tools, adb, objection, radare2 (for .so), mitmproxy/Burp (authorized traffic).
