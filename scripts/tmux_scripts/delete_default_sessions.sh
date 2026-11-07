#!/usr/bin/env bash
# Deletes all default numbered tmux sessions (e.g. 0, 1, 2, ...)

deleted=0

while IFS= read -r session; do
    if [[ "$session" =~ ^[0-9]+$ ]]; then
        tmux kill-session -t "$session"
        echo "Deleted session: $session"
        ((deleted++))
    fi
done < <(tmux list-sessions -F '#{session_name}' 2>/dev/null)

if [[ $deleted -eq 0 ]]; then
    echo "No default numbered sessions found."
else
    echo "Deleted $deleted session(s)."
fi
