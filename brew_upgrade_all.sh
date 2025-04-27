#!/bin/bash

# This script upgrades all installed Homebrew formulae and casks individually.
# 
# It loops through the list of installed formulae and upgrades each one separately,
# then loops through the list of installed casks and upgrades each one separately.
# 
# This ensures that all packages are explicitly upgraded, avoiding issues where 
# some casks may not upgrade properly when running a blanket 'brew upgrade' command.
# 
# Note: Some cask upgrades may prompt for an administrator password if required 
# by the app's installer.

# Function to upgrade Homebrew formulae
upgrade_formulae() {
  for formula in $(brew list --formula); do
    brew upgrade "$formula"
  done
}

# Function to upgrade Homebrew casks
upgrade_casks() {
  for cask in $(brew list --cask); do
    brew upgrade --cask "$cask"
  done
}

# Run both functions serially
upgrade_formulae
upgrade_casks


