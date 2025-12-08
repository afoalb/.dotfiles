#!/usr/bin/env bash
set -e

# ----------------------------
# Configuration
# ----------------------------
DOTFILES_DIR="$HOME/.dotfiles"
ANSIBLE_DIR="$DOTFILES_DIR/ansible"
VAULT_PASS_FILE="$ANSIBLE_DIR/.vault_pass.txt"
SECRETS_FILE="$ANSIBLE_DIR/vars/secrets.yml"
CURRENT_USER="$(whoami)"

# ----------------------------
# Step 0: Ensure vault password file exists
# ----------------------------
if [ ! -f "$VAULT_PASS_FILE" ]; then
  echo "[first-run] Creating local Ansible vault password..."
  mkdir -p "$(dirname "$VAULT_PASS_FILE")"
  openssl rand -base64 32 > "$VAULT_PASS_FILE"
  chmod 600 "$VAULT_PASS_FILE"
  chown "$CURRENT_USER" "$VAULT_PASS_FILE"
fi

# ----------------------------
# Step 1: Handle sudo password
# ----------------------------
update_sudo_pass() {
  read -s -p "Enter your sudo password: " SUDO_PASS
  echo

  mkdir -p "$(dirname "$SECRETS_FILE")"

  # Encrypt sudo password under secrets.sudo_pass
  ansible-vault encrypt_string "$SUDO_PASS" --name "sudo_pass" \
    --vault-password-file "$VAULT_PASS_FILE" >> "$SECRETS_FILE"

  # Ensure ownership and permissions
  chmod 600 "$SECRETS_FILE"
  chown "$CURRENT_USER" "$SECRETS_FILE"

  echo "[first-run] Sudo password encrypted and stored in $SECRETS_FILE"
}

if [ ! -f "$SECRETS_FILE" ]; then
  echo "[first-run] No sudo password stored yet."
  update_sudo_pass
else
  echo "[first-run] A sudo password is already stored in $SECRETS_FILE."
  echo "Do you want to use the current sudo password or enter a new one?"
  select choice in "Use current password" "Enter new password"; do
    case $choice in
      "Use current password")
        echo "[first-run] Using existing sudo password."
        break
        ;;
      "Enter new password")
        update_sudo_pass
        break
        ;;
      *)
        echo "Invalid choice. Please select 1 or 2."
        ;;
    esac
  done
fi

# ----------------------------
# Step 2: Ensure Homebrew is installed
# ----------------------------
ensure_brew_installed() {
  if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
    return 0
  fi
  
  echo "[first-run] Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

ensure_brew_installed

echo "[first-run] Adding Homebrew to PATH for this script..."
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "[first-run] Updating Homebrew..."
brew update

# ----------------------------
# Step 3: Ensure Ansible is installed
# ----------------------------
echo "[first-run] Installing Ansible..."
brew install ansible

# ----------------------------
# Step 4: Run the Ansible playbook
# ----------------------------
echo "[first-run] Running Ansible playbook..."
ansible-playbook "$ANSIBLE_DIR/macos.yml" --vault-password-file "$VAULT_PASS_FILE"

echo "[first-run] Setup complete!"
