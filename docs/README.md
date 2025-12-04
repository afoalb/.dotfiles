
# macOS Setup Instructions (Phase 0)

## 1. Install Xcode Command Line Tools

macOS requires these before Homebrew or Ansible can run:

    xcode-select --install

Wait until installation finishes (it may take several minutes).


## 2. Run first-run script

After CLT is installed, use:

    ~/.dotfiles/scripts/first-run.sh

This script will:
- Install Homebrew
- Install Ansible via Homebrew
- Run the main playbook
