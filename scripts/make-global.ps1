# scripts/make-global.ps1
# This script mirrors the specwright into the Antigravity global directory.
# This ensures workflows, agents, skills, docs, and templates are accessible
# from any project without cross-workspace file access prompts.
#
# Run this script after making changes to the toolkit to sync updates.

$antigravityDir = Join-Path $env:USERPROFILE ".gemini\antigravity"
$toolkitRoot = Resolve-Path "$PSScriptRoot\.."

# Mapping: local source directory → global target directory name
# global_workflows keeps its existing name for Antigravity compatibility.
# agents, skills, docs, templates are siblings so ../agents/ etc. resolve correctly.
$dirMappings = @(
    @{ Source = "workflows";  Target = "global_workflows" }
    @{ Source = "agents";     Target = "agents" }
    @{ Source = "skills";     Target = "skills" }
    @{ Source = "docs";       Target = "docs" }
    @{ Source = "templates";  Target = "templates" }
)

function Sync-ItemToGlobal {
    param (
        [string]$SourcePath,
        [string]$TargetPath,
        [bool]$IsDirectory = $false
    )

    # Remove existing to update
    if (Test-Path $TargetPath) {
        Remove-Item $TargetPath -Force -Recurse
    }

    try {
        if ($IsDirectory) {
            New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -Force -ErrorAction Stop | Out-Null
        } else {
            New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -Force -ErrorAction Stop | Out-Null
        }
        return "linked"
    }
    catch {
        if ($IsDirectory) {
            Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse -Force
        } else {
            Copy-Item -Path $SourcePath -Destination $TargetPath -Force
        }
        return "copied"
    }
}

Write-Host ""
Write-Host "Syncing specwright to global Antigravity directory..." -ForegroundColor Cyan
Write-Host "  Source:  $toolkitRoot" -ForegroundColor Gray
Write-Host "  Target:  $antigravityDir" -ForegroundColor Gray
Write-Host ""

foreach ($mapping in $dirMappings) {
    $sourceDir = Join-Path $toolkitRoot $mapping.Source
    $targetDir = Join-Path $antigravityDir $mapping.Target

    if (-not (Test-Path $sourceDir)) {
        Write-Host "  [SKIP] $($mapping.Source)/ not found" -ForegroundColor Yellow
        continue
    }

    # Ensure target directory exists
    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    $sourceName = $mapping.Source
    $targetName = $mapping.Target

    if ($sourceName -eq "skills") {
        # Skills are directories — link/copy each skill folder
        $skillDirs = Get-ChildItem -Path $sourceDir -Directory
        $count = 0
        foreach ($skill in $skillDirs) {
            $target = Join-Path $targetDir $skill.Name
            $result = Sync-ItemToGlobal -SourcePath $skill.FullName -TargetPath $target -IsDirectory $true
            $count++
        }
        Write-Host "  [OK] $targetName/  ($count skill folders $result)" -ForegroundColor Green

    } elseif ($sourceName -eq "templates") {
        # Templates have subdirectories — link/copy the whole tree
        # Remove and re-sync the entire directory
        if (Test-Path $targetDir) {
            Remove-Item $targetDir -Force -Recurse
        }
        $result = Sync-ItemToGlobal -SourcePath $sourceDir -TargetPath $targetDir -IsDirectory $true
        $templateCount = (Get-ChildItem -Path $sourceDir -Recurse -File).Count
        Write-Host "  [OK] $targetName/  ($templateCount files $result)" -ForegroundColor Green

    } else {
        # Flat directories (workflows, agents, docs) — link/copy individual .md files
        $files = Get-ChildItem -Path $sourceDir -Filter "*.md"
        $count = 0
        foreach ($file in $files) {
            $target = Join-Path $targetDir $file.Name
            $result = Sync-ItemToGlobal -SourcePath $file.FullName -TargetPath $target
            $count++
        }
        Write-Host "  [OK] $targetName/  ($count files $result)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "Global sync complete!" -ForegroundColor Green
Write-Host "Workflows, agents, skills, docs, and templates are now available globally." -ForegroundColor White
Write-Host ""
