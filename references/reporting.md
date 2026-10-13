# Reporting & Field Journal

Two outputs: a report for the task, and a field-journal entry for reusable precedent.

## Report structure
1. Outcome: what the artifact does and whether it is proven or `[INFERENCE]`.
2. Evidence → Finding → Path for each claim: the observation, what it means, the reproducible route.
3. Reproducible artifact: script / patch / keys / request recipe, rerunnable on a clean checkout.
4. Residual uncertainty and scope/authorization notes.
5. Redaction: every secret replaced with `<REDACTED>`.

## Field-journal entry (precedent)
One short file per non-trivial case:
- Target class (not the specific secret): e.g. "Android app with HMAC request signing + SSL pinning".
- The decisive trust boundary and the technique that cracked it.
- Pitfalls and what to try first next time.

This turns a one-off solve into method, per `principle-encode-lessons-in-structure`.
