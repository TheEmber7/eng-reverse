---
name: eng-reverse
description: Reverse-then-build operating mode. Recover a spec from an artifact with reverse-engineering discipline (recon, analysis, hypothesis), turn it into a build plan, then implement under eng-mode playbooks and principles, run a thermo-nuclear code quality self-review of the diff, and finish with verification and documentation. Use when you must reverse engineer (binaries, APKs, firmware, obfuscated JS, protocols, CTF, authorized assessments) and then plan and build a reimplementation, port, patch, client, or compatible tool with engineering rigor.
---

# Eng Reverse

**Reverse → Plan → Build → Self-review.** Both reverse-skill and eng-mode matter; the order is fixed.

1. **Reverse** recovers the spec from the artifact (evidence, not vibes).
2. **Plan** turns that recovered knowledge into a concrete build plan.
3. **Build** uses eng-mode discipline — smallest coherent change, root-cause fixes, prove against the real artifact — to implement the plan.
4. **Self-review** runs the Thermo-Nuclear Code Quality Review on your own diff and fixes what it finds before anything is called done.

Understand the artifact before you write code. Smallest coherent probe, then smallest coherent change. Every claim traces to an observation; every deliverable is proven.

## Authorization gate (MUST, read first)

Reverse engineering and security testing are only legitimate on artifacts you own or are explicitly authorized to analyze.

- Before any action that touches a live target (network requests, dynamic hooking, deployed service, device), confirm scope and authorization. Record target, allowed actions, and network profile. No ACT against a target until authorization is established.
- Offline/local samples (a binary, an APK file, a firmware image you hold) may be analyzed statically without a live target, but still respect licensing and local law.
- Never exfiltrate real secrets, user data, or credentials. Redact every secret in notes and reports: write `<REDACTED>` in its place and keep live values in environment variables, never in captured artifacts you show.
- If authorization is unclear, stop and ask. This gate is not optional and Force/urgency never bypasses it.
- The Build phase inherits the same scope: do not ship credentials, bypasses of third-party protections outside authorization, or code that attacks unauthorized targets.

## The pipeline

Work moves through eight phases. Skip a phase only with an explicit, written reason. Each phase ends with evidence or an artifact, not a feeling.

```
Recon → Analysis → Hypothesis → Plan → Build (eng-mode) → Thermo-Nuclear Self-Review → Verification → Documentation
\______________________________/   \____________________/   \________________________/
         reverse recovers                   eng-mode drives         review your own diff,
              the spec                        the build            fix before claiming done
```

### 1. Recon

Map the terrain before touching internals. Cheap, read-only, broad. (reverse-skill)

- Identify artifact type and toolchain: `file`, magic bytes, headers, packer/obfuscator signatures, language/runtime, architecture, build metadata.
- Inventory structure: sections/segments, imports/exports, strings, embedded resources, manifests, entry points, bundled configs.
- Note defenses up front: packing, anti-debug, SSL pinning, root/jailbreak checks, integrity checks, control-flow obfuscation, minification.
- Produce a target map: what the artifact is, its major components, and the smallest region that likely holds the behavior of interest.
- Apply `principle-guard-the-context-window`: triage broadly, then narrow. Do not dump whole disassemblies into context; extract the region that matters.

### 2. Analysis

Understand the selected region. Static first, then dynamic only as needed. (reverse-skill)

- Static: disassemble/decompile the narrowest relevant function or module; trace data flow for the value you care about (a signature, a token, a decryption key, a gated branch).
- Dynamic (only when static is insufficient, and only within authorization): hook the narrowest trust boundary — the signer, crypto helper, JNI/FFI bridge, request builder — and record inputs and outputs at that boundary. Prefer narrow hooks over broad UI tracing.
- Correlate static and dynamic evidence before claiming you understand an edge. One source alone is a lead, not a conclusion.
- Apply `principle-fix-root-causes` (inverted): find the real mechanism, not the first plausible-looking string or XREF.

### 3. Hypothesis

State what you think the artifact does, as a falsifiable claim. (reverse-skill)

- Write the hypothesis concretely: "the signature is HMAC-SHA256 over `method+path+body+nonce` with key derived from `X`", not "it signs the request somehow".
- Name the decisive observation that would confirm or refute it, and the cheapest experiment that produces it.
- Keep competing hypotheses explicit when the evidence is ambiguous; do not collapse to one prematurely. Apply `principle-attack-the-premise` when repeated experiments fail the same way — question the shared assumption instead of running another variant.
- A hypothesis that survives the decisive experiment becomes the **recovered spec** handed to Plan. Do not enter Plan on unfalsified speculation — label remaining gaps `[INFERENCE]` and carry them explicitly.

### 4. Plan

Turn the recovered spec into a build plan. Do not start writing production code in this phase.

- Write the recovered contract: inputs, outputs, invariants, error cases, and the surface the reimplementation must match (API, file format, protocol, CLI, library).
- Choose the deliverable: reimplementation, compatible client, port, patch, decoder, test harness, or documentation-only — and say why that choice is the smallest that satisfies the goal.
- Decompose into verifiable units: ordered steps, each with an observable acceptance check. Prefer a thin vertical slice that proves the core contract first.
- Name data shapes and module boundaries before APIs. Apply eng-mode's `principle-model-the-domain` and `principle-sequence-verifiable-units`.
- Call out risks, open `[INFERENCE]` gaps, and what will be proven in Verification versus assumed.
- Exit criterion: a short plan artifact (in the reply or a file) that a fresh eng-mode session could execute without re-deriving the reverse work. See `references/plan-build.md`.

### 5. Build (eng-mode)

Implement the plan under eng-mode discipline. This is where eng-mode owns the work. (eng-mode)

- Route the work: feature / bug-fix / refactoring / investigation as eng-mode would. Prefer the smallest coherent change that lands one verifiable unit at a time.
- Apply eng-mode principles at decision points — do not preload the catalog; read a leaf when it governs the choice and name the choice it changed:
  - `principle-laziness-protocol` / `principle-subtract-before-you-add` when sizing the diff.
  - `principle-model-the-domain` for stateful logic and shared shapes.
  - `principle-test-behavior-not-implementation` when writing tests.
  - `principle-migrate-callers-then-delete-legacy-apis` when replacing interfaces.
  - `principle-make-operations-idempotent` for scripts and lifecycle steps.
- Prove against the **real** contract recovered in reverse: call the code the way its users (or the original artifact) do. A green unit test that never exercises the recovered surface is not enough.
- Do not reopen reverse analysis mid-build unless Verification falsifies the recovered spec. If it does, return to Hypothesis with the new evidence — do not patch around a wrong model.
- If eng-mode itself is installed in the session (`/eng-mode` or sibling eng-mode skills), defer playbook routing, todo ownership, and delegation rules to it for this phase. This skill's Build section is the portable subset when eng-mode is not loaded.

### 6. Thermo-Nuclear Self-Review

After implementing, review your own work before claiming anything is done. Load `references/thermo-nuclear-review.md` and apply it in full to the diff you just produced.

- Scope: every change from Build (`git diff` against the pre-build base, plus new files). You are the author and the reviewer; hold your own code to the approval bar, not a lower one.
- Be ambitious: look for "code judo" restructurings that make branches, helpers, modes, or layers disappear while preserving behavior.
- Flag aggressively: giant files/functions, spaghetti conditionals, leaky or premature abstractions, duplicated logic, unclear names, dead code, and anything the reference lists.
- Fix, don't just report. Apply the remedies under eng-mode discipline (smallest coherent change, behavior unchanged), then re-review the updated diff. Loop until the reference's approval bar is met.
- Anything you consciously leave unfixed must be listed with a reason in the reply. Do not enter Verification with known violations silently carried.
- If a restructuring would change behavior or the recovered contract, it is not a review fix: go back to Plan.

### 7. Verification

Prove the build against the recovered contract and the original artifact.

- Reproduce the original behavior from the smallest independent artifact: a standalone script, round-trip test, or replay that matches the artifact's own inputs/outputs — not hand-picked cases alone.
- Verify on the same surface the real artifact uses. A reimplementation that matches on your inputs but diverges on the artifact's inputs is unverified.
- `principle-prove-it-works`: a claim without a reproduction you can rerun is inference, and must be labeled `[INFERENCE]`.
- Explain any measured number (timing, entropy, match rates) — rule out that you measured something other than the mechanism. Apply `principle-explain-the-number`.
- If Verification fails, diagnose whether the failure is in Build (fix under eng-mode) or in the recovered spec (return to Hypothesis → Plan). Do not silently widen scope.

### 8. Documentation

Capture both the reverse findings and the build so the next person inherits them.

- Structure reverse findings as Evidence → Finding → Path: what you observed, what it means, and the reproducible route to it.
- Document the plan and what shipped: the contract, the verifiable units, and how to rerun Verification.
- Deliver the smallest reproducible artifacts (scripts, patches, tests, request recipes) alongside the prose.
- Record a field-journal entry for reusable precedent: the target class, the decisive boundary, the technique that worked, and the build approach.
- Redact every secret. Cite only artifacts actually produced this session.

## Routing

Pick the narrowest relevant reference. Load it only when the phase needs it; do not preload.

- Native binary (ELF/PE/Mach-O), CTF pwn/crackme, anti-analysis: `references/binary-recon.md` (Recon/Analysis).
- Android APK / mobile runtime, Frida hooking, signing/pinning: `references/mobile-apk.md`.
- Obfuscated or minified frontend JS, encryption params, browser runtime: `references/web-js.md`.
- Firmware image, embedded device, protocol/traffic replay: `references/firmware-protocol.md`.
- Choosing and verifying the right tool for reverse phases: `references/tooling.md`.
- Plan → Build handoff and eng-mode mapping: `references/plan-build.md`.
- Post-build self-review standards: `references/thermo-nuclear-review.md` (always, in phase 6).
- Writing the report / field journal: `references/reporting.md`.

## Engineering discipline

These govern every phase — reverse and build.

- Smallest coherent probe, then smallest coherent change. One question or one unit at a time.
- Reverse before build. Do not implement from an unfalsified guess.
- Plan before code. A build without a plan re-derives the reverse work inside the editor.
- Review your own diff thermo-nuclear style and fix it before claiming done.
- Prove against the real artifact / recovered contract. Leads are not proof.
- Root cause over symptom — in analysis and in bug-fix alike.
- Idempotent, rerunnable artifacts. Apply `principle-make-operations-idempotent`.
- Guard the context window. Extract the region that matters; never flood context with full dumps.
- Candid judgment. Out of scope, inconclusive evidence, or "static is enough" are acceptable answers.

## Principles

Read a principle leaf only when it governs the current decision (`principles/` holds short leaves adapted from eng-mode). Name each applied principle and the choice it changed in your reply. A citation without a decision is decorative.

- `principle-prove-it-works` — before claiming any finding or shipping a unit.
- `principle-fix-root-causes` — when a plausible-but-shallow explanation tempts you.
- `principle-attack-the-premise` — when repeated experiments or fixes fail the same way.
- `principle-explain-the-number` — before trusting a measured value.
- `principle-guard-the-context-window` — when output or dumps threaten context budget.
- `principle-make-operations-idempotent` — when writing repro scripts, loops, or lifecycle steps.

When eng-mode is loaded, also apply its fuller principle set during Build (laziness, subtract-before-add, model-the-domain, test-behavior-not-implementation, sequence-verifiable-units, etc.) under the same citation rule.

## Reply

Lead with the outcome: what was recovered, what was planned, what was built, what the self-review found and fixed (and anything left, with reasons), and what is proven. Then sections for evidence, the plan, the reproducible path, residual uncertainty, and authorization notes. Every claim points to an observation or carries an `[INFERENCE]` label in the same sentence. Redact secrets. Cite only artifacts read or produced this session. Never hand over a check you could run yourself.
