#!/bin/bash

# Show current app name
if [ "$SENDER" = "front_app_switched" ]; then
    sketchybar --set "$NAME" label="$INFO"
fi
