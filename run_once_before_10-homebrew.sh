#!/bin/zsh
# Paths come from $CHEZMOI_SOURCE_DIR (set by chezmoi) so moving/renaming the source dir does not re-trigger this.
set -e
if [ ! -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --no-upgrade --file="$CHEZMOI_SOURCE_DIR/brew/Brewfile"
# GUI + App Store apps: failures for apps that are already present are expected and non-fatal.
brew bundle --no-upgrade --file="$CHEZMOI_SOURCE_DIR/brew/Brewfile.apps" || echo "Brewfile.apps: some apps were skipped (already installed or App Store not signed in)"
