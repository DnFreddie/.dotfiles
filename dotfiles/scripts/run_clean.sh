#!/usr/bin/env zsh

# Define the temporary file with a .sh extension in the current directory
TEMP_FILE=$(mktemp ./tmpcmd.XXXXXX.sh)

# Open nvim and set up keybinding for Alt+X
nvim $TEMP_FILE -c "nnoremap <M-x> :wq!<CR>"

# If nvim was closed and the file contains a command, execute it
if [[ -s $TEMP_FILE ]]; then
    COMMAND=$(cat $TEMP_FILE)
    echo "Executing: $COMMAND"
    xclip -sel clip <<< "$COMMAND"
    echo -e "\n"
    eval "$COMMAND"
fi

# Clean up
rm -f $TEMP_FILE

