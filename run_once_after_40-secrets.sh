#!/bin/zsh
# Load shell secrets from Bitwarden into the Keychain if a Bitwarden session is available.
if [ -n "${BW_SESSION:-}" ] && command -v bw >/dev/null; then
  zsh "$CHEZMOI_SOURCE_DIR/scripts/secrets/bitwarden-to-keychain.sh"
else
  echo "Secrets: run  bw login && export BW_SESSION=\"\$(bw unlock --raw)\" && zsh $CHEZMOI_SOURCE_DIR/scripts/secrets/bitwarden-to-keychain.sh"
fi
