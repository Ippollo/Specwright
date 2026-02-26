---
description: Stage, commit, and push changes using conventional commits.
quick_summary: "git status → stage → conventional commit → push. Always pushes."
requires_mcp: []
recommends_mcp: [github]
---

# /commit - Commit & Push Workflow

**Goal**: Stage, commit, and push changes in one consistent step.

> **Skill Reference**:
>
> - [git-wizard](../skills/git-wizard/SKILL.md) — Smart Commit protocol

## When to Use

- After `/final-polish` and before `/deploy` or `/archive`.
- Any time you want to save and push progress.

## Steps

// turbo-all

1. **Review changes**:

   ```bash
   git status
   git diff --stat
   ```

   - Summarize what changed for the user.

2. **Stage all changes**:

   ```bash
   git add -A
   ```

3. **Compose commit message** using the Smart Commit protocol:
   - Use **Conventional Commits** format: `type(scope): description`
   - Derive the type and scope from the staged changes.
   - Keep the subject line under 50 characters.

4. **Commit**:

   ```bash
   git commit -m "type(scope): description"
   ```

5. **Push**:

   ```bash
   git push
   ```

   - If the branch has no upstream, use `git push -u origin HEAD`.

6. **Verify**:
   ```bash
   git log --oneline -1
   ```

   - Confirm the commit hash and message, then notify the user.

## Usage

```bash
/commit
```
