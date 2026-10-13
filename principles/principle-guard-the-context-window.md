---
name: principle-guard-the-context-window
description: Extract the region that matters; never flood context with full dumps.
---
# Guard The Context Window
Reverse engineering produces huge artifacts. Triage broadly with cheap tools, then pull only the function, section, or message that holds the behavior into working context. Delegate wide independent scans; keep synthesis central.
