# Tooling Discipline

Carry eng-mode's rule: never guess a tool path or invent a flag. Verify the tool exists, then use documented invocations.

1. Before a phase, confirm the tools it needs are installed (`which`, `--version`). Record actual paths.
2. If a tool is missing, install it through the sanctioned package route; do not improvise a lookalike or run an unvetted script.
3. Prefer the narrowest tool that answers the question: `strings`/`rabin2 -z` before a full decompiler; one Frida hook before full instrumentation.
4. Keep every command reproducible: write the exact command (secrets redacted) into the report so the result can be rerun.
5. MCP servers (IDA MCP, Burp MCP, js-hook MCP, etc.) must be downloaded/registered/enabled before use — a referenced MCP is not an available one.

Tool-to-phase quick map: Recon → file/binwalk/strings/rabin2/jadx/apktool; Analysis → radare2/Ghidra/IDA/jadx/frida/gdb/DevTools; Verification → pwntools/Node/standalone repro scripts.
