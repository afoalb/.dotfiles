#!/bin/bash

# Highlight active workspace
if [ "$SELECTED" = "true" ]; then
    sketchybar --set "$NAME" icon.highlight=on
else
    sketchybar --set "$NAME" icon.highlight=off
fi
