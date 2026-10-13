---
name: principle-make-operations-idempotent
description: Repro scripts and loops should produce the same result on a clean run.
---
# Make Operations Idempotent
A repro script that only works once, or depends on leftover state from a previous run, is not proof. Make extraction, decryption, and replay scripts rerunnable from a clean checkout to the same result.
