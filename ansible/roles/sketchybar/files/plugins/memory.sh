#!/usr/bin/env sh
vm_stat | awk '/Pages active/ {active=$3} /Pages inactive/ {inactive=$3} END {printf("Mem: %.0f%%", 100*(active+inactive)/(active+inactive+1))}'

