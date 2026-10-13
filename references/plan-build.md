# Plan → Build (eng-mode handoff)

This reference covers phases 4–5 of Eng Reverse. Reverse work (Recon → Analysis → Hypothesis) must already have produced a recovered spec — including explicit `[INFERENCE]` gaps — before you open this file.

## Plan (phase 4)

Produce a short plan a fresh eng-mode session could execute:

1. **Recovered contract** — inputs, outputs, invariants, error cases, match surface (API / format / protocol / CLI).
2. **Deliverable** — reimplementation, client, port, patch, decoder, harness, or docs-only; one sentence on why it is the smallest fit.
3. **Verifiable units** — ordered steps, each with an observable acceptance check. First unit should prove the core contract.
4. **Data shapes & boundaries** — name canonical types and module edges before APIs (eng-mode: model-the-domain).
5. **Risks & gaps** — list `[INFERENCE]` items and what Verification will settle.

Exit when the plan is written. Do not start production implementation in Plan.

## Build (phase 5, eng-mode)

eng-mode drives implementation. Mapping:

| Plan need | eng-mode route |
|---|---|
| New or changed behavior | feature playbook |
| Defect vs recovered contract | bug-fix + diagnosing-bugs |
| Behavior-preserving reshape | refactoring playbook |
| Read-only "how does X work" leftover | investigation playbook |
| Contested design | architect / arena / interrogate |

Rules of thumb:

- Smallest coherent change per unit; migrate callers, delete legacy — no shims.
- Tests call the public surface the way users (or the original artifact) do; assert literal expected values.
- Fresh workers for bounded implementation; lead keeps integration and verification.
- If Verification falsifies the recovered spec, stop Build and return to Hypothesis — do not paper over a wrong model.

When `/eng-mode` or eng-mode skills are available in the session, defer playbook routing, todo ownership, and delegation to them. This skill's Build section is the portable subset otherwise.

Upstream: https://github.com/ajoslin/eng-mode
