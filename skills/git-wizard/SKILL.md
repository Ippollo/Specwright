---
name: git-wizard
description: Use when writing commit messages, recovering lost code, resolving merge conflicts, squashing or rewording commits, or managing branches. Follows conventional commit format with expert-level recovery and history cleanup protocols.
---

# Git Wizard

Expert-level Git capabilities beyond simple `add/commit`.

## Available Protocols

| Protocol                | Use When                                       |
| ----------------------- | ---------------------------------------------- |
| **Smart Commit**        | Save progress, need good commit message        |
| **Time Travel**         | Lost code, undo changes, find when bug started |
| **Conflict Resolution** | Merge conflict, rebase failed                  |
| **History Cleanup**     | Squash commits, reword message, clean branch   |
| **Branch Manager**      | Start feature, switch context                  |

## 1. Smart Commit Protocol

```bash
git diff --cached  # Check staged changes
```

**Conventional Commits format:**

```
type(scope): short description (<50 chars)

- WHY this change
- Technical detail if needed
```

| Type       | Use              |
| ---------- | ---------------- |
| `feat`     | New feature      |
| `fix`      | Bug fix          |
| `docs`     | Documentation    |
| `refactor` | Code restructure |
| `chore`    | Maintenance      |

## 2. Time Travel (Recovery)

```bash
git reflog                           # Find target state
git checkout -b recovery/<timestamp> # Create recovery branch
git restore --source=<commit> <file> # Restore specific file
```

**Find when bug started:**

```bash
git bisect start
git bisect bad
git bisect good <commit>
# Test and mark good/bad until found
git bisect reset
```

## 3. Conflict Resolution

```bash
git status                      # List conflicted files
git checkout --ours <file>      # Keep current branch version
git checkout --theirs <file>    # Keep incoming version
git add <file>                  # Mark resolved
git merge --continue            # Or: git rebase --continue
```

**Abort commands:** `git merge --abort`, `git rebase --abort`

## 4. History Cleanup

```bash
git rebase -i HEAD~<N>  # Interactive rebase last N commits
```

| Action   | Effect                                 |
| -------- | -------------------------------------- |
| `squash` | Combine with previous, keep messages   |
| `fixup`  | Combine with previous, discard message |
| `reword` | Change commit message                  |
| `drop`   | Delete commit                          |

## 5. Branch Manager

**Naming:** `type/short-description` (e.g., `feat/user-dashboard`)

```bash
git stash push -m "WIP: description"  # Save work
git checkout <other-branch>            # Switch
git stash pop                          # Restore
```

## Quick Reference

| Task                            | Command                      |
| ------------------------------- | ---------------------------- |
| Undo last commit (keep changes) | `git reset --soft HEAD~1`    |
| Undo last commit (discard)      | `git reset --hard HEAD~1`    |
| Find who changed a line         | `git blame <file>`           |
| Commit history for file         | `git log --follow -p <file>` |

---

## Additional Resources

For detailed documentation, see:

- [REFERENCE.md](file:///c:/Projects/agentic-toolkit/skills/git-wizard/REFERENCE.md) - Full examples, edge cases, decision trees
