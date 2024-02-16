#!/bin/bash

SESSION=$(tmux ls | fzf | cut -d: -f1)

if [ -n "$SESSION" ]; then
    tmux attach-session -t "$SESSION"
else
    echo "No session selected!"
fi

