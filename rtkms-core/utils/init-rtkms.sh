#!/bin/bash

# Script for initializing rtkms in a project

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Command line arguments processing
CLEAN_MODE=false
for arg in "$@"; do
    case $arg in
        --clean) CLEAN_MODE=true; shift ;;
        --help|-h)
            echo "Usage: $0 [--clean] [--help]"
            echo "Options:"
            echo "  --clean     Remove existing rtkms structure before installation"
            echo "  --help, -h  Show this help message"
            exit 0 ;;
    esac
done

# Check for rtkms-core
[ ! -d "./rtkms-core" ] && {
    echo -e "${RED}Error: rtkms-core directory not found.${NC}"
    echo "Run: git clone https://github.com/nrunner0/rtkms.git"
    exit 1
}

# Clean mode handling
if [ "$CLEAN_MODE" = true ]; then
    # Check if structure exists
    if [ -d "rtkms" ] || [ -f "project.md" ] || [ -f "workflow.md" ] || [ -f "stages.md" ] || [ -f "backlog.md" ]; then
        echo -e "${YELLOW}Clean mode: Found rtkms files to remove.${NC}"
        read -p "Proceed with removal? (y/n): " confirm_clean
        if [[ "$confirm_clean" == "y" ]]; then
            [ -f "project.md" ] && rm -f project.md
            [ -f "workflow.md" ] && rm -f workflow.md
            [ -f "stages.md" ] && rm -f stages.md
            [ -f "backlog.md" ] && rm -f backlog.md
            [ -d "rtkms" ] && rm -rf rtkms
            echo -e "${GREEN}Removed existing rtkms structure.${NC}"
        else
            echo -e "${YELLOW}Clean cancelled. Continuing with installation...${NC}"
        fi
    else
        echo -e "${YELLOW}No existing rtkms structure found.${NC}"
    fi
fi

# Check if rtkms directory exists
if [ -d "rtkms" ] && [ "$CLEAN_MODE" = false ]; then
    echo -e "${YELLOW}Warning: rtkms directory already exists!${NC}"
    read -p "Overwrite existing files? (y/n) [n]: " overwrite
    overwrite=${overwrite:-n}
    [[ "$overwrite" != "y" ]] && {
        echo -e "${RED}Installation cancelled. Use --clean to remove existing structure.${NC}"
        exit 1
    }
fi

# Create directory structure
echo -e "${GREEN}Creating directory structure...${NC}"
mkdir -p rtkms/{docs/{requirements/{SYS,USR,FUNC,SEC,PERF,UI},tasks/{backlog,in_progress,review,completed,verified,canceled},knowledge/{CONCEPT,PATTERN,DECISION,ALGO,TECH,INTEG,ARCH},code/diagrams/{class,sequence,component,activity,state}},meta,rules,templates,_processed}

# Language selection
echo "Available languages:"
ls -1 rtkms-core/templates/ | sort
read -p "Select language (ru/en) [en]: " language
language=${language:-en}

# Verify language availability
[ ! -d "rtkms-core/templates/$language" ] && {
    echo -e "${RED}Error: Language '$language' not available.${NC}"
    exit 1
}

# Copy files from core
echo -e "${GREEN}Copying files from core...${NC}"

# Create config files directly from templates
if [ -d "rtkms-core/meta/$language" ] && [ -n "$(ls -A rtkms-core/meta/$language 2>/dev/null)" ]; then
    # Copy meta files directly to their final names (without .template in the name)
    for template in rtkms-core/meta/$language/*.template.md; do
        if [[ "$template" == *"stages.template.md"* ]]; then
            # Копировать stages.template.md в корень как stages.md
            cp "$template" "stages.md"
        else
            # Копировать остальные шаблоны в rtkms/meta
            target_name=$(basename "$template" .template.md)
            cp "$template" "rtkms/meta/$target_name.md"
        fi
    done
else
    # Fallback to English templates
    for template in rtkms-core/meta/en/*.template.md; do
        if [[ "$template" == *"stages.template.md"* ]]; then
            # Копировать stages.template.md в корень как stages.md
            cp "$template" "stages.md"
        else
            # Копировать остальные шаблоны в rtkms/meta
            target_name=$(basename "$template" .template.md)
            cp "$template" "rtkms/meta/$target_name.md"
        fi
    done
fi

# Copy rules with fallback
if [ -d "rtkms-core/rules/$language" ] && [ -n "$(ls -A rtkms-core/rules/$language 2>/dev/null)" ]; then
    cp rtkms-core/rules/$language/*.md rtkms/rules/
elif [ -d "rtkms-core/rules/en" ]; then
        cp rtkms-core/rules/en/*.md rtkms/rules/
    else
    echo -e "${RED}Error: No rules found in core.${NC}"
        exit 1
fi

# Copy templates and utilities
cp -r rtkms-core/templates/${language}/* rtkms/templates/
# Скрипты утилит теперь используются напрямую из rtkms-core/utils
# cp -r rtkms-core/utils/* rtkms/utils/
# chmod +x rtkms/utils/*.sh

# Project setup
read -p "Create project files? (y/n) [y]: " create_project
create_project=${create_project:-y}

if [[ "$create_project" == "y" ]]; then
    # Get info
    read -p "Project name: " project_name
    read -p "Short name: " project_short_name
    current_date=$(date +%Y-%m-%d)
    
    # Create and update project file
    cp "rtkms-core/examples/${language}/project.example.md" project.md 2>/dev/null || 
       cp rtkms-core/examples/en/project.example.md project.md
    sed -i -e "s/Knowledge and Requirements Management System \"RTKMS\"/Requirements, Tasks and Knowledge Management for \"$project_name\"/g" \
           -e "s/RTKMS/$project_short_name/g" \
           -e "s/- ru (base)/- $language (base)/g" \
           -e "s/2023-11-01/$current_date/g" \
           project.md
    
    # Create backlog file
    echo -e "${GREEN}Creating backlog file...${NC}"
    if [ -f "rtkms-core/templates/$language/backlog.md" ]; then
        # Use the language-specific backlog template
        cp "rtkms-core/templates/$language/backlog.md" backlog.md
    else
        # Fallback to English template
        cp "rtkms-core/templates/en/backlog.md" backlog.md
    fi
    
    # Update project name in backlog file
    sed -i "s/{project_name}/$project_name/g" backlog.md
    
    # Update config files
    [ -f "rtkms/meta/config.md" ] && sed -i -e "s/{project_name}/$project_name/g" \
           -e "s/{project_short_name}/$project_short_name/g" \
           -e "s/default_language: en/default_language: $language/g" \
           rtkms/meta/config.md
    
    # Translate headers in config file if Russian language is used but selected English
    if [ "$language" = "en" ]; then
        # Only apply translations if the file contains Russian text
        if grep -q "Конфигурация" "rtkms/meta/config.md"; then
            sed -i -e 's/Конфигурация rtkms/rtkms Configuration/g' \
                   -e 's/Настройки проекта/Project Settings/g' \
                   -e 's/Настройки идентификаторов/Identifier Settings/g' \
                   -e 's/Настройки языка/Language Settings/g' \
                   -e 's/Основной язык проекта/Primary project language/g' \
                   -e 's/Разрешать файлы на нескольких языках/Allow files in multiple languages/g' \
                   -e 's/Настройки интеграции/Integration Settings/g' \
                   -e 's/Настройки путей/Path Settings/g' \
                   -e 's/Папка для архивации ненужных файлов/Folder for archiving unnecessary files/g' \
                   -e 's/Настройки обработки файлов/File Processing Settings/g' \
                   -e 's/Автоматически архивировать обработанные файлы/Automatically archive processed files/g' \
                   -e 's/Хранить архив N дней/Keep archive for N days/g' \
                   -e 's/Сканировать наличие неиспользуемых файлов/Scan for unused files/g' \
                   -e 's/Настройки ИИ-ассистента/AI Assistant Settings/g' \
                   -e 's/Автоматическое обновление индексов/Automatic index updates/g' \
                   -e 's/Автоматическое предложение связей/Automatic relationship suggestions/g' \
                   -e 's/Подробные сообщения от ИИ/Detailed messages from AI/g' \
                   -e 's/Строгое соблюдение правил системы/Strict adherence to system rules/g' \
                   -e 's/Частота запросов подтверждения у пользователя/Frequency of user confirmation requests/g' \
                   -e 's/Типы вопросов, требующие подтверждения/Types of questions requiring confirmation/g' \
                   "rtkms/meta/config.md"
        fi
    fi
    
    # Update stages file with the current date
    [ -f "stages.md" ] && sed -i -e "s/YYYY-MM-DD/$current_date/g" stages.md
    
    # Translate stages file if needed
    if [ "$language" = "en" ]; then
        if grep -q "Этапы проекта" "stages.md"; then
            sed -i -e 's/Этапы проекта/Project Stages/g' \
                   -e 's/Код этапа/Stage Code/g' \
                   -e 's/Название/Name/g' \
                   -e 's/Статус/Status/g' \
                   -e 's/Начало/Start/g' \
                   -e 's/Окончание/End/g' \
                   -e 's/Ожидаемые результаты/Expected Results/g' \
                   -e 's/Планирование проекта/Project Planning/g' \
                   -e 's/Разработка минимально жизнеспособного продукта/Minimum Viable Product Development/g' \
                   -e 's/Тестирование и документирование/Testing and Documentation/g' \
                   -e 's/Подготовка и осуществление релиза/Release Preparation and Execution/g' \
                   -e 's/Обзор этапов/Stages Overview/g' \
                   -e 's/краткое_описание_этапа/brief_stage_description/g' \
                   -e 's/цель_/goal_/g' \
                   -e 's/результат_/result_/g' \
                   -e 's/зависимость_/dependency_/g' \
                   -e 's/Описание/Description/g' \
                   -e 's/Цели/Goals/g' \
                   -e 's/Зависимости/Dependencies/g' \
                   -e 's/График разработки/Development Schedule/g' \
                   -e 's/Критические пути/Critical Paths/g' \
                   -e 's/Риски/Risks/g' \
                   -e 's/описание_и_стратегия_снижения/description_and_mitigation_strategy/g' \
                   "stages.md"
        fi
    fi
    
    # Translate workflow file if needed
    if [ "$language" = "en" ]; then
        if [ -f "workflow.md" ] && grep -q "Рабочий процесс" "workflow.md"; then
            sed -i -e 's/Рабочий процесс в проекте/Workflow in project/g' \
                   -e 's/Инструкция для ИИ-ассистента/Instructions for AI Assistant/g' \
                   -e 's/Ты мой ИИ-ассистент по проекту/You are my AI assistant for the project/g' \
                   -e 's/Ты работаешь с системой управления требованиями, задачами и знаниями/You work with the requirements, tasks, and knowledge management system/g' \
                   -e 's/Твои обязанности/Your responsibilities/g' \
                   -e 's/Комментировать действия/Comment on actions/g' \
                   -e 's/Объясняй, что ты делаешь на каждом шаге работы/Explain what you are doing at each step/g' \
                   -e 's/чтобы я мог понимать процесс/so I can understand the process/g' \
                   -e 's/Задавать уточняющие вопросы/Ask clarifying questions/g' \
                   -e 's/Задавай вопросы по ключевым аспектам проекта/Ask questions about key aspects of the project/g' \
                   -e 's/чтобы лучше понять контекст/to better understand the context/g' \
                   -e 's/Следовать правилам RTKMS/Follow RTKMS rules/g' \
                   -e 's/Соблюдай структуру и правила системы/Follow the structure and rules of the system/g' \
                   -e 's/находящиеся в/located in/g' \
                   -e 's/Создавать и редактировать документы/Create and edit documents/g' \
                   -e 's/Помогай в создании требований, задач и документов знаний/Help create requirements, tasks, and knowledge documents/g' \
                   -e 's/Отслеживать взаимосвязи/Track relationships/g' \
                   -e 's/Помогай отслеживать связи между различными документами и обновлять индексы/Help track connections between different documents and update indexes/g' \
                   -e 's/Структура проекта/Project structure/g' \
                   -e 's/Документы проекта/Project documents/g' \
                   -e 's/Требования проекта/Project requirements/g' \
                   -e 's/Задачи проекта/Project tasks/g' \
                   -e 's/База знаний проекта/Project knowledge base/g' \
                   -e 's/Код и диаграммы/Code and diagrams/g' \
                   -e 's/Метаданные системы/System metadata/g' \
                   -e 's/Правила и инструкции/Rules and instructions/g' \
                   -e 's/Шаблоны документов/Document templates/g' \
                   -e 's/Утилиты и скрипты/Utilities and scripts/g' \
                   -e 's/Архив обработанных документов/Archive of processed documents/g' \
                   -e 's/Ключевые файлы/Key files/g' \
                   -e 's/основное описание проекта/main project description/g' \
                   -e 's/описание минимально жизнеспособного продукта/minimum viable product description/g' \
                   -e 's/этапы проекта/project stages/g' \
                   -e 's/конфигурация проекта/project configuration/g' \
                   -e 's/индекс документов/document index/g' \
                   -e 's/Стиль работы/Work style/g' \
                   -e 's/Активный/Active/g' \
                   -e 's/Не просто отвечай на вопросы, но и предлагай решения/Not just answer questions, but also propose solutions/g' \
                   -e 's/Подробный/Detailed/g' \
                   -e 's/Давай детальные объяснения и комментарии к своим действиям/Provide detailed explanations and comments on your actions/g' \
                   -e 's/Методичный/Methodical/g' \
                   -e 's/Следуй структуре и правилам системы/Follow the structure and rules of the system/g' \
                   -e 's/Интерактивный/Interactive/g' \
                   -e 's/Задавай вопросы для уточнения деталей/Ask questions to clarify details/g' \
                   -e 's/Начало работы/Getting started/g' \
                   -e 's/Когда я обращаюсь к тебе с новой задачей, сделай следующее/When I approach you with a new task, do the following/g' \
                   -e 's/Прочитай и проанализируй задачу/Read and analyze the task/g' \
                   -e 's/Объясни, как ты понимаешь задачу/Explain how you understand the task/g' \
                   -e 's/Задай уточняющие вопросы при необходимости/Ask clarifying questions if necessary/g' \
                   -e 's/Объясни, какие шаги ты будешь предпринимать/Explain what steps you will take/g' \
                   -e 's/Приступи к выполнению с комментариями каждого действия/Start execution with comments on each action/g' \
                   -e 's/Первые шаги/First steps/g' \
                   -e 's/Теперь я готов начать работу с проектом/Now I am ready to start working with the project/g' \
                   -e 's/Когда я обращусь к тебе, ты должен/When I approach you, you should/g' \
                   -e 's/Рассказать о себе и своей роли в проекте/Tell me about yourself and your role in the project/g' \
                   -e 's/Предложить ознакомиться с файлами/Suggest reviewing the files/g' \
                   -e 's/Задать несколько вопросов о целях и контексте проекта/Ask a few questions about the goals and context of the project/g' \
                   -e 's/Предложить начать работу с первого этапа проекта/Suggest starting work from the first stage of the project/g' \
                   -e 's/Жду твоих инструкций для начала работы/I await your instructions to begin work/g' \
                   -e 's/Работа с ИИ-ассистентом/Working with the AI assistant/g' \
                   -e 's/Для эффективной работы с ИИ-ассистентом, следуйте этим шагам/For effective work with the AI assistant, follow these steps/g' \
                   -e 's/Покажите этот файл ИИ-ассистенту для начала работы/Show this file to the AI assistant to begin work/g' \
                   -e 's/Попросите проанализировать файлы/Ask to analyze the files/g' \
                   -e 's/Попросите создать необходимые требования и задачи согласно проекту и MVP/Ask to create the necessary requirements and tasks according to the project and MVP/g' \
                   -e 's/Продолжайте работу согласно этапам проекта/Continue work according to the project stages/g' \
                   -e 's/Начало работы с первым этапом/Starting work with the first stage/g' \
                   -e 's/Для начала работы с первым этапом, после настройки всех необходимых файлов, введите/To start working with the first stage, after setting up all necessary files, enter/g' \
                   -e 's/Начинаем работу с первым этапом проекта. Пожалуйста, проанализируй project.md и mvp.md, создай необходимые требования и первые задачи/We are starting work on the first stage of the project. Please analyze project.md and mvp.md, create the necessary requirements and initial tasks/g' \
                   -e 's/Процесс работы с этапами/Process of working with stages/g' \
                   -e 's/Создание требований для этапа на основе целей проекта и MVP/Creating requirements for the stage based on project goals and MVP/g' \
                   -e 's/Разбиение требований на задачи с оценкой времени/Breaking down requirements into tasks with time estimates/g' \
                   -e 's/Выполнение задач в порядке приоритета/Executing tasks in order of priority/g' \
                   -e 's/Регулярное обновление статуса задач и этапа/Regular updating of task and stage status/g' \
                   -e 's/Проверка результатов выполнения задач/Checking task completion results/g' \
                   -e 's/Переход к следующему этапу после завершения текущего/Moving to the next stage after completing the current one/g' \
                   -e 's/Команды для работы с системой/Commands for working with the system/g' \
                   -e 's/Создай новое требование/Create a new requirement/g' \
                   -e 's/для создания нового требования/to create a new requirement/g' \
                   -e 's/Создай новую задачу/Create a new task/g' \
                   -e 's/для создания новой задачи/to create a new task/g' \
                   -e 's/Обнови статус задачи/Update task status/g' \
                   -e 's/для обновления статуса задачи/to update the status of a task/g' \
                   -e 's/Обнови статус этапа/Update stage status/g' \
                   -e 's/для обновления статуса этапа/to update the status of a stage/g' \
                   -e 's/Перейди к следующему этапу/Move to the next stage/g' \
                   -e 's/для перехода к следующему этапу/to move to the next stage/g' \
                   "workflow.md"
        fi
    fi
    
    # Create task
    mkdir -p rtkms/docs/tasks/backlog
    cp rtkms-core/templates/${language}/TASK-S01-001.template.md rtkms/docs/tasks/backlog/TASK-S01-001.md
    sed -i -e "s/YYYY-MM-DD/$current_date/g" rtkms/docs/tasks/backlog/TASK-S01-001.md

# Create workflow file
    if [ -f "rtkms-core/meta/$language/workflow.template.md" ]; then
        sed "s/{project_name}/$project_name/g" rtkms-core/meta/$language/workflow.template.md > workflow.md
    elif [ -f "rtkms/meta/workflow.template.md" ]; then
        sed "s/{project_name}/$project_name/g" rtkms/meta/workflow.template.md > workflow.md
    fi
fi

echo -e "${GREEN}rtkms initialization completed!${NC}"
echo "Next steps:"
echo "1. Review project.md"
echo "2. View stages.md"
echo "3. Check backlog.md"
echo "4. Open workflow.md in your AI assistant"
echo ""
echo "To manage: ./rtkms-core/utils/start-rtkms.sh"
echo "To reinstall: ./rtkms-core/utils/init-rtkms.sh --clean"

exit 0 