---
description: Scan project to identify relevant skills, detect gaps, and generate a project profile.
quick_summary: "Analyze tech stack, recommend skills, flag gaps, generate .agents/project-profile.md."
requires_mcp: []
recommends_mcp: [context7, github]
---

# /discover - Project Discovery

**Goal**: Analyze the current project to recommend relevant toolkit skills, identify gaps, and generate a persistent project profile.

## When to Use

- Starting work in a new project for the first time
- After adding major new dependencies or technologies
- When you're unsure which toolkit skills apply to the project
- Periodically, to catch drift as the project evolves

## Steps

// turbo-all

### Step 1: Scan Project

Analyze the project to detect its technology stack. Check these sources:

| Source                                | What to Extract                                 |
| ------------------------------------- | ----------------------------------------------- |
| `package.json`                        | Dependencies, devDependencies, scripts, engines |
| `requirements.txt` / `pyproject.toml` | Python packages                                 |
| `go.mod` / `Cargo.toml`               | Go/Rust dependencies                            |
| `tsconfig.json` / `jsconfig.json`     | TypeScript/JS config                            |
| `firebase.json` / `.firebaserc`       | Firebase services                               |
| `docker-compose.yml` / `Dockerfile`   | Containerization                                |
| `vite.config.*` / `next.config.*`     | Build tooling / frameworks                      |
| `tailwind.config.*`                   | CSS framework                                   |
| `.github/workflows/`                  | CI/CD                                           |
| `.env` / `.env.example`               | Environment variables (keys only, never values) |
| `prisma/` / `drizzle/` / `supabase/`  | ORM / BaaS                                      |
| File extensions scan                  | `.py`, `.go`, `.rs`, `.vue`, `.svelte`, etc.    |

### Step 2: Map to Global Skills

Compare detected technologies against the global `CATALOG.md` (`c:\Projects\specwright\CATALOG.md`).

**Known mappings** (extend as the catalog grows):

| Detected                    | Recommended Skill(s)                      |
| --------------------------- | ----------------------------------------- |
| React / Next.js             | `react-best-practices`                    |
| Vue / Svelte                | `vue-svelte-patterns`                     |
| REST APIs / GraphQL         | `api-design-patterns`                     |
| Firebase / Firestore        | `security-hardening`, `data-modeling`     |
| Docker / CI pipelines       | `deployment-pipeline`                     |
| Gemini SDK / AI integration | `gemini-api-dev`                          |
| Any test framework          | `unit-testing-strategy`, `webapp-testing` |
| Database schemas            | `data-modeling`                           |
| Git / complex branching     | `git-wizard`                              |
| Performance concerns        | `backend-performance`                     |

### Step 3: Identify Gaps

List technologies detected that have **no matching global skill**. For each gap:

- Name the technology
- Describe what a skill _could_ cover
- Rate the gap as **high** (core to the project) or **low** (peripheral)

### Step 4: Check for Local Skills

Scan `.agents/skills/` in the project root (if it exists) and list any project-local skills found. Verify each has a valid `SKILL.md`.

### Step 5: Generate Project Profile

Create or update `.agents/project-profile.md` using the template at `c:\Projects\specwright\templates\project-profile-template.md`.

- **If the file doesn't exist**: Generate it from the template.
- **If the file exists**: Merge new findings. Do NOT overwrite manual edits in the `Conventions` section.

### Step 6: Offer Gap Filling

For each **high-priority** gap identified in Step 3:

1. Ask the user if they want to create a **local skill** for it
2. If yes, use the `skill-builder` skill in **local mode** to scaffold `.agents/skills/<skill-name>/SKILL.md`
3. Update the profile's "Local Skills" section

## Output

After completing all steps, present a summary:

```
📋 Project Profile: .agents/project-profile.md

🔧 Tech Stack: [languages], [frameworks], [cloud], [database]

✅ Recommended Skills (N):
   - skill-name — reason

⚠️ Gaps Found (N):
   - Technology — no matching skill (priority)

📁 Local Skills (N):
   - skill-name — description
```

## Conditional Skills

- [skill-builder](../skills/skill-builder/SKILL.md): Load when the user wants to create a local skill to fill a gap.
- [skill-management](../skills/skill-management/SKILL.md): Reference for governance rules around local skills.

## Usage

```bash
# Full project scan
/discover

# Re-scan after adding new dependencies
/discover

# Quick check — just show what's recommended without generating profile
/discover --dry-run
```

## Next Steps

After discovery:

- Use `/specify` → `/plan` → `/work` to start building — workflows will reference the profile
- Use `/investigate` for deeper analysis of specific technologies
- Use `/skill` to create or enhance skills for identified gaps
