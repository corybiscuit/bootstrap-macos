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

# Check if Python 3 is available and install if needed
if ! command -v python3 &> /dev/null; then
    echo "📦 Python 3 not found. Installing the latest stable version..."
    
    # Check if Homebrew is available
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for this session
        if [[ $(uname -m) == "arm64" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        else
            export PATH="/usr/local/bin:$PATH"
        fi
    fi
    
    # Install Python 3 via Homebrew
    echo "📦 Installing Python 3 via Homebrew..."
    brew install python3
    
    # Verify Python 3 installation
    if ! command -v python3 &> /dev/null; then
        echo "❌ Error: Failed to install Python 3."
        echo "Please install Python 3 manually and try again."
        exit 1
    fi
    
    echo "✅ Python 3 installed successfully! ($(python3 --version))"
fi

# Install Ansible using python3 -m pip (pip comes with Python 3.4+)
echo "📦 Installing Ansible..."
python3 -m pip install --user ansible

# Add Python user bin to PATH if not already there
PYTHON_USER_BIN="$HOME/Library/Python/$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')/bin"
if [[ ":$PATH:" != *":$PYTHON_USER_BIN:"* ]]; then
    echo "🔧 Adding Python user bin to PATH..."
    echo "export PATH=\"$PYTHON_USER_BIN:\$PATH\"" >> ~/.zprofile
    export PATH="$PYTHON_USER_BIN:$PATH"
fi

# Verify installation
if command -v ansible &> /dev/null; then
    echo "✅ Ansible installed successfully!"
    echo "📍 Version: $(ansible --version | head -1)"
    echo ""
    echo "🎉 You can now run the bootstrap playbook:"
    echo "   make bootstrap"
    echo "   # or manually: ansible-playbook bootstrap.yml --ask-become-pass"
else
    echo "❌ Error: Ansible installation failed."
    echo "Please install Ansible manually and try again."
    exit 1
fi