#!/bin/bash

# Battery with icon
PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | head -1)"
CHARGE="$(echo "$PERCENTAGE" | tr -d '%')"
CHARGING="$(pmset -g batt | grep -c 'AC Power')"

if [ -z "$PERCENTAGE" ]; then
    exit 0
fi

# Select battery icon based on charge level
if [ "$CHARGING" -eq 1 ]; then
    ICON="󰂄"  # Charging
else
    if [ "$CHARGE" -ge 90 ]; then
        ICON="󰁹"  # Full
    elif [ "$CHARGE" -ge 60 ]; then
        ICON="󰂀"  # 3/4
    elif [ "$CHARGE" -ge 30 ]; then
        ICON="󰁾"  # Half
    elif [ "$CHARGE" -ge 10 ]; then
        ICON="󰁻"  # 1/4
    else
        ICON="󰂃"  # Empty
    fi
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}"
