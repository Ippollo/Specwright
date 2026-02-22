# scripts/make-global.ps1
# This script links your local workflows to the Antigravity global customization folder.
# This ensures that any changes you make in this repo are instantly available everywhere.

$globalWorkflowDir = Join-Path $env:USERPROFILE ".gemini\antigravity\global_workflows"
$localWorkflowDir = Resolve-Path "$PSScriptRoot\..\workflows"

if (-not (Test-Path $globalWorkflowDir)) {
    Write-Error "Global workflow directory not found at $globalWorkflowDir. Please ensure Antigravity is installed."
    return
}

Write-Host "`nLinking local workflows to global customizations..." -ForegroundColor Cyan

$files = Get-ChildItem -Path "$localWorkflowDir\*.md"
foreach ($file in $files) {
    $target = Join-Path $globalWorkflowDir $file.Name

    # Remove existing to update link
    if (Test-Path $target) {
        Remove-Item $target -Force
    }

    try {
        New-Item -ItemType SymbolicLink -Path $target -Target $file.FullName -Force -ErrorAction Stop | Out-Null
        Write-Host "  [OK] Linked: $($file.Name)" -ForegroundColor Gray
    }
    catch {
        Write-Host "  [WARN] Failed to link $($file.Name) (Admin required). Falling back to Copy." -ForegroundColor Yellow
        Copy-Item -Path $file.FullName -Destination $target -Force
        Write-Host "  [OK] Copied: $($file.Name)" -ForegroundColor Gray
    }
}

Write-Host "`nGlobal setup complete!" -ForegroundColor Green
Write-Host "Your workflows will now appear in Customizations > Workflows in Antigravity." -ForegroundColor White
