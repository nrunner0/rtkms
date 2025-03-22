#!/bin/bash

# Script for initializing rtkms in a project

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for rtkms-core
if [ ! -d "./rtkms-core" ]; then
    echo -e "${RED}Error: rtkms-core directory not found.${NC}"
    echo "Make sure the script is run from the project's root directory."
    echo "If rtkms-core is not yet cloned, run the command:"
    echo "git clone https://github.com/nrunner0/rtkms.git"
    exit 1
fi

# Create directory structure
echo -e "${GREEN}Creating rtkms directory structure...${NC}"
mkdir -p rtkms/docs/requirements/{SYS,USR,FUNC,SEC,PERF,UI}
mkdir -p rtkms/docs/tasks/{backlog,in_progress,review,completed,verified,canceled}
mkdir -p rtkms/docs/knowledge/{CONCEPT,PATTERN,DECISION,ALGO,TECH,INTEG,ARCH}
mkdir -p rtkms/docs/code/diagrams/{class,sequence,component,activity,state}
mkdir -p rtkms/meta
mkdir -p rtkms/rules
mkdir -p rtkms/templates
mkdir -p rtkms/utils
mkdir -p rtkms/_processed

# Define project language
echo -e "${GREEN}Language configuration...${NC}"
echo "Available languages:"
ls -1 rtkms-core/templates/ | sort
read -p "Select primary project language (ru/en) [en]: " language
language=${language:-en}

# Check if the selected language is available
if [ ! -d "rtkms-core/templates/$language" ]; then
    echo -e "${RED}Error: Language '$language' is not available.${NC}"
    echo "Available languages:"
    ls -1 rtkms-core/templates/
    exit 1
fi

# Copy language-specific templates and rules
echo -e "${GREEN}Copying files from rtkms core for language: $language...${NC}"

# Configuration files from the selected language
cp rtkms-core/meta/$language/*.template.md rtkms/meta/
# If language-specific meta folder doesn't exist, use English as fallback
if [ ! -d "rtkms-core/meta/$language" ] || [ -z "$(ls -A rtkms-core/meta/$language)" ]; then
    echo -e "${YELLOW}Warning: Meta templates for '$language' not found. Using English templates.${NC}"
    cp rtkms-core/meta/en/*.template.md rtkms/meta/
fi

# Rules
echo -e "${GREEN}Copying rules for language: ${language}...${NC}"
# Check if the language directory exists
if [ -d "rtkms-core/rules/$language" ] && [ ! -z "$(ls -A rtkms-core/rules/$language 2>/dev/null)" ]; then
    # Copy files from language directory
    cp rtkms-core/rules/$language/*.md rtkms/rules/
else
    # Fallback to English
    echo -e "${YELLOW}Warning: Rules for '$language' not found. Using English rules.${NC}"
    if [ -d "rtkms-core/rules/en" ] && [ ! -z "$(ls -A rtkms-core/rules/en 2>/dev/null)" ]; then
        cp rtkms-core/rules/en/*.md rtkms/rules/
    else
        echo -e "${RED}Error: No rules files found in the core.${NC}"
        exit 1
    fi
fi

# Templates
echo -e "${GREEN}Copying templates for language: ${language}...${NC}"
cp -r rtkms-core/templates/${language}/* rtkms/templates/

# Utilities
cp -r rtkms-core/utils/* rtkms/utils/
chmod +x rtkms/utils/*.sh

# Offer to create a project file
read -p "Create a project file based on the template? (y/n) [y]: " create_project_file
create_project_file=${create_project_file:-y}

if [[ "$create_project_file" == "y" ]]; then
    # Get project name
    read -p "Enter project name: " project_name
    read -p "Enter short project name: " project_short_name
    
    # Create project file
    echo -e "${GREEN}Creating project file...${NC}"
    # Copy project template file for selected language
    if [ -f "rtkms-core/examples/$language/project.example.md" ]; then
        cp rtkms-core/examples/$language/project.example.md project.md
    else
        echo -e "${YELLOW}Warning: Project template for '$language' not found. Using English template.${NC}"
        cp rtkms-core/examples/en/project.example.md project.md
    fi
    
    # Replace data in project file
    current_date=$(date +%Y-%m-%d)
    sed -i -e "s/Knowledge and Requirements Management System \"RTKMS\"/Requirements, Tasks and Knowledge Management for \"$project_name\"/g" \
           -e "s/RTKMS/$project_short_name/g" \
           -e "s/- ru (base)/- $language (base)/g" \
           -e "s/2023-11-01/$current_date/g" \
           project.md
    
    echo -e "${GREEN}Project file created: project.md${NC}"
    
    # Update configuration
    sed -i -e "s/{project_name}/$project_name/g" \
           -e "s/{project_short_name}/$project_short_name/g" \
           -e "s/default_language: en/default_language: $language/g" \
           rtkms/meta/config.md
    
    echo -e "${GREEN}Configuration file updated: rtkms/meta/config.md${NC}"
    
    # Update stages file with current date for reference only
    sed -i -e "s/YYYY-MM-DD/$current_date/g" rtkms/meta/stages.md
    
    echo -e "${GREEN}Project stages file updated with reference dates: rtkms/meta/stages.md${NC}"
fi

# Create stage1 file
read -p "Create a file for Stage 1 description? (y/n) [y]: " create_stage1_file
create_stage1_file=${create_stage1_file:-y}

if [[ "$create_stage1_file" == "y" ]]; then
    # Copy Stage example for selected language
    if [ -f "rtkms-core/examples/$language/stage1.example.md" ]; then
        cp rtkms-core/examples/$language/stage1.example.md stage1.md
    else
        echo -e "${YELLOW}Warning: Stage1 template for '$language' not found. Using English template.${NC}"
        cp rtkms-core/examples/en/stage1.example.md stage1.md
    fi
    
    # If project name is set, update header
    if [ -n "$project_name" ]; then
        sed -i -e "s/Stage 1: System Foundation - RTKMS/Stage 1: System Foundation - $project_short_name/g" \
               -e "s/2023-11-01/$current_date/g" \
               stage1.md
    fi
    
    echo -e "${GREEN}Stage 1 file created: stage1.md${NC}"
fi

# Create first task for the stage
if [ -n "$project_name" ]; then
    # Copy task template for first stage
    mkdir -p rtkms/docs/tasks/backlog
    cp rtkms-core/templates/${language}/TASK-S01-001.template.md rtkms/docs/tasks/backlog/TASK-S01-001.md
    
    # Update date in task for reference only
    sed -i -e "s/YYYY-MM-DD/$current_date/g" rtkms/docs/tasks/backlog/TASK-S01-001.md
    
    echo -e "${GREEN}Initial task created: rtkms/docs/tasks/backlog/TASK-S01-001.md${NC}"
fi

# Create workflow file
if [ -n "$project_name" ]; then
    # Look for language-specific workflow template
    if [ -f "rtkms-core/meta/$language/workflow.template.md" ]; then
        sed -e "s/{project_name}/$project_name/g" \
            rtkms-core/meta/$language/workflow.template.md > workflow.md
    else
        echo -e "${YELLOW}Warning: Workflow template for '$language' not found. Using template from rtkms/meta.${NC}"
        sed -e "s/{project_name}/$project_name/g" \
            rtkms/meta/workflow.template.md > workflow.md
    fi
else
    cp rtkms/meta/workflow.template.md workflow.md
fi

echo -e "${GREEN}Workflow file created: workflow.md${NC}"

echo -e "${GREEN}rtkms initialization completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Review the project description file: project.md"
echo "2. Familiarize yourself with Stage 1 goals in: stage1.md"
echo "3. Study the project stages plan: rtkms/meta/stages.md"
echo "4. Open workflow.md in your AI assistant (Claude, ChatGPT) to start working"
echo ""
echo "To manage the project, use the script: ./rtkms/utils/start-rtkms.sh"

exit 0 