# Binary Recon & Analysis (ELF / PE / Mach-O, CTF, crackmes)

Phase mapping: Recon → Analysis → Verification. Adapt depth to the artifact.

## Recon
- Identify: `file`, `rabin2 -I`, magic bytes, arch/bitness, endianness, static vs dynamic linking.
- Packer/obfuscator: entropy scan (`binwalk -E`), unusual section names (UPX, `.themida`), tiny `.text` + huge packed section.
- Inventory: `strings -a -n 6`, `rabin2 -z` (data strings), `rabin2 -i` (imports), `rabin2 -E`/`-s` (exports/symbols), `readelf -a`, `objdump -d`.
- Mitigations: `checksec` (NX, PIE, RELRO, canary) for exploitation targets.

## Analysis
- Disassemble/decompile the narrowest function: radare2 (`r2 -A`, `pdf @ sym.main`), Ghidra/IDA/Binary Ninja for a decompiler view.
- Trace data flow for the value you care about (compared key, flag check, crypto constant). Follow XREFs to the comparison, not just the string.
- Dynamic within authorization: `gdb`/`pwndbg`, `ltrace`/`strace` for syscalls/libcalls, `frida`/`qiling`/`unicorn` for emulation of a single routine.
- Anti-debug: detect `ptrace`, timing checks, int3 scans; patch or hook the narrowest check to proceed.

## Verification
- Reconstruct the algorithm in a standalone script and confirm it reproduces the program's own accept condition on the program's own inputs.
- For CTF: the flag/accept path is the proof; keep the exact input that triggers it.

## Common tools
radare2/rizin, Ghidra, IDA, Binary Ninja, gdb+pwndbg, pwntools, angr, unicorn, qiling, binwalk, checksec.
