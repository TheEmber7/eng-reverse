# Eng Reverse

**Reverse → Plan → Build → Self-review.** An agent skill that combines [zhaoxuya520/reverse-skill](https://github.com/zhaoxuya520/reverse-skill) (recover the spec) with [ajoslin/eng-mode](https://github.com/ajoslin/eng-mode) (an OMP port of Lauren Tan's *pstack*; plan and build under engineering discipline).

Both upstreams matter. The order is fixed:

1. **Reverse engineer** — recover the contract from the artifact with evidence.
2. **Plan** — turn that recovered knowledge into a concrete, verifiable build plan.
3. **Build with eng-mode** — implement under eng-mode playbooks and principles (smallest coherent change, root-cause fixes, prove against the real artifact).

4. **Thermo-nuclear self-review** — review your own diff with the Thermo-Nuclear Code Quality Review standards and fix issues before claiming done.

Then verify against the original artifact and document.

## What it is

A single `SKILL.md` that drives a eight-phase pipeline, each phase gated by evidence or an artifact:

```
Recon → Analysis → Hypothesis → Plan → Build (eng-mode) → Thermo-Nuclear Self-Review → Verification → Documentation
\______________________________/   \____________________/
         reverse recovers                   eng-mode drives
              the spec                        the build
```

1. **Recon** — map artifact type, structure, and defenses (cheap, read-only, broad).
2. **Analysis** — understand the narrowest relevant region; static first, then dynamic.
3. **Hypothesis** — falsifiable claim; survivors become the recovered spec.
4. **Plan** — contract, deliverable, verifiable units, data shapes, risks — no production code yet.
5. **Build (eng-mode)** — implement the plan under eng-mode playbooks/principles.
6. **Thermo-Nuclear Self-Review** — strict maintainability review of your own diff; fix and re-review until it passes.
7. **Verification** — reproduce against the artifact's own inputs/outputs.
8. **Documentation** — Evidence → Finding → Path, plan + what shipped, field journal.

reverse-skill's domain methodology (binary, APK/mobile, frontend JS, firmware/protocol, tooling, authorization gating, Evidence→Finding→Path) lives in `references/`. eng-mode's engineering principles are carried as short leaves under `principles/`, and Build defers to eng-mode itself when that plugin/skills are loaded. Plan→Build handoff details are in `references/plan-build.md`.

> **Authorization first.** Reverse engineering and security testing are only legitimate on artifacts you own or are explicitly authorized to analyze. The skill enforces an authorization gate before any live/dynamic action and requires secret redaction throughout. Build inherits the same scope.

## Layout

```
eng-reverse/
├── SKILL.md                  # the combined skill (frontmatter: name, description)
├── README.md                 # this file
├── LICENSE                   # MIT
├── CREDITS.md                # attribution + upstream license notes
├── principles/               # eng-mode principle leaves (reframed, used in reverse + build)
│   ├── principle-prove-it-works.md
│   ├── principle-fix-root-causes.md
│   ├── principle-attack-the-premise.md
│   ├── principle-explain-the-number.md
│   ├── principle-guard-the-context-window.md
│   └── principle-make-operations-idempotent.md
├── references/               # reverse domain + plan/build handoff
│   ├── binary-recon.md
│   ├── mobile-apk.md
│   ├── web-js.md
│   ├── firmware-protocol.md
│   ├── tooling.md
│   ├── plan-build.md         # Plan → eng-mode Build mapping
│   ├── thermo-nuclear-review.md # Phase 6 self-review standards
│   └── reporting.md
└── scripts/
    ├── recon.sh              # Phase 1 read-only triage helper (no network)
    └── repro_skeleton.py     # Phase 7 verification scaffold
```

## Install

This is a standard agent "skill" folder. Drop it where your agent discovers skills.

### Claude Code
Project-scoped:
```sh
mkdir -p .claude/skills
cp -r eng-reverse .claude/skills/eng-reverse
```
Or user-scoped: copy into `~/.claude/skills/eng-reverse`. Claude Code reads the frontmatter `name`/`description` and loads the skill when a task matches.

### Cursor
```sh
mkdir -p .cursor/skills        # project-scoped (or ~/.cursor/skills for user-scoped)
cp -r eng-reverse .cursor/skills/eng-reverse
```

### OMP / `.agents` layout (eng-mode native)
```sh
mkdir -p .agents/skills
cp -r eng-reverse .agents/skills/eng-reverse
```

For the full Build phase, also install [eng-mode](https://github.com/ajoslin/eng-mode) (`omp plugin install github:ajoslin/eng-mode`) so playbook routing and principles are available. Eng Reverse's Build section is the portable subset when eng-mode is not loaded.

After copying, start a session and invoke it by task ("reverse this APK's request signing and build a compatible client") or by name. Helpers: `scripts/recon.sh <artifact>` for read-only triage; `scripts/repro_skeleton.py` as a verification scaffold.

## Usage sketch

```
You: "Figure out how this binary checks the license key, then build a compatible checker."
Agent (eng-reverse):
  Recon      → file/rabin2/strings, spots the compared constant region
  Analysis   → decompiles the check, traces the comparison data flow
  Hypothesis → "key = base32(sha1(serial)[:10]) compared at 0x401abc"  → recovered spec
  Plan       → contract + verifiable units for a small checker CLI
  Build      → eng-mode feature playbook; implement unit by unit
  Review     → thermo-nuclear self-review of the diff; simplify and fix
  Verify     → checker accepts the binary's own serial/key pairs
  Document   → Evidence→Finding→Path + plan + field-journal precedent
```

## Credits & license

See [CREDITS.md](CREDITS.md). This combined work is released under the MIT License (`LICENSE`). Both upstreams are MIT at their repository root; the reverse-skill `CTF-Sandbox-Orchestrator/` subfolder is GPL-3.0 and **no code from that subfolder is included here** — only independently rewritten methodology. This skill does not redistribute source files from either upstream; it is an original synthesis that credits and links them.
