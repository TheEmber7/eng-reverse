---
name: principle-guard-the-context-window
description: Extract the region that matters; never flood context with full dumps.
---
# Guard The Context Window
Reverse engineering produces huge artifacts. Triage broadly with cheap tools, then pull only the function, section, or message that holds the behavior into working context. Delegate wide independent scans; keep synthesis central.

Wait once, never poll. A long decompile, fuzz run, or capture is one background job and one blocking wait. Repeated status checks and `sleep` each replay the whole context.
