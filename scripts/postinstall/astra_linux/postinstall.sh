#!/bin/bash

set -e

MODULES_DIR="./modules"
COMMON_DIR="./common"

if [ -f "$COMMON_DIR/logger.sh" ]; then
    source "$COMMON_DIR/logger.sh"
else
    log_info() { echo "[INFO] $1"; }
    log_success() { echo "[SUCCESS] $1"; }
    log_warning() { echo "[WARNING] $1"; }
    log_error() { echo "[ERROR] $1"; }
fi

source "$MODULES_DIR/version_detector.sh"

load_version_module() {
    local version=$1
    local module_file="$MODULES_DIR/astra_${version}.sh"
    
    if [ -f "$module_file" ]; then
        log_info "Loading module for Astra Linux $version"
        source "$module_file"
    else
        log_error "Module for version $version not found: $module_file"
        return 1
    fi
}

check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script requires root privileges. Run with sudo!"
        exit 1
    fi
}

check_dependencies() {
    local deps=("bash" "apt-get")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            log_error "Dependency not found: $dep"
            return 1
        fi
    done
}

main() {
    log_info "Starting Astra Linux post-installation script..."
    
    check_root
    check_dependencies
    
    log_info "Detecting Astra Linux version..."
    local astra_version=$(detect_astra_version)
    
    if [ $? -ne 0 ]; then
        log_error "Version detection failed"
        exit 1
    fi
    
    if ! is_supported_version "$astra_version"; then
        log_error "Version $astra_version is not supported"
        exit 1
    fi
    
    local full_name=$(get_astra_full_name)
    log_success "Detected: $full_name (version: $astra_version)"
    
    if ! load_version_module "$astra_version"; then
        exit 1
    fi
    
    log_info "Starting post-installation for version $astra_version"
    perform_postinstall
    
    log_success "Post-installation completed successfully!"
}

main "$@"