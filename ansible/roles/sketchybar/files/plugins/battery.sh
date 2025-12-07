#!/usr/bin/env sh
pmset -g batt | grep -Eo '[0-9]+%'
