# Конфигурация rtkms

## Настройки проекта
- `project_name`: {project_name}
- `project_short_name`: {project_short_name}
- `project_version`: 0.1.0
- `rtkms_version`: 1.0
- `date_format`: YYYY-MM-DD

## Настройки идентификаторов
- `id_format_req`: REQ-{category}-{number} (пример: REQ-SYS-0001)
- `id_format_task`: TASK-{stage}-{number} (пример: TASK-S01-0001)
- `id_format_knowledge`: KN-{number} (пример: KN-0001)

## Настройки языка
- `default_language`: ru # Основной язык проекта
- `allow_multilingual`: false # Разрешать файлы на нескольких языках

## Настройки интеграции
- `cursor_integration`: true
- `claude_integration`: true
- `claude_version`: claude-3.7-sonnet

## Настройки путей
- `base_path`: rtkms
- `requirements_path`: ${base_path}/docs/requirements
- `tasks_path`: ${base_path}/docs/tasks
- `knowledge_path`: ${base_path}/docs/knowledge
- `code_docs_path`: ${base_path}/docs/code
- `templates_path`: ${base_path}/templates
- `rules_path`: ${base_path}/rules
- `meta_path`: ${base_path}/meta
- `archive_path`: _processed
- `utils_path`: rtkms-core/utils
- `sources_path`: src

## Настройки обработки файлов
- `auto_archive_processed`: true # Автоматически архивировать обработанные файлы
- `scan_for_unused`: true # Сканировать наличие неиспользуемых файлов

## Настройки ИИ-ассистента
- `auto_index`: true # Автоматическое обновление индексов
- `auto_linking`: true # Автоматическое предложение связей
- `verbose_mode`: true # Подробные сообщения от ИИ
- `strict_mode`: true # Строгое соблюдение правил системы
- `interactive_mode`: medium # Частота запросов подтверждения у пользователя
- `interactive_questions`: critical # Типы вопросов, требующие подтверждения