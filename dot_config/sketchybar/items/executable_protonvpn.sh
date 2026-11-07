#!/usr/bin/env sh

sketchybar --add item protonvpn right \
           --set protonvpn \
                 icon="$ICON_VPN" \
                 icon.font="JetBrainsMono Nerd Font:Medium:15.0" \
                 icon.color=$VPN_DISCONNECTED \
                 label.drawing=off \
                 update_freq=10 \
                 script="$PLUGIN_DIR/protonvpn.sh" \
                 click_script="open -a ProtonVPN"
