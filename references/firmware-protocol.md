# Firmware & Protocol Recon & Analysis

## Firmware
- Recon: `binwalk` to carve filesystems/images, identify bootloader, kernel, squashfs/jffs2, architecture.
- Extract: `binwalk -e` / `unsquashfs`; inventory init scripts, services, and update/verify routines, and identify any hardcoded credentials — redact every secret (`<REDACTED>`) and never extract or exfiltrate it.
- Analysis: load extracted binaries into radare2/Ghidra (see binary-recon.md); map the self-update, crypto, and keying routines; identify XOR/rotate/self-keyed schemes.
- Verification: on firmware and keys you own or are authorized to test, verify your reimplementation by reconstructing the key/transform and reproducing a valid decrypt or signed image offline for interoperability.

## Protocol / traffic
- Recon: capture (authorized) with tcpdump/Wireshark/mitmproxy; identify framing, transport, encoding (protobuf, custom TLV, JSON).
- Analysis: diff messages to isolate per-field meaning; correlate with client code that builds/parses them.
- Verification: verify interoperability by building a client that round-trips a valid request/response against your OWN authorized test endpoint (within scope).

## Common tools
binwalk, unsquashfs, radare2/Ghidra, Wireshark/tcpdump, mitmproxy, protobuf-inspector.
