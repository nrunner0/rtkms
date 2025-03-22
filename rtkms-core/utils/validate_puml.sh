#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if PlantUML is installed
function check_plantuml() {
    if ! command -v plantuml &> /dev/null; then
        echo -e "${RED}PlantUML is not installed.${NC}"
        echo "Please install PlantUML and ensure it's in your PATH."
        echo "You can install it using:"
        echo "  - For Debian/Ubuntu: sudo apt-get install plantuml"
        echo "  - For macOS: brew install plantuml"
        echo "  - Or download from https://plantuml.com/download"
        exit 1
    fi
}

# Function to validate a PlantUML file
function validate_puml_file() {
    local puml_file=$1
    echo -e "${YELLOW}Validating: $puml_file${NC}"
    
    # Run PlantUML validation
    if plantuml -checkonly "$puml_file"; then
        echo -e "${GREEN}✓ Validation passed${NC}"
        return 0
    else
        echo -e "${RED}✗ Validation failed${NC}"
        return 1
    fi
}

# Function to generate a PNG preview
function generate_png_preview() {
    local puml_file=$1
    echo -e "${YELLOW}Generating PNG preview...${NC}"
    
    # Run PlantUML to generate PNG
    if plantuml "$puml_file"; then
        echo -e "${GREEN}✓ PNG preview generated${NC}"
        local png_file=${puml_file%.puml}.png
        if [[ -f "$png_file" ]]; then
            echo "Preview saved to: $png_file"
            return 0
        else
            echo -e "${RED}Could not find generated PNG file.${NC}"
            return 1
        fi
    else
        echo -e "${RED}✗ Failed to generate PNG preview${NC}"
        return 1
    fi
}

# Check dependencies
check_plantuml

# Check arguments
if [[ $# -eq 0 ]]; then
    echo -e "${RED}Error: No PlantUML file specified.${NC}"
    echo "Usage: $0 <puml_file> [--preview]"
    echo "  --preview: Generate a PNG preview of the diagram"
    exit 1
fi

PUML_FILE=$1
PREVIEW=false

# Check additional arguments
if [[ $# -gt 1 && $2 == "--preview" ]]; then
    PREVIEW=true
fi

# Check if the file exists
if [[ ! -f "$PUML_FILE" ]]; then
    echo -e "${RED}Error: File '$PUML_FILE' not found.${NC}"
    exit 1
fi

# Check file extension
if [[ "${PUML_FILE##*.}" != "puml" ]]; then
    echo -e "${RED}Error: File '$PUML_FILE' does not have a .puml extension.${NC}"
    exit 1
fi

# Validate PlantUML file
if validate_puml_file "$PUML_FILE"; then
    # Generate preview if requested
    if [[ "$PREVIEW" == true ]]; then
        generate_png_preview "$PUML_FILE"
    fi
    
    # Suggest next steps
    echo -e "${GREEN}Diagram validation completed successfully.${NC}"
    echo "To include this diagram in your documentation:"
    
    # Determine the relative path based on the file location
    if [[ "$PUML_FILE" == *"/rtkms/docs/code/diagrams/"* ]]; then
        # Extract the diagram type
        DIAGRAM_TYPE=$(echo "$PUML_FILE" | sed -n 's|.*/diagrams/\([^/]*\)/.*|\1|p')
        if [[ -n "$DIAGRAM_TYPE" ]]; then
            echo "1. Reference this diagram in your documents using:"
            echo "   \`![Diagram](../docs/code/diagrams/$DIAGRAM_TYPE/${PUML_FILE##*/%.puml}.png)\`"
        else
            echo "1. Reference this diagram in your documents using markdown image syntax."
        fi
    else
        echo "1. Consider moving this file to the appropriate directory under rtkms/docs/code/diagrams/"
        echo "   For example, if this is a sequence diagram: rtkms/docs/code/diagrams/sequence/"
    fi
    
    echo "2. Add appropriate documentation for this diagram in the code documentation."
    exit 0
else
    echo -e "${RED}Diagram validation failed. Please fix the issues and try again.${NC}"
    exit 1
fi 