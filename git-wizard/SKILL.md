---
schema_version: 1.0
name: git-wizard
description: "Expert-level Version Control protocols for conventional commits, recovery operations, conflict resolution, and history management."
---

# Git Wizard

This skill provides **Expert** level Git capabilities, going beyond simple `add/commit` to cover the full range of version control mastery.

> **Integration Note**: This skill uses the `prompt-engineering` protocols (Chain-of-Thought, Persona).

---

## 1. Smart Commit Protocol

**Use when**: The user wants to commit changes, "save progress", or asks for a good commit message.

> **Instruction**:
>
> 1.  **Analyze**: Run `git diff --cached`. If empty, run `git diff` to check for unstaged changes.
> 2.  **Reason (Chain-of-Thought)**: Analyze the diff. What essentially changed? Categorize it.
> 3.  **Generate**: Acting as a **Senior Tech Lead** who values clear, scannable commit history, draft a message following the [Conventional Commits](https://www.conventionalcommits.org/) specification.
> 4.  **Confirm**: Present the message to the user before executing.

### Conventional Commit Types

| Type       | When to Use                                           |
| ---------- | ----------------------------------------------------- |
| `feat`     | A new feature for the user                            |
| `fix`      | A bug fix                                             |
| `docs`     | Documentation only changes                            |
| `style`    | Formatting, missing semicolons (no code logic change) |
| `refactor` | Code restructuring without changing external behavior |
| `perf`     | Performance improvements                              |
| `test`     | Adding or correcting tests                            |
| `build`    | Changes to build system or dependencies               |
| `ci`       | CI configuration changes                              |
| `chore`    | Maintenance tasks (e.g., updating `.gitignore`)       |
| `revert`   | Reverting a previous commit                           |

### Message Format

```
type(scope): short description (imperative mood, <50 chars)

- Bullet point explaining WHY, not just what
- Another technical detail if needed

Refs: #123, #456
```

### Good vs. Bad Examples

| ❌ Bad        | ✅ Good                                        |
| ------------- | ---------------------------------------------- |
| `fixed stuff` | `fix(auth): prevent session timeout on idle`   |
| `updates`     | `feat(dashboard): add real-time notifications` |
| `WIP`         | `chore(deps): upgrade React to v18.2`          |

### Edge Cases

- **Diff too large (>500 lines)?** Summarize by file/component instead of line-by-line. Suggest splitting into multiple commits.
- **Mixed changes?** Recommend splitting into separate commits (e.g., `fix` + `refactor`).

---

## 2. Time Travel Protocol (Recovery)

**Use when**: "I lost the code from yesterday", "Undo this mess", "Find when this bug started", "Recover deleted file".

> **Instruction**:
>
> 1.  **Locate**: Use `git reflog` or `git log --oneline -20` to find the target state.
> 2.  **Isolate**: **NEVER** run hard resets on shared branches. Create a recovery branch: `git checkout -b recovery/<timestamp>`.
> 3.  **Restore**: Cherry-pick commits or `git restore --source=<commit> <file>` for specific files.
> 4.  **Verify**: Run the build/test suite to confirm the recovery worked.

### Git Bisect (Binary Bug Search)

**Use when**: "Find when this bug was introduced" or "This worked last week, what changed?"

```bash
# Start bisect
git bisect start

# Mark current state as bad
git bisect bad

# Mark a known good commit (e.g., from last week)
git bisect good <commit-hash>

# Git will checkout a middle commit. Test it, then:
git bisect good   # if the bug is NOT present
git bisect bad    # if the bug IS present

# Repeat until Git identifies the first bad commit
# When done:
git bisect reset
```

> **Tip**: For automated bisecting, use `git bisect run <test-script>` where the script exits `0` for good and `1` for bad.

### Edge Cases

- **Reflog is empty?** Check `git fsck --lost-found` for dangling commits.
- **Need to recover a deleted branch?** Use `git reflog` to find the last commit, then `git checkout -b <branch-name> <commit>`.

---

## 3. Conflict Resolution Protocol

**Use when**: "Merge conflict", "Rebase failed", "How do I fix this conflict?", or any `CONFLICT` message in Git output.

> **Instruction**:
>
> 1.  **Assess**: Run `git status` to list all conflicted files.
> 2.  **Understand**: For each file, identify the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
> 3.  **Resolve**: Choose the appropriate strategy per file:
>     - **Manual**: Edit the file to combine both changes logically.
>     - **Ours**: `git checkout --ours <file>` (keep current branch's version).
>     - **Theirs**: `git checkout --theirs <file>` (keep incoming branch's version).
> 4.  **Stage**: `git add <resolved-file>`.
> 5.  **Continue**: `git merge --continue` or `git rebase --continue`.

### Conflict Strategies Decision Tree

```
Is it a binary file (image, font, etc.)?
├── Yes → Choose one version: `git checkout --ours/--theirs <file>`
└── No → Is the conflict simple (few lines)?
    ├── Yes → Manually edit to combine changes
    └── No → Consider:
        ├── Using a merge tool: `git mergetool`
        └── Breaking the change into smaller PRs
```

### Abort & Escape Hatches

| Situation                  | Command                                 |
| -------------------------- | --------------------------------------- |
| Abandon a merge            | `git merge --abort`                     |
| Abandon a rebase           | `git rebase --abort`                    |
| Abandon a cherry-pick      | `git cherry-pick --abort`               |
| Undo a completed bad merge | `git reset --hard HEAD~1` (local only!) |

> [!CAUTION]
> Never force-push (`git push --force`) to shared branches without team coordination. Use `--force-with-lease` as a safer alternative.

---

## 4. History Cleanup Protocol

**Use when**: "Squash commits", "Clean up my branch", "Reword commit message", "Combine these commits".

> **Instruction**:
>
> 1.  **Safety First**: Ensure you're on a feature branch, NOT `main`/`master`.
> 2.  **Interactive Rebase**: `git rebase -i HEAD~<N>` where N is the number of commits to edit.
> 3.  **Choose Actions**: In the editor, change `pick` to the desired action.
> 4.  **Resolve Conflicts**: If conflicts arise, resolve and `git rebase --continue`.
> 5.  **Force Push**: `git push --force-with-lease` to update remote.

### Rebase Actions

| Action   | What It Does                                       |
| -------- | -------------------------------------------------- |
| `pick`   | Keep the commit as-is                              |
| `reword` | Keep the commit but edit the message               |
| `edit`   | Pause to amend the commit (add files, split, etc.) |
| `squash` | Combine with previous commit, keep both messages   |
| `fixup`  | Combine with previous commit, discard this message |
| `drop`   | Delete the commit entirely                         |

### Common Scenarios

**Squash last 3 commits into one:**

```bash
git rebase -i HEAD~3
# Change 2nd and 3rd commits from "pick" to "squash"
# Save, then write a combined commit message
```

**Fix a typo in last commit message:**

```bash
git commit --amend
# Or for older commits:
git rebase -i HEAD~<N>  # Change "pick" to "reword"
```

**Split a commit into two:**

```bash
git rebase -i HEAD~<N>  # Change "pick" to "edit"
git reset HEAD~1        # Unstage the commit
git add <subset>        # Stage first part
git commit -m "First part"
git add <rest>          # Stage second part
git commit -m "Second part"
git rebase --continue
```

> [!WARNING]
> Never rebase commits that have been pushed to shared branches and pulled by others. This rewrites history and causes divergence.

---

## 5. Branch Manager Protocol

**Use when**: "Start a new feature", "Switch context", or managing multiple work streams.

> **Instruction**:
>
> 1.  **Naming Convention**: Enforce `type/short-description` format.
> 2.  **Safety Check**: Before switching, check for uncommitted changes. Stash if necessary.
> 3.  **Sync**: Recommend pulling latest from base branch before creating new branches.

### Branch Naming Examples

| Type       | Example                    |
| ---------- | -------------------------- |
| Feature    | `feat/user-dashboard`      |
| Bug fix    | `fix/login-timeout`        |
| Hotfix     | `hotfix/security-patch`    |
| Experiment | `experiment/new-algorithm` |
| Release    | `release/v2.1.0`           |

### Context Switching Safely

```bash
# Save current work
git stash push -m "WIP: description of current work"

# Switch branches
git checkout <other-branch>

# ... do work ...

# Return and restore
git checkout <original-branch>
git stash pop
```

---

## Quick Reference

| Task                                 | Command                                                      |
| ------------------------------------ | ------------------------------------------------------------ |
| Undo last commit (keep changes)      | `git reset --soft HEAD~1`                                    |
| Undo last commit (discard changes)   | `git reset --hard HEAD~1`                                    |
| See what would be committed          | `git diff --cached`                                          |
| Find who changed a line              | `git blame <file>`                                           |
| See commit history for a file        | `git log --follow -p <file>`                                 |
| List all branches (with last commit) | `git branch -av`                                             |
| Delete merged branches               | `git branch --merged \| grep -v main \| xargs git branch -d` |

---

## Example Invocations

- "Run the Smart Commit protocol on my staged changes."
- "Use Time Travel to find when `validateUser` was deleted."
- "Help me resolve this merge conflict."
- "Clean up my branch—squash the last 5 commits."
- "Start a new feature branch for the payment system."
