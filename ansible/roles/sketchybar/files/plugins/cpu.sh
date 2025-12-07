#!/usr/bin/env sh
top -l 1 | grep 'CPU usage' | awk '{print $3 $4 $5}'

