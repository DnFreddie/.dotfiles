#!/usr/bin/env bash

# Read the list of languages and commands
selected=$(cat ~/scripts/.tmux-cht-languages ~/scripts/.tmux-cht-command | fzf --height 40% --reverse)

# Exit if no selection is made
if [[ -z $selected ]]; then
    exit 0
fi

# Prompt the user to enter a query
read -r -p "Enter Query: " query

# URL-encode the selected and query variables
encoded_selected=$(printf '%s' "$selected" | jq -Rr @uri)
encoded_query=$(printf '%s' "$query" | jq -Rr @uri)

# Check if the selected language exists in .tmux-cht-languages
if grep -qs "$selected" ~/.tmux-cht-languages; then
    curl -s "cht.sh/$encoded_selected/$encoded_query" | glow | bat
else
    curl -s "cht.sh/$encoded_selected/$encoded_query" | glow | bat  # Fetch and display the 
fi

