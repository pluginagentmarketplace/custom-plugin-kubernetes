#!/bin/bash

# Developer Roadmap AI Guide Plugin - Initialization Script
# This script initializes the plugin when loaded in Claude Code

set -e

echo "🚀 Initializing Developer Roadmap AI Guide Plugin..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Initialize plugin state
init_plugin_state() {
    echo -e "${BLUE}→ Setting up plugin state...${NC}"
    # Create initial configuration if needed
    mkdir -p ~/.claude-code/plugins/developer-roadmap
    echo -e "${GREEN}✓ Plugin state initialized${NC}"
}

# Verify plugin structure
verify_structure() {
    echo -e "${BLUE}→ Verifying plugin structure...${NC}"

    required_dirs=("agents" "commands" "skills" "hooks" ".claude-plugin")
    for dir in "${required_dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo -e "${GREEN}✓ Directory $dir exists${NC}"
        else
            echo -e "✗ Directory $dir missing!"
            exit 1
        fi
    done
}

# Check required files
check_required_files() {
    echo -e "${BLUE}→ Checking required files...${NC}"

    required_files=(
        ".claude-plugin/plugin.json"
        "agents/01-backend-devops.md"
        "agents/02-frontend-mobile.md"
        "agents/03-data-ai.md"
        "agents/04-architecture-design.md"
        "agents/05-languages-databases.md"
        "agents/06-management-product.md"
        "agents/07-quality-security.md"
        "commands/learn.md"
        "commands/explore-roles.md"
        "commands/assess-skills.md"
        "commands/browse-projects.md"
        "skills/backend-devops/SKILL.md"
        "skills/frontend-mobile/SKILL.md"
        "skills/data-ai/SKILL.md"
        "skills/architecture/SKILL.md"
        "skills/languages/SKILL.md"
        "skills/management/SKILL.md"
        "skills/security/SKILL.md"
        "hooks/hooks.json"
        "README.md"
    )

    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✓ File $file exists${NC}"
        else
            echo -e "✗ File $file missing!"
            exit 1
        fi
    done
}

# Display plugin information
display_info() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}✓ Developer Roadmap AI Guide Plugin Loaded!${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "📚 Available Commands:"
    echo "   /learn          - Start your learning journey"
    echo "   /explore-roles  - Discover 65 career paths"
    echo "   /assess-skills  - Evaluate your knowledge"
    echo "   /browse-projects - Find hands-on projects"
    echo ""
    echo "🤖 Available Agents: 7 specialized agents"
    echo "   1. Backend & DevOps Specialist"
    echo "   2. Frontend & Mobile Developer"
    echo "   3. Data & AI Engineer"
    echo "   4. Architecture & Design Specialist"
    echo "   5. Languages & Databases Expert"
    echo "   6. Management & Product Specialist"
    echo "   7. Quality & Security Expert"
    echo ""
    echo "🛠️  Available Skills: 7 practical skills"
    echo "   • backend-devops"
    echo "   • frontend-mobile"
    echo "   • data-ai"
    echo "   • architecture"
    echo "   • languages"
    echo "   • management"
    echo "   • security"
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Get started with: /learn"
    echo ""
}

# Main initialization flow
main() {
    init_plugin_state
    verify_structure
    check_required_files
    display_info
}

# Run initialization
main

exit 0
