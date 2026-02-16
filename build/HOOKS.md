# Git Hooks Setup

This project includes pre-commit git hooks that automatically validate code before commits.

## What the Pre-Commit Hook Does

The `pre-commit` hook will:
1. Check for unapproved snapshot files (`.received.*`) - Ensures all Verify snapshots are approved
2. Run `dotnet build` - Ensures the code compiles
3. Run `dotnet test` - Runs all unit tests

If any step fails, the commit will be **aborted** and you'll need to fix the issues before trying again.

## Installation

### Linux / macOS

```bash
./build/install-hooks.sh
```

### Windows (PowerShell)

```powershell
.\build\install-hooks.ps1
```

## Snapshot Testing Workflow

When running tests locally, Verify creates `.received.*` files that must be approved before committing:

1. **Run tests** - Creates `.received.*` files with actual output
2. **Approve snapshots** - Review and approve changes using `verify` command:
   ```bash
   verify
   ```
   Or see [VERIFY.md](VERIFY.md) for other approval methods
3. **Commit** - Pre-commit hook checks for remaining `.received.*` files
   - If any found: commit is blocked with helpful instructions
   - If all approved: commit proceeds normally

This ensures only reviewed, approved snapshots are committed to git.

## Usage

Once installed, the pre-commit hook will automatically run every time you commit:

```bash
git commit -m "Your commit message"
# Pre-commit checks run automatically
```

## Bypassing the Hook

If you need to bypass the hook for a specific commit (not recommended):

```bash
git commit --no-verify
```

## Uninstalling Hooks

### Linux / macOS

```bash
rm .git/hooks/pre-commit
```

### Windows (PowerShell)

```powershell
Remove-Item .git/hooks/pre-commit
```

## Hook Files

- **`build/hooks/pre-commit`** - The pre-commit hook script (bash)
- **`build/install-hooks.sh`** - Installation script for Linux/macOS
- **`build/install-hooks.ps1`** - Installation script for Windows

## Troubleshooting

### Permission Denied on Linux/macOS

If you get a "permission denied" error, make the installation script executable:

```bash
chmod +x build/install-hooks.sh
./build/install-hooks.sh
```

### Hook Not Running

Verify the hook is installed and executable:

```bash
ls -la .git/hooks/pre-commit
```

The output should show the file is executable (has `x` permission).

### Build or Tests Failing

The hook will show you which step failed. Fix the issue and commit again:

```bash
# Fix compilation errors or test failures
git add .
git commit -m "Your message"
```
