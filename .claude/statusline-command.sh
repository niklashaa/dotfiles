#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory
short_cwd="${cwd/#$HOME/\~}"

# Git branch (skip optional locks)
branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)

# Build output
out=""

# Directory (cyan)
out="${out}$(printf '\033[36m%s\033[0m' "$short_cwd")"

# Git branch (green)
if [ -n "$branch" ]; then
  out="${out} $(printf '\033[32m%s\033[0m' "$branch")"
fi

# Model (dimmed)
if [ -n "$model" ]; then
  out="${out} $(printf '\033[2m%s\033[0m' "$model")"
fi

# Context usage
if [ -n "$used" ]; then
  out="${out} $(printf '\033[2mctx:%s%%\033[0m' "$(printf '%.0f' "$used")")"
fi

echo "$out"
