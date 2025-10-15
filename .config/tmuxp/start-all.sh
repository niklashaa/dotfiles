#!/bin/bash
# Ctrl+s d
# tmux kill-server
# Start all tmuxp sessions

sessions=("notes" "database" "dotfiles" "niklashaag-com" "rizm")

for session in "${sessions[@]}"; do
    echo "Loading $session session..."
    tmuxp load -d "$session"
done

echo "All sessions loaded!"
echo "Use 'tmux attach -t <session-name>' to attach to a session"
echo "Or use 'tmux ls' to see all sessions"
