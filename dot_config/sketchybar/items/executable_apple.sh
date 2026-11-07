#!/usr/bin/env sh

sketchybar --add item apple.logo left \
           --set apple.logo \
                 icon="$ICON_APPLE" \
                 icon.font="JetBrainsMono Nerd Font:Bold:16.0" \
                 icon.color=$WHITE \
                 label.drawing=off \
                 padding_left=8 \
                 padding_right=10 \
                 click_script="osascript -e 'tell application \"System Events\" to click menu bar item 1 of menu bar 1 of process \"SystemUIServer\"' 2>/dev/null || open -a 'System Preferences'"
