# Rebuilding this Mac from ~/Ark

Audience: a person or an agent with a terminal on a fresh macOS install. Each step has a check. Do them in order.

## 0. Preconditions
- Signed in to iCloud (System Settings) with iCloud Drive on. Check: `ls "$HOME/Library/Mobile Documents/com~apple~CloudDocs"` lists `Books` and `Local Documents`.
- The backup drive is mounted, or GitHub is reachable. Check: `ls "/Volumes/My Passport/Ark"` or `curl -sI https://github.com | head -1`.
- Note: the drive is NTFS. On a fresh Mac it mounts read-only until Paragon NTFS for Mac is installed. Read-only is enough for restoring.

## 1. Get ~/Ark
Preferred: copy from the drive, which brings Documents, Games, Archive and Development along.

    rsync -rlt --exclude .DS_Store "/Volumes/My Passport/Ark/" "$HOME/Ark/"

Fallback without the drive (dotfiles and code only):

    mkdir -p ~/Ark && git clone https://github.com/ZachFara/dotfiles ~/Ark/dotfiles

Check: `ls ~/Ark/dotfiles/bootstrap.sh`.

## 2. Run the bootstrap

    ~/Ark/dotfiles/bootstrap.sh

This installs Homebrew and chezmoi, points chezmoi at `~/Ark/dotfiles`, and runs `chezmoi apply`, which installs `brew/Brewfile` (CLI tools, casks, fonts) and `brew/Brewfile.apps` (GUI apps: Chrome, Office, Raycast, Steam, Discord, CleanShot, Zoom, Paragon NTFS, ... plus App Store apps via `mas`), oh-my-zsh, powerlevel10k, tpm, writes every dotfile, installs VSCode extensions and npm globals. Expect 30 to 60 minutes, mostly downloads. macOS will prompt to allow some casks (AeroSpace, kitty, Docker); accept those. Sign in to the App Store beforehand or the four `mas` lines (Bitwarden, Dropover, Goodnotes, Save to Raindrop.io) are skipped; rerun `brew bundle --file ~/Ark/dotfiles/brew/Brewfile.apps` after signing in. Both bundles run with `--no-upgrade`, and failures in Brewfile.apps are non-fatal, so an app that is already present never blocks the apply.

Checks:
- `chezmoi verify --exclude=scripts` prints nothing and exits 0.
- `zsh -ic 'echo $ZSH_THEME'` prints `powerlevel10k/powerlevel10k`.
- `nvim --headless +q` exits 0 (first interactive launch installs plugins).
- `tmux -V`, `kitty --version`, `aerospace --version` all print a version.
- `code --list-extensions | wc -l` is about 20.

recon (the tmux Claude dashboard on prefix + a) is not on crates.io, so the Brewfile cannot install it. After the bootstrap, run:

    cargo install --git https://github.com/gavraz/recon --rev 707418b --locked

Check: `~/.cargo/bin/recon json` prints a JSON list (empty if no Claude sessions are open).

## 3. Secrets
Values are in Bitwarden, folder `env`, items `env:AWS_ACCESS_KEY`, `env:AWS_SECRET`, `env:ANTHROPIC_API_KEY`. Load them into the Keychain:

    bw login
    export BW_SESSION="$(bw unlock --raw)"
    zsh ~/Ark/dotfiles/scripts/secrets/bitwarden-to-keychain.sh

Check: `zsh -ic '[ -n "$ANTHROPIC_API_KEY" ] && echo ok'` prints `ok`. If Bitwarden is unavailable, add each with `security add-generic-password -U -a "$USER" -s "env:NAME" -w "VALUE"`.

## 4. Code

    ln -s ~/Ark/Development ~/Development

Repos are already clones with remotes. Virtual environments and node_modules were not carried; recreate per project (`uv sync`, `npm install`). Claude Code hooks in `~/.claude/settings.json` call `~/Development/active/AgentCommons/.venv/bin/commons`, so run `uv sync` in that repo first or the hooks will warn.

Check: `cd ~/Development/active/AgentCommons && git status` shows a clean tree on `main`.

## 5. Obsidian
Install Obsidian (in the Brewfile), open the vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/MaghzDovom` once iCloud has synced it. The vault's git repo lives in a `.nosync` folder inside it; see the vault's own CLAUDE.md. `~/Ark/Obsidian` should be a symlink to that path.

## 6. Books
`~/Ark/Books` is a symlink to `~/Library/Mobile Documents/com~apple~CloudDocs/Books`. Recreate the symlink if it is missing. The drive holds a real copy under `Ark/Books` in case iCloud is slow.

## 7. Games
Copy back only what you want: `~/Ark/Games/Terraria/AppSupport` to `~/Library/Application Support/Terraria`, `RimWorld/Saves` and `RimWorld/Config` to `~/Library/Application Support/RimWorld/`, `Barony/dotbarony` to `~/.barony`, FTL and IntoTheBreach to their folders under Application Support, `Paradox Interactive` to `~/Documents/Paradox Interactive`, and unpack `ProjectZomboid/Zomboid-saves-from-old-backup.tar.gz` to `~/Zomboid`. Steam games re-download from Steam.

## 8. Not restored by design
Caches, old virtualenvs, node_modules, Steam library, Downloads clutter, VSCode history, Claude Code session transcripts, Photos (iCloud Photos, sign in), Messages and Mail (synced by Apple ID). Raycast: sign in to the Raycast account; `~/Ark/dotfiles/raycast/` is only a reference copy. Account sign-ins are manual: Chrome, Microsoft 365, Steam, Discord, Telegram, WhatsApp, Zoom, ProtonVPN, Bitwarden, Claude Code (`claude` then login), VSCode Settings Sync off (settings come from chezmoi), GitHub (`gh auth login`), Docker. Paragon NTFS needs its license entered. Microsoft Defender came from the UChicago MDM, not from here.

## Known rough edges
- `brew bundle check` can complain that `docker-desktop` "needs to be installed or updated" when Docker has updated itself; that is why the bundle runs with `--no-upgrade`.
- `.zshrc` references `~/tools/plink` and `.tmux.conf` references `~/.config/tmux-runner.sh`; neither exists. Harmless.
- Claude Code and VSCode write their settings files directly. After changing settings in those apps, run `chezmoi re-add` to capture them.
