#!/bin/bash

detect_astra_version() {
    local version=""
    
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "$NAME" == *"Astra"* ]] || [[ "$PRETTY_NAME" == *"Astra"* ]]; then
            if [[ "$VERSION" =~ [0-9]+\.[0-9]+ ]]; then
                version=$(echo "$VERSION" | grep -oE '[0-9]+\.[0-9]+')
            elif [[ "$VERSION_ID" =~ [0-9]+\.[0-9]+ ]]; then
                version="$VERSION_ID"
            else
                if [ -f /etc/astra-version ]; then
                    version=$(cat /etc/astra-version | grep -oE '[0-9]+\.[0-9]+')
                elif command -v lsb_release >/dev/null 2>&1; then
                    version=$(lsb_release -rs | grep -oE '[0-9]+\.[0-9]+')
                fi
            fi
        else
            log_error "This is not Astra Linux! Detected: $NAME"
            return 1
        fi
    else
        log_error "File /etc/os-release not found!"
        return 1
    fi
    
    if [ -z "$version" ]; then
        log_error "Failed to detect Astra Linux version"
        return 1
    fi
    
    echo "$version"
    return 0
}

is_supported_version() {
    local version=$1
    local supported_versions=("1.6" "1.8")
    
    for supported in "${supported_versions[@]}"; do
        if [ "$version" == "$supported" ]; then
            return 0
        fi
    done
    
    return 1
}

get_astra_full_name() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "$PRETTY_NAME"
    else
        echo "Astra Linux Unknown"
    fi
}

export -f detect_astra_version
export -f is_supported_version
export -f get_astra_full_name