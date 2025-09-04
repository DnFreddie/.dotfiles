tmux list-windows -a -F '#W :#S:#I' |grep -v  -E "bash|gosh"  |   fzf --reverse  --with-nth=1 | awk -F: '{print $2 ":" $3}' | xargs tmux switch-client -t

