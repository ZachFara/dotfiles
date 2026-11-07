#!/bin/zsh
set -e
if command -v code >/dev/null; then
  while read -r ext; do [ -n "$ext" ] && code --install-extension "$ext" >/dev/null 2>&1 && echo "vscode: $ext"; done < "$CHEZMOI_SOURCE_DIR/vscode-extensions.txt"
fi
if command -v npm >/dev/null; then
  while read -r pkg; do [ -n "$pkg" ] && [ "$pkg" != npm ] && { npm install -g "$pkg" >/dev/null 2>&1 && echo "npm: $pkg" || echo "npm: $pkg skipped (already present or failed)"; }; done < "$CHEZMOI_SOURCE_DIR/brew/npm-globals.txt"
fi
[ -d "$HOME/.tmux/plugins/tpm" ] && "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || true
