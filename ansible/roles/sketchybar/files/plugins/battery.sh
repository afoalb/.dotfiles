#!/bin/bash

# Simple battery percentage
PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | head -1)"
CHARGING="$(pmset -g batt | grep -c 'AC Power')"

if [ -z "$PERCENTAGE" ]; then
    exit 0
fi

if [ "$CHARGING" -eq 1 ]; then
    sketchybar --set "$NAME" label="⚡ ${PERCENTAGE}"
else
    sketchybar --set "$NAME" label="${PERCENTAGE}"
fi
