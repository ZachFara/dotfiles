#!/usr/bin/env bash
#
# Try a Nerd Font glyph live in the workspace pill, without editing any config.
#
#   ./preview-icon.sh F0DB              # show U+F0DB
#   ./preview-icon.sh F065 F0C9         # show two glyphs side by side
#   ./preview-icon.sh -c 0xffbf5af2 F065  # ...in a specific color
#   ./preview-icon.sh --restore         # back to the real layout state
#
# Codepoints come from https://www.nerdfonts.com/cheat-sheet (drop the "U+").
# While previewing, the item's 2s poll is paused so the glyph doesn't get
# overwritten; --restore turns it back on.

CONFIG_DIR="$HOME/.config/sketchybar"

restore() {
    sketchybar --set workspace update_freq=2 >/dev/null
    sh "$CONFIG_DIR/plugins/aerospace.sh"
    echo "restored: showing live layout state again"
}

[ $# -eq 0 ] && { restore; exit 0; }
[ "$1" = "--restore" ] || [ "$1" = "-r" ] && { restore; exit 0; }

COLOR=""
if [ "$1" = "-c" ]; then
    COLOR="$2"; shift 2
fi

GLYPHS=$(python3 -c '
import sys
print(" ".join(chr(int(a.lstrip("Uu+"), 16)) for a in sys.argv[1:]))' "$@") || exit 1

# Freeze the poll so the preview sticks
sketchybar --set workspace update_freq=0 >/dev/null

if [ -n "$COLOR" ]; then
    sketchybar --set workspace icon="$GLYPHS" icon.color="$COLOR" label="$*"
else
    sketchybar --set workspace icon="$GLYPHS" label="$*"
fi

echo "previewing: $* $([ -n "$COLOR" ] && echo "in $COLOR")"
echo "run '$0 --restore' when done"
