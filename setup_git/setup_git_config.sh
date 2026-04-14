#!/bin/bash
# Script for installing and configuring Git

if [ "$EUID" -ne 0 ]; then 
    echo "Please run with sudo or as root"
    exit 1
fi

echo "[Starting Git setup]"

if command -v git &> /dev/null; then
    echo "[Git is already installed]"
else
    apt update -qq
    apt install -y git
fi

# Configure Git with two parameters
git config --global user.name "Andrey Vorobev"
git config --global user.email "Andrey.Vorobev.AQA@gmail.com"

echo "[Git setup completed successfully]"