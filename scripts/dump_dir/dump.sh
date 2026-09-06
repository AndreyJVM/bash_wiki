#!/usr/bin/env bash
#
# dump.sh — собирает дерево текстовых файлов проекта в единый data.txt
#
# Назначение:
#   Рекурсивно сканирует текущую директорию и упаковывает содержимое текстовых
#   файлов в формат:
#     <путь_к_файлу>
#     """
#     <содержимое>
#     """
#
# Особенности:
#   - Игнорирует служебные каталоги (.git, node_modules, target, build и т.д.).
#   - Фильтрует бинарные файлы (картинки, jar, архивы).
#   - Использует тройные кавычки ("""), чтобы не конфликтовать с кодом внутри файлов.
#   - Оптимален для формирования контекста под анализ нейросетями (LLM).

set -euo pipefail

OUTPUT_FILE="data.txt"

# Очищаем или создаем выходной файл в директории запуска
> "$OUTPUT_FILE"

# Список исключаемых директорий
EXCLUDE_DIRS=(
  -name ".git" -o \
  -name "node_modules" -o \
  -name "dist" -o \
  -name "build" -o \
  -name "target" -o \
  -name ".idea" -o \
  -name ".vscode" -o \
  -name ".venv" -o \
  -name "__pycache__"
)

echo "Сборка контекста проекта..."

find . \( "${EXCLUDE_DIRS[@]}" \) -prune -o -type f ! -name "$OUTPUT_FILE" -print0 | while IFS= read -r -d '' file; do
  # Пропускаем бинарные файлы
  if grep -qI . "$file" 2>/dev/null; then
    clean_path="${file#./}"

    echo "$clean_path" >> "$OUTPUT_FILE"
    echo '"""' >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
    echo '"""' >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
  fi
done

echo "Готово! Результат сохранён в $OUTPUT_FILE"