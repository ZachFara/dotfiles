#!/usr/bin/env sh

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

# Heuristic: ProtonVPN brings up a utun interface beyond the
# stock macOS ones (utun0-2 are usually system/iCloud).
# If you have the ProtonVPN CLI installed, swap this line for
# a direct status check instead, e.g.:
#   protonvpn-cli status | grep -q "Connected"
VPN_ACTIVE=$(ifconfig | awk '/^utun[3-9]/{iface=$1} iface && /inet /{print iface; exit}')

if [ -n "$VPN_ACTIVE" ]; then
    sketchybar --set protonvpn icon.color=$VPN_CONNECTED
else
    sketchybar --set protonvpn icon.color=$VPN_DISCONNECTED
fi
