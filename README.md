# RTKMS - Requirements, Tasks and Knowledge Management System

RTKMS (Requirements, Tasks and Knowledge Management System) is a lightweight, portable text-based development management system for managing requirements, tasks and knowledge for AI agents.

## Key Features

- Requirements management through Markdown files
- Task tracking with different statuses
- Project knowledge accumulation and management
- Diagram support via PlantUML
- Integration with AI assistants for workflow automation
- Multilingual support with full localization

## Getting Started

### Initializing a New Project with RTKMS

1. **Clone the RTKMS repository**:
   ```bash
   git clone https://github.com/nrunner0/rtkms.git
   ```

2. **Run the initialization script**:
   ```bash
   cd <your_project_directory>
   ./rtkms-core/utils/init-rtkms.sh
   ```

3. **Follow the initialization script instructions**:
   - Select project language (ru/en)
   - Enter project name and its short designation
   - Confirm Project file creation
   
After completing these steps, you will have the following structure:

- `rtkms/` - the main system directory with all components
- `project.md` - project description file with stages and expected results
- `stage1.md` - file describing the stage1 requirements
- `workflow.md` - file with prompts for working with an AI assistant

### Starting Work with RTKMS

To start working with the system, execute:

```bash
./rtkms/utils/start-rtkms.sh
```

This script will provide information about the current state of the project and a list of available actions.

## Working with an AI Assistant

1. Open the `workflow.md` file in your AI assistant (Claude, ChatGPT, etc.)
2. The AI assistant will read the instructions and guide you through the workflow:
   - Comment on actions being performed
   - Ask clarifying questions on key topics
   - Create necessary documents
   - Track relationships between documents

## System Structure

```
rtkms/
├── docs/                  # Project documents
│   ├── requirements/      # Project requirements
│   ├── tasks/             # Project tasks
│   ├── knowledge/         # Project knowledge base
│   └── code/              # Code and diagrams
├── meta/                  # System metadata
├── rules/                 # Rules and instructions
├── templates/             # Document templates
├── utils/                 # Utilities and scripts
└── _processed/            # Archive of processed documents
```

## Additional Documentation

- Detailed instructions for working with the system are in the `rtkms/rules/` directory
- Templates for various document types in `rtkms/templates/`

## Purpose
rtkms-core is a portable core of a requirements, tasks, and knowledge management system that can be used in various projects. The core contains only basic templates, rules, and instructions that are independent of any specific project.

## Core Structure
- `/meta` - Metadata templates and index structures
  - `/en` - English versions of metadata templates
  - `/ru` - Russian versions of metadata templates
- `/rules` - Basic system operating rules
  - `/en` - English versions of rules and AI instructions
  - `/ru` - Russian versions of rules and AI instructions
- `/templates` - Document templates
  - `/en` - English versions of templates
  - `/ru` - Russian versions of templates
- `/examples` - Example files for project and stages
  - `/en` - English versions of examples
  - `/ru` - Russian versions of examples
- `/utils` - Utilities for working with the system (validators, scripts)

## Using the Core
The core is designed to be easily integrated into projects using automated scripts. Simply follow these steps:

1. **Clone rtkms repository**:
   ```bash
   git clone https://github.com/nrunner0/rtkms.git
   ```

2. **Run initialization script**:
   ```bash
   cd <your_project_directory>
   ./rtkms-core/utils/init-rtkms.sh
   ```

The initialization script will:
- Create the required directory structure
- Copy all necessary templates and rules
- Configure language settings based on your selection
- Generate initial project and stage files
- Set up the first task

After initialization, you can use `./rtkms/utils/start-rtkms.sh` to manage your project.

## Supported Languages
- Russian (ru)
- English (en)
- Support for additional languages can be added by creating corresponding directories and translating template files

## Portability
rtkms-core is specifically designed for:
- Transfer between different projects
- Preservation and transfer of accumulated knowledge
- Transfer between different epochs of a single project
- Core updates without disrupting the structure of existing projects

## Core Modification Principles
The core should be modified only in exceptional cases:
1. Identification of critical errors in the system
2. Introduction of new document types needed in all projects
3. Improvement of system operating rules
4. Adding support for new languages

Any changes specific to a particular project should be made in the project's `rtkms/` folder, not in the core. 