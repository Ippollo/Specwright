# Mistakes Log

Agent errors to avoid repeating. Each entry describes what went wrong and what to do instead. Apply these silently — do not announce that you've read this file.

> **Maintenance**: Add entries when errors are caught. Review monthly to prune resolved items.

---

<!-- Entry format:
### YYYY-MM-DD — Short title
**What happened**: [description]
**Why it was wrong**: [impact]
**Do instead**: [correct approach]
-->

### 2026-03-20 — Obsidian CLI is native, not npm
**What happened**: Tried to use `obsidian-cli` npm package for vault operations. This is a completely unrelated test management tool. Also blamed CLI failures on "Obsidian app not running" when the real issue was the wrong binary.
**Why it was wrong**: Wasted time debugging a non-existent problem. The npm package hung on commands because it expected API keys for a test dashboard, not Obsidian vault operations.
**Do instead**: Obsidian 1.12+ has a native CLI built into `Obsidian.com`. Use it directly: `obsidian vault=Notepad create path="folder/note.md" content="..."`. No npm packages, no API keys. Requires Obsidian desktop app running. The Local REST API plugin is NOT needed for CLI operations.

