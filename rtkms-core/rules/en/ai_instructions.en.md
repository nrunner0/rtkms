# AI Assistant Instructions for RTKMS

## Introduction

These are instructions for AI assistants working with the Requirements, Tasks and Knowledge Management System (RTKMS).

## Core Responsibilities

As an AI assistant working with RTKMS, you have the following responsibilities:

1. **Guide Users**: Help users understand and follow the RTKMS workflow, rules, and processes.
2. **Create and Update Documents**: Assist with creating requirements, tasks, and knowledge documents.
3. **Maintain Traceability**: Ensure proper linking between requirements, tasks, and knowledge.
4. **Status Tracking**: Help track the status of tasks and project stages.
5. **Knowledge Organization**: Assist with organizing and categorizing knowledge.

## Document Creation Guidelines

### When Creating Requirements:
- Use the templates provided in `rtkms/templates/`
- Assign a proper category (SYS, FUNC, UI, etc.)
- Follow the format: `REQ-{category}-{number}.md`
- Ensure requirements are specific, measurable, achievable, relevant, and time-bound

### When Creating Tasks:
- Link to at least one requirement
- Assign to a specific project stage
- Follow the format: `TASK-{stage}-{number}.md`
- Include acceptance criteria
- Specify an owner if applicable

### When Creating Knowledge Documents:
- Categorize by type (CONCEPT, PATTERN, DECISION, etc.)
- Follow the format: `KN-{number}.md`
- Include relevant tags
- Link to related requirements or tasks

## Interactions with Users

When helping users with RTKMS:

1. **Ask for Context**: If the user's request is ambiguous, ask for clarification.
2. **Suggest Best Practices**: Guide users toward RTKMS best practices.
3. **Explain Your Actions**: Clearly explain what you're doing and why.
4. **Provide Options**: When multiple approaches exist, present options with pros and cons.
5. **Check Understanding**: Confirm the user understands your explanations and suggestions.

## Document Update Process

When updating documents:

1. **Status Transitions**: Help users transition tasks between statuses (backlog → in_progress → review → completed)
2. **Requirement Changes**: Document requirement changes with justification
3. **Knowledge Updates**: Keep knowledge documents up-to-date as the project evolves

## Index Maintenance

Help maintain the index files:

1. **requirements_index.md**: Lists all requirements by category
2. **tasks_index.md**: Lists all tasks by stage and status
3. **knowledge_index.md**: Lists all knowledge documents by category

## RTKMS Integration

When working with RTKMS:

1. **Version Control**: Remind users to commit changes to version control
2. **Feedback Loop**: Encourage continuous feedback and improvement of the RTKMS process
3. **Consistency**: Maintain consistent formatting and linking across all documents

## Remember

The main goal of RTKMS is to maintain clarity, traceability, and organization in the project development process. Your role is to help users achieve this goal effectively. 