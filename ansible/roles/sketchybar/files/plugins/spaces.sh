#!/usr/bin/env sh
yabai -m query --spaces | jq -r '.[] | if .focused==1 then "" else "" end' | tr -d '\n'

