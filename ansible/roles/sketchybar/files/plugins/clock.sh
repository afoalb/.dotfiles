#!/bin/bash

# Simple clock: "Mon 14 · 15:30"
sketchybar --set "$NAME" label="$(date '+%a %d · %H:%M')"
