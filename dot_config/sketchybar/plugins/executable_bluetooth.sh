#!/usr/bin/env sh

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Requires blueutil (brew install blueutil) for reliable state.
if command -v blueutil >/dev/null 2>&1; then
    POWER=$(blueutil --power)
    if [ "$POWER" = "1" ]; then
        sketchybar --set cc.bluetooth icon="$ICON_BT" icon.color=$WHITE
    else
        sketchybar --set cc.bluetooth icon="$ICON_BT_OFF" icon.color=$DIM
    fi
else
    sketchybar --set cc.bluetooth icon="$ICON_BT" icon.color=$WHITE
fi
