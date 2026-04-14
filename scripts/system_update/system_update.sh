#!/bin/bash

set -euo pipefail

log_message() {
    local level=$1
    local message=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" | tee -a /var/log/system_update.log
}

# Проверка прав администратора
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_message "ERROR" "This script must be run as root"
        exit 1
    fi
}

main() {
    check_root

    log_message "INFO" "Starting system update process..."

    log_message "INFO" "Updating package list..."
    if sudo apt-get update -y; then
        log_message "INFO" "Package list updated successfully"
    else
        log_message "ERROR" "Failed to update package list"
        exit 1
    fi

    log_message "INFO" "Upgrading system packages..."
    if sudo apt-get upgrade -y; then
        log_message "INFO" "System upgrade completed successfully"
    else
        log_message "ERROR" "Failed to upgrade system packages"
        exit 1
    fi

    log_message "INFO" "Upgrading distribution (if needed)..."
    if sudo apt-get dist-upgrade -y; then
        log_message "INFO" "Distribution upgrade completed successfully"
    else
        log_message "ERROR" "Failed to upgrade distribution"
        exit 1
    fi

    log_message "INFO" "Removing unused packages..."
    if sudo apt-get autoremove -y; then
        log_message "INFO" "Unused packages removed successfully"
    else
        log_message "ERROR" "Failed to remove unused packages"
        exit 1
    fi

    log_message "INFO" "Cleaning up package cache..."
    if sudo apt-get clean; then
        log_message "INFO" "Package cache cleaned successfully"
    else
        log_message "ERROR" "Failed to clean package cache"
    fi

    log_message "INFO" "System update process completed successfully"
}

main "$@"