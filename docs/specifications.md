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
- Default shell: zsh with tmux auto-start (attaches to existing session or creates new)
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
- Packer (via HashiCorp tap: hashicorp/tap/packer)

## Database Tools
- TablePlus (universal database GUI, paid software)
- mycli (MySQL CLI with autocomplete)
- pgcli (PostgreSQL CLI)

## API Development
- HTTPie Desktop (cask: httpie-desktop, renamed from httpie)
- httpie (CLI)

## Monitoring & System Tools
- btop (system monitor)
- Stats (menu bar system monitor)
- glances (alternative system monitor)

## Productivity & Utilities
- Alfred Powerpack (launcher, paid software)
  - Configured to replace Spotlight with Cmd+Space hotkey
- Maccy (clipboard manager)
- espanso (text expander - installed via direct download from GitHub releases v2.2.1)
- AlDente (battery charge limiter, free tier, limit to 80%, configured as background app)

## Documentation & Knowledge
- Obsidian (notes, markdown-based)
- DevDocs Desktop: discontinued upstream (as of 2024-12-16)
  - Alternatives: Dash (paid), Velocity (open source), or Zeal (deprecated)

## File Management
- Keka (archive utility)

## Media & Entertainment
- Netflix (streaming)
- Spotify (music streaming)
- Shottr (screenshot tool)
- FastRawViewer (RAW and JPEG image viewer, paid software)
  - Set as default for camera images (.jpg, .jpeg, .raw, .cr2, .nef, .arw, .raf, .dng)

## Browsers
- Firefox Developer Edition (extensions synced via profile)
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

### Startup Applications
- Alfred 5 (launcher)
- Maccy (clipboard manager)
- AlDente (battery limiter)
- Ice (menu bar manager)
- Little Snitch (firewall)
- Stats (system monitor)
- SketchyBar (status bar)

### Background Apps (Menu Bar Only)
- AlDente: Configured with LSUIElement to hide from dock
- Maccy: Configured with LSUIElement to hide from dock
- Stats: Configured with LSUIElement to hide from dock
- Ice: Configured with LSUIElement to hide from dock

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


## Default Applications

### File Associations
- Text files (.txt, .md, .log): Neovim
- Code files (.py, .js, .ts, .yml, .json): Neovim
- Archives (.zip, .rar, .7z): Keka

### Protocol Handlers
- http/https: Firefox Developer Edition
- ssh: Alacritty with tmux

### Apps
- Default terminal: Alacritty
- Default browser: Firefox  
- Screenshots: Shottr

### Launcher
- Application launcher: Alfred Powerpack
- Quick actions: Alfred Powerpack

