# macOS Development Environment

Automated macOS development environment setup using Ansible. Designed for a Red Hat certified architect working with Django/React, Proxmox VMs, and Infrastructure as Code.

## 📋 Philosophy

**FOSS-first, pragmatically professional:** Prioritizes open source tools while embracing quality proprietary software where it provides significant value. Configurations are portable and degrade gracefully on remote systems.

## 🎯 What Gets Installed

The complete list of software and configurations is defined in [`docs/specifications.md`](docs/specifications.md), which serves as the **single source of truth** for this system.

### Core Categories

- **Package Managers:** Homebrew, mas
- **CLI Tools:** fzf, ripgrep, fd, bat, eza, zoxide, tldr, jq, yq, mtr, dog, httpie, mosh
- **Shell Environment:** zsh, bash, starship prompt
- **Terminal:** Alacritty, tmux
- **Window Management:** yabai, skhd, SketchyBar, Karabiner-Elements, Hammerspoon, Ice
- **Editors:** Neovim (LazyVim), VS Code
- **Version Control:** lazygit, git-delta, gh, tig, Fork
- **Language Tools:** pyenv, poetry, pipx, fnm, direnv
- **Containers:** Colima, Podman, UTM
- **Infrastructure:** Terraform, Packer, Ansible tooling
- **Databases:** TablePlus, mycli, pgcli
- **Productivity:** Alfred/Raycast, Maccy, espanso, btop, Stats, AlDente
- **Documentation:** Obsidian, Zeal
- **Security:** Bitwarden, Little Snitch, SSH hardening

## 🚀 Quick Start

### Prerequisites

1. **Fresh macOS installation** (or existing system - roles are idempotent)
2. **Internet connection**
3. **Admin privileges**

### Installation

```bash
# 1. Clone this repository
git clone https://github.com/yourusername/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 2. Install Xcode Command Line Tools
xcode-select --install

# 3. Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 4. Install Ansible
brew install ansible

# 5. Create secrets file (optional, for encrypted variables)
cp ansible/vars/secrets.yml.example ansible/vars/secrets.yml
ansible-vault edit ansible/vars/secrets.yml

# 6. Run the playbook
cd ansible
ansible-playbook macos.yml --ask-become-pass

# 7. (Optional) Run specific roles only
ansible-playbook macos.yml --tags shell,neovim
```

### First Run Notes

- The playbook will take 30-60 minutes on first run (downloads ~5GB)
- Some GUI applications will require manual setup (Karabiner permissions, etc.)
- Neovim will install plugins on first launch
- VS Code extensions install automatically but may need reload
- Paid software (Little Snitch, TablePlus, Fork, Alfred) will require license keys

## 📁 Repository Structure

```
.dotfiles/
├── ansible/
│   ├── macos.yml              # Main playbook
│   ├── Brewfile               # All Homebrew packages
│   ├── roles/
│   │   ├── homebrew/          # Package installation
│   │   ├── macos/             # System preferences
│   │   ├── shell/             # bash, zsh, starship configs
│   │   ├── ssh/               # SSH hardening
│   │   ├── alacritty/         # Terminal config
│   │   ├── yabai/             # Window manager
│   │   ├── sketchybar/        # Menu bar
│   │   ├── keyboard/          # Karabiner-Elements
│   │   ├── neovim/            # LazyVim setup
│   │   └── vscode/            # VS Code + extensions
│   └── vars/
│       └── secrets.yml        # Encrypted variables (git-ignored)
├── docs/
│   └── specifications.md      # SOURCE OF TRUTH - complete system spec
├── scripts/
│   └── first-run.sh          # Bootstrap script
└── README.md                 # This file
```

## ⚙️ Customization

### Modifying Installed Software

**IMPORTANT:** `docs/specifications.md` is the source of truth. When making changes:

1. **Update the specification first:** Edit `docs/specifications.md`
2. **Update the Brewfile:** Add/remove packages in `ansible/Brewfile`
3. **Update roles if needed:** Modify role tasks/templates
4. **Commit together:** Keep specification and implementation synchronized

Example workflow:
```bash
# 1. Edit specification
vim docs/specifications.md  # Add "Rectangle Pro" under Window Management

# 2. Edit Brewfile
vim ansible/Brewfile        # Add: cask "rectangle-pro"

# 3. Commit both
git add docs/specifications.md ansible/Brewfile
git commit -m "feat: add Rectangle Pro window manager"

# 4. Apply
ansible-playbook ansible/macos.yml --tags homebrew
```

### Customizing Shell Configuration

Shell configs support local overrides:

```bash
# Bash (works on remote Linux systems)
echo 'export MY_VAR=value' >> ~/.bashrc.local

# Zsh (local macOS enhancements)
echo 'alias myalias=command' >> ~/.zshrc.local
```

### VS Code Settings

Edit `ansible/roles/vscode/files/settings.json` before running playbook, or modify after installation at:
```
~/Library/Application Support/Code/User/settings.json
```

### Neovim Configuration

LazyVim configuration is in:
```
~/.config/nvim/lua/config/     # options.lua, keymaps.lua
~/.config/nvim/lua/plugins/    # custom plugins
```

### SSH Configuration

Add host-specific configs in:
```
~/.ssh/config.d/hosts.conf
```

## 🔧 Common Tasks

### Update All Software

```bash
cd ~/.dotfiles/ansible
ansible-playbook macos.yml --tags homebrew
```

### Reinstall Just One Role

```bash
ansible-playbook macos.yml --tags neovim
```

### Available Tags

- `homebrew` - Install/update all packages
- `macos` - Apply system preferences
- `shell` - Shell configurations
- `ssh` - SSH config
- `yabai` - Window manager
- `sketchybar` - Menu bar
- `keyboard` - Karabiner
- `alacritty` - Terminal
- `neovim` - Neovim setup
- `vscode` - VS Code setup

### Backup Current Configuration

```bash
# Export current Homebrew packages
brew bundle dump --file=~/Brewfile.backup

# Backup VS Code extensions
code --list-extensions > ~/vscode-extensions.txt

# Backup current dotfiles
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz ~/.config ~/.zshrc ~/.bashrc ~/.ssh/config
```

## 🐛 Troubleshooting

### Homebrew Installation Fails

```bash
# Check Homebrew is in PATH
echo $PATH | grep homebrew

# Re-source shell
source ~/.zshrc  # or ~/.bashrc
```

### Yabai/Skhd Not Starting

```bash
# Grant accessibility permissions in System Settings > Privacy & Security
# Restart services
yabai --restart-service
skhd --restart-service
```

### Neovim Plugins Not Installing

```bash
# Remove and reinstall
rm -rf ~/.local/share/nvim
nvim  # Will auto-install plugins
```

### VS Code Extensions Not Installing

```bash
# Install manually
code --install-extension ms-python.python
```

### SSH Config Issues

```bash
# Test SSH config syntax
ssh -G hostname

# Check file permissions
ls -la ~/.ssh/config  # Should be 600
```

## 📝 Notes

### Portable Configurations

- **Bash configs** work on vanilla Linux/macOS with graceful degradation
- **Vim config** (`~/.vimrc`) is basic and portable
- **SSH config** uses widely-supported options
- Enhanced tools (eza, bat, etc.) have fallbacks to standard commands

### Security Considerations

- Secrets are stored in `ansible/vars/secrets.yml` (Ansible Vault encrypted)
- SSH config uses strong ciphers and modern KEX algorithms
- Firewall and stealth mode enabled by default
- Password required immediately after sleep

### Performance

- **Initial run:** 30-60 minutes (downloads ~5GB)
- **Subsequent runs:** 2-5 minutes (only applies changes)
- **Roles are idempotent:** Safe to run repeatedly

## 🤝 Contributing

This is a personal dotfiles repository, but you're welcome to:

1. Fork for your own use
2. Open issues for bugs
3. Submit PRs for improvements
4. Share your own implementations

### Development Workflow

When adding features:

1. Update `docs/specifications.md` first
2. Implement in appropriate role
3. Update `Brewfile` if adding software
4. Test on a fresh macOS VM (or use `--check` mode)
5. Commit with conventional commits format

## 📚 Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Homebrew Bundle](https://github.com/Homebrew/homebrew-bundle)
- [LazyVim Documentation](https://www.lazyvim.org/)
- [Yabai Documentation](https://github.com/koekeishiya/yabai)
- [SketchyBar Documentation](https://github.com/FelixKratz/SketchyBar)

## 📄 License

MIT License - feel free to use and modify for your own needs.

## 🙏 Acknowledgments

Built with inspiration from:
- [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Awesome macOS Command Line](https://git.herrbischoff.com/awesome-macos-command-line/about/)
- [LazyVim](https://www.lazyvim.org/)

---

**Remember:** `docs/specifications.md` is the single source of truth. Keep it synchronized with your implementation.
