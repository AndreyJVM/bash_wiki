#!/bin/bash

# ls-helper.sh - расширенная оболочка для команды ls с дополнительными функциями
# Версия: v1.2b
#
# Основные функции:
#   color    - цветной вывод содержимого директории
#   last N   - показать N последних измененных файлов (по умолчанию 5)
#   len      - вывести список файлов с указанием длины имен
#   long     - показать файл(ы) с самым длинным именем
#
# Примеры использования:
#   ./ls-helper.sh color
#   ./ls-helper.sh last 3
#   ./ls-helper.sh len
#   ./ls-helper.sh long

function Usage_Exit {
    echo "Использование: $0 [color|last|len|long] [доп.параметры]"
    echo "Попробуйте:"
    echo "  $0 color          # цветной вывод"
    echo "  $0 last 3         # 3 последних файла"
    echo "  $0 len            # список с длиной имени"
    echo "  $0 long           # файл(ы) с самым длинным именем"
    exit
}

function Ls-Length {
    ls -1 "$@" | while read fn; do
        printf '%3d %s\n' ${#fn} ${fn}
    done | sort -n
}

# Проверка наличия обязательного параметра
(( $# < 1 )) && Usage_Exit

sub=$1
shift

case $sub in
    color)
        # Цветной вывод с обработкой специальных символов
        ls -N --color=tty -T 0 "$@"
    ;;

    last|latest)
        # Вывод последних измененных файлов
        ls -lrt | tail "-n${1:-5}"
    ;;

    len*)
        # Вывод списка файлов с длинами имен
        Ls-Length "$@"
    ;;

    long)
        # Поиск файла(ов) с максимальной длиной имени
        Ls-Length "$@" | tail -1
    ;;

    *)
        # Обработка неизвестной команды
        echo "Ошибка: неизвестная команда '$sub'"
        Usage_Exit
    ;;
esac