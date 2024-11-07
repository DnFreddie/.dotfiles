``` bash
##NAME:.tmux.conf##
 set -g default-terminal "tmux-256color"
 set -g base-index 1
 set -s escape-time 0
 set -g mouse on
 set-window-option -g automatic-rename on
 set-option -g set-titles on
 set-option -g renumber-windows on
 bind x kill-pane

 setw -g mode-keys vi
 bind h select-pane -L
 bind j select-pane -D
 bind k select-pane -U
 bind l select-pane -R
 bind r source-file ~/.tmux.conf
 bind-key v split-window -h -c "#{pane_current_path}"

 bind-key e split-window -v -c "#{pane_current_path}"
 # Enable vi keys.
 set -g status-left-length 60
 set -g status-left-style default
```
