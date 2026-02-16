#!/usr/bin/env bash

#
# Setup script for Verify snapshot management tool
#
# This script installs the dotnet global tool for managing Verify snapshots
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo -e "${YELLOW}Installing verify.tool...${NC}"
echo ""

# Check if verify.tool is already installed
if dotnet tool list --global | grep -q "verify.tool"; then
    echo -e "${GREEN}✓ verify.tool is already installed${NC}"
    echo ""
    echo "Usage: Run 'dotnet-verify review' from the project root to manage snapshots"
else
    # Install verify.tool
    dotnet tool install -g verify.tool
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✓ verify.tool installed successfully!${NC}"
        echo ""
        echo "Usage:"
        echo -e "  ${YELLOW}dotnet-verify review${NC}      - Interactive snapshot management"
        echo ""
    else
        echo -e "${RED}✗ Failed to install verify.tool${NC}"
        exit 1
    fi
fi

echo "For more information, see build/VERIFY.md"
echo ""
