# /coach - Reference Documentation

Extended documentation for the coach workflow. Read only when detailed information is needed.

## Example Session

```
You: /coach on

Me: 🎓 Coach mode enabled! I'll now:
    • Explain what I'm doing and why
    • Suggest toolkit workflows at key moments
    • Ask before taking complex actions
    • Teach while we work

    What would you like to work on?

You: I want to add dark mode to my app.

Me: Great goal! Let me help you approach this.

    📚 **Learning Moment**: "Dark mode" could be a quick CSS toggle or a major
    theme system overhaul. Before jumping in, it helps to clarify scope.

    **Your options:**

    1. **Quick approach** (< 1 hour)
       Just add a toggle and some CSS variables. I can do this directly.

    2. **Structured approach** (feature-sized work)
       Use `/new dark-mode` to create a change folder, then `/specify` and `/plan` to plan it.
       Better if this touches multiple components.

    Which feels right for your situation?

You: Let's do the structured approach, I want to learn.

Me: Perfect! Here's what we'll do:

    📍 **Phase: PLANNING**

    **Step 1**: Create the change folder

    > **Quick Ref: /new**
    > Creates a `changes/dark-mode/` folder with a proposal template.
    > This is your workspace for this feature.

    Running `/new dark-mode`...

    ✅ Created `changes/dark-mode/proposal.md`

    > **MCP Tip**: The `/new` workflow works best with **GitHub** enabled to link to your project board.

    **Step 2**: Generate planning docs

    > **Quick Ref: /specify + /plan**
    > `/specify` generates behavioral specs from your description.
    > `/plan` generates the design and task breakdown.

    Should I run `/specify "Add system-wide dark mode with user preference toggle"` and then `/plan`?

You: Yes, do it.

Me: ✅ Created `changes/dark-mode/specs/theme.md` and `changes/dark-mode/tasks.md`

    📍 **Phase: BUILDING**

    **Step 3**: Execute the task pipeline

    > **Quick Ref: /work**
    > Reads `tasks.md` and auto-advances through stages:
    > `/backend` → `/design` → `/security` → `/enhance` → `/test`

    Running `/work`...

    ✅ All tasks complete!

    📍 **Phase: VERIFYING**

    **Step 4**: Review the agent's work

    > **Quick Ref: /review**
    > Runs specialist agents over auto-proceeded work to catch issues.
    > Use this whenever `/work` auto-proceeded without your review.

    Should I run `/review` to audit the changes?

You: Yes.

Me: ✅ Review complete — 2 minor issues found and fixed.

    **Step 5**: Commit and push

    > **Quick Ref: /commit**
    > Stages, creates a conventional commit, and pushes. Always pushes.

    Running `/commit`...

    ✅ Committed and pushed!

    **Step 6**: Finalize and archive

    > **Quick Ref: /archive**
    > Merges your delta specs into `specs/` and cleans up the change folder.

    Ready to run `/archive dark-mode`?
```

## MCP Server Guidance

When suggesting workflows or agents, I'll check their MCP server requirements and guide you:

> **MCP Tip**: The `/investigate` workflow works best with these servers:
>
> - **GitHub** (recommended): Fetch issue history for context
> - **Context7** (recommended): Understand library APIs
> - **Firecrawl** (recommended): Scrape external documentation
>
> Check your `mcp_config.json` to see which are enabled. Over time, you'll learn which servers you use most.

**Teaching approach:**

- First time: Explain what the server does and why it helps
- Subsequent times: Just mention "works better with X enabled"
- Never require—always frame as recommended enhancements

## Disabling Coach Mode

When you're ready:

```
/coach off
```

I'll return to normal operation—faster, less explanation, trusting that you know the toolkit.
