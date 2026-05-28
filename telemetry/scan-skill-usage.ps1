<#
.SYNOPSIS
    Scans Antigravity conversation logs for skill invocations.

.DESCRIPTION
    Parses conversation overview files to find view_file calls targeting
    SKILL.md files. Produces a JSONL log and a human-readable markdown report.

    This is a retrospective scanner — it extracts usage data from existing
    conversation logs rather than requiring real-time logging.

.PARAMETER BrainDir
    Path to the Antigravity brain directory containing conversation logs.
    Defaults to $env:USERPROFILE\.gemini\antigravity\brain

.PARAMETER OutputDir
    Directory to write output files (usage.jsonl and usage-report.md).
    Defaults to the same directory as this script.

.PARAMETER SkillDirs
    Additional directories containing skills to check for zero-invocation
    detection. Each directory should contain subdirectories with SKILL.md files.

.EXAMPLE
    .\scan-skill-usage.ps1
    .\scan-skill-usage.ps1 -BrainDir "C:\Users\Me\.gemini\antigravity\brain"
#>

param(
    [string]$BrainDir = (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\brain"),
    [string]$OutputDir = $PSScriptRoot,
    [string[]]$SkillDirs = @()
)

# --- Setup ---

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$usageJsonl = Join-Path $OutputDir "usage.jsonl"
$usageReport = Join-Path $OutputDir "usage-report.md"

Write-Host "Skill Usage Telemetry Scanner"
Write-Host "=============================="
Write-Host "Brain directory: $BrainDir"
Write-Host ""

# --- Scan conversation logs ---

$results = [System.Collections.ArrayList]::new()
$seen = @{}  # dedup key tracking
$conversations = Get-ChildItem $BrainDir -Directory -ErrorAction SilentlyContinue
$total = $conversations.Count
$current = 0
$skipped = 0

foreach ($conv in $conversations) {
    $current++
    $convId = $conv.Name
    $overview = Join-Path $conv.FullName ".system_generated\logs\overview.txt"

    if (-not (Test-Path $overview)) {
        $skipped++
        continue
    }

    Write-Progress -Activity "Scanning conversations" -Status "$current / $total" `
        -PercentComplete (($current / $total) * 100)

    $lines = Get-Content $overview -ErrorAction SilentlyContinue
    foreach ($line in $lines) {
        # Quick filter: must mention both view_file and SKILL.md
        if ($line -notmatch 'view_file') { continue }
        if ($line -notmatch 'SKILL') { continue }

        # Extract timestamp
        $timestamp = ""
        if ($line -match '"created_at"\s*:\s*"([^"]+)"') {
            $timestamp = $Matches[1]
        }

        # Extract skill names from paths.
        # Handles various JSON escaping levels:
        #   skills\\\\skill-name\\\\SKILL.md  (double-escaped in nested JSON)
        #   skills\\skill-name\\SKILL.md      (single-escaped)
        #   skills/skill-name/SKILL.md        (forward slash)
        $skillMatches = [regex]::Matches($line, 'skills(?:\\+|/+)([a-zA-Z0-9_-]+)(?:\\+|/+)SKILL\.md')

        # Check if IsSkillFile was set (strong signal of execution vs. review)
        $isExecution = $line -match '"IsSkillFile"\s*:\s*"?true"?'

        foreach ($m in $skillMatches) {
            $skillName = $m.Groups[1].Value

            # Deduplicate: same skill + timestamp + conversation = one invocation
            $key = "$convId|$timestamp|$skillName"
            if ($seen.ContainsKey($key)) { continue }
            $seen[$key] = $true

            [void]$results.Add([PSCustomObject]@{
                Timestamp      = $timestamp
                Skill          = $skillName
                ConversationId = $convId
                IsExecution    = $isExecution
            })
        }
    }
}

Write-Progress -Activity "Scanning conversations" -Completed

# --- Write JSONL ---

$jsonLines = $results | ForEach-Object {
    @{
        timestamp       = $_.Timestamp
        skill           = $_.Skill
        conversation_id = $_.ConversationId
        is_execution    = $_.IsExecution
    } | ConvertTo-Json -Compress
}
$jsonLines | Set-Content $usageJsonl -Encoding UTF8

# --- Discover known skills for zero-invocation detection ---

$knownSkills = @{}

# Auto-discover: global skills directory
$globalDir = Join-Path $env:USERPROFILE ".gemini\antigravity-ide\skills"
if (Test-Path $globalDir) {
    Get-ChildItem $globalDir -Directory | ForEach-Object {
        $knownSkills[$_.Name] = "global"
    }
}

# Auto-discover: any additional directories passed via parameter
foreach ($dir in $SkillDirs) {
    if (Test-Path $dir) {
        Get-ChildItem $dir -Directory | Where-Object {
            Test-Path (Join-Path $_.FullName "SKILL.md")
        } | ForEach-Object {
            $knownSkills[$_.Name] = $dir
        }
    }
}

# --- Generate report ---

$skillCounts = $results | Group-Object Skill | Sort-Object Count -Descending

# Date range
$parsedDates = $results | Where-Object { $_.Timestamp } | ForEach-Object {
    try { [datetime]::Parse($_.Timestamp) } catch {}
} | Sort-Object
$firstDate = if ($parsedDates.Count -gt 0) { $parsedDates[0].ToString("yyyy-MM-dd") } else { "N/A" }
$lastDate = if ($parsedDates.Count -gt 0) { $parsedDates[-1].ToString("yyyy-MM-dd") } else { "N/A" }

$report = @"
# Skill Usage Report

> Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
> Data range: $firstDate to $lastDate
> Conversations scanned: $($total - $skipped) (of $total total, $skipped without logs)
> Total invocations: $($results.Count)

## Invocations by Skill

| Skill | Count | Last Used | Execution Reads |
|---|---|---|---|

"@

foreach ($group in $skillCounts) {
    $lastUsed = ($group.Group | ForEach-Object {
        try { [datetime]::Parse($_.Timestamp) } catch {}
    } | Sort-Object -Descending | Select-Object -First 1)
    $lastUsedStr = if ($lastUsed) { $lastUsed.ToString("yyyy-MM-dd") } else { "N/A" }
    $execCount = ($group.Group | Where-Object { $_.IsExecution }).Count
    $report += "| ``$($group.Name)`` | $($group.Count) | $lastUsedStr | $execCount |`n"
}

# Zero-invocation skills
$invokedSkills = $results | Select-Object -ExpandProperty Skill -Unique
$uninvoked = $knownSkills.Keys | Where-Object { $_ -notin $invokedSkills } | Sort-Object

if ($uninvoked.Count -gt 0) {
    $report += "`n## Skills with Zero Invocations`n`n"
    $report += "These skills were found in skill directories but never read in any conversation log:`n`n"
    foreach ($s in $uninvoked) {
        $report += "- ``$s`` ($($knownSkills[$s]))`n"
    }
}

$report += @"

---

## Notes

- **Count** includes all reads of SKILL.md (invocations, audits, and edits).
- **Execution Reads** counts reads where ``IsSkillFile=true`` was set — a stronger signal the skill was used for its intended purpose.
- **Zero Invocations** only checks auto-discovered skill directories. Pass ``-SkillDirs`` to add more.
- Raw data: ``usage.jsonl`` ($($results.Count) records)
"@

$report | Set-Content $usageReport -Encoding UTF8

# --- Summary ---

Write-Host ""
Write-Host "Done!"
Write-Host "  Conversations scanned: $($total - $skipped)"
Write-Host "  Total invocations: $($results.Count)"
Write-Host "  Unique skills: $(($results | Select-Object -ExpandProperty Skill -Unique).Count)"
if ($uninvoked.Count -gt 0) {
    Write-Host "  Zero-invocation skills: $($uninvoked.Count)"
}
Write-Host ""
Write-Host "Output:"
Write-Host "  $usageJsonl"
Write-Host "  $usageReport"
