# Eng Reverse

**An engineering-grade reverse-engineering agent skill.** It fuses the disciplined workflow of [ajoslin/eng-mode](https://github.com/ajoslin/eng-mode) (an OMP port of Lauren Tan's *pstack*) with the reverse-engineering methodology of [zhaoxuya520/reverse-skill](https://github.com/zhaoxuya520/reverse-skill), and turns both into one coherent operating mode for AI coding/security agents.

Where eng-mode asks "build the smallest correct change and prove it against the real artifact," Eng Reverse asks the inverse: **recover the spec from the system, and prove your understanding against the real artifact.** Same rigor, opposite direction.

## What it is

A single `SKILL.md` that drives a five-phase pipeline, each phase gated by evidence rather than vibes:

1. **Recon** — map the artifact type, structure, and defenses (cheap, read-only, broad).
2. **Analysis** — understand the narrowest relevant region, static first then dynamic.
3. **Hypothesis** — state a falsifiable claim and the cheapest experiment that settles it.
4. **Verification** — reproduce the behavior from an independent, rerunnable artifact against the target's own inputs.
5. **Documentation** — Evidence → Finding → Path, plus a reusable field-journal entry.

eng-mode's engineering principles (prove-it-works, fix-root-causes, attack-the-premise, explain-the-number, guard-the-context-window, make-operations-idempotent) are carried in as short leaves under `principles/`, reframed for reverse engineering. reverse-skill's domain methodology (binary, APK/mobile, frontend JS, firmware/protocol, tooling discipline, Evidence→Finding→Path reporting, authorization gating) lives in `references/`.

> **Authorization first.** Reverse engineering and security testing are only legitimate on artifacts you own or are explicitly authorized to analyze. The skill enforces an authorization gate before any live/dynamic action and requires secret redaction throughout.

## Layout

```
eng-reverse/
├── SKILL.md                  # the combined skill (frontmatter: name, description)
├── README.md                 # this file
├── LICENSE                   # MIT
├── CREDITS.md                # attribution + upstream license notes
├── principles/               # engineering principle leaves (from eng-mode, reframed)
│   ├── principle-prove-it-works.md
│   ├── principle-fix-root-causes.md
│   ├── principle-attack-the-premise.md
│   ├── principle-explain-the-number.md
│   ├── principle-guard-the-context-window.md
│   └── principle-make-operations-idempotent.md
├── references/               # domain methodology (from reverse-skill, rewritten)
│   ├── binary-recon.md
│   ├── mobile-apk.md
│   ├── web-js.md
│   ├── firmware-protocol.md
│   ├── tooling.md
│   └── reporting.md
└── scripts/
    ├── recon.sh              # Phase 1 read-only triage helper (no network)
    └── repro_skeleton.py     # Phase 4 verification scaffold
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

After copying, start a session and invoke it by task ("reverse engineer this APK's request signing") or by name. The scripts are optional helpers: `scripts/recon.sh <artifact>` for read-only triage, `scripts/repro_skeleton.py` as a verification scaffold.

## Usage sketch

```
You: "Figure out how this binary checks the license key."
Agent (eng-reverse):
  Recon      → file/rabin2/strings, spots the compared constant region
  Analysis   → decompiles the check, traces the comparison data flow
  Hypothesis → "key = base32(sha1(serial)[:10]) compared at 0x401abc"
  Verify     → standalone script reproduces an accepted key for the binary's own serial
  Document   → Evidence→Finding→Path + field-journal precedent
```

## Credits & license

See [CREDITS.md](CREDITS.md). This combined work is released under the MIT License (`LICENSE`). Both upstreams are MIT at their repository root; the reverse-skill `CTF-Sandbox-Orchestrator/` subfolder is GPL-3.0 and **no code from that subfolder is included here** — only independently rewritten methodology. This skill does not redistribute source files from either upstream; it is an original synthesis that credits and links them.
