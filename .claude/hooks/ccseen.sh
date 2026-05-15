#!/usr/bin/env bash
# Called from the tmux pane-focus-in hook. Visiting any pane in a window
# clears the yellow attention style set by the Claude Stop hook.
[ -z "${TMUX_PANE:-}" ] && exit 0

tmux set-window-option -t "$TMUX_PANE" -u window-status-style 2>/dev/null
