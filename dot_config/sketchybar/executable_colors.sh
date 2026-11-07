#!/usr/bin/env sh

# ============================================================
#  Clear / Apple-native palette
#  The bar itself is translucent (frosted glass). Text and icons
#  are white like the native menu bar, with Apple system colors
#  used sparingly for meaningful status.
# ============================================================

# Bar: fully transparent — the wallpaper/screensaver shows through,
# with a subtle blur for a frosted-glass edge. Native menu bar is hidden.
# (If text is hard to read over a bright wallpaper, bump the alpha,
#  e.g. 0x33000000 for a light tint.)
export BAR_COLOR=0x00000000
export BAR_BORDER_COLOR=0x00000000

# Neutral text/icon shades (white with varying opacity)
export WHITE=0xffffffff
export SOFT_WHITE=0xf0ffffff
export GREY=0x99ffffff        # dimmed  (~60%)
export DIM=0x59ffffff         # dimmer  (~35%)

# Apple system accent colors (used sparingly)
export RED=0xffff453a
export GREEN=0xff32d74b
export YELLOW=0xffffd60a
export ORANGE=0xffff9f0a
export BLUE=0xff0a84ff
export MAUVE=0xffbf5af2
export TEAL=0xff64d2ff

export ITEM_BG_COLOR=0x1affffff
export ACCENT_COLOR=$SOFT_WHITE

# Current-workspace pill (subtle translucent white highlight)
export SPACE_PILL_BG=0x26ffffff
export SPACE_ACTIVE_ICON=$WHITE
export SPACE_INACTIVE_ICON=$GREY

# VPN status
export VPN_CONNECTED=$WHITE
export VPN_DISCONNECTED=$DIM
