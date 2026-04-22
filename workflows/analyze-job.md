---
description: Analyze a job posting against your profile for gap analysis, match scoring, and role classification
---

# Analyze Job

Compares a job posting against your professional profile to produce a structured gap analysis with match score, skill gaps, strengths, and strategic recommendations.

## Steps

### 1. Gather the Job Details

Get the job posting from the user. They may:
- Paste the full job description directly
- Provide a URL (use firecrawl-mcp to scrape it)
- Reference a job already tracked by title or company

If they provide a URL, scrape it first:
```
Use firecrawl_scrape to extract the job title, company, and full description.
```

### 2. Load the Candidate Profile

Read the candidate's profile and job history from the Obsidian vault:

```
view_file: c:\HQ\KB\40_Knowledge\professional-profile.md
  — Professional summary, skills, education, certs, target roles, previous role context

view_file: c:\HQ\KB\40_Knowledge\linkedin-export.md
  — Full job history with achievements, tools, methods, and metrics
```

Format the profile for analysis using this priority:
1. **Primary Source**: Job history from linkedin-export.md — real companies, dates, achievements with metrics
2. **Supplementary**: Skills, education, certifications from professional-profile.md
3. **Narrative**: Professional summary as additional context

### 3. Run the Analysis

Using the Career Strategist agent persona, analyze the job against the profile:

**Scoring Guidelines:**
- 90-100: Exceptional match, exceeds most requirements
- 75-89: Strong match, meets core requirements with minor gaps
- 60-74: Moderate match, has foundation but notable gaps
- 40-59: Below average match, significant gaps
- 0-39: Poor match, fundamental misalignment

**Produce these sections:**

1. **Match Score** (0-100) with overall assessment paragraph
2. **Hard Skill Gaps** — each with required level, candidate level, severity (low/medium/high/critical), and recommendation
3. **Experience Gaps** — years required vs candidate years, with recommendation
4. **Soft Skill Gaps** — evidence in posting, recommendation
5. **Strengths** — evidence in profile, relevance to posting
6. **Profile Suggestions** — questions to ask the candidate to discover hidden experience that could fill gaps
7. **Role Classification** — classify as `people_leadership`, `operations_systems`, or `hybrid` with reasoning citing specific posting signals

### 4. Present Results

Format as a structured markdown report with:
- Match score prominently displayed
- Gap summary (count by severity)
- Strengths highlighted as leverage points
- Role classification with strategy implications
- Profile suggestions as actionable next steps

### 5. Store Results

Save the analysis to the board repo output folder. **Every analysis.md MUST start with YAML frontmatter** before the analysis body:

```yaml
---
company: "[Company Name]"
title: "[Job Title]"
slug: [company-slug]
score: [0-100]
role_mode: [people_leadership | operations_systems | hybrid]
status: analyzed
analyzed_at: [YYYY-MM-DD]
vault_note: "[Vault filename.md]"   # only if vault note exists
---
```

Write the file:
```
write_to_file: c:\HQ\board\output\jobs\{company-slug}\analysis.md
```

If the job is tracked in the vault, update its status:
```
replace_file_content on the vault job file:
  status: new → status: analyzed
```

### 6. Apply / Not-Pursue Decision Gate

**Ask the user**: "Will you apply for this role?"

**If YES → Apply:**
- Update the analysis.md frontmatter:
  - `status: applied`
  - Add `applied_at: [YYYY-MM-DD]`
- Update the vault note status: `analyzed → applied`
- Update `pipeline.md` — move row to **Applied** section

**If NO → Not Pursuing:**
- Update the analysis.md frontmatter:
  - `status: not_pursued`
- Update the vault note status: `analyzed → not_pursued`
- Update `pipeline.md` — move row to **Not Pursued** section (or remove if not yet added)

> **Why this matters:** Only `applied`, `rejected`, `interviewing`, and `no_response` statuses are counted in search strategy metrics. `analyzed` and `not_pursued` are excluded. This keeps score averages and gap analysis clean.

### 7. Update Pipeline Dashboard

Update `c:\HQ\board\pipeline.md` — add or update the job's row in the appropriate section. Keep the pipeline sorted alphabetically within each section.

## Output Format

```markdown
---
company: "[Company Name]"
title: "[Job Title]"
slug: [company-slug]
score: [0-100]
role_mode: [people_leadership | operations_systems | hybrid]
status: analyzed
analyzed_at: [YYYY-MM-DD]
vault_note: "[Vault filename.md]"
---

# Gap Analysis: [Job Title] at [Company]

**Match Score: XX/100** — [Overall Assessment]
**Role Mode: [people_leadership | operations_systems | hybrid]**

## Strengths (X found)
- **[Area]**: [Evidence] → [Relevance]

## Gaps (X hard skill, X experience, X soft skill)

### Critical/High Priority
- **[Skill]** (critical): Required [X], You have [Y] → [Recommendation]

### Medium/Low Priority
- ...

## Profile Enhancement Opportunities
- **[Gap Area]**: [Question to ask yourself] → If yes, add: [suggestion]

## Strategic Recommendation
[Mode-specific advice based on role classification]
```

## Status Lifecycle

```
new → analyzed → applied → interviewing → [rejected | offer | withdrawn]
                         ↘ not_pursued
                         ↘ no_response
```

| Status | Counted in Stats? |
|---|---|
| `analyzed` | No |
| `not_pursued` | No |
| `applied` | Yes |
| `no_response` | Yes |
| `rejected` | Yes |
| `interviewing` | Yes |

## Skills Used

- `career-data` — file paths and frontmatter schemas for profile and job data
- `role-classifier` — 3-mode classification methodology

