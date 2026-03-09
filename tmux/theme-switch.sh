#!/bin/bash
# Called by dark-mode-notify when macOS appearance changes.
# DARKMODE env var: 1 = dark, 0 = light

if [ "$DARKMODE" = "1" ]; then
  tmux source-file ~/.tmux/gruvbox-dark.conf
else
  tmux source-file ~/.tmux/gruvbox-light.conf
fi
