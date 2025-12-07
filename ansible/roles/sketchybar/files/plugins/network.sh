#!/usr/bin/env sh

INTERFACE="en0"
BASE="/tmp/sb_net_graph"
mkdir -p "$BASE"

RX_FILE="$BASE/rx"
TX_FILE="$BASE/tx"
RX_PREV_FILE="$BASE/rx_prev"
TX_PREV_FILE="$BASE/tx_prev"

ALPHA=0.3   # smoothing factor

# --- Current counters ---
RX_NOW=$(netstat -bI "$INTERFACE" | awk 'NR==2 {print $7}')
TX_NOW=$(netstat -bI "$INTERFACE" | awk 'NR==2 {print $10}')

# --- Previous ---
RX_OLD=$(cat "$RX_FILE" 2>/dev/null || echo "$RX_NOW")
TX_OLD=$(cat "$TX_FILE" 2>/dev/null || echo "$TX_NOW")

echo "$RX_NOW" > "$RX_FILE"
echo "$TX_NOW" > "$TX_FILE"

# --- Instant deltas ---
RX_DELTA=$((RX_NOW - RX_OLD))
TX_DELTA=$((TX_NOW - TX_OLD))

# --- Load previous smoothed value ---
RX_PREV=$(cat "$RX_PREV_FILE" 2>/dev/null || echo "$RX_DELTA")
TX_PREV=$(cat "$TX_PREV_FILE" 2>/dev/null || echo "$TX_DELTA")

# --- Apply smoothing ---
RX_SM=$(awk -v a=$ALPHA -v x=$RX_DELTA -v y=$RX_PREV 'BEGIN{printf "%d", a*x + (1-a)*y}')
TX_SM=$(awk -v a=$ALPHA -v x=$TX_DELTA -v y=$TX_PREV 'BEGIN{printf "%d", a*x + (1-a)*y}')

echo "$RX_SM" > "$RX_PREV_FILE"
echo "$TX_SM" > "$TX_PREV_FILE"

# --- Human-readable formatting, fixed-width left-aligned ---
# Total width: 10 chars for value + unit
human() {
  b=$1
  if [ $b -gt 1073741824 ]; then val="$(echo "$b / 1073741824" | bc -l)"; unit="GB/s"
  elif [ $b -gt 1048576 ]; then val="$(echo "$b / 1048576" | bc -l)"; unit="MB/s"
  elif [ $b -gt 1024 ]; then val="$(echo "$b / 1024" | bc -l)"; unit="KB/s"
  else val="$b"; unit="B/s"
  fi
  # Combine value + unit, round to 1 decimal if needed
  str=$(printf "%.1f%s" "$val" "$unit")
  # Pad the combined string to fixed width (11 chars) to prevent shifting
  printf "%-11s" "$str"
}

DL_STR=$(human $RX_SM)
UL_STR=$(human $TX_SM)

# --- Icons ---
DL_ICON="󰜮"
UL_ICON="󰜷"

# --- Set label ---
# The fixed-width numbers prevent shifting of other items
sketchybar --set "$NAME" label="$DL_ICON $DL_STR $UL_ICON $UL_STR"

