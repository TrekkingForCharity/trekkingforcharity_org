#!/usr/bin/env bash

#
# Git hooks installation script for Linux/macOS
#
# This script installs git hooks from build/hooks/ to .git/hooks/
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_ROOT="$(git rev-parse --show-toplevel)"
GIT_HOOKS_DIR="$GIT_ROOT/.git/hooks"
SOURCE_HOOKS_DIR="$GIT_ROOT/build/hooks"

# Check if .git/hooks directory exists
if [ ! -d "$GIT_HOOKS_DIR" ]; then
    echo -e "${RED}Error: .git/hooks directory not found${NC}"
    echo "Make sure you're at the root of the repository"
    exit 1
fi

echo ""
echo -e "${YELLOW}Installing git hooks...${NC}"
echo ""

# Install pre-commit hook
if [ -f "$SOURCE_HOOKS_DIR/pre-commit" ]; then
    cp "$SOURCE_HOOKS_DIR/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    echo -e "${GREEN}✓ Installed pre-commit hook${NC}"
else
    echo -e "${RED}✗ pre-commit hook not found at $SOURCE_HOOKS_DIR/pre-commit${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Git hooks installed successfully!${NC}"
echo ""
echo "To uninstall hooks, run:"
echo -e "  ${YELLOW}rm $GIT_HOOKS_DIR/pre-commit${NC}"
echo ""
echo "To bypass hooks on a single commit, use:"
echo -e "  ${YELLOW}git commit --no-verify${NC}"
echo ""
