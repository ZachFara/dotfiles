#!/bin/zsh
# Fresh Mac: one command rebuilds the setup from this repo.
#   mkdir -p ~/Ark && git clone https://github.com/ZachFara/dotfiles ~/Ark/dotfiles && ~/Ark/dotfiles/bootstrap.sh
# or, if ~/Ark was copied from the backup drive, just:  ~/Ark/dotfiles/bootstrap.sh
set -e
K="$HOME/Ark/dotfiles"
[ -x /opt/homebrew/bin/brew ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
command -v chezmoi >/dev/null || brew install chezmoi
mkdir -p "$HOME/.config/chezmoi"
printf 'sourceDir = "%s"\n' "$K" > "$HOME/.config/chezmoi/chezmoi.toml"
chezmoi apply        # runs brew bundle, oh-my-zsh/p10k/tpm, writes every dotfile, installs VSCode extensions and npm globals
echo
echo "Setup applied. Remaining manual steps are listed in $K/AGENT-SETUP.md"
