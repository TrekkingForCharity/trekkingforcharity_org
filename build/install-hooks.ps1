<#
.SYNOPSIS
    Git hooks installation script for Windows
.DESCRIPTION
    This script installs git hooks from build\hooks\ to .git\hooks\
.EXAMPLE
    .\build\install-hooks.ps1
#>

$ErrorActionPreference = "Stop"

# Colors
$Green = [System.ConsoleColor]::Green
$Red = [System.ConsoleColor]::Red
$Yellow = [System.ConsoleColor]::Yellow

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $Yellow
}

function Write-Success {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "ERROR: $Message" -ForegroundColor $Red
}

# Get repository root
try {
    $gitRoot = & git rev-parse --show-toplevel
}
catch {
    Write-Error-Custom "Not a git repository or git not installed"
    exit 1
}

$gitHooksDir = Join-Path $gitRoot ".git\hooks"
$sourceHooksDir = Join-Path $gitRoot "build\hooks"

# Check if .git\hooks directory exists
if (-not (Test-Path $gitHooksDir)) {
    Write-Error-Custom ".git\hooks directory not found"
    Write-Host "Make sure you're at the root of the repository"
    exit 1
}

# Check if source hooks directory exists
if (-not (Test-Path $sourceHooksDir)) {
    Write-Error-Custom "build\hooks directory not found"
    exit 1
}

Write-Host ""
Write-Info "Installing git hooks..."
Write-Host ""

# Install pre-commit hook
$sourcePreCommit = Join-Path $sourceHooksDir "pre-commit"
$targetPreCommit = Join-Path $gitHooksDir "pre-commit"

if (Test-Path $sourcePreCommit) {
    Copy-Item -Path $sourcePreCommit -Destination $targetPreCommit -Force
    Write-Success "✓ Installed pre-commit hook"
}
else {
    Write-Error-Custom "pre-commit hook not found at $sourcePreCommit"
    exit 1
}

Write-Host ""
Write-Success "Git hooks installed successfully!"
Write-Host ""
Write-Host "To uninstall hooks, run:"
Write-Host "  Remove-Item $(Join-Path $gitHooksDir `"pre-commit`")" -ForegroundColor $Yellow
Write-Host ""
Write-Host "To bypass hooks on a single commit, use:"
Write-Host "  git commit --no-verify" -ForegroundColor $Yellow
Write-Host ""
