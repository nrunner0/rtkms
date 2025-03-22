#!/bin/bash

# Script for starting work with rtkms

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for rtkms structure
if [ ! -d "./rtkms" ]; then
    echo -e "${RED}Error: rtkms structure not found.${NC}"
    echo "First run the init-rtkms.sh script to initialize the structure."
    exit 1
fi

# Load configuration
echo -e "${GREEN}Loading rtkms configuration...${NC}"

# Check for required files
if [ ! -f "./rtkms/meta/config.md" ]; then
    echo -e "${RED}Error: Configuration file not found.${NC}"
    exit 1
fi

# Check for project file and stage files
if [ ! -f "./project.md" ]; then
    echo -e "${YELLOW}Warning: Project file not found. It is recommended to create a project file.${NC}"
fi

# Check for stage files using glob pattern
if [ -z "$(ls ./stage*.md 2>/dev/null)" ]; then
    echo -e "${YELLOW}Warning: No stage files found. It is recommended to create stage files.${NC}"
fi

# Get project information
project_name=$(grep "project_name" ./rtkms/meta/config.md | cut -d ":" -f 2 | sed 's/^ *//' | tr -d " ")
language=$(grep "default_language" ./rtkms/meta/config.md | cut -d ":" -f 2 | sed 's/^ *//' | tr -d " ")

# If language isn't set, default to English
if [ -z "$language" ]; then
    language="en"
    echo -e "${YELLOW}Warning: Language not set in config. Using English as default.${NC}"
fi

# Check if rules file exists for the configured language
if [ ! -d "./rtkms/rules" ]; then
    echo -e "${RED}Error: Rules directory not found. Make sure the system is properly initialized.${NC}"
    exit 1
fi

# Check if at least one rules file exists
rules_file_count=$(find ./rtkms/rules -name "*.md" | wc -l)
if [ $rules_file_count -eq 0 ]; then
    echo -e "${YELLOW}Warning: No rules files found in the rules directory.${NC}"
    # Try to find rules in the core language directory
    if [ -d "rtkms-core/rules/$language" ] && [ ! -z "$(ls -A rtkms-core/rules/$language 2>/dev/null)" ]; then
        echo -e "${YELLOW}Initializing rules from core language directory...${NC}"
        mkdir -p ./rtkms/rules
        cp rtkms-core/rules/$language/*.md ./rtkms/rules/
    else
        echo -e "${YELLOW}Warning: Rules for language '$language' not found in core. Using English rules.${NC}"
        language="en"
        # Check for English rules
        if [ -d "rtkms-core/rules/en" ] && [ ! -z "$(ls -A rtkms-core/rules/en 2>/dev/null)" ]; then
            cp rtkms-core/rules/en/*.md ./rtkms/rules/
        else
            echo -e "${RED}Error: No rules files found in the core.${NC}"
            exit 1
        fi
    fi
fi

echo -e "${GREEN}Project: $project_name${NC}"
echo -e "${GREEN}Project language: $language${NC}"

# Display information about current project state
echo -e "${YELLOW}rtkms structure is ready for use!${NC}"

# Count documents
req_count=$(find ./rtkms/docs/requirements -name "REQ-*.md" | wc -l)
task_count=$(find ./rtkms/docs/tasks -name "TASK-*.md" | wc -l)
kn_count=$(find ./rtkms/docs/knowledge -name "KN-*.md" | wc -l)

echo -e "${GREEN}Current project status:${NC}"
echo "- Requirements: $req_count"
echo "- Tasks: $task_count"
echo "- Knowledge documents: $kn_count"

# Display information about current stage
# Get stage code from stages.md, adapt to the language used
if [ "$language" == "ru" ]; then
    current_stage=$(grep -A 3 "в работе\|in_progress" ./rtkms/meta/stages.md | grep "Код этапа\|Stage code" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//' | tr -d " ")
else
    current_stage=$(grep -A 3 "in_progress" ./rtkms/meta/stages.md | grep "Stage code" | head -n 1 | cut -d ":" -f 2 | sed 's/^ *//' | tr -d " ")
fi

if [ -n "$current_stage" ]; then
    echo -e "${GREEN}Current stage: $current_stage${NC}"
    
    # Show in-progress tasks for current stage
    tasks_in_progress=$(find ./rtkms/docs/tasks/in_progress -name "TASK-$current_stage-*.md" | wc -l)
    echo "- Tasks in progress for current stage: $tasks_in_progress"
    
    # List in-progress tasks
    if [ $tasks_in_progress -gt 0 ]; then
        echo -e "${YELLOW}Tasks in progress:${NC}"
        for task in $(find ./rtkms/docs/tasks/in_progress -name "TASK-$current_stage-*.md"); do
            task_name=$(head -n 1 "$task" | sed 's/# //')
            echo "  - $task_name"
        done
    fi
else
    echo -e "${YELLOW}Current stage not defined. It is recommended to set stage status in file: rtkms/meta/stages.md${NC}"
fi

# Localize messages based on language
if [ "$language" == "ru" ]; then
    # Russian messages
    MENU_TITLE="Доступные действия:"
    MENU_ITEM_1="Создать новое требование"
    MENU_ITEM_2="Создать новую задачу"
    MENU_ITEM_3="Создать новый документ знаний"
    MENU_ITEM_4="Обновить индексы"
    MENU_ITEM_5="Редактировать файл проекта"
    MENU_ITEM_6="Редактировать файлы этапов"
    MENU_ITEM_7="Просмотреть правила работы с rtkms"
    MENU_ITEM_8="Просмотреть статусы этапов"
    MENU_ITEM_9="Проверить диаграмму PlantUML"
    MENU_ITEM_10="Обновить rtkms-core"
    MENU_ITEM_11="Выход"
    MENU_PROMPT="Выберите действие (1-11): "
    FUNCTION_CREATE_REQ="Функция создания требования:"
    FUNCTION_CREATE_TASK="Функция создания задачи:"
    FUNCTION_CREATE_KNOWLEDGE="Функция создания документа знаний:"
    FUNCTION_UPDATE_INDEXES="Функция обновления индексов:"
    FUNCTION_EDIT_PROJECT="Редактирование файла проекта:"
    FUNCTION_EDIT_STAGES="Редактирование файлов этапов:"
    FUNCTION_CHECK_PUML="Проверка диаграммы PlantUML:"
    FUNCTION_UPDATE_CORE="Обновление rtkms-core:"
    INVALID_SELECTION="Неверный выбор"
    WORK_COMPLETED="Работа с rtkms завершена."
else
    # English messages (default)
    MENU_TITLE="Available actions:"
    MENU_ITEM_1="Create new requirement"
    MENU_ITEM_2="Create new task"
    MENU_ITEM_3="Create new knowledge document"
    MENU_ITEM_4="Update indexes"
    MENU_ITEM_5="Edit project file"
    MENU_ITEM_6="Edit stage files"
    MENU_ITEM_7="View rtkms rules"
    MENU_ITEM_8="View stage statuses"
    MENU_ITEM_9="Check PlantUML diagram"
    MENU_ITEM_10="Update rtkms-core"
    MENU_ITEM_11="Exit"
    MENU_PROMPT="Select action (1-11): "
    FUNCTION_CREATE_REQ="Create requirement function:"
    FUNCTION_CREATE_TASK="Create task function:"
    FUNCTION_CREATE_KNOWLEDGE="Create knowledge document function:"
    FUNCTION_UPDATE_INDEXES="Update indexes function:"
    FUNCTION_EDIT_PROJECT="Edit project file:"
    FUNCTION_EDIT_STAGES="Edit stage files:"
    FUNCTION_CHECK_PUML="Check PlantUML diagram:"
    FUNCTION_UPDATE_CORE="Update rtkms-core:"
    INVALID_SELECTION="Invalid selection"
    WORK_COMPLETED="Work with rtkms completed."
fi

# Offer actions
echo -e "${YELLOW}${MENU_TITLE}${NC}"
echo "1. ${MENU_ITEM_1}"
echo "2. ${MENU_ITEM_2}"
echo "3. ${MENU_ITEM_3}"
echo "4. ${MENU_ITEM_4}"
echo "5. ${MENU_ITEM_5}"
echo "6. ${MENU_ITEM_6}"
echo "7. ${MENU_ITEM_7}"
echo "8. ${MENU_ITEM_8}"
echo "9. ${MENU_ITEM_9}"
echo "10. ${MENU_ITEM_10}"
echo "11. ${MENU_ITEM_11}"

read -p "${MENU_PROMPT}" action

case $action in
    1) 
        echo -e "${GREEN}${FUNCTION_CREATE_REQ}${NC}"
        if [ "$language" == "ru" ]; then
            echo "Запустите свой ИИ-ассистент и введите: 'Создай новое требование для проекта $project_name'"
        else
            echo "Start your AI assistant and enter: 'Create a new requirement for project $project_name'"
        fi
        ;;
    2) 
        echo -e "${GREEN}${FUNCTION_CREATE_TASK}${NC}"
        if [ "$language" == "ru" ]; then
            echo "Запустите свой ИИ-ассистент и введите: 'Создай новую задачу для этапа $current_stage проекта $project_name'"
        else
            echo "Start your AI assistant and enter: 'Create a new task for stage $current_stage of project $project_name'"
        fi
        ;;
    3) 
        echo -e "${GREEN}${FUNCTION_CREATE_KNOWLEDGE}${NC}"
        if [ "$language" == "ru" ]; then
            echo "Запустите свой ИИ-ассистент и введите: 'Создай новый документ знаний для проекта $project_name'"
        else
            echo "Start your AI assistant and enter: 'Create a new knowledge document for project $project_name'"
        fi
        ;;
    4) 
        echo -e "${GREEN}${FUNCTION_UPDATE_INDEXES}${NC}"
        if [ "$language" == "ru" ]; then
            echo "Запустите свой ИИ-ассистент и введите: 'Обнови индексы проекта $project_name'"
        else
            echo "Start your AI assistant and enter: 'Update indexes for project $project_name'"
        fi
        ;;
    5)
        echo -e "${GREEN}${FUNCTION_EDIT_PROJECT}${NC}"
        if [ -f "./project.md" ]; then
            editor_cmd="nano"
            if command -v editor &> /dev/null; then
                editor_cmd="editor"
            elif command -v vim &> /dev/null; then
                editor_cmd="vim"
            fi
            $editor_cmd ./project.md
            echo -e "${GREEN}Project file updated.${NC}"
        else
            echo -e "${RED}Project file not found. Run init-rtkms.sh to create a project file.${NC}"
        fi
        ;;
    6)
        echo -e "${GREEN}${FUNCTION_EDIT_STAGES}${NC}"
        # Find existing stage files
        stage_files=$(find . -maxdepth 1 -name "stage*.md" | sort)
        
        if [ -n "$stage_files" ]; then
            if [ "$language" == "ru" ]; then
                echo "Доступные файлы этапов:"
            else
                echo "Available stage files:"
            fi
            i=1
            for file in $stage_files; do
                echo "$i) $file"
                i=$((i+1))
            done
            
            if [ "$language" == "ru" ]; then
                read -p "Выберите файл этапа для редактирования (номер): " stage_num
            else
                read -p "Select stage file to edit (number): " stage_num
            fi
            
            selected_file=$(echo "$stage_files" | sed -n "${stage_num}p")
            
            if [ -n "$selected_file" ]; then
                editor_cmd="nano"
                if command -v editor &> /dev/null; then
                    editor_cmd="editor"
                elif command -v vim &> /dev/null; then
                    editor_cmd="vim"
                fi
                $editor_cmd "$selected_file"
                if [ "$language" == "ru" ]; then
                    echo -e "${GREEN}Файл этапа обновлен: $selected_file${NC}"
                else
                    echo -e "${GREEN}Stage file updated: $selected_file${NC}"
                fi
            else
                if [ "$language" == "ru" ]; then
                    echo -e "${RED}Неверный выбор.${NC}"
                else
                    echo -e "${RED}Invalid selection.${NC}"
                fi
            fi
        else
            if [ "$language" == "ru" ]; then
                echo -e "${RED}Файлы этапов не найдены. Запустите init-rtkms.sh для создания файлов этапов.${NC}"
            else
                echo -e "${RED}No stage files found. Run init-rtkms.sh to create stage files.${NC}"
            fi
        fi
        ;;
    7) 
        # Display rules in the selected language
        rules_file="./rtkms/rules/rules.md"
        
        if [ -f "$rules_file" ]; then
            cat "$rules_file"
        else
            echo -e "${YELLOW}Rules not found in rtkms. Looking for core rules...${NC}"
            if [ -f "rtkms-core/rules/$language/rules.md" ]; then
                cat "rtkms-core/rules/$language/rules.md"
            else
                echo -e "${YELLOW}Rules for language '$language' not found. Showing English rules.${NC}"
                cat "rtkms-core/rules/en/rules.md"
            fi
        fi
        ;;
    8) 
        cat ./rtkms/meta/stages.md 
        ;;
    9)
        echo -e "${GREEN}${FUNCTION_CHECK_PUML}${NC}"
        if [ "$language" == "ru" ]; then
            read -p "Введите путь к файлу .puml: " puml_file
        else
            read -p "Enter path to .puml file: " puml_file
        fi
        if [ -f "$puml_file" ]; then
            ./rtkms/utils/validate_puml.sh "$puml_file"
        else
            if [ "$language" == "ru" ]; then
                echo -e "${RED}Файл не найден: $puml_file${NC}"
            else
                echo -e "${RED}File not found: $puml_file${NC}"
            fi
        fi
        ;;
    10)
        echo -e "${GREEN}${FUNCTION_UPDATE_CORE}${NC}"
        if [ "$language" == "ru" ]; then
            read -p "Обновить rtkms-core из репозитория? (y/n) [y]: " update_core
        else
            read -p "Update rtkms-core from repository? (y/n) [y]: " update_core
        fi
        update_core=${update_core:-y}
        if [ "$update_core" = "y" ]; then
            if [ -d "./rtkms-core/.git" ]; then
                cd rtkms-core && git pull && cd ..
                if [ "$language" == "ru" ]; then
                    echo -e "${GREEN}rtkms-core обновлен. Рекомендуется проверить изменения и обновить файлы в rtkms.${NC}"
                else
                    echo -e "${GREEN}rtkms-core updated. It is recommended to check changes and update files in rtkms.${NC}"
                fi
            else
                if [ "$language" == "ru" ]; then
                    echo -e "${RED}Директория rtkms-core не является git-репозиторием.${NC}"
                else
                    echo -e "${RED}The rtkms-core directory is not a git repository.${NC}"
                fi
            fi
        fi
        ;;
    11) 
        echo "${MENU_ITEM_11}" 
        exit 0 
        ;;
    *) 
        echo "${INVALID_SELECTION}" 
        ;;
esac

echo -e "${GREEN}${WORK_COMPLETED}${NC}"
exit 0 