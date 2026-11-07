#!/usr/bin/env bash
# Session killer: fuzzy-select one or more tmux sessions to kill.
# Multi-select with Tab, confirm with Enter.

current=$(tmux display-message -p '#S')

selected=$(tmux list-sessions -F '#{session_name}' 2>/dev/null \
    | grep -v "^${current}$" \
    | fzf --multi \
          --prompt="Kill session(s) > " \
          --header="Tab to multi-select | Current session (${current}) excluded")

[[ -z "$selected" ]] && exit 0

while IFS= read -r session; do
    tmux kill-session -t "$session"
    echo "Killed: $session"
done <<< "$selected"
