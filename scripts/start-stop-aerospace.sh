#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Start Stop Aerospace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Start Stop Aerospace
# @raycast.author Zachariah Farahany

if pgrep -x "AeroSpace" > /dev/null; then
    killall AeroSpace
    killall borders
else
    open /Applications/AeroSpace.app
fi

