#!/usr/bin/env bash
# Sessionizer: fuzzy-find a project directory and create/switch to its tmux session.
# Searches ~/Development/active by default. Pass additional paths as arguments.

SEARCH_DIRS=(
    "$HOME/Development/active"
)

# Append any extra paths passed as arguments
for arg in "$@"; do
    SEARCH_DIRS+=("$arg")
done

# Find directories one level deep and fuzzy-select
selected=$(find "${SEARCH_DIRS[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)

# Exit if nothing was selected
[[ -z "$selected" ]] && exit 0

# Use the folder name as the session name (sanitize dots → underscores for tmux)
session_name=$(basename "$selected" | tr '.' '_')

if tmux has-session -t "$session_name" 2>/dev/null; then
    # Session exists — switch to it
    tmux switch-client -t "$session_name"
else
    # Create new detached session rooted at the selected directory
    tmux new-session -d -s "$session_name" -c "$selected"
    tmux switch-client -t "$session_name"
fi
