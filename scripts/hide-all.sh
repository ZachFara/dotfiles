#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Hide All
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Hides all open windows
# @raycast.author Zachariah Farahany

osascript -e 'tell application "System Events" to set visible of (every process whose background only is false) to false'

