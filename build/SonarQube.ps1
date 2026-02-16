#!/usr/bin/env powershell
<#
.SYNOPSIS
    SonarQube analysis setup and execution script
.DESCRIPTION
    This script helps set up and run SonarQube analysis on the TrekkingForCharity project
.PARAMETER SonarToken
    SonarQube authentication token
.PARAMETER SonarHostUrl
    SonarQube server URL (default: http://localhost:9000)
.PARAMETER Analysis
    Run analysis (default: $false)
.EXAMPLE
    .\build\SonarQube.ps1 -SonarToken "your-token" -Analysis
#>

param(
    [string]$SonarToken,
    [string]$SonarHostUrl = "http://localhost:9000",
    [switch]$Analysis
)

$ErrorActionPreference = "Stop"

# Colors for output
$Green = [System.ConsoleColor]::Green
$Yellow = [System.ConsoleColor]::Yellow

function Write-Header {
    param([string]$Message)
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor $Green
    Write-Host $Message -ForegroundColor $Green
    Write-Host "=" * 70
}

function Write-Info {
    param([string]$Message)
    Write-Host $Message -ForegroundColor $Yellow
}

Write-Header "TrekkingForCharity SonarQube Analysis"

# Check if SonarQube Scanner is installed
Write-Info "Checking for SonarQube Scanner..."

$scannerPath = & dotnet tool list --global | Select-String "dotnet-sonarscanner"

if (-not $scannerPath) {
    Write-Info "Installing SonarQube Scanner for .NET..."
    dotnet tool install --global dotnet-sonarscanner
}
else {
    Write-Info "SonarQube Scanner is already installed"
}

if ($Analysis) {
    Write-Header "Running SonarQube Analysis"
    
    if (-not $SonarToken) {
        Write-Host "Error: SonarToken is required for analysis" -ForegroundColor Red
        exit 1
    }
    
    Write-Info "Starting SonarQube analysis..."
    
    # Begin analysis
    dotnet sonarscanner begin `
        /k:"trekkingforcharity" `
        /d:sonar.host.url="$SonarHostUrl" `
        /d:sonar.login="$SonarToken" `
        /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" `
        /d:sonar.coverage.exclusions="**/bin/**,**/obj/**"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to begin SonarQube analysis" -ForegroundColor Red
        exit 1
    }
    
    # Build
    Write-Info "Building solution..."
    dotnet build --configuration Release
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed" -ForegroundColor Red
        exit 1
    }
    
    # End analysis
    Write-Info "Completing SonarQube analysis..."
    dotnet sonarscanner end /d:sonar.login="$SonarToken"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nAnalysis completed successfully!" -ForegroundColor $Green
        Write-Host "View results at: $SonarHostUrl/projects" -ForegroundColor $Green
    }
    else {
        Write-Host "Failed to complete SonarQube analysis" -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Header "Setup Complete"
    Write-Host "To run SonarQube analysis, execute:"
    Write-Host "  .\build\SonarQube.ps1 -SonarToken <YOUR_TOKEN> -Analysis" -ForegroundColor $Yellow
    Write-Host ""
    Write-Host "Or with custom SonarQube URL:"
    Write-Host "  .\build\SonarQube.ps1 -SonarToken <YOUR_TOKEN> -SonarHostUrl http://your-server:9000 -Analysis" -ForegroundColor $Yellow
}
