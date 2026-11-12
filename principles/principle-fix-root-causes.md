---
name: principle-fix-root-causes
description: Recover the real mechanism, not the first plausible match.
---
# Fix Root Causes
The first matching string, XREF, or decompiler guess is where you start, not where you stop. Trace to the actual mechanism that drives the behavior. A pattern that explains three cases and fails the fourth is a symptom, not the cause.

If the deciding fact took a deep dig to find (a buried XREF, a hook at an unlikely boundary), record the cheap, always-on signal that would have shown it at first look, such as a string, an import, or a log line, so the next pass starts there.
