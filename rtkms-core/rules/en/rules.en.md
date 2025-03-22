# RTKMS Rules

## Introduction

RTKMS (Requirements, Tasks and Knowledge Management System) is a lightweight, text-based system for managing requirements, tasks, and project knowledge.

## General Principles

1. **Text-Based Storage**: All artifacts are stored in Markdown files for maximum compatibility and version control efficiency.
2. **Modularity**: The system is divided into logical modules (requirements, tasks, knowledge).
3. **Traceability**: Requirements are linked to tasks and knowledge documents.
4. **Simplicity**: The system aims to be simple to use and understand.

## Directory Structure

- `rtkms/docs/requirements/` - Contains all project requirements
- `rtkms/docs/tasks/` - Contains all project tasks
- `rtkms/docs/knowledge/` - Contains all project knowledge
- `rtkms/docs/code/` - Contains code documentation and diagrams
- `rtkms/meta/` - Contains metadata files for the project
- `rtkms/rules/` - Contains the rules for using the system
- `rtkms/templates/` - Contains templates for creating new documents
- `rtkms/utils/` - Contains utility scripts
- `rtkms/_processed/` - Contains processed documents

## File Naming Conventions

- **Requirements**: `REQ-{category}-{number}.md` (e.g., REQ-SYS-0001.md)
- **Tasks**: `TASK-{stage}-{number}.md` (e.g., TASK-S01-0001.md)
- **Knowledge**: `KN-{number}.md` (e.g., KN-0001.md)

## Document Creation Rules

1. **Requirements**:
   - Must have a unique ID
   - Must be categorized (SYS, FUNC, UI, etc.)
   - Must include acceptance criteria

2. **Tasks**:
   - Must reference at least one requirement
   - Must have a status (backlog, in_progress, etc.)
   - Must be assigned to a project stage

3. **Knowledge**:
   - Must be categorized by type
   - Must have relevant tags
   - Should reference related requirements or tasks

## Document Linking

Documents should be linked using markdown links:
- `[REQ-SYS-0001](../requirements/SYS/REQ-SYS-0001.md)`
- `[TASK-S01-0001](../tasks/in_progress/TASK-S01-0001.md)`
- `[KN-0001](../knowledge/CONCEPT/KN-0001.md)`

## Workflow

1. Create requirements based on project needs
2. Create tasks to implement requirements
3. Create knowledge documents as needed
4. Update document statuses as work progresses
5. Link documents to maintain traceability

## Mandatory Rules
1. ALWAYS save files in the correct format and in the correct path
2. ALWAYS follow document templates from the templates folder
3. ALWAYS apply correct file naming according to standards:
   - Requirements: REQ-{category}-{number}.md (example: REQ-SYS-0001.md)
   - Tasks: TASK-{stage}-{number}.md (example: TASK-S01-0001.md)
   - Knowledge: KN-{number}.md (example: KN-0001.md)
   - Code Documentation: CD-{file_name}.md
   - Diagrams: {diagram_type}-{name}.puml
4. ALWAYS place files according to specified paths:
   - Requirements: ${requirements_path}/{category}/REQ-{category}-{number}.md
   - Tasks: ${tasks_path}/{status}/TASK-{stage}-{number}.md
   - Knowledge: ${knowledge_path}/{category}/KN-{number}.md
   - Code Documentation: ${code_docs_path}/CD-{file_name}.md
   - Diagrams: ${code_docs_path}/diagrams/{diagram_type}/{diagram_type}-{name}.puml
5. When modifying a document, ALWAYS check and update links with other documents
6. ALWAYS update task status when making changes and move files to appropriate directories
7. When creating new documents, ALWAYS check for related documents
8. All dates must be in YYYY-MM-DD format
9. ALWAYS maintain minimalism and conciseness in documents
10. When deleting or archiving a document, ALWAYS check and fix references in other documents
11. ALWAYS update index files when adding, modifying, or deleting documents
12. Code documentation MUST NOT duplicate the code itself, but should explain its purpose and principles
13. ALWAYS verify PlantUML documentation files using validate_puml.sh before publishing them

## Recommended Rules
1. Keep descriptions brief (no more than 3-5 sentences)
2. Avoid duplicating information between documents
3. When creating documents, suggest linking them with existing ones
4. Suggest updating related documents when significant changes are made
5. Use lists instead of long paragraphs of text
6. Use short but informative headings
7. Use identifiers for clear references to other documents
8. Group related tasks by stages and statuses
9. Periodically analyze and archive outdated documents in _processed
10. Use diagrams to visualize complex concepts

## File Processing Rules
1. Files that have been processed and are no longer needed should be moved to the _processed folder
2. When processing files, preserve original names and add a date prefix YYYYMMDD_
3. If a file is partially processed, clearly indicate in the documentation which parts were processed
4. Regularly check the project for "dead" links and deleted documents

## User Interaction Rules
1. When performing critical operations (deletion, mass modification), ALWAYS request confirmation
2. Offer solution options when user choice is required
3. Respect interactivity settings from the configuration file
4. When ambiguity arises during task execution, request clarification from the user
5. After performing complex operations, provide a brief summary of the actions taken 