# SonarQube Integration Guide

This project is configured for automated code quality analysis using SonarQube with the SonarAnalyzer for C#.

## Overview

SonarQube provides continuous inspection of code quality and security vulnerabilities. The TrekkingForCharity project includes:

- **SonarAnalyzer.CSharp** NuGet packages in all projects
- **Centralized ruleset** configuration in `.sonarqube/SonarQube.ruleset`
- **PowerShell script** for local analysis runs
- **GitHub Actions workflow** for automated CI/CD integration

## Prerequisites

- .NET 8.0 or higher
- SonarQube server (local or cloud instance)
- SonarQube authentication token
- **Windows**: PowerShell 5.0 or higher
- **Linux/macOS**: Bash shell with dotnet CLI

## Setup Instructions

### 1. Local SonarQube Server (Optional)

To run a local SonarQube instance using Docker:

```bash
docker run -d --name sonarqube \
  -p 9000:9000 \
  sonarqube:latest
```

Access at `http://localhost:9000` (default credentials: admin/admin)

### 2. Create a SonarQube Token

1. Navigate to your SonarQube instance
2. Go to **My Account** → **Security** → **Tokens**
3. Generate a new token
4. Copy and save the token securely

### 3. Running Analysis Locally

#### Using PowerShell Script (Windows)

```powershell
# First time setup (installs scanner)
.\build\SonarQube.ps1

# Run analysis
.\build\SonarQube.ps1 -SonarToken "your-token-here" -Analysis

# With custom SonarQube URL
.\build\SonarQube.ps1 -SonarToken "your-token-here" -SonarHostUrl "http://your-server:9000" -Analysis
```

#### Using Bash Script (Linux/macOS)

```bash
# First time setup (installs scanner)
./build/SonarQube.sh

# Run analysis
./build/SonarQube.sh --token "your-token-here" --analysis

# With custom SonarQube URL
./build/SonarQube.sh --token "your-token-here" --url "http://your-server:9000" --analysis

# View help
./build/SonarQube.sh --help
```

#### Using dotnet-sonarscanner directly

```bash
# Install scanner (if not already installed)
dotnet tool install --global dotnet-sonarscanner

# Begin analysis
dotnet sonarscanner begin \
  /k:"trekkingforcharity" \
  /d:sonar.host.url="http://localhost:9000" \
  /d:sonar.login="your-token-here"

# Build and test
dotnet build --configuration Release
dotnet test

# End analysis
dotnet sonarscanner end \
  /d:sonar.login="your-token-here"
```

### 4. GitHub Actions Integration

To enable automated SonarQube analysis in CI/CD:

1. Go to your repository Settings → Secrets
2. Add the following secrets:
   - `SONAR_TOKEN`: Your SonarQube authentication token
   - `SONAR_HOST_URL`: Your SonarQube server URL (e.g., `https://sonarqube.example.com`)

The workflow will run automatically on:
- Push to `main` or `develop` branches
- Pull requests targeting `main` or `develop`

## Configuration Files

### sonar-project.properties

Main SonarQube configuration file containing:
- Project identification (`sonar.projectKey`, `sonar.projectName`)
- Source code location
- Exclusion patterns
- C# specific settings

### .sonarqube/SonarQube.ruleset

XML ruleset file that defines analyzer rules and their severity levels:
- Security Hotspots (S2092, S3649, etc.)
- Code Smells (S1144, S1481, etc.)
- Bug Detection (S2259, S2583, etc.)
- Maintainability Rules (S101, S3776, etc.)

### Directory.Build.props

Central MSBuild property file that:
- Enables code analysis across all projects
- Applies the SonarQube ruleset
- Configures build-time analysis

## Quality Rules

The following key rule categories are monitored:

### Security Hotspots
- Cookie security
- SQL injection vulnerabilities
- LDAP injection
- JSON parsing issues

### Code Smells
- Unused variables and members
- Infinite loops
- Boolean literal usage
- Assignment operator issues

### Bugs
- Null pointer dereferences
- Unreachable conditions
- Duplicate code blocks

### Maintainability
- Class and method naming conventions
- Cyclomatic complexity
- Method parameter count
- TODO/FIXME comments

## Viewing Results

After analysis completes:

1. **Local Results**: Open `http://localhost:9000/dashboard?id=trekkingforcharity`
2. **CI/CD Results**: Check the GitHub Actions workflow logs and SonarQube dashboard
3. **Pull Request Comments**: SonarQube can post quality gate status to PRs (requires additional setup)

## Troubleshooting

### Analysis won't start

```bash
# Verify scanner is installed
dotnet tool list --global | grep sonarscanner

# Reinstall if needed
dotnet tool install --global --force dotnet-sonarscanner
```

### Connection issues

```bash
# Test connectivity to SonarQube server
curl http://localhost:9000/api/system/status
```

### Permission errors

- Verify your token has appropriate permissions
- Check that the `sonar.login` parameter includes the full token

## Best Practices

1. **Regular Scanning**: Integrate into your development workflow
2. **Quality Gates**: Set up quality gates to enforce standards
3. **Rule Customization**: Adjust rules in `SonarQube.ruleset` as needed
4. **Documentation**: Keep analysis results documented in PRs
5. **Trend Monitoring**: Track quality metrics over time

## Resources

- [SonarQube Documentation](https://docs.sonarqube.org/)
- [SonarAnalyzer for C#](https://github.com/SonarSource/sonar-dotnet)
- [Quality Rules Browser](https://rules.sonarsource.com/csharp)
- [GitHub - dotnet-sonarscanner](https://github.com/SonarSource/sonar-scanner-msbuild)
