# bootstrap-macos

An Ansible playbook for setting up a local macOS machine with essential tools and configurations.

## Overview

This playbook automates the setup of a fresh macOS system with:

- **Homebrew** package manager installation
- **Essential CLI tools** (git, curl, wget, jq, tree, htop, vim, etc.)
- **Development tools** (Node.js, Python, Go, Docker)
- **macOS applications** via Homebrew Cask (VS Code, Chrome, Firefox, etc.)
- **System preferences** configuration (Dock, Finder, Trackpad settings)
- **Shell configuration** with useful aliases and environment variables

## Prerequisites

1. **macOS** (tested on macOS 10.15+)
2. **Ansible** installed on your system:
   ```bash
   # Easy installation script (recommended)
   ./install-ansible.sh
   
   # Or install manually via Python 3
   python3 -m pip install --user ansible
   
   # Or via Homebrew (if you already have it)
   brew install ansible
   ```
3. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```

## Quick Start

1. **Clone this repository**:
   ```bash
   git clone https://github.com/corybiscuit/bootstrap-macos.git
   cd bootstrap-macos
   ```

2. **Install Ansible requirements**:
   ```bash
   make requirements
   # or manually: ansible-galaxy install -r requirements.yml
   ```

3. **Run the bootstrap playbook**:
   ```bash
   make bootstrap
   # or manually: ansible-playbook bootstrap.yml --ask-become-pass
   ```

## Usage

### Available Make Commands

- `make help` - Show available commands
- `make requirements` - Install Ansible Galaxy requirements
- `make bootstrap` - Run the full bootstrap playbook
- `make check` - Check playbook syntax
- `make dry-run` - Run playbook in check mode (dry run)
- `make install` - Install requirements and run bootstrap

### Manual Ansible Commands

```bash
# Check syntax
ansible-playbook bootstrap.yml --syntax-check

# Dry run (check mode)
ansible-playbook bootstrap.yml --check

# Run the playbook
ansible-playbook bootstrap.yml --ask-become-pass

# Run specific tags only
ansible-playbook bootstrap.yml --tags "homebrew,shell" --ask-become-pass
```

## Configuration

### Using Configuration Files

The playbook supports local configuration files for easy customization:

1. **Copy the example configuration**:
   ```bash
   cp config.example.yml config.local.yml
   ```

2. **Edit your local configuration**:
   ```bash
   vim config.local.yml  # or use your preferred editor
   ```

3. **Customize settings** like Git user info, additional packages, and system preferences.

### Customizing Package Lists

Edit `vars.yml` or use `config.local.yml` to customize:

- **homebrew_packages**: CLI tools and packages
- **homebrew_casks**: GUI applications
- **additional_homebrew_packages**: Extra packages to install
- **additional_homebrew_casks**: Extra applications to install
- **macos_settings**: System preferences
- **git_user_name** and **git_user_email**: Git configuration

Example local configuration (`config.local.yml`):
```yaml
git_user_name: "Your Name"
git_user_email: "your.email@example.com"

additional_homebrew_packages:
  - ripgrep
  - fd
  - bat

additional_homebrew_casks:
  - postman
  - figma

macos_settings:
  dock_autohide: false
  dock_position: "left"
```

### Architecture Support

The playbook automatically detects and handles both:
- **Apple Silicon (M1/M2)**: Uses `/opt/homebrew`
- **Intel Macs**: Uses `/usr/local`

## What Gets Installed

### CLI Tools
- git, curl, wget, jq
- tree, htop, vim, tmux
- zsh-completions, zsh-syntax-highlighting
- node, python@3.11, go
- docker, docker-compose

### Applications
- Visual Studio Code
- Google Chrome, Firefox
- Slack, Zoom
- Docker Desktop
- iTerm2, Rectangle, The Unarchiver

### System Configurations
- Dock: Auto-hide, position, tile size
- Finder: Show hidden files and extensions
- Trackpad: Tap to click, three-finger drag
- Keyboard: Fast key repeat, disable auto-correct
- Shell: zsh with useful aliases and environment variables

## Directory Structure

```
bootstrap-macos/
├── ansible.cfg              # Ansible configuration
├── bootstrap.yml           # Main playbook entry point
├── vars.yml                # All configuration variables
├── config.example.yml      # Example local configuration
├── Makefile                # Convenient make targets
├── requirements.yml        # Ansible Galaxy requirements
├── inventory/
│   └── hosts              # Inventory file for localhost
├── playbooks/
│   ├── bootstrap.yml      # Main bootstrap playbook
│   └── tasks/
│       ├── macos_settings.yml  # System preferences tasks
│       └── shell_config.yml    # Shell configuration tasks
└── README.md
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**: Make sure to run with `--ask-become-pass`
2. **Homebrew installation fails**: Ensure Xcode Command Line Tools are installed
3. **Tasks fail**: Check if you're running on macOS (the playbook includes a check)

### Logs and Debugging

- Use `-v`, `-vv`, or `-vvv` flags for verbose output
- Check system preferences manually if automated settings don't apply
- Some settings may require logout/restart to take effect

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the playbook
5. Submit a pull request

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.