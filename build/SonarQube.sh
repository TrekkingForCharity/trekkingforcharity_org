#!/usr/bin/env bash

#
# SonarQube analysis setup and execution script
# 
# This script helps set up and run SonarQube analysis on the TrekkingForCharity project
#
# Usage:
#   ./build/SonarQube.sh [--help] [--token TOKEN] [--url URL] [--analysis]
#
# Options:
#   --help              Show this help message
#   --token TOKEN       SonarQube authentication token (required for --analysis)
#   --url URL           SonarQube server URL (default: http://localhost:9000)
#   --analysis          Run the analysis
#
# Examples:
#   ./build/SonarQube.sh --token "your-token" --analysis
#   ./build/SonarQube.sh --token "your-token" --url "http://sonarqube.example.com" --analysis
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
SONAR_TOKEN=""
SONAR_HOST_URL="http://localhost:9000"
RUN_ANALYSIS=false

# Functions
print_header() {
    echo ""
    echo "$(printf '=%.0s' {1..70})"
    echo -e "${GREEN}$1${NC}"
    echo "$(printf '=%.0s' {1..70})"
    echo ""
}

print_info() {
    echo -e "${YELLOW}$1${NC}"
}

print_error() {
    echo -e "${RED}ERROR: $1${NC}"
}

print_help() {
    cat << EOF
SonarQube Analysis Script for TrekkingForCharity

Usage: $(basename "$0") [OPTIONS]

Options:
    --help              Show this help message
    --token TOKEN       SonarQube authentication token (required for --analysis)
    --url URL           SonarQube server URL (default: http://localhost:9000)
    --analysis          Run the analysis

Examples:
    $(basename "$0") --token "your-token" --analysis
    $(basename "$0") --token "your-token" --url "http://sonarqube.example.com" --analysis

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --help)
            print_help
            exit 0
            ;;
        --token)
            SONAR_TOKEN="$2"
            shift 2
            ;;
        --url)
            SONAR_HOST_URL="$2"
            shift 2
            ;;
        --analysis)
            RUN_ANALYSIS=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            print_help
            exit 1
            ;;
    esac
done

# Main script
print_header "TrekkingForCharity SonarQube Analysis"

# Check if SonarQube Scanner is installed
print_info "Checking for SonarQube Scanner..."

if ! dotnet tool list --global | grep -q "dotnet-sonarscanner"; then
    print_info "Installing SonarQube Scanner for .NET..."
    dotnet tool install --global dotnet-sonarscanner
else
    print_info "SonarQube Scanner is already installed"
fi

if [ "$RUN_ANALYSIS" = true ]; then
    print_header "Running SonarQube Analysis"
    
    if [ -z "$SONAR_TOKEN" ]; then
        print_error "SonarToken is required for analysis"
        exit 1
    fi
    
    print_info "Starting SonarQube analysis..."
    
    # Begin analysis
    dotnet sonarscanner begin \
        /k:"trekkingforcharity" \
        /d:sonar.host.url="$SONAR_HOST_URL" \
        /d:sonar.login="$SONAR_TOKEN" \
        /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" \
        /d:sonar.coverage.exclusions="**/bin/**,**/obj/**"
    
    if [ $? -ne 0 ]; then
        print_error "Failed to begin SonarQube analysis"
        exit 1
    fi
    
    # Build
    print_info "Building solution..."
    dotnet build --configuration Release
    
    if [ $? -ne 0 ]; then
        print_error "Build failed"
        exit 1
    fi
    
    # End analysis
    print_info "Completing SonarQube analysis..."
    dotnet sonarscanner end /d:sonar.login="$SONAR_TOKEN"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}Analysis completed successfully!${NC}"
        echo -e "${GREEN}View results at: $SONAR_HOST_URL/projects${NC}"
    else
        print_error "Failed to complete SonarQube analysis"
        exit 1
    fi
else
    print_header "Setup Complete"
    echo "To run SonarQube analysis, execute:"
    echo -e "  ${YELLOW}./build/SonarQube.sh --token <YOUR_TOKEN> --analysis${NC}"
    echo ""
    echo "Or with custom SonarQube URL:"
    echo -e "  ${YELLOW}./build/SonarQube.sh --token <YOUR_TOKEN> --url http://your-server:9000 --analysis${NC}"
fi
