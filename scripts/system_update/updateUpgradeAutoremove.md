
# System Update Automation Script

This script automates the process of updating and maintaining your Ubuntu/Debian-based Linux system.

## 📌 Features

- Automatic package list update
- System upgrade with dependency resolution
- Removal of unused packages
- Comprehensive logging
- Error handling and status reporting

## 🛠 Prerequisites

- **Operating System**: Ubuntu/Debian-based distribution
- **Permissions**: Root access or sudo privileges
- **Disk Space**: Minimum 1GB free space (recommended 5GB for major updates)
- **Internet Connection**: Stable connection for package downloads

## 📥 Installation

1. Download the script:
   ```bash
   curl -O https://raw.githubusercontent.com/AndreyJVM/repo/main/system_update/update_system.sh
   ```
   
2. Make it executable:
   ```bash
   chmod +x system_update.sh
   ```
3. (Optional) Move to system binaries for global access:
   ```bash
   sudo mv system_update.sh /usr/local/bin/system-update
   ```
4. Usage:
   ```bash
   sudo ./system_update.sh
   ```