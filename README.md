# dotfiles

Managed with [chezmoi](https://www.chezmoi.io). Source directory is this folder (`~/Ark/dotfiles`, set in `~/.config/chezmoi/chezmoi.toml`), target is `$HOME`.

Fresh Mac: `~/Ark/dotfiles/bootstrap.sh` (see the header of that file for the clone one-liner). It installs Homebrew, runs `chezmoi apply`, and `chezmoi` then runs the `run_once_*` scripts: Brewfile, oh-my-zsh, powerlevel10k, tpm, VSCode extensions, npm globals, and a reminder to load secrets. Detailed, verifiable steps for a person or an agent: `AGENT-SETUP.md`.

Day to day:

    chezmoi edit ~/.zshrc      # edit the source, then apply
    chezmoi apply              # write managed files into ~
    chezmoi re-add             # pull edits made directly in ~ (e.g. by VSCode, Claude Code, Obsidian) back into the source
    chezmoi diff               # what would change
    chezmoi managed            # everything under management

What is managed: zsh (.zshrc, .zprofile, .p10k.zsh, .zsh_keychain_secrets, .config/zsh/keychain-items.txt), tmux, aerospace, git, kitty, sketchybar, nvim (full config, formerly its own repo), VSCode settings/keybindings/snippets, Claude Code settings and the design-taste-frontend skill. `~/.claude/CLAUDE.md` and the Claude memory notes are applied by chezmoi too but are gitignored here (personal); they travel with the Ark backup, not with this repo.

Not managed as dotfiles, ignored via `.chezmoiignore`: `brew/` (Brewfile, npm-globals.txt), `vscode-extensions.txt`, `scripts/` (personal scripts; `scripts/secrets/` moves secrets between Bitwarden and the Keychain), `reference/` (Claude plugin and MCP lists).

Secrets are never in this repo. Values live in the macOS Keychain as `env:NAME` items and in Bitwarden (folder `env`). `.zsh_keychain_secrets` exports them at shell start from the names listed in `~/.config/zsh/keychain-items.txt`.
