# Firmware & Protocol Recon & Analysis

## Firmware
- Recon: `binwalk` to carve filesystems/images, identify bootloader, kernel, squashfs/jffs2, architecture.
- Extract: `binwalk -e` / `unsquashfs`; inventory init scripts, services, hardcoded creds (redact), update/verify routines.
- Analysis: load extracted binaries into radare2/Ghidra (see binary-recon.md); map the self-update, crypto, and keying routines; identify XOR/rotate/self-keyed schemes.
- Verification: reconstruct the key/transform and reproduce a valid decrypt or a valid signed image offline.

## Protocol / traffic
- Recon: capture (authorized) with tcpdump/Wireshark/mitmproxy; identify framing, transport, encoding (protobuf, custom TLV, JSON).
- Analysis: diff messages to isolate per-field meaning; correlate with client code that builds/parses them.
- Verification: build a client that round-trips a valid request/response and gets accepted by the real endpoint (within scope).

## Common tools
binwalk, unsquashfs, radare2/Ghidra, Wireshark/tcpdump, mitmproxy, protobuf-inspector.
