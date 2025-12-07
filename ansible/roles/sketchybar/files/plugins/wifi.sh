#!/usr/bin/env sh
SSID=$(networksetup -getairportnetwork en0 | cut -d ':' -f2 | sed 's/^ //')
sketchybar --set "$NAME" label="$SSID"

