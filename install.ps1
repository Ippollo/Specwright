# Agentic Toolkit Installer (PowerShell)
# This script installs the Agentic Toolkit into your current project.
# Usage:
#   iwr -useb https://raw.githubusercontent.com/Ippollo/Specwright/main/install.ps1 | iex

$repoUrl = "https://github.com/Ippollo/Specwright.git"
$tempDir = Join-Path $env:TEMP "specwright-temp"

# 1. Clean up
if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }

Write-Host "🚀 Installing Agentic Toolkit from $repoUrl..." -ForegroundColor Cyan

# 2. Clone the toolkit
git clone --depth 1 $repoUrl $tempDir

if ($LASTEXITCODE -ne 0) {
    # Try the alternate 'skills' name if the first one fails
    $repoUrlAlt = "https://github.com/Ippollo/specwright.git"
    Write-Host "Retrying with $repoUrlAlt..." -ForegroundColor Yellow
    git clone --depth 1 $repoUrlAlt $tempDir
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to clone toolkit repository."
        return
    }
}

# 3. Setup Project Structure
Write-Host "📦 Setting up project structure..." -ForegroundColor Gray

# Create .agent/workflows if it doesn't exist
if (-not (Test-Path ".agent/workflows")) {
    New-Item -ItemType Directory -Force -Path ".agent/workflows" | Out-Null
}

# 4. Copy Components
# Copy Workflows
Copy-Item -Path "$tempDir/workflows/*.md" -Destination ".agent/workflows" -Force

# Copy Agents, Skills, and Templates to root (if they don't already exist or overwrite?)
$folders = @("agents", "skills", "templates")
foreach ($folder in $folders) {
    if (Test-Path "$tempDir/$folder") {
        Write-Host "  -> Copying $folder..." -ForegroundColor Gray
        Copy-Item -Path "$tempDir/$folder" -Destination "." -Recurse -Force
    }
}

# 5. Clean up
Remove-Item -Path $tempDir -Recurse -Force

Write-Host "`n✨ Agentic Toolkit successfully installed!" -ForegroundColor Green
Write-Host "Try these commands in your AI assistant:" -ForegroundColor White
Write-Host "  /constitution - Set project rules"
Write-Host "  /brainstorm    - Explore ideas"
Write-Host "  /new <name>   - Start a new feature"
Write-Host "  /plan          - Create an implementation plan"
Write-Host "`nEnjoy your superpower! 🦸" -ForegroundColor Cyan
