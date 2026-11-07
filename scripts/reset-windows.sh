#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Reset windows
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Reset aerospace windows to go to their proper place
# @raycast.author Zachariah Farahany

match_re() { awk -F'|' -v re="$1" '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); if ($2 ~ re) print $1}'; }
match_app() { awk -F'|' -v app="$1" '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); if ($2 == app) print $1}'; }

# Workspace 1 - Browsing and AI
aerospace list-windows --all | match_app 'Safari' | xargs -I{} aerospace move-node-to-workspace --window-id {} 1
aerospace list-windows --all | match_app 'Google Chrome' | xargs -I{} aerospace move-node-to-workspace --window-id {} 1
aerospace list-windows --all | match_app 'Claude' | xargs -I{} aerospace move-node-to-workspace --window-id {} 1

# Workspace 2 - Coding & Working
aerospace list-windows --all | match_app 'kitty' | xargs -I{} aerospace move-node-to-workspace --window-id {} 2
aerospace list-windows --all | match_app 'Code' | xargs -I{} aerospace move-node-to-workspace --window-id {} 2

# Workspace 3 - Notes
aerospace list-windows --all | match_app 'Obsidian' | xargs -I{} aerospace move-node-to-workspace --window-id {} 3
aerospace list-windows --all | match_app 'Goodnotes' | xargs -I{} aerospace move-node-to-workspace --window-id {} 3
aerospace list-windows --all | match_app 'Microsoft OneNote' | xargs -I{} aerospace move-node-to-workspace --window-id {} 3

# Workspace 4 - Communication
aerospace list-windows --all | match_app 'Messages' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4
aerospace list-windows --all | match_app 'Discord' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4
aerospace list-windows --all | match_app 'WhatsApp' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4
aerospace list-windows --all | match_app 'Microsoft Outlook' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4
aerospace list-windows --all | match_app 'Zoom' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4
aerospace list-windows --all | match_app 'Telegram' | xargs -I{} aerospace move-node-to-workspace --window-id {} 4

# Workspace 5 - Planning
aerospace list-windows --all | match_app 'Linear' | xargs -I{} aerospace move-node-to-workspace --window-id {} 5
aerospace list-windows --all | match_app 'Calendar' | xargs -I{} aerospace move-node-to-workspace --window-id {} 5

# Workspace 6 - Office
aerospace list-windows --all | match_app 'Microsoft Word' | xargs -I{} aerospace move-node-to-workspace --window-id {} 6
aerospace list-windows --all | match_app 'Microsoft Excel' | xargs -I{} aerospace move-node-to-workspace --window-id {} 6
aerospace list-windows --all | match_app 'Microsoft PowerPoint' | xargs -I{} aerospace move-node-to-workspace --window-id {} 6
aerospace list-windows --all | match_app 'LibreOffice' | xargs -I{} aerospace move-node-to-workspace --window-id {} 6
aerospace list-windows --all | match_re 'Tableau' | xargs -I{} aerospace move-node-to-workspace --window-id {} 6

# Workspace 7 - Finder & Screenshots
aerospace list-windows --all | match_app 'Finder' | xargs -I{} aerospace move-node-to-workspace --window-id {} 7
aerospace list-windows --all | match_app 'CleanShot X' | xargs -I{} aerospace move-node-to-workspace --window-id {} 7

# Workspace 8 - Games
aerospace list-windows --all | match_re 'Steam|GeForce|Barony|RimWorld|Terraria|Kerbal|Zomboid|Polytopia|FTL|Into the Breach|Farmer Was Replaced' | xargs -I{} aerospace move-node-to-workspace --window-id {} 8

# Workspace 9 - Configuration (Docker, VPNs, settings)
aerospace list-windows --all | match_app 'Docker Desktop' | xargs -I{} aerospace move-node-to-workspace --window-id {} 9
aerospace list-windows --all | match_app 'Proton VPN' | xargs -I{} aerospace move-node-to-workspace --window-id {} 9
aerospace list-windows --all | match_app 'Activity Monitor' | xargs -I{} aerospace move-node-to-workspace --window-id {} 9
aerospace list-windows --all | match_app 'System Settings' | xargs -I{} aerospace move-node-to-workspace --window-id {} 9
aerospace list-windows --all | match_re 'Logi Options|Logitech' | xargs -I{} aerospace move-node-to-workspace --window-id {} 9

