---
description: Deploy application changes.
quick_summary: "Detect deploy method → run pre-deploy checks → deploy → verify. Project-aware."
requires_mcp: []
recommends_mcp: [github, gcloud, firebase-mcp-server, observability]
---

# /deploy - Deployment

**Goal**: Deploy the current project to its target environment.

> **Skill Reference**:
>
> - [deployment-pipeline](../skills/deployment-pipeline/SKILL.md) — CI/CD and deployment protocols

## When to Use

- After code is committed and push is confirmed.
- As part of `/finish` (commit → **deploy** → archive).
- Any time you want to ship what's on the current branch.

## Steps

// turbo-all

1. **Detect deploy method**: Determine how this project deploys by checking (in order):

   | Signal                         | Deploy Method                          |
   | ------------------------------ | -------------------------------------- |
   | `firebase.json` exists         | `firebase deploy`                      |
   | `vercel.json` or `.vercel/`    | `vercel --prod`                        |
   | `fly.toml` exists              | `fly deploy`                           |
   | `Dockerfile` + `app.yaml`      | `gcloud app deploy`                    |
   | `Dockerfile` + Cloud Run cfg   | `gcloud run deploy`                    |
   | `package.json` has `deploy`    | `npm run deploy`                       |
   | `Makefile` has `deploy` target | `make deploy`                          |
   | Project profile lists CI/CD    | Follow what the profile documents      |
   | None of the above              | **Stop** — ask user for deploy command |
   - Check the project root for these signals.
   - If multiple signals match, prefer the most specific (e.g., `firebase.json` over `package.json` deploy script).
   - **If no method detected**: Ask the user. Do NOT guess or skip deployment.

2. **Pre-deploy checks**:
   - Run `git status` — confirm working directory is clean (all changes committed).
   - If there are uncommitted changes, **stop** and suggest running `/commit` first.
   - Run the project's lint/build if a build step exists (`npm run build`, etc.) — confirm it passes.

3. **Deploy**:
   - Run the detected deploy command.
   - Stream output and watch for errors.
   - If the deploy command fails, report the error and suggest troubleshooting steps.

4. **Post-deploy verification**:
   - If the project has a known URL: check that the deployed version is accessible (curl or browser check).
   - If Firebase: run `firebase hosting:channel:list` or check the hosting URL.
   - If no URL is known: report deploy command exit status and ask user to verify manually.
   - Summarize: deploy method used, target environment, success/failure.

## Firebase-Specific Notes

For Firebase projects, the deploy command depends on what's configured in `firebase.json`:

```bash
# Deploy everything configured
firebase deploy

# Deploy only functions
firebase deploy --only functions

# Deploy only hosting
firebase deploy --only hosting

# Deploy specific function(s)
firebase deploy --only functions:functionName
```

- Check `firebase.json` to determine which services are configured (hosting, functions, firestore rules, storage rules).
- If only one service is configured, deploy just that service.
- If multiple, deploy all unless the user specifies otherwise.

## Usage

```bash
# Deploy using auto-detected method
/deploy

# Deploy and specify environment
/deploy staging
```

## Notes

- This workflow is called automatically by `/finish` between `/commit` and `/archive`.
- For projects without a deploy pipeline, this workflow will ask the user for the deploy command and suggest adding it to the project profile for future runs.
