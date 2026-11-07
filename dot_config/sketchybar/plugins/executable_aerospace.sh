#!/usr/bin/env sh

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/plugins/workspace_names.sh"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
LABEL=$(workspace_label "$FOCUSED")

# Layout state of the focused window (empty if the workspace has no windows).
#   window-is-fullscreen           -> true | false
#   window-layout                  -> "floating", else the effective tiling layout
#   window-parent-container-layout -> h_tiles | v_tiles | h_accordion | v_accordion
STATE=$(aerospace list-windows --focused \
        --format '%{window-is-fullscreen}|%{window-layout}|%{window-parent-container-layout}' \
        2>/dev/null | head -1)

FULLSCREEN=$(echo "$STATE" | cut -d'|' -f1)
WIN_LAYOUT=$(echo "$STATE" | cut -d'|' -f2)
PARENT_LAYOUT=$(echo "$STATE" | cut -d'|' -f3)

# Maps a container layout to its glyph.
#   even split     = tiles      (columns horizontal, bars vertical)
#   dominant panel = accordion  (▐█▌ horizontal, ▂█▂ vertical)
layout_glyph() {
    case "$1" in
        h_tiles)     printf '%s' "$ICON_LAYOUT_H_TILES" ;;
        v_tiles)     printf '%s' "$ICON_LAYOUT_V_TILES" ;;
        h_accordion) printf '%s' "$ICON_LAYOUT_H_ACCORDION" ;;
        v_accordion) printf '%s' "$ICON_LAYOUT_V_ACCORDION" ;;
        *)           printf '%s' "$ICON_LAYOUT_H_TILES" ;;
    esac
}

if [ -z "$STATE" ]; then
    # Nothing focused on this workspace
    ICON="$ICON_LAYOUT_EMPTY"
    ICON_COLOR="$DIM"
elif [ "$FULLSCREEN" = "true" ]; then
    # Keep the underlying orientation visible alongside the fullscreen marker
    ICON="$ICON_LAYOUT_FULL $(layout_glyph "$PARENT_LAYOUT")"
    ICON_COLOR="$MAUVE"
elif [ "$WIN_LAYOUT" = "floating" ]; then
    ICON="$ICON_LAYOUT_FLOAT"
    ICON_COLOR="$ORANGE"
else
    # Tiles and accordion are both white — the glyph alone carries the distinction.
    ICON="$(layout_glyph "$PARENT_LAYOUT")"
    ICON_COLOR="$SOFT_WHITE"
fi

sketchybar --set workspace icon="$ICON" icon.color="$ICON_COLOR" label="$LABEL"
