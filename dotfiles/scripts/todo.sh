#!/bin/bash

declare -a results


grepFunction() {
  grep -oP "TODO{\K[^}]*" "$1"
}


export -f grepFunction

mapfile -t results < <(find ~/env ~/Desktop/ -type d \( -name 'lib' -o -name 'target' -o -name 'bin' -o -name 'docs' -o -name '__pycache__' -o -name '.*' -o -name 'node_modules' \) -prune -o -type f -print0 | parallel -0 grepFunction)

for item in "${results[@]}"; do
  task add  "$item" due:tomorrow
done

