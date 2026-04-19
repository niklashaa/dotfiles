#!/usr/bin/env bash
# Maintain @ccwork_panes as a space-separated list of working pane IDs per window.
# Usage: ccwork.sh add   → add $TMUX_PANE, clean stale pane IDs
#        ccwork.sh remove → remove $TMUX_PANE, clean stale pane IDs
action="${1:-noop}"
[ -z "${TMUX_PANE:-}" ] && exit 0

current=$(tmux show-window-option -t "$TMUX_PANE" -qv @ccwork_panes 2>/dev/null)
live=" $(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | tr '\n' ' ') "

cleaned=""
for p in $current; do
  [ "$p" = "$TMUX_PANE" ] && continue
  case "$live" in *" $p "*) cleaned="${cleaned:+$cleaned }$p" ;; esac
done

[ "$action" = "add" ] && cleaned="${cleaned:+$cleaned }$TMUX_PANE"

tmux set-window-option -t "$TMUX_PANE" @ccwork_panes "$cleaned" 2>/dev/null
