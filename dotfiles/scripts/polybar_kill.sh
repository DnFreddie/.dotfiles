#!/bin/bash

# Check if Polybar is running
pgrep -x polybar >/dev/null

# $? is a special variable that holds the exit status of the last command executed
if [ $? -ne 0 ]; then
  # Polybar is not running, so launch it
  polybar example &  # Replace 'example' with your Polybar configuration name if different
else
  # Polybar is running, so kill it
  pkill -x polybar
fi

