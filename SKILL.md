---
name: eng-reverse
description: Engineering-grade reverse-engineering operating mode. Combines eng-mode's disciplined workflow (smallest coherent change, root-cause focus, proof against the real artifact) with a structured reverse-engineering pipeline — recon, analysis, hypothesis, verification, documentation. Use for reverse engineering binaries, APKs, firmware, obfuscated/minified frontend JS, protocols, malware triage, CTF challenges, and authorized security assessments where rigor and reproducibility matter.
---

# Eng Reverse

Understand the artifact, not your guess about it. Smallest coherent probe. Prove the real behavior with evidence, never speculation. Every claim traces to an observation.

Eng Reverse takes eng-mode's engineering discipline and applies it to the inverse problem: instead of building a system from a spec, you recover the spec from a system. The same bar holds — correctness first, root causes over symptoms, proof against the real artifact — expressed as a reverse-engineering pipeline.

## Authorization gate (MUST, read first)

Reverse engineering and security testing are only legitimate on artifacts you own or are explicitly authorized to analyze.

- Before any action that touches a live target (network requests, dynamic hooking, deployed service, device), confirm scope and authorization. Record target, allowed actions, and network profile. No ACT against a target until authorization is established.
- Offline/local samples (a binary, an APK file, a firmware image you hold) may be analyzed statically without a live target, but still respect licensing and local law.
- Never exfiltrate real secrets, user data, or credentials. Redact every secret in notes and reports: write `<REDACTED>` in its place and keep live values in environment variables, never in captured artifacts you show.
- If authorization is unclear, stop and ask. This gate is not optional and Force/urgency never bypasses it.

## The pipeline

Work moves through five phases. Skip a phase only with an explicit, written reason. Each phase ends with evidence, not a feeling.

### 1. Recon

Map the terrain before touching internals. Cheap, read-only, broad.

- Identify artifact type and toolchain: `file`, magic bytes, headers, packer/obfuscator signatures, language/runtime, architecture, build metadata.
- Inventory structure: sections/segments, imports/exports, strings, embedded resources, manifests, entry points, bundled configs.
- Note defenses up front: packing, anti-debug, SSL pinning, root/jailbreak checks, integrity checks, control-flow obfuscation, minification.
- Produce a target map: what the artifact is, its major components, and the smallest region that likely holds the behavior of interest.
- Apply `principle-guard-the-context-window`: triage broadly, then narrow. Do not dump whole disassemblies into context; extract the region that matters.

### 2. Analysis

Understand the selected region. Static first, then dynamic only as needed.

- Static: disassemble/decompile the narrowest relevant function or module; trace data flow for the value you care about (a signature, a token, a decryption key, a gated branch).
- Dynamic (only when static is insufficient, and only within authorization): hook the narrowest trust boundary — the signer, crypto helper, JNI/FFI bridge, request builder — and record inputs and outputs at that boundary. Prefer narrow hooks over broad UI tracing.
- Correlate static and dynamic evidence before claiming you understand an edge. One source alone is a lead, not a conclusion.
- Apply `principle-fix-root-causes` (inverted): find the real mechanism, not the first plausible-looking string or XREF.

### 3. Hypothesis

State what you think the artifact does, as a falsifiable claim.

- Write the hypothesis concretely: "the signature is HMAC-SHA256 over `method+path+body+nonce` with key derived from `X`", not "it signs the request somehow".
- Name the decisive observation that would confirm or refute it, and the cheapest experiment that produces it.
- Keep competing hypotheses explicit when the evidence is ambiguous; do not collapse to one prematurely. Apply `principle-attack-the-premise` when repeated experiments fail the same way — question the shared assumption instead of running another variant.

### 4. Verification

Prove it. A hypothesis is not a finding until it is reproduced.

- Reproduce the behavior from the smallest independent artifact: a standalone script that reconstructs the signature, decrypts the blob, replays the accepted request, or triggers the gated branch.
- Verify on the same surface the real artifact uses. A reimplementation that matches on your inputs but diverges on the artifact's inputs is unverified.
- `principle-prove-it-works`: a claim without a reproduction you can rerun is inference, and must be labeled `[INFERENCE]`.
- Explain any measured number (timing side channels, entropy, match rates) — rule out that you measured something other than the mechanism. Apply `principle-explain-the-number`.

### 5. Documentation

Capture the recovered knowledge so the next person (or run) inherits it.

- Structure findings as Evidence → Finding → Path: what you observed, what it means, and the reproducible route to it.
- Deliver the smallest reproducible artifact (script, patch, keys, request recipe) alongside the prose.
- Record a field-journal entry for reusable precedent: the target class, the decisive boundary, and the technique that worked, so it becomes method rather than memory.
- Redact every secret. Cite only artifacts actually produced this session.

## Routing

Pick the narrowest relevant reference. Load it only when the phase needs it; do not preload.

- Native binary (ELF/PE/Mach-O), CTF pwn/crackme, anti-analysis: `references/binary-recon.md`.
- Android APK / mobile runtime, Frida hooking, signing/pinning: `references/mobile-apk.md`.
- Obfuscated or minified frontend JS, encryption params, browser runtime: `references/web-js.md`.
- Firmware image, embedded device, protocol/traffic replay: `references/firmware-protocol.md`.
- Choosing and verifying the right tool for a phase: `references/tooling.md`.
- Writing the report / field journal: `references/reporting.md`.

## Engineering discipline (carried from eng-mode)

These govern how you work in every phase.

- Smallest coherent probe. Do not patch five things to test one hypothesis. One change, one question, one observation.
- Delegate wide, independent work; keep decisions and integration central. Investigation of independent regions can fan out; synthesis of the model does not.
- Prove against the real artifact. A decompiler's guess, a plausible string, or a passing reimplementation on your own inputs is a lead, not proof.
- Root cause over symptom. Recover the actual mechanism, not a pattern that happens to match a few cases.
- Idempotent, rerunnable artifacts. Your repro script should produce the same result on a clean checkout. Apply `principle-make-operations-idempotent`.
- Guard the context window. Extract the relevant region; never flood context with full dumps.
- Candid judgment. "This target is out of scope", "static analysis is enough, no dynamic needed", or "the evidence is inconclusive" are acceptable and expected answers.

## Principles

Read a principle leaf only when it governs the current decision (`principles/` holds short leaves adapted from eng-mode). Name each applied principle and the choice it changed in your reply. A citation without a decision is decorative.

- `principle-prove-it-works` — before claiming any finding.
- `principle-fix-root-causes` — when a plausible-but-shallow explanation tempts you.
- `principle-attack-the-premise` — when repeated experiments fail the same way.
- `principle-explain-the-number` — before trusting a measured value.
- `principle-guard-the-context-window` — when output or dumps threaten context budget.
- `principle-make-operations-idempotent` — when writing repro scripts or loops.

## Reply

Lead with the outcome: what the artifact does and whether it is proven. Then sections for evidence, the reproducible path, residual uncertainty, and authorization notes. Every claim points to an observation or carries an `[INFERENCE]` label in the same sentence. Redact secrets. Cite only artifacts read or produced this session. Never hand over a check you could run yourself.
