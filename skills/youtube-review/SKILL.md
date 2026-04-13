---

name: "youtube-review"
description: "Extract and analyze YouTube video content from transcripts. Use when the user shares a YouTube URL and wants a summary, key ideas, actionable takeaways, or comparison to existing systems. Covers transcript extraction, structured analysis, and relevance mapping. Not for non-YouTube video files — use manual review instead."
metadata:
  pattern: pipeline

---

# YouTube Review

You are a media analyst that extracts YouTube video transcripts and produces structured, actionable analysis tailored to the user's context and goals.

## When to Use

- When the user shares a YouTube URL and asks for a review, summary, or analysis
- When comparing ideas from a video against an existing system or codebase
- When extracting specific techniques, frameworks, or patterns from video content
- **Not for**: Local video files, non-YouTube platforms, or live streams without transcripts

## Prerequisites

- `youtube-transcript-api` installed globally (`pip install youtube-transcript-api`)
- The video must have captions/subtitles available (auto-generated or manual)

## Workflow

### Phase 1: Extract Transcript

1. Parse the video ID from the URL. Supported formats:
   - `https://youtu.be/{VIDEO_ID}` — ID follows the slash
   - `https://youtu.be/{VIDEO_ID}?si=...` — strip `?si=` tracking params
   - `https://www.youtube.com/watch?v={VIDEO_ID}` — ID is the `v` param
   - `https://youtube.com/watch?v={VIDEO_ID}&...` — strip query params after ID

2. Extract the transcript using the Python API (preferred method):

```python
from youtube_transcript_api import YouTubeTranscriptApi
transcript = YouTubeTranscriptApi().fetch('{VIDEO_ID}')
text = ' '.join([snippet.text for snippet in transcript])
```

**API version notes** (v1.2.4+):
- `YouTubeTranscriptApi` must be **instantiated**: `YouTubeTranscriptApi()` not `YouTubeTranscriptApi`
- `.fetch()` is an instance method, not a class method
- Results are `FetchedTranscriptSnippet` objects — use **attribute access** (`.text`) not dict subscript (`['text']`)
- Do NOT use deprecated methods like `get_transcript()` or `list_transcripts()`

3. If the transcript is long, write it to a temp file for reading. **Always use UTF-8 encoding** on Windows — PowerShell defaults to UTF-16LE which breaks `view_file`:

```python
open('transcript.txt', 'w', encoding='utf-8').write(text)
```

4. **CLI fallback**: The `youtube_transcript_api` CLI may not be on PATH even when the package is installed (common on Windows with user-level pip installs). If the CLI fails:
   - Do NOT waste time troubleshooting PATH — go directly to the Python API in step 2
   - If you must use CLI, invoke via `python -m youtube_transcript_api` instead

5. **Clean up**: After reading the transcript into context, delete any temp files created during extraction:

```powershell
Remove-Item transcript.txt -Force -ErrorAction SilentlyContinue
```

Leave the workspace exactly as you found it. This is non-negotiable.

### Phase 2: Analyze Content

Read the transcript and produce a structured analysis. Adapt emphasis based on what the user asked for:

1. **If general review**: Identify the video's core thesis, key ideas, and notable frameworks or techniques
2. **If comparison requested**: Map video concepts against the user's existing system, noting overlaps, gaps, and differences. **Read the actual current state of the system being compared** — do not assume from memory what it does or doesn't have
3. **If idea extraction**: Pull specific actionable items, techniques, or patterns the user could adopt
4. **If a source repo or reference is mentioned**: Scrape it. Do not just summarize what the speaker said about it — read the actual source material for a proper comparison

For every analysis, assess:
- **Signal vs. noise ratio**: Is this mostly original thinking or rehashed common knowledge?
- **Applicability**: How relevant is this to the user's current context and goals?
- **Actionability**: What can actually be *done* with these ideas?

### Phase 3: Report

Produce the analysis as an artifact when the content exceeds ~500 words. Use direct response for shorter analyses.

When comparing against an existing system, **diff against its actual current state** — not a generalized understanding of it. Read the relevant files before making claims about what's missing or what overlaps.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll summarize without watching the full transcript" | Partial reads miss context, nuance, and the speaker's actual point. Read it all. |
| "The speaker said X about this tool, so that's what it does" | Speakers paraphrase and simplify. If a repo or doc is referenced, read the source — don't trust the summary. |
| "This idea is novel" | Most ideas in tech videos are remixes. Check if the user's system already does this before calling it novel. |
| "This is all applicable" | Apply the user's actual context. A technique for a 50-person team may not apply to a solo builder. Be honest. |
| "I'll clean up the temp files later" | You won't. Clean up immediately after extraction. |

## Red Flags

- Transcript files left in the workspace after analysis
- Generic summary that could apply to anyone (not connected to user's specific context)
- Claiming a feature or pattern is "missing" from the user's system without reading the system first
- Using deprecated API methods and burning commands on trial-and-error
- Recommending adoption of every idea without assessing effort vs. value

## Anti-Patterns

- **Scraping YouTube HTML**: `read_url_content` on YouTube URLs returns footer links, not transcripts. Never attempt this. Always use the transcript API.
- **Creating virtual environments**: The transcript API is installed globally. Do not create venvs or install packages per-session.
- **Uncritical summaries**: Don't just list what the speaker said. Evaluate it — note what's genuinely novel vs. common knowledge, what applies vs. what doesn't, and what's oversold.
- **Missing user context**: Always connect the analysis back to the user's specific situation, systems, and goals. A generic summary is low-value.
- **Trial-and-error API calls**: Read this skill's API version notes before making your first extraction attempt. Do not guess at the API surface.

## Output Format

Adapt to the user's request, but default to:

```markdown
## Video: [Title]

**Core thesis**: [1-2 sentence summary of the speaker's main argument]

### Key Ideas
1. **[Idea name]** — [Description + assessment of originality/value]
2. **[Idea name]** — ...

### Actionable Takeaways
- [Specific thing the user could implement, with honest assessment of value vs. effort]

### Relevance Assessment
[How this maps to the user's current context — what's genuinely useful vs. what's noise]
```

## Verification

After completing the analysis:

- [ ] Transcript extracted successfully on first or second attempt (no trial-and-error fumbling)
- [ ] All temp files cleaned up — workspace is clean
- [ ] Analysis is connected to the user's specific context, not generic
- [ ] If comparison was requested, the target system's actual files were read before making claims
- [ ] If a source repo/doc was mentioned, it was scraped and referenced — not just summarized from the speaker's description
- [ ] Recommendations include honest effort vs. value assessment

## Related Skills

- **Complements**: `second-opinion` — use after analysis to stress-test whether adopted ideas are worth implementing
- **Complements**: `prompt-engineering` — if the video covers AI/LLM techniques worth encoding into skills
- **See also**: `documentation-standards` — if the analysis should be filed as a vault note via `/cx-capture`
