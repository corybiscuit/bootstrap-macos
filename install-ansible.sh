#!/bin/bash

# Script to install Ansible on macOS
set -e

echo "🚀 Installing Ansible for macOS bootstrap..."

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ Error: This script is designed for macOS only."
    exit 1
fi

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⚠️  Please complete the Xcode Command Line Tools installation and run this script again."
    exit 1
fi

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required but not installed."
    echo "Please install Python 3 and try again."
    exit 1
fi

# Check if pip3 is available
if ! command -v pip3 &> /dev/null; then
    echo "📦 Installing pip3..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py --user
    rm get-pip.py
    export PATH="$HOME/Library/Python/$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/bin:$PATH"
fi

# Install Ansible
echo "📦 Installing Ansible..."
pip3 install --user ansible

# Add Python user bin to PATH if not already there
PYTHON_USER_BIN="$HOME/Library/Python/$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/bin"
if [[ ":$PATH:" != *":$PYTHON_USER_BIN:"* ]]; then
    echo "🔧 Adding Python user bin to PATH..."
    echo "export PATH=\"$PYTHON_USER_BIN:\$PATH\"" >> ~/.zprofile
    export PATH="$PYTHON_USER_BIN:$PATH"
fi

# Verify installation
if command -v ansible-playbook &> /dev/null; then
    echo "✅ Ansible installed successfully!"
    echo "📍 Version: $(ansible-playbook --version | head -1)"
    echo ""
    echo "🎉 You can now run the bootstrap playbook:"
    echo "   make bootstrap"
    echo "   # or manually: ansible-playbook bootstrap.yml --ask-become-pass"
else
    echo "❌ Error: Ansible installation failed."
    echo "Please install Ansible manually and try again."
    exit 1
fi