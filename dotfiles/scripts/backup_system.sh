#!/usr/bin/env bash

logdir="$HOME/.log_user/nix_configs"
mkdir -p "$logdir"
curDate=$(date +%Y-%m-%d_%H-%M-%S)

if rsync -av /etc/nixos/ "$logdir/config${curDate}/" >> /dev/null; then
    notify-send "UPDATE Status" "Successful"
else
    notify-send "UPDATE Status" "Failed"
    exit 1
fi

mapfile -d '' sortedDirs < <(find "$logdir" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z -Vr)

if [ "${#sortedDirs[@]}" -gt 6 ]; then
    for dir in "${sortedDirs[@]:6}"
    do
        echo "Remove $dir?"
        rm -rf  "$dir"
    done
fi
