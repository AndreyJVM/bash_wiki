# Project Dumper for AI Context

Скрипт рекурсивно сканирует проект и объединяет все текстовые файлы в один файл `data.txt` для удобной передачи контекста в языковые модели (LLM).

## Быстрый запуск (one-liner)

Перейдите в корень проекта, который нужно проанализировать, и выполните:

### Вариант через `curl`:
```bash
curl -fsSL https://raw.githubusercontent.com/AndreyJVM/bash_wiki/main/scripts/dump_dir/dump.sh | bash
```

### Вариант через `wget`:
```bash
wget -qO- https://raw.githubusercontent.com/AndreyJVM/bash_wiki/main/scripts/dump_dir/dump.sh | bash
```

---

## Что делает скрипт:
- Пропускает бинарные файлы (изображения, архивы, байт-код).
- Игнорирует служебные папки (`.git`, `node_modules`, `target`, `.idea`, `build`, `.venv` и др.).
- Формирует файл `data.txt` в текущей рабочей директории следующего вида:

```text
src/Main.java
"""
public class Main {
    public static void main(String[] args) {
        ...
    }
}
"""


README.md
"""
# Project Name
...
"""
```