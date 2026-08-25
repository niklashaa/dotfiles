#!/usr/bin/env bash
# Claude Code ↔ tmux state bridge. One pane runs one Claude session; its state
# lives in two window options so the status bar can render it with plain
# formats, no shelling out:
#   @ccwork_panes  panes with a turn in progress
#   @ccwait_panes  panes where Claude is blocked on the user (permission, question)
# A pane is in at most one list. A window whose turn ended while it was not on
# screen gets window-status-style yellow until it is visited.
#
# Two things Claude Code will not tell us, both handled by `sweep` (run from
# status-right every status-interval):
#   - an interrupted turn (Escape) fires no hook at all, so the transcript
#     recorded at `work` is checked for the interrupt marker;
#   - a Claude that exited back to the shell mid-turn fires nothing either, so
#     a tracked pane whose foreground command is no longer Claude is dropped.
#
# Prints nothing on purpose: on PermissionRequest any stdout is read as a
# permission decision.
#
# Usage: ccstate.sh work|wait|done|gone   Claude hook, acts on $TMUX_PANE
#        ccstate.sh seen <window_id>      tmux hook, clears the yellow
#        ccstate.sh sweep                 drop stale entries everywhere
set -u
action="${1:-}"
WORK=@ccwork_panes
WAIT=@ccwait_panes
YELLOW='fg=colour232 bg=yellow bold'

opt_get() { tmux show-options -w -t "$1" -qv "$2" 2>/dev/null; }

# Remove $2 from both lists of window $1, prune dead panes, then add $2 to $3
# ("" = neither).
edit_lists() {
  local win="$1" pane="$2" target="${3:-}" opt cur new p live
  live=" $(tmux list-panes -a -F '#{pane_id}' 2>/dev/null | tr '\n' ' ') "
  for opt in $WORK $WAIT; do
    cur=$(opt_get "$win" "$opt")
    new=""
    for p in $cur; do
      [ "$p" = "$pane" ] && continue
      case "$live" in *" $p "*) new="${new:+$new }$p" ;; esac
    done
    [ "$opt" = "$target" ] && new="${new:+$new }$pane"
    tmux set-window-option -t "$win" "$opt" "$new" 2>/dev/null
  done
}

in_list() { case " $(opt_get "$1" "$2") " in *" $3 "*) return 0 ;; esac; return 1; }

transcript_key() { echo "CC_TRANSCRIPT_${1#%}"; }

# True when some attached client is currently showing the window of pane $1.
on_screen() {
  local wid
  wid=$(tmux display -p -t "$1" '#{window_id}' 2>/dev/null) || return 1
  tmux list-clients -F '#{window_id}' 2>/dev/null | grep -qx "$wid"
}

untrack() {
  edit_lists "$1" "$2" ""
  tmux set-environment -gu "$(transcript_key "$2")" 2>/dev/null
}

case "$action" in
  work|wait|done|gone)
    pane="${TMUX_PANE:-}"
    [ -z "$pane" ] && exit 0
    input=""
    [ -t 0 ] || input=$(cat)
    ;;
esac

case "$action" in
  work)
    # PostToolUse calls this on every tool call; nothing to do unless the pane
    # is not already plain "working".
    if in_list "$pane" $WORK "$pane" && ! in_list "$pane" $WAIT "$pane"; then exit 0; fi
    edit_lists "$pane" "$pane" $WORK
    tmux set-window-option -t "$pane" -u window-status-style 2>/dev/null
    path=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null)
    [ -n "$path" ] && tmux set-environment -g "$(transcript_key "$pane")" "$path" 2>/dev/null
    ;;
  wait)
    in_list "$pane" $WAIT "$pane" && exit 0
    edit_lists "$pane" "$pane" $WAIT
    ;;
  done)
    tracked=0
    { in_list "$pane" $WORK "$pane" || in_list "$pane" $WAIT "$pane"; } && tracked=1
    untrack "$pane" "$pane"
    if [ "$tracked" = 1 ] && ! on_screen "$pane"; then
      tmux set-window-option -t "$pane" window-status-style "$YELLOW" 2>/dev/null
    fi
    ;;
  gone)
    untrack "$pane" "$pane"
    ;;
  seen)
    [ -n "${2:-}" ] && tmux set-window-option -t "$2" -u window-status-style 2>/dev/null
    ;;
  sweep)
    tmux list-windows -a -F "#{window_id} #{$WORK} #{$WAIT}" 2>/dev/null | while read -r win panes; do
      for p in $panes; do
        cmd=$(tmux display -p -t "$p" '#{pane_current_command}' 2>/dev/null)
        # The native binary reports its version as the command name.
        case "$cmd" in
          claude|node|[0-9]*.[0-9]*.[0-9]*) ;;
          *) untrack "$win" "$p"; continue ;;
        esac
        path=$(tmux show-environment -g "$(transcript_key "$p")" 2>/dev/null | cut -d= -f2-)
        [ -f "$path" ] || continue
        # Skip the non-message lines (file-history snapshots) that trail an
        # interrupt before the next prompt arrives.
        last=$(tail -n 5 "$path" | grep -E '"type":"(user|assistant)"' | tail -n 1)
        case "$last" in
          *"Request interrupted by user"*) untrack "$win" "$p" ;;
        esac
      done
    done
    ;;
esac
exit 0
