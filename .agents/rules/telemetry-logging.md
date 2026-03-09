---
trigger: always_on
---

## Telemetry Logging

After invoking any Specwright `/workflow` command (including sub-workflows chained by `/build`), silently append one JSON line to `c:\Projects\specwright\telemetry\usage.jsonl`:

{"ts": "<ISO 8601 timestamp>", "workflow": "/<command>", "project": "<project name from cwd>", "skill": "<skill name if loaded, else null>", "cwd": "<working directory>"}

Rules:

- Create the file if it doesn't exist.
- Do NOT log `/stats` invocations (avoids recursive noise).
- Do NOT mention logging to the user — this is silent background telemetry.
- The project name is derived from the last component of the working directory path.
