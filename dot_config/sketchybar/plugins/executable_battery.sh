#!/usr/bin/env sh

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | head -1 | tr -d '%')
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    exit 0
fi

case $PERCENTAGE in
    9[0-9]|100) ICON="$ICON_BAT_100" ;;
    [6-8][0-9]) ICON="$ICON_BAT_75" ;;
    [3-5][0-9]) ICON="$ICON_BAT_50" ;;
    [1-2][0-9]) ICON="$ICON_BAT_25" ;;
    *) ICON="$ICON_BAT_0" ;;
esac

COLOR=$WHITE
if [ -n "$CHARGING" ]; then
    ICON="$ICON_BAT_CHARGING"
    COLOR=$GREEN
elif [ "$PERCENTAGE" -le 10 ]; then
    COLOR=$RED
elif [ "$PERCENTAGE" -le 20 ]; then
    COLOR=$YELLOW
fi

sketchybar --set cc.battery icon="$ICON" \
                             icon.color=$COLOR \
                             label="$PERCENTAGE%" \
                             label.drawing=on
