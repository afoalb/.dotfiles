# macOS Development Environment Specification

## Package Managers
- Homebrew
- mas (Mac App Store CLI)

## Window Management
- yabai (tiling window manager)
- skhd (hotkey daemon)
- SketchyBar (menu bar)
- Karabiner-Elements (keyboard customization)
- Hammerspoon (automation)
- Ice / JordanBaird Ice (menu bar icon organization)

## Terminal & Shell
- Alacritty (terminal emulator)
- tmux (terminal multiplexer)
- zsh (local shell, with fallback configs)
- bash (remote compatibility, portable configs)
- starship (cross-shell prompt)

### Alacritty Configuration
- Font: FiraCode Nerd Font, 14pt
- Color scheme: Monokai Pro with pure black background (#000000)
- Background opacity: 0.87 (13% transparent)
- Default shell: zsh with login flag (using terminal.shell configuration)
- Window decorations: buttonless
- Scrollback: 50,000 lines
- Vi mode enabled
- GPU acceleration

### Zsh Configuration
- History: 10,000 entries with timestamps
- Word characters: Excludes '/' for better path navigation (Ctrl-W/Alt-Backspace stops at directories)
- Key bindings: Emacs mode with enhanced history search
- Completion: Case-insensitive with menu selection
- Prompt: Starship
- Tool integrations: fzf, zoxide (initialized at end), Homebrew
- Enhanced CLI aliases: eza for ls, bat for cat, fd for find, ripgrep for grep

## CLI Tools & Utilities
- fzf (fuzzy finder)
- ripgrep (code search)
- fd (find replacement)
- bat (cat with syntax highlighting)
- eza (modern ls)
- zoxide (smart cd)
- tldr (simplified man pages)
- jq (JSON processor)
- yq (YAML processor)
- mtr (network diagnostics)
- doggo (DNS client)
- curlie (curl + httpie syntax)
- httpie (HTTP client)
- mosh (mobile shell, better SSH)

## Text Editors & IDEs
- Neovim with LazyVim distribution (idempotent installation - preserves existing configuration)
- VS Code with extensions

## Neovim Plugins (via LazyVim)
- nvim-lspconfig (Language Server Protocol)
- null-ls (formatting: black, prettier, terraform fmt)
- nvim-dap (debugger)
- Telescope (fuzzy finder)
- nvim-tree (file explorer)
- toggleterm (terminal integration)
- vim-fugitive (git)
- vim-surround (text objects)
- vim-commentary (comments)
- gitsigns (git decorations)
- which-key (keybinding hints)

## VS Code Extensions
- ms-python.python
- ms-python.vscode-pylance
- ms-python.debugpy
- dbaeumer.vscode-eslint
- esbenp.prettier-vscode
- bradlc.vscode-tailwindcss
- HashiCorp.terraform
- redhat.ansible
- ms-azuretools.vscode-docker
- eamodio.gitlens
- vscodevim.vim
- shardulm94.trailing-spaces
- oderwat.indent-rainbow
- usernamehw.errorlens
- ms-vscode-remote.remote-ssh

## Version Control
- git
- lazygit (terminal UI)
- delta (diff viewer)
- gh (GitHub CLI)
- tig (repository browser)
- Fork (Git GUI, paid software)

## Language Runtimes & Version Managers
- pyenv (Python version management)
- poetry (Python dependency management)
- pipx (isolated Python CLI tools)
- fnm (Node.js version manager)
- direnv (automatic environment variables)

## Containers & Virtualization
- Colima (container runtime)
- podman (container CLI)
- UTM (QEMU frontend for VMs)

## Infrastructure as Code
- Terraform
- terraform-docs
- tflint
- tfsec
- Ansible
- ansible-lint
- Packer (note: no longer available via Homebrew, manual install required)

## Database Tools
- TablePlus (universal database GUI, paid software)
- mycli (MySQL CLI with autocomplete)
- pgcli (PostgreSQL CLI)

## API Development
- HTTPie Desktop
- httpie (CLI)

## Monitoring & System Tools
- btop (system monitor)
- Stats (menu bar system monitor)
- glances (alternative system monitor)

## Productivity & Utilities
- Alfred Powerpack (launcher, paid software)
- Maccy (clipboard manager)
- espanso (text expander - note: no longer available via Homebrew, manual install required)
- AlDente (battery charge limiter, free tier, limit to 80%)

## Documentation & Knowledge
- Obsidian (notes, markdown-based)
- Zeal (offline API documentation - note: no longer available via Homebrew, consider alternatives)

## File Management
- Keka (archive utility)
- Quick Look plugins (note: deprecated in modern macOS, limited availability)

## Browsers
- Firefox Developer Edition
- Google Chrome

## Security & Secrets
- Bitwarden (password manager)
- ansible-vault (Ansible secrets)
- Little Snitch (network firewall, paid software)

## Backup
- Time Machine (built-in)

## macOS System Configurations

### Finder
- Show hidden files
- Show all file extensions
- Show path bar
- Show status bar
- Default location: home folder
- Disable .DS_Store on network drives
- Disable .DS_Store on USB drives
- Show ~/Library folder
- Use list view as default
- Show full path in title bar
- Keep folders on top when sorting
- Search current folder by default
- Expanded save dialogs default

### Keyboard
- Key repeat rate: 2 (fast)
- Initial key repeat delay: 15 (short)
- Disable auto-correct
- Disable auto-capitalize
- Disable smart quotes
- Disable smart dashes
- Disable period substitution
- Disable automatic text completion

### Dock
- Auto-hide enabled
- Minimize animation: scale effect
- Show delay removed
- Hide delay removed
- Icon size: 56 pixels
- Show recent applications: disabled
- Minimize to application icon

### System
- Disable UI animations
- Reduce transparency
- Disable sound effects
- Screenshots directory: ~/Screenshots
- Screenshots format: PNG
- Disable screenshot thumbnail preview
- Three-finger drag enabled (Accessibility)
- Hot corners configured
- Scroll direction: not natural (Linux-like)

### Security
- Require password immediately after sleep
- Show lock screen message with contact info
- Firewall enabled
- Stealth mode enabled

### Menu Bar
- Show battery percentage
- Use 24-hour time format
- Show date in menu bar
- Flash clock separators: disabled

### Other
- Expand print dialog by default
- Disable resume system-wide
- Disable automatic termination of inactive apps
- Disable disk image verification
- Disable Time Machine prompts for new disks
- Enable full keyboard access for all controls
- Disable press-and-hold for special characters (enable key repeat)

## SSH Configuration
- ControlMaster auto
- ControlPersist 10m
- ServerAliveInterval 60
- Compression yes
- VisualHostKey yes
- Include config.d directory

## Git Configuration
- User name and email
- Default branch: main
- Pull strategy: rebase
- Delta as pager
- GPG signing (optional)
- Aliases for common commands

