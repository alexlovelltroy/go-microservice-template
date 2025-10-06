#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
#
# SPDX-License-Identifier: MIT

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_OWNER="OpenCHAMI"
DEFAULT_TEMPLATE_OWNER="alexlovelltroy"
DEFAULT_TEMPLATE_REPO="go-microservice-template"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}OpenCHAMI Go Microservice Setup Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Get repository information
echo -e "${YELLOW}Please provide your repository information:${NC}"
echo ""

read -p "Repository owner/organization (default: ${DEFAULT_OWNER}): " REPO_OWNER
REPO_OWNER=${REPO_OWNER:-$DEFAULT_OWNER}

read -p "Repository name: " REPO_NAME
if [ -z "$REPO_NAME" ]; then
    echo -e "${RED}Error: Repository name is required${NC}"
    exit 1
fi

read -p "Project description: " PROJECT_DESC
if [ -z "$PROJECT_DESC" ]; then
    PROJECT_DESC="A Go microservice in the OpenCHAMI project"
fi

read -p "Copyright holder (default: OpenCHAMI Contributors): " COPYRIGHT_HOLDER
COPYRIGHT_HOLDER=${COPYRIGHT_HOLDER:-"OpenCHAMI Contributors"}

read -p "Current year (default: $(date +%Y)): " YEAR
YEAR=${YEAR:-$(date +%Y)}

echo ""
echo -e "${YELLOW}Summary:${NC}"
echo "  Owner:       ${REPO_OWNER}"
echo "  Repository:  ${REPO_NAME}"
echo "  Description: ${PROJECT_DESC}"
echo "  Copyright:   ${COPYRIGHT_HOLDER}"
echo "  Year:        ${YEAR}"
echo ""

read -p "Proceed with these values? (y/n): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Setting up project README...${NC}"

# Convert project name to title case for README
PROJECT_NAME_TITLE=$(echo "${REPO_NAME}" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

# Create new README from template
if [ -f "README.template" ]; then
    cat README.template | \
        sed "s|{{REPO_OWNER}}|${REPO_OWNER}|g" | \
        sed "s|{{REPO_NAME}}|${REPO_NAME}|g" | \
        sed "s|{{PROJECT_NAME}}|${PROJECT_NAME_TITLE}|g" | \
        sed "s|{{PROJECT_DESCRIPTION}}|${PROJECT_DESC}|g" | \
        sed "s|{{COPYRIGHT_HOLDER}}|${COPYRIGHT_HOLDER}|g" | \
        sed "s|{{YEAR}}|${YEAR}|g" > README.md.new

    mv README.md.new README.md
    echo "  ✓ Created new README.md from template"

    # Remove the README template file
    rm -f README.template
    echo "  ✓ Removed README.template"
else
    echo -e "${YELLOW}  ⚠ README.template not found, keeping original README${NC}"
fi

echo ""
echo -e "${GREEN}Updating repository references...${NC}"

# Function to replace in file
replace_in_file() {
    local file=$1
    local search=$2
    local replace=$3

    if [ -f "$file" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s|${search}|${replace}|g" "$file"
        else
            # Linux
            sed -i "s|${search}|${replace}|g" "$file"
        fi
        echo "  ✓ Updated $file"
    fi
}

# Files to update (excluding README.md since it's already done)
FILES=(
    "go.mod"
    ".goreleaser.yaml"
    ".github/CODEOWNERS"
)

# Update repository references
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        replace_in_file "$file" "${DEFAULT_TEMPLATE_OWNER}/${DEFAULT_TEMPLATE_REPO}" "${REPO_OWNER}/${REPO_NAME}"
        replace_in_file "$file" "github.com/${DEFAULT_TEMPLATE_OWNER}/${DEFAULT_TEMPLATE_REPO}" "github.com/${REPO_OWNER}/${REPO_NAME}"
    fi
done

# Update copyright year and holder
echo ""
echo -e "${GREEN}Updating copyright information...${NC}"

# Update LICENSES/MIT.txt
if [ -f "LICENSES/MIT.txt" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|Copyright (c) <year> <copyright holders>|Copyright (c) ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSES/MIT.txt"
        sed -i '' "s|SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors|SPDX-FileCopyrightText: ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSES/MIT.txt"
    else
        sed -i "s|Copyright (c) <year> <copyright holders>|Copyright (c) ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSES/MIT.txt"
        sed -i "s|SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors|SPDX-FileCopyrightText: ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSES/MIT.txt"
    fi
    echo "  ✓ Updated LICENSES/MIT.txt"
fi

# Update LICENSE if it's a symlink
if [ -L "LICENSE" ]; then
    echo "  ℹ LICENSE is a symlink to LICENSES/MIT.txt (already updated)"
elif [ -f "LICENSE" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|Copyright (c) 2025 OpenCHAMI Contributors|Copyright (c) ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSE"
        sed -i '' "s|SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors|SPDX-FileCopyrightText: ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSE"
    else
        sed -i "s|Copyright (c) 2025 OpenCHAMI Contributors|Copyright (c) ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSE"
        sed -i "s|SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors|SPDX-FileCopyrightText: ${YEAR} ${COPYRIGHT_HOLDER}|g" "LICENSE"
    fi
    echo "  ✓ Updated LICENSE"
fi

# Update go.mod module path
echo ""
echo -e "${GREEN}Updating Go module...${NC}"
if [ -f "go.mod" ]; then
    echo "  ✓ Updated go.mod module path"
    echo ""
    echo -e "${YELLOW}Running 'go mod tidy'...${NC}"
    go mod tidy
    echo "  ✓ Go modules tidied"
fi

# Update CHANGELOG
if [ -f "CHANGELOG.md" ]; then
    echo ""
    echo -e "${GREEN}Updating CHANGELOG...${NC}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s|## \[1.0.0\] - 2025-10-05|## [Unreleased]|g" "CHANGELOG.md"
    else
        sed -i "s|## \[1.0.0\] - 2025-10-05|## [Unreleased]|g" "CHANGELOG.md"
    fi
    echo "  ✓ Updated CHANGELOG.md"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Template setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${YELLOW}📝 README Updated:${NC}"
echo "  Your README.md has been replaced with a clean starter README."
echo "  ${BLUE}Template documentation preserved in TEMPLATE.md${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Review the changes: ${BLUE}git diff${NC}"
echo "  2. Initialize git (if new repo): ${BLUE}git init${NC}"
echo "  3. Set up pre-commit hooks: ${BLUE}make setup-dev${NC}"
echo "  4. Add REUSE headers to your files: ${BLUE}make reuse-annotate${NC}"
echo "  5. Customize README.md with your project details"
echo "  6. Start coding your microservice!"
echo ""
echo -e "${YELLOW}📚 Documentation:${NC}"
echo "  See ${BLUE}TEMPLATE.md${NC} for:"
echo "  • Complete development workflow documentation"
echo "  • CI/CD pipeline details"
echo "  • All available Make targets"
echo "  • Pre-commit hooks configuration"
echo "  • Testing and deployment guides"
echo ""
echo -e "${YELLOW}To update all REUSE headers with your copyright info, run:${NC}"
echo "  ${BLUE}reuse annotate --copyright=\"${COPYRIGHT_HOLDER}\" --license=\"MIT\" --year=\"${YEAR}\" --skip-existing --recursive .${NC}"
echo ""
echo -e "${YELLOW}Optional: Remove this setup script when done:${NC}"
echo "  ${BLUE}rm scripts/setup-template.sh${NC}"
echo ""
