# Scenario: Investigating & Fixing a Bug

When a bug appears, don't just hack a fix. Use the toolkit to diagnose and resolve it systematically.

## The Goal

Fix a "Memory Leak" occurring during large file uploads.

---

### Step 1: Investigation

Start by gathering context on the problematic area.

```bash
/investigate "Trace the upload stream logic in the backend and check for unclosed resources."
```

### Step 2: Isolated Workspace

Initialize a fix folder.

```bash
/new fix-upload-leak
```

### Step 3: Diagnostic Debugging

Invoke the Debugger agent to find the root cause.

```bash
/debug "Analyze the leak during 500MB+ uploads. Suggest a streaming fix."
```

_The agent will analyze the code, propose a fix, and explain the 'Why'._

### Step 4: Verification (The most important step)

Ensure the bug is actually fixed and no regressions were introduced.

```bash
/test "Large file upload stability and memory usage benchmarks"
```

### Step 5: Polish & Archive

Review the changes for quality.

```bash
/final-polish
/archive fix-upload-leak
```

---

## Pro-Tip: Using `/second-opinion`

If the fix is complex (e.g., changing core networking logic), get a review before archiving:

```bash
/second-opinion "Does this streaming fix introduce any race conditions in the buffer management?"
```
