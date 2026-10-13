# Credits & Attribution

Eng Reverse is an original synthesis. It does not copy source files verbatim from
either upstream; it reinterprets their ideas into one coherent skill with a fixed
flow: **reverse engineer → plan → build with eng-mode**. Full credit and thanks
to both upstreams.

## reverse-skill — reverse-engineering methodology (phases 1–3, 6–7)
- Source: https://github.com/zhaoxuya520/reverse-skill
- License: MIT at the repository root. Copyright (c) 2026 zhaoxuya520.
  NOTE: the `CTF-Sandbox-Orchestrator/` subdirectory is licensed GPL-3.0. No code
  or text from that subdirectory is included in Eng Reverse; the mobile/binary/
  firmware/JS methodology here was rewritten from the MIT-licensed top-level
  skills and general domain knowledge.
- What we drew from it: the domain pipeline for binaries, APKs, frontend JS,
  firmware, and protocols; the authorization/scope gate before touching a live
  target; secret redaction; the tool-verification discipline; and the
  Evidence → Finding → Path reporting with a reusable field journal.
- Role in Eng Reverse: **recover the spec** (Recon → Analysis → Hypothesis) and
  shape Verification/Documentation of reverse findings.

## eng-mode — engineering discipline & build workflow (phases 4–5, principles)
- Source: https://github.com/ajoslin/eng-mode
- An Oh My Pi (OMP) port of Lauren Tan's *pstack* plugin
  (https://github.com/cursor/plugins/tree/main/pstack).
- License: MIT. Copyright (c) 2026 Lauren Tan; Copyright (c) 2026 Andrew Joslin.
- What we drew from it: the "smallest coherent change / prove it against the real
  artifact / root-cause over symptom" philosophy, the principle-leaf pattern
  (read a principle only when it governs a decision, then name the decision it
  changed), context-window guarding, verifiable-unit sequencing, and playbook
  routing for feature / bug-fix / refactoring / investigation.
- Role in Eng Reverse: **Plan turns the recovered spec into a build plan; Build
  is driven by eng-mode** playbooks and principles. When eng-mode is installed in
  the session, defer to it for that phase.

## License of this work
MIT (see LICENSE). Compatible with both upstream root licenses. We deliberately
excluded the GPL-3.0 `CTF-Sandbox-Orchestrator/` content to keep this MIT-clean.
