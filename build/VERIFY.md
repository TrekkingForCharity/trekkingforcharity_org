# Verify Snapshot Management

This project uses [Verify](https://github.com/VerifyTests/Verify) for snapshot testing. This guide explains how to work with snapshot files.

## Understanding Snapshot Files

When tests run, Verify creates or compares snapshot files:

- **`.verified.` files**: The expected/approved snapshots (committed to git)
- **`.received.` files**: The actual test output (should be in `.gitignore`)

If actual output doesn't match the verified snapshot, the test fails and a `.received.` file is created for review.

## Managing Snapshots

### Option 1: Using Verify Tool (Recommended - Cross-Platform)

Install the dotnet tool globally:

```bash
dotnet tool install -g verify.tool
```

Then run from the project root to interactively manage snapshots:

```bash
dotnet-verify review
```

This provides an interactive menu to:
- View differences between `.received.` and `.verified.` files
- Approve changes (move `.received.` → `.verified.`)
- Reject changes (delete `.received.`)
- Compare files side-by-side

### Option 2: Using DiffEngineTray (Windows Only)

For Windows, download [DiffEngineTray](https://github.com/VerifyTests/DiffEngine/blob/main/docs/tray.md) for background tray support.

### Option 3: Diff Tools

Verify can launch your configured diff tool to review changes:

Configure your preferred diff tool and Verify will use it automatically when available tools include:
- Beyond Compare
- Araxis Merge
- KDiff3
- WinMerge
- And many others

### Option 4: Manual File Renaming

```bash
# Approve by renaming
mv tests/Api.Tests/WeatherForecastFunctionTests.GetSummary_MapsTemperatureToLabel.received.txt \
   tests/Api.Tests/WeatherForecastFunctionTests.GetSummary_MapsTemperatureToLabel.verified.txt
```

## Workflow

1. **Make code changes** that affect test output
2. **Run tests**: `dotnet test`
3. **Review differences**:
   ```bash
   dotnet-verify review  # Interactive mode, or
   ```
4. **Approve changes** you've verified are correct
5. **Commit `*.verified.*` files** to git
6. `.received.` files are automatically excluded from git

## Git Configuration

Your `.gitignore` should include:

```
*.received.*
```

And `.gitattributes` should have (for text files):

```
*.verified.txt text eol=lf working-tree-encoding=UTF-8
*.verified.json text eol=lf working-tree-encoding=UTF-8
*.verified.xml text eol=lf working-tree-encoding=UTF-8
```

## CI/CD Behavior

In CI environments:
- Tests fail if `.received.` files exist (indicating unexpected changes)
- Development can approve locally with `dotnet-verify review`
- Approved changes are committed and CI passes

## Troubleshooting

### FileNotFoundException for `.received.` files

This is normal - it means the test output doesn't match and needs review.

### `.received.` files don't appear

- Verify output is written to the test directory by default
- Check `tests/Api.Tests/` and `tests/Client.Tests/` directories
- Use `dotnet-verify review` command to locate them

### Verify tool won't reinstall

```bash
dotnet tool update -g verify.tool
```

## Resources

- [Verify Documentation](https://github.com/VerifyTests/Verify)
- [Snapshot Testing Concepts](https://github.com/VerifyTests/Verify/blob/main/docs/compared-to-assertion.md)
- [Verify Tool GitHub](https://github.com/VerifyTests/Verify)
