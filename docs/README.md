# Initial Setup

Before running Ansible, complete these steps on a fresh macOS installation.


## 1. Install Xcode Command Line Tools

Required before Homebrew or Ansible can run:

    xcode-select --install

Wait for installation to complete (several minutes).


## 2. Run Bootstrap Script

After Xcode CLI tools are installed:

    ~/.dotfiles/scripts/first-run.sh

This script will:

    - Install Homebrew
    - Install Ansible via Homebrew
    - Run the main playbook
