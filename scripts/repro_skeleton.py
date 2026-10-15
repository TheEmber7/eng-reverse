#!/usr/bin/env python3
"""repro_skeleton.py — Phase 7 (Verification) scaffold for Eng Reverse.

A repro must be rerunnable from a clean checkout and must verify against the
REAL artifact's own inputs/outputs, not hand-picked ones. Fill in the TODOs.

Discipline carried from eng-mode:
  - prove-it-works: reproduce, don't assert.
  - make-operations-idempotent: same result on a clean run.
  - never commit real secrets; load them from the environment, redact in output.
"""
from __future__ import annotations
import os
import sys


def recovered_algorithm(inputs: dict) -> str:
    """Your reconstructed mechanism (signature/decrypt/transform).

    Replace this body with the algorithm recovered during Analysis.
    """
    raise NotImplementedError("Implement the recovered algorithm here")


def load_ground_truth() -> list[tuple[dict, str]]:
    """Return (inputs, expected_output) pairs CAPTURED FROM THE REAL ARTIFACT.

    These must come from the target itself (e.g. observed signed requests),
    not values you computed. That is what makes this verification instead of
    self-confirmation.
    """
    # TODO: load captured samples (redact any secret before storing).
    return []


def main() -> int:
    cases = load_ground_truth()
    if not cases:
        print("[!] No ground-truth cases loaded — add captured samples first.")
        return 2
    passed = 0
    for i, (inputs, expected) in enumerate(cases):
        got = recovered_algorithm(inputs)
        ok = got == expected
        passed += ok
        print(f"case {i}: {'PASS' if ok else 'FAIL'}")
        if not ok:
            print(f"  expected: {expected}")
            print(f"  got:      {got}")
    print(f"\n{passed}/{len(cases)} cases reproduced against the real artifact.")
    return 0 if passed == len(cases) else 1


if __name__ == "__main__":
    sys.exit(main())
