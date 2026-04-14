#!/bin/bash

# Скрипт резервного копирования пользовательских данных
# Для Astra Linux 1.6

# Конфигурация
SOURCE_DIR="/home/domain"                     # Исходный каталог с пользователями
TARGET_DIR="/home/backups"                    # Корневой каталог для бэкапов
SPECIAL_DIR="Desktops/Desktop1/backup"        # Директория для бэкапирования
LOGFILE="/var/log/user_backup.log"            # Файл лога
RETENTION_COUNT=3                             # Хранить N последних бэкапов
MAX_USER_QUOTA_GB=15                          # Макс. объем бэкапов на пользователя (GB)
DATE=$(date +%Y-%m-%d_%H-%M-%S)               # Формат даты для имени файла

# Создаем каталоги если их нет
mkdir -p "$TARGET_DIR"
mkdir -p "$(dirname "$LOGFILE")"

# Логирование
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOGFILE"
}

# Функция проверки размера директории
get_dir_size_gb() {
    du -sb "$1" | awk '{printf "%.2f", $1/1024/1024/1024}'
}

# Начало работы
log "=== Начало резервного копирования ==="

# Проверка свободного места (минимум 20GB)
MIN_SPACE=20480 # 20GB в MB
available=$(df -m "$TARGET_DIR" | awk 'NR==2 {print $4}')
if [ "$available" -lt "$MIN_SPACE" ]; then
    log "ОШИБКА: Недостаточно свободного места в $TARGET_DIR (доступно: ${available}MB, требуется: ${MIN_SPACE}MB)"
    exit 1
fi

# Обработка каждого пользователя
for user_dir in "$SOURCE_DIR"/*; do
    if [ -d "$user_dir" ]; then
        username=$(basename "$user_dir")
        user_backup_dir="$TARGET_DIR/$username"
        mkdir -p "$user_backup_dir"

        # Проверяем наличие специальной директории
        if [ -d "$user_dir/$SPECIAL_DIR" ]; then
            log "Найдена директория $SPECIAL_DIR у пользователя $username"

            # Проверяем текущий размер бэкапов пользователя
            current_size_gb=$(get_dir_size_gb "$user_backup_dir")
            log "Текущий размер бэкапов пользователя $username: ${current_size_gb}GB"

            # Проверяем квоту
            if (( $(echo "$current_size_gb >= $MAX_USER_QUOTA_GB" | bc -l) )); then
                log "ПРЕДУПРЕЖДЕНИЕ: Достигнут лимит квоты (${MAX_USER_QUOTA_GB}GB) для $username, пропускаем"
                continue
            fi

            # Проверяем размер новых данных для бэкапа
            new_data_size_gb=$(get_dir_size_gb "$user_dir/$SPECIAL_DIR")
            log "Размер новых данных для бэкапа: ${new_data_size_gb}GB"

            if (( $(echo "$current_size_gb + $new_data_size_gb > $MAX_USER_QUOTA_GB" | bc -l) )); then
                log "ПРЕДУПРЕЖДЕНИЕ: Бэкап превысит квоту для $username, пропускаем"
                continue
            fi

            backup_file="${user_backup_dir}/${username}_${DATE}.tar.gz"

            # Создаем tar.gz архив с прогрессом
            log "Создание бэкапа ${backup_file}..."
            if tar -czf "$backup_file" -C "$SOURCE_DIR" "$username/$SPECIAL_DIR" 2>> "$LOGFILE"; then
                backup_size_gb=$(get_dir_size_gb "$backup_file")
                log "Успешно: ${backup_file} создан (${backup_size_gb}GB)"

                # Устанавливаем правильные права
                chmod 600 "$backup_file"
                chown root:root "$backup_file"

                # Удаляем старые бэкапы, оставляя только последние RETENTION_COUNT
                backups_count=$(ls -1 "$user_backup_dir"/*.tar.gz 2>/dev/null | wc -l)
                if [ "$backups_count" -gt "$RETENTION_COUNT" ]; then
                    files_to_delete=$((backups_count - RETENTION_COUNT))
                    log "Удаляем $files_to_delete старых бэкапов для $username..."
                    ls -1t "$user_backup_dir"/*.tar.gz | tail -n $files_to_delete | xargs rm -f
                fi
            else
                log "ОШИБКА при создании ${backup_file}"
            fi
        else
            log "Пропускаем $username - директория $SPECIAL_DIR не найдена"
        fi
    fi
done

# Конец работы
log "=== Резервное копирование завершено ==="
log ""