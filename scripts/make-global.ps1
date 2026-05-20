# scripts/make-global.ps1
# This script mirrors the specwright into the Antigravity global directory.
# This ensures workflows, agents, skills, docs, and templates are accessible
# from any project without cross-workspace file access prompts.
#
# Run this script after making changes to the toolkit to sync updates.

$toolkitRoot = Resolve-Path "$PSScriptRoot\.."

# Identify active Antigravity global directories
$targetDirs = @()
$antigravityDir = Join-Path $env:USERPROFILE ".gemini\antigravity"
$antigravityIdeDir = Join-Path $env:USERPROFILE ".gemini\antigravity-ide"

if (Test-Path $antigravityDir) { $targetDirs += $antigravityDir }
if (Test-Path $antigravityIdeDir) { $targetDirs += $antigravityIdeDir }

if ($targetDirs.Count -eq 0) {
    Write-Error "No active Antigravity global directory found at $antigravityDir or $antigravityIdeDir"
    exit 1
}

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

function Safe-RemoveItem {
    param (
        [string]$Path
    )
    if (Test-Path $Path) {
        $item = Get-Item $Path -Force
        # Check if it's a symbolic link or junction (ReparsePoint)
        if ($item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
            if ($item.PSIsContainer) {
                # It's a directory symlink or junction
                [System.IO.Directory]::Delete($Path)
            } else {
                # It's a file symlink
                [System.IO.File]::Delete($Path)
            }
        } else {
            # It's a normal file or directory
            if ($item.PSIsContainer) {
                Remove-Item $Path -Force -Recurse
            } else {
                Remove-Item $Path -Force
            }
        }
    }
}

function Sync-ItemToGlobal {
    param (
        [string]$SourcePath,
        [string]$TargetPath,
        [bool]$IsDirectory = $false
    )

    # Remove existing to update using safe .NET-based deletion
    Safe-RemoveItem $TargetPath

    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Target $SourcePath -Force -ErrorAction Stop | Out-Null
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
Write-Host "Syncing specwright to global Antigravity directories..." -ForegroundColor Cyan
Write-Host "  Source:  $toolkitRoot" -ForegroundColor Gray
foreach ($targetDir in $targetDirs) {
    Write-Host "  Target:  $targetDir" -ForegroundColor Gray
}
Write-Host ""

foreach ($targetDir in $targetDirs) {
    Write-Host "Syncing to target: $targetDir..." -ForegroundColor Cyan
    
    foreach ($mapping in $dirMappings) {
        $sourceDir = Join-Path $toolkitRoot $mapping.Source
        $targetSubDir = Join-Path $targetDir $mapping.Target

        if (-not (Test-Path $sourceDir)) {
            Write-Host "  [SKIP] $($mapping.Source)/ not found" -ForegroundColor Yellow
            continue
        }

        # Ensure target directory exists and is a real directory (not a symlink/junction)
        if (Test-Path $targetSubDir) {
            $item = Get-Item $targetSubDir -Force
            if ($item.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)) {
                Safe-RemoveItem $targetSubDir
                New-Item -ItemType Directory -Path $targetSubDir -Force | Out-Null
            }
        } else {
            New-Item -ItemType Directory -Path $targetSubDir -Force | Out-Null
        }

        $sourceName = $mapping.Source
        $targetName = $mapping.Target

        if ($sourceName -eq "skills") {
            # Skills are directories — link/copy each skill folder
            $skillDirs = Get-ChildItem -Path $sourceDir -Directory
            $count = 0
            $result = "none"
            foreach ($skill in $skillDirs) {
                $target = Join-Path $targetSubDir $skill.Name
                $result = Sync-ItemToGlobal -SourcePath $skill.FullName -TargetPath $target -IsDirectory $true
                $count++
            }
            Write-Host "  [OK] $targetName/  ($count skill folders $result)" -ForegroundColor Green

        } elseif ($sourceName -eq "templates") {
            # Templates have subdirectories — link/copy the whole tree
            # Remove and re-sync the entire directory using Safe-RemoveItem
            Safe-RemoveItem $targetSubDir
            $result = Sync-ItemToGlobal -SourcePath $sourceDir -TargetPath $targetSubDir -IsDirectory $true
            $templateCount = (Get-ChildItem -Path $sourceDir -Recurse -File).Count
            Write-Host "  [OK] $targetName/  ($templateCount files $result)" -ForegroundColor Green

        } else {
            # Flat directories (workflows, agents, docs) — link/copy individual .md files
            $files = Get-ChildItem -Path $sourceDir -Filter "*.md"
            $count = 0
            $result = "none"
            foreach ($file in $files) {
                $target = Join-Path $targetSubDir $file.Name
                $result = Sync-ItemToGlobal -SourcePath $file.FullName -TargetPath $target
                $count++
            }
            Write-Host "  [OK] $targetName/  ($count files $result)" -ForegroundColor Green
        }
    }
}

Write-Host ""
Write-Host "Global sync complete!" -ForegroundColor Green
Write-Host "Workflows, agents, skills, docs, and templates are now available globally." -ForegroundColor White
Write-Host ""
