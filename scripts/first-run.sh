
#!/usr/bin/env bash
set -e


ensure_brew_installed() {
  if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
    return 0
  fi
  
  echo "[first-run] Homebrew not found. Attempting installation..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew_installed

echo "[first-run] Adding Homebrew to PATH..."
echo export PATH=$PATH:/opt/homebrew/bin >> ~/.zshrc
source ~/.zshrc

echo "[first-run] Updating brew..."
brew update

echo "[first-run] Installing Ansible..."
brew install ansible

echo "[first-run] Running Ansible playbook..."
ansible-playbook ~/.dotfiles/ansible/macos.yml --ask-become-pass

echo "[first-run] Done."

