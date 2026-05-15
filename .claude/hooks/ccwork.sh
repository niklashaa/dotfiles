#!/usr/bin/env bash
# Maintain a space-separated list of pane IDs in the @ccwork_panes window
# option (panes where Claude Code is currently working). Used by tmux to
# show the ◉ indicator in the status bar.
# Usage: ccwork.sh add     → add $TMUX_PANE, clean stale pane IDs
#        ccwork.sh remove  → remove $TMUX_PANE, clean stale pane IDs
action="${1:-noop}"
opt="@ccwork_panes"
[ -z "${TMUX_PANE:-}" ] && exit 0

current=$(tmux show-options -w -t "$TMUX_PANE" -qv "$opt" 2>/dev/null)
live=" $(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | tr '\n' ' ') "

cleaned=""
for p in $current; do
  [ "$p" = "$TMUX_PANE" ] && continue
  case "$live" in *" $p "*) cleaned="${cleaned:+$cleaned }$p" ;; esac
done

[ "$action" = "add" ] && cleaned="${cleaned:+$cleaned }$TMUX_PANE"

tmux set-window-option -t "$TMUX_PANE" "$opt" "$cleaned" 2>/dev/null
