#!/usr/bin/env bash
# Ensures standard tmux sessions exist with required windows. Creates missing ones.

MAGHZDOVOM_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/MaghzDovom"

session_exists() {
    tmux has-session -t "$1" 2>/dev/null
}

# Returns true if any pane in the session is currently at the given path
pane_exists_at() {
    local session="$1"
    local path="$2"
    tmux list-panes -t "$session" -a -F '#{pane_current_path}' 2>/dev/null | grep -qxF "$path"
}

ensure_window() {
    local session="$1"
    local path="$2"
    if pane_exists_at "$session" "$path"; then
        echo "  [ok] window exists at: $path"
    else
        tmux new-window -t "$session" -c "$path"
        echo "  [+] created window at: $path"
    fi
}

# --- config ---
echo "==> config"
if ! session_exists "config"; then
    tmux new-session -d -s "config" -c "$HOME/.config"
    tmux new-window -t "config" -c "$HOME/.config/nvim"
    echo "  [+] created session with windows at ~/.config and ~/.config/nvim"
else
    ensure_window "config" "$HOME/.config"
    ensure_window "config" "$HOME/.config/nvim"
fi

# --- maghzdovom ---
echo "==> maghzdovom"
if ! session_exists "maghzdovom"; then
    tmux new-session -d -s "maghzdovom" -c "$MAGHZDOVOM_DIR"
    echo "  [+] created session with window at MaghzDovom"
else
    ensure_window "maghzdovom" "$MAGHZDOVOM_DIR"
fi

# --- misc ---
echo "==> misc"
if ! session_exists "misc"; then
    tmux new-session -d -s "misc" -c "$HOME/Development"
    echo "  [+] created session with window at ~/Development"
else
    ensure_window "misc" "$HOME/Development"
fi

echo ""
echo "Done."
