#!/usr/bin/env bash
# Define include directories
include_dirs=(
    alacritty
    i3
    picom
    scripts
    wallpapers
    dunst
    nvim
    polybar
)
scriptsDir="$HOME/scripts/"
dot_configs=(
    "$HOME/.tmux.conf"
    "$HOME/.bashrc"
    "$HOME/.vimrc"
    scriptsDir
    )

# Define log directory and file
logdir="$HOME/.log_user/nix_backup"
log_file="$HOME/.log_user/nix_backup/nix-log.json"

mkdir -p "$logdir" || { echo "Error: Unable to create log directory" >&2; exit 1; }

touch "$log_file" || { echo "Error: Unable to create log file" >&2; exit 1; }

send_notification() {
    notify-send "Backup Error" "$1"
}

rsync_command="rsync -av"
for dir in "${include_dirs[@]}"; do
    rsync_command+=" --include='$dir/' --include='$dir/**'"
done
rsync_command+=" --exclude='*'"

output=$(eval "$rsync_command $HOME/.config/ $HOME/Documents/nixconfig/dotfiles/") || { send_notification "Rsync command failed"; exit 1; }

for c in "${dot_configs[@]}"; do
    
  if [ "$c" = "$scriptsDir" ]; then
        rsync -av "$c" "$HOME/Documents/nixconfig/dotfiles/scripts/"
    else
        rsync -av "$c" "$HOME/Documents/nixconfig/dotfiles/"
    fi   
done

backup_flakes="rsync -av /etc/nixos/ $HOME/Documents/nixconfig/"
second_output=$(eval "$backup_flakes") || { send_notification "Flakes backup command failed"; exit 1; }

curDate=$(date)

json_object=$(jq -n --arg date "$curDate" --arg output "$output" --arg flakes "$second_output" '{date: $date, configs: $output, flakes: $flakes, exit_code: 0}')

echo "$json_object" >> "$log_file" || { send_notification "Unable to append to log file"; exit 1; }

##notify-send "Backup $curDate Dotfiles" "These files have been changed in: $output"
#notify-send "Backup $curDate Flakes" "These files have been changed in: $second_output"
# Switch to the backup branch and push changes
cd "$HOME/Documents/nixconfig/" || { send_notification "Unable to change directory"; exit 1; }
git switch backup || { send_notification "Unable to switch branch"; exit 1; }
git add . || { send_notification "Unable to add changes to the index"; exit 1; }
git commit -am "automatic push $curDate" || { send_notification "Unable to commit changes"; exit 1; }
git push --set-upstream origin backup || { send_notification "Unable to push changes to remote repository"; exit 1; }


notify-send "UPDATE Statu " "Sucessfull"
exit 0

