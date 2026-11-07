#!/usr/bin/env sh

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# `networksetup -getairportnetwork` no longer returns the SSID on recent
# macOS (locked down), so use the interface link status instead.
if ifconfig en0 2>/dev/null | grep -q "status: active"; then
    sketchybar --set cc.wifi icon="$ICON_WIFI" icon.color=$WHITE
else
    sketchybar --set cc.wifi icon="$ICON_WIFI_OFF" icon.color=$DIM
fi
