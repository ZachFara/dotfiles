#!/usr/bin/env sh

sketchybar --add item clock right \
           --set clock \
                 update_freq=10 \
                 icon="$ICON_CLOCK" \
                 icon.color=$SOFT_WHITE \
                 icon.font="JetBrainsMono Nerd Font:Medium:12.0" \
                 label.font="SF Pro:Semibold:13.0" \
                 script="$PLUGIN_DIR/clock.sh" \
                 click_script="$PLUGIN_DIR/open_control_center.sh"
