#!/bin/bash

# This script upgrades Homebrew itself, and then upgrades all installed formulae and casks individually.
#
# It ensures that:
# 1. Homebrew is updated first (brew update)
# 2. Homebrew itself is upgraded if necessary (brew upgrade brew)
# 3. Installed formulae are upgraded one-by-one
# 4. Installed casks are upgraded one-by-one
#
# This avoids issues where outdated Homebrew versions could cause upgrade failures.
# Note: Some cask upgrades may prompt for an administrator password if required by the app's installer.

# Function to update and upgrade Homebrew itself
upgrade_homebrew() {
  echo "Updating Homebrew..."
  brew update
}

# Function to upgrade Homebrew formulae
upgrade_formulae() {
  echo "Upgrading Homebrew formulae..."
  brew list --formula | while IFS= read -r formula; do
    brew upgrade "$formula"
  done
}

# Function to upgrade Homebrew casks
upgrade_casks() {
  echo "Upgrading Homebrew casks..."
  brew list --cask | while IFS= read -r cask; do
    brew upgrade --cask "$cask"
  done
}

# Run all upgrade functions in order
upgrade_homebrew
upgrade_formulae
upgrade_casks