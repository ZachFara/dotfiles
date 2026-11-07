#!/usr/bin/env sh

# ============================================================
#  Workspace display names  (your dictionary)
#
#  Edit the case block below to rename a workspace. The bar shows
#  "<id> - <name>" when a name is set, or just "<id>" when blank.
#  Example:  1) name="Standard" ;;
#
#  (macOS ships bash 3.2, which has no associative arrays, so this
#   uses a case statement as the "dictionary".)
#  Defaults below are guessed from your ~/.aerospace.toml.
# ============================================================

workspace_label() {
    local id="$1"
    local name=""
    case "$id" in
        1)  name="Web" ;;      # Safari, Claude
        2)  name="Code" ;;     # kitty, VS Code
        3)  name="Notes" ;;    # Obsidian
        4)  name="Chat" ;;     # Messages, Discord
        5)  name="Plan" ;;     # Linear, Calendar
        6)  name="Office" ;;   # Word, Excel
        7)  name="Files" ;;    # Finder
        8)  name="" ;;
        9)  name="Config" ;;   # Docker, VPNs
    esac

    if [ -n "$name" ]; then
        echo "$id - $name"
    else
        echo "$id"
    fi
}
