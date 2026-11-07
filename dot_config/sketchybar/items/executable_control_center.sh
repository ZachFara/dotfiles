#!/usr/bin/env sh

# Each status item opens its own native System Settings pane on click
# (uses `open` URL schemes, so no Accessibility permission is needed).
WIFI_CLICK="open 'x-apple.systempreferences:com.apple.wifi-settings-extension'"
BT_CLICK="open 'x-apple.systempreferences:com.apple.BluetoothSettings'"
BATT_CLICK="open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'"

sketchybar --add item cc.battery right \
           --set cc.battery \
                 update_freq=30 \
                 icon.font="JetBrainsMono Nerd Font:Medium:15.0" \
                 label.font="SF Pro:Semibold:12.0" \
                 script="$PLUGIN_DIR/battery.sh" \
                 click_script="$BATT_CLICK" \
           \
           --add item cc.bluetooth right \
           --set cc.bluetooth \
                 icon="$ICON_BT" \
                 icon.font="JetBrainsMono Nerd Font:Medium:15.0" \
                 label.drawing=off \
                 update_freq=15 \
                 script="$PLUGIN_DIR/bluetooth.sh" \
                 click_script="$BT_CLICK" \
           \
           --add item cc.wifi right \
           --set cc.wifi \
                 icon="$ICON_WIFI" \
                 icon.font="JetBrainsMono Nerd Font:Medium:15.0" \
                 label.drawing=off \
                 update_freq=15 \
                 script="$PLUGIN_DIR/wifi.sh" \
                 click_script="$WIFI_CLICK"
