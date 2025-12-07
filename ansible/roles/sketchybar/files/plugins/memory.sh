#!/usr/bin/env sh

DATA_DIR="/tmp/sketchybar_mem_graph"
HISTORY_FILE="$DATA_DIR/history"
mkdir -p "$DATA_DIR"

MAX_POINTS=12
SPARKS=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# --- Get memory usage %
MEM=$(top -l 1 | grep PhysMem | awk '{used=$2+$4; total=$2+$4+$6; printf "%d", (used/total*100)}')

# --- Load previous history ---
HISTORY=$(cat "$HISTORY_FILE" 2>/dev/null || echo "")

# Append new value
HISTORY="$HISTORY $MEM"

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

# --- Fixed-width, left-aligned Memory label ---
MEM_STR=$(printf "%-4s" "${MEM}%")  # left-align, 4 chars wide

# --- Set SketchyBar label ---
sketchybar --set "$NAME" label="$graph $MEM_STR"
