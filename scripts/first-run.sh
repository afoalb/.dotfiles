
#!/usr/bin/env bash
set -e

echo "[first-run] Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "[first-run] Installing Ansible..."
brew install ansible

echo "[first-run] Running Ansible playbook..."
ansible-playbook ~/.dotfiles/ansible/macos.yml

echo "[first-run] Done."

