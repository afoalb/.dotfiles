#!/usr/bin/env sh

DATA_DIR="/tmp/sketchybar_cpu_graph"
HISTORY_FILE="$DATA_DIR/history"
mkdir -p "$DATA_DIR"

MAX_POINTS=12
SPARKS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# --- Get number of CPU cores ---
NUM_CORES=$(sysctl -n hw.ncpu)

# --- Get total CPU usage per process and normalize to 0-100% ---
CPU=$(ps -A -o %cpu | awk -v cores="$NUM_CORES" '{s+=$1} END {printf "%.0f", s/cores}')

# --- Load previous history ---
HISTORY=$(cat "$HISTORY_FILE" 2>/dev/null || echo "")

# Append new value
HISTORY="$HISTORY $CPU"

# Keep graph at fixed width
HISTORY=$(echo "$HISTORY" | awk -v max="$MAX_POINTS" '{for(i=NF-max+1;i<=NF;i++) if(i>0) printf "%s ", $i}')

echo "$HISTORY" > "$HISTORY_FILE"

# --- Convert values → bricks ---
graph=""
for val in $HISTORY; do
  idx=$(( val * 7 / 100 ))
  [ $idx -gt 7 ] && idx=7
  [ $idx -lt 0 ] && idx=0
  graph="$graph${SPARKS[$idx]}"
done

# --- Fixed-width, left-aligned CPU label ---
CPU_STR=$(printf "%-4s" "${CPU}%")  # left-align, 4 chars wide

# --- Set SketchyBar label ---
sketchybar --set "$NAME" label="$graph $CPU_STR"
