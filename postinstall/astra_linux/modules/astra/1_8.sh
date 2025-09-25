#!/bin/bash

perform_postinstall() {
    log_info "Executing configuration for Astra Linux 1.8..."
    
    backup_sources_list
    configure_sources_1_8
    update_package_list
}

backup_sources_list() {
    local backup_file="/etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)"
    if cp /etc/apt/sources.list "$backup_file"; then
        log_success "Backup created: $backup_file"
    else
        log_error "Failed to create backup of sources.list"
        return 1
    fi
}

configure_sources_1_8() {
    log_info "Configuring repositories for Astra Linux 1.8..."
    
    cat > /etc/apt/sources.list << 'EOF'
# Astra Linux 1.8 repositories
deb http://download.astralinux.ru/astra/stable/1.8_x86-64/repository-main/ 1.8_x86-64 main contrib non-free
deb http://download.astralinux.ru/astra/stable/1.8_x86-64/repository-base/ 1.8_x86-64 main contrib non-free
deb http://download.astralinux.ru/astra/stable/1.8_x86-64/repository-update/ 1.8_x86-64 main contrib non-free
deb http://download.astralinux.ru/astra/stable/1.8_x86-64/repository-extended/ 1.8_x86-64 main contrib non-free
EOF

    log_success "Sources.list configured for Astra Linux 1.8"
}

update_package_list() {
    log_info "Updating package list..."
    
    if apt-get update; then
        log_success "Package list updated successfully"
    else
        log_error "Failed to update package list"
        return 1
    fi
}

export -f perform_postinstall