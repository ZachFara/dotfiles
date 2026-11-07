#!/usr/bin/env sh

# Single-slot workspace indicator:
#   [layout-icon]  <current workspace display name>
# The layout icon reflects fullscreen / horizontal / vertical / accordion.
# Display names are set in plugins/workspace_names.sh.

sketchybar --add event aerospace_workspace_change

sketchybar --add item workspace left \
           --subscribe workspace aerospace_workspace_change front_app_switched \
           --set workspace \
                 update_freq=2 \
                 icon.font="JetBrainsMono Nerd Font:Medium:14.0" \
                 icon.color=$SOFT_WHITE \
                 icon.padding_left=8 \
                 icon.padding_right=4 \
                 label.font="SF Pro:Semibold:13.0" \
                 label.color=$WHITE \
                 label.padding_left=2 \
                 label.padding_right=8 \
                 background.color=$SPACE_PILL_BG \
                 background.corner_radius=7 \
                 background.height=22 \
                 script="$PLUGIN_DIR/aerospace.sh" \
                 click_script="aerospace workspace-back-and-forth"
