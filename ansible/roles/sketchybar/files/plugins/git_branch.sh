#!/bin/bash

# Git branch indicator
# Shows current branch when in terminal/editor apps

APP="$INFO"

# Only show for developer apps
case "$APP" in
    "Alacritty"|"Terminal"|"iTerm2"|"Code"|"Visual Studio Code"|"Neovim"|"nvim")
        # Try to get current directory from the focused app
        # For Alacritty/Terminal, we check the most recent git repo

        # Use lsof to find the cwd of the frontmost terminal process
        # This is a best-effort approach
        CWD=""

        if [[ "$APP" == "Alacritty" ]]; then
            # Get Alacritty's child shell process cwd
            PID=$(pgrep -n "zsh|bash" 2>/dev/null)
            if [[ -n "$PID" ]]; then
                CWD=$(lsof -p "$PID" 2>/dev/null | awk '$4=="cwd" {print $9}')
            fi
        fi

        # Fallback: check home directory for a default project
        if [[ -z "$CWD" || ! -d "$CWD" ]]; then
            CWD="$HOME"
        fi

        # Get git branch
        if [[ -d "$CWD" ]]; then
            BRANCH=$(cd "$CWD" && git branch --show-current 2>/dev/null)
        fi

        if [[ -n "$BRANCH" ]]; then
            sketchybar --set "$NAME" label=" $BRANCH" drawing=on
        else
            sketchybar --set "$NAME" drawing=off
        fi
        ;;
    *)
        # Hide for non-dev apps
        sketchybar --set "$NAME" drawing=off
        ;;
esac
