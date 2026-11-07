#!/usr/bin/env sh

osascript -e '
tell application "System Events"
    tell process "ControlCenter"
        click menu bar item "Control Center" of menu bar 1
    end tell
end tell
'
