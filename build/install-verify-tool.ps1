<#
.SYNOPSIS
    Setup script for Verify snapshot management tool
.DESCRIPTION
    Installs the dotnet global tool for managing Verify snapshots
.EXAMPLE
    .\build\install-verify-tool.ps1
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

Write-Host ""
Write-Info "Installing verify.tool..."
Write-Host ""

# Check if verify.tool is already installed
$installed = & dotnet tool list --global | Select-String "verify.tool"

if ($installed) {
    Write-Success "✓ verify.tool is already installed"
    Write-Host ""
    Write-Host "Usage: Run 'dotnet-verify review' from the project root to manage snapshots"
}
else {
    # Install verify.tool
    & dotnet tool install -g verify.tool
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Success "✓ verify.tool installed successfully!"
        Write-Host ""
        Write-Host "Usage:"
        Write-Host "  $(Write-Host 'dotnet-verify review' -ForegroundColor $Yellow)      - Interactive snapshot management"
        Write-Host ""
    }
    else {
        Write-Error-Custom "Failed to install verify.tool"
        exit 1
    }
}

Write-Host "For more information, see build/VERIFY.md"
Write-Host ""
