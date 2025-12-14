# macOS Development Environment

Automated macOS setup using Ansible. Personal configuration for Django/React development, Proxmox VMs, and Infrastructure as Code.


## Quick Start

Prerequisites:

    - Fresh macOS installation (or existing system)
    - Admin privileges
    - Internet connection

Installation:

    # Clone repository
    git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles
    cd ~/.dotfiles

    # Install Xcode CLI tools
    xcode-select --install

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install Ansible and run playbook
    brew install ansible
    cd ansible
    ansible-playbook macos.yml --ask-become-pass

First run takes 30-60 minutes. Subsequent runs take 2-5 minutes.


## What Gets Installed

Full specification in [`docs/specifications.md`](docs/specifications.md).

Shell & Terminal:

    - zsh, bash, starship prompt
    - Alacritty, tmux
    - fzf, ripgrep, fd, bat, eza, zoxide

Window Management:

    - yabai (tiling)
    - Hammerspoon (hotkeys)
    - SketchyBar (menu bar)
    - JankyBorders (active window)
    - Karabiner-Elements

Editors:

    - Neovim with LazyVim
    - VS Code

Development:

    - pyenv, poetry, pipx, fnm, direnv
    - Colima, Podman, UTM
    - Terraform, Packer
    - lazygit, gh, tig


## Repository Structure

    .dotfiles/
    ├── ansible/
    │   ├── macos.yml          # Main playbook
    │   ├── Brewfile           # All packages
    │   ├── roles/             # Configuration roles
    │   └── vars/secrets.yml   # Encrypted variables
    ├── docs/
    │   └── specifications.md  # Source of truth
    └── README.md


## Common Tasks

Update all software:

    cd ~/.dotfiles/ansible
    ansible-playbook macos.yml --tags homebrew

Run specific role:

    ansible-playbook macos.yml --tags neovim

Available tags:

    - homebrew, macos, shell, ssh
    - yabai, hammerspoon, sketchybar, borders
    - keyboard, alacritty, neovim, vscode


## Customisation

Shell overrides:

    # Machine-specific configuration
    echo 'export MY_VAR=value' >> ~/.zshrc.local

Adding software:

    1. Edit docs/specifications.md
    2. Update ansible/Brewfile
    3. Run playbook


## Keyboard Shortcuts

Window management uses vim-style keys:

    Option + hjkl           Focus window
    Option + Shift + hjkl   Resize window
    Option + Shift + f      Fullscreen
    Option + Shift + r      Balance sizes
    Option + Ctrl + hjkl    Swap windows
    Option + Ctrl + r       Rotate layout

App launchers:

    Cmd + Enter             Alacritty
    Cmd + E                 Finder
    Cmd + B                 Firefox


## Troubleshooting

Yabai not working:

    # Grant accessibility permissions in System Settings
    yabai --restart-service

Neovim plugins missing:

    rm -rf ~/.local/share/nvim
    nvim  # Will reinstall


## Notes

Portable configurations:

    - Bash configs work on vanilla Linux
    - Vim config is basic and portable
    - Enhanced tools fall back to standard commands

Security:

    - Secrets stored with Ansible Vault
    - SSH uses strong ciphers
    - Firewall enabled by default


## Licence

MIT
