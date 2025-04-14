# ~/.bashrc
#Check if we are running interactively
[[ $- != *i* ]] && return

# ------------- Complitons --------------------
if ! shopt -oq posix; then
	if [ -f "/usr/share/bash-completion/bash_completion" ]; then
		source "/usr/share/bash-completion/bash_completion"
	elif [ -f /etc/bash_completion ]; then
		source "/etc/bash_completion"
	elif [ -f "$HOME/.bash_completion" ]; then
		source "/etc/bash_completion"
	fi
else
	printf "No complitons found\n"
fi

if ! shopt -oq posix; then
	for i in "$HOME/.local/share/completions/"*; do
		[[ -r "$i" ]] && source "$i"
	done
fi

#  ------------- Options --------------------
#set -o vi
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s histappend
shopt -s autocd
shopt -s checkhash
shopt -s direxpand
shopt -s dirspell
shopt -s dotglob
shopt -s lithist
shopt -s progcomp
shopt -s gnu_errfmt
shopt -s histverify
shopt -s cdspell

#---------------Aliases---------------
alias sys="systemctl"
alias sysu="systemctl --user"
alias c="bat -p"
alias grepi="grep -i -r --exclude-dir=.git"
alias k='kubectl'
alias chmox='chmod +x'
alias vi="vim"
alias v="nvim"
alias d="podman"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
alias dpi="docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'"
# alias "apt history"= "grep 'install' /var/log/dpkg.log* | sort | cut -f1,2,4 -d ''"

#---------------Terraform---------------
alias tfp="terraform plan"
alias tfd="terraform destroy"
alias tfa="terraform apply"
#---------------gits---------------
alias gitss="git switch"
alias gits="git status"
alias issue="gh issue create"
alias iss="gh issue list"
alias gitl="git log  --graph --decorate --oneline -n 5"
alias gitb="git branch"
alias gitd="git diff"
alias gitr="git reflog"
alias gitw="git worktree"

#---------------Colors---------------
alias l="less"
alias lr="less -R"
alias path='echo -e "${PATH//:/\\n}"'
alias py="python3"
alias la="ls -a"
alias ll='ls -lha'
alias grep='grep --color=auto'
alias ls="ls --color=auto"
alias diff='diff --color=auto'
alias ip='ip --color=auto'
#---------------Ansible---------------
alias ap='ansible-playbook'
alias a='ansible'
alias an='ansible-navigator'
alias ac='ansible-playbook -C'
alias ads='ansible-doc -s '
alias ad='ansible-doc'
#---------------Molecule---------------
alias m="molecule"
alias mt="molecule test  --destroy=never"
#---------------Binds---------------
bind 'set bell-style none'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"
bind '"\e[Z": menu-complete-backward'
bind '"\t": menu-complete'
alias gs="git switch"
alias gits="git status -s"
alias issue="gh issue create"
alias iss="gh issue list"
alias lw="librewolf"
alias l="less"
alias lr="less -R"
#---------------Binds---------------
bind 'set bell-style none'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"
bind '"\e[Z": menu-complete-backward'
bind '"\t": menu-complete'

#---------------Functions---------------

hh() {
    history -a
    history -r

    local selected
    selected="$(history | awk '{first=$1;$1=""; print substr($0,2)}' | awk '!seen[$0]++' | fzf --tac --layout=reverse)"

    if [[ -n "$selected" ]]; then
        READLINE_LINE="$selected"
        READLINE_POINT=${#selected}
    fi
}

# Bind `hh` function to a keyboard shortcut (Ctrl+G)
bind -x '"\C-g": hh'


#---------------Utilites-----------------------

  tn() {
      local COLOR_INDEX="\033[38;2;181;126;220m"
      local COLOR_SESSION_NAME="\033[1;38;2;150;150;170m"
      local COLOR_SESSION_DESCRIPTION="\033[38;2;120;120;120m"
      local COLOR_RESET="\033[0m"

      tcreate() {
          if [ -z "$TMUX" ]; then
              cd "$2" && tmux new -As "$1";
          else
              tmux detach -E "cd '$2' && tmux new -A -s '$1'";
          fi
      }

      case $1 in
          -c)
              tcreate "$(basename "$PWD")" "$PWD"
              return
              ;;
          -p)
              if [ -n "$2" ] && [ -d "$2" ]; then
                  tcreate "$(basename "$2")" "$2"
              else
                  echo "Error: Invalid path or path not provided"
                  return 1
              fi
              return
              ;;
          -l ) 
              # Create the 'edit' windo    ;;
            tmux rename-window -t :1 'edit' || tmux new-window -t :1 -n 'edit' 2>/dev/null
            tmux rename-window -t :2 'run' || tmux new-window -t :2 -n 'run' 2>/dev/null
            tmux select-window -t :1 2>/dev/null

            return
            ;;
      esac

      if [ -n "$1" ]; then
          sessions=$(tmux list-sessions -F '#{session_name}')
          matches=$(echo "$sessions" | grep -i "^$1")

          if [ -z "$matches" ]; then
              matches=$(echo "$sessions" | grep -i "$1")
          fi

          if [ -z "$matches" ]; then
              echo "No matching session found for '$1'"
              return 1
          elif [ "$(echo "$matches" | wc -l)" -eq 1 ]; then
              session_name="$matches"
              tcreate "$session_name" "$PWD"
              return
          else
              echo "Multiple matching sessions found:"
              select session_name in $matches; do
                  [ -n "$session_name" ] && break
              done
              tcreate "$session_name" "$PWD"
              return
          fi
      fi

      if ! tmux list-sessions > /dev/null 2>&1; then
          tcreate "$(basename "$PWD")" "$PWD"
          return
      fi

      printf "Select:\n"
      mapfile -t sessions_array < <(tmux list-sessions)
      for i in "${!sessions_array[@]}"; do
          session_name="${sessions_array[$i]%%:*}"
          session_description="${sessions_array[$i]#*:}"
          printf "${COLOR_INDEX}%d.${COLOR_RESET} " "$((i + 1))"
          printf "${COLOR_SESSION_NAME}%s${COLOR_RESET} " "$session_name"
          printf "${COLOR_SESSION_DESCRIPTION}%s${COLOR_RESET}\n" "$session_description"
      done
      printf ":"
      read -r choice
      if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [[ "$choice" -le "${#sessions_array[@]}" ]]; then
          selected="${sessions_array[$((choice - 1))]}"
          session_name="${selected%%:*}"
          tcreate "$session_name" "$PWD"
      elif [ -n "$choice" ]; then
          echo "Invalid selection!"
      else
          echo "No session selected!"
      fi
  }


open() {
  if [ -n "$1" ]; then
    if [ -d "$1" ]; then
      selected_file=$(find "$1" -type f | fzf --layout=reverse)
      [ -n "$selected_file" ] && xdg-open "$selected_file" &
    else
      xdg-open "$1" &
    fi
  else
    selected_file=$(find . -type f | fzf --layout=reverse)
    [ -n "$selected_file" ] && xdg-open "$selected_file" &
  fi
}



#------------- Bash settings --------------------
export PROMPT_COMMAND='history -a; history -r'


export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
export LS_COLORS="*.py=33:*.yaml=00;32:*.yml=00;32:*.lua=02;36:*.tar=00;31:*.go=38;5;93:*.rs=01;31:*.json=38;5;208:*.nix=36;40;93:ex=01;38;5;118:$LS_COLORS"

#export MANPAGER="vim +Man!"
export MANPAGER="vim -M +MANPAGER -c 'set ft=man nomod nolist' -"
export EDITOR="vim"
export VISUAL="vim"
export LAB="$HOME/github.com/DnFreddie/"
export JUNK="$HOME/.junk/"

export LESS_TERMCAP_mb=$'\E[1;38;2;245;194;231m'             # Pink
export LESS_TERMCAP_md=$'\E[1;38;2;137;180;250m'             # Blue
export LESS_TERMCAP_me=$'\E[0m'                              # Reset
export LESS_TERMCAP_us=$'\E[4;38;2;166;227;161m'             # Green
export LESS_TERMCAP_ue=$'\E[0m'                              # Reset underline
export LESS_TERMCAP_so=$'\E[38;2;17;17;27;48;2;243;139;168m' # Red search highlighting
export LESS_TERMCAP_se=$'\E[0m'                              # Reset search highlighting

#---------------Prompt---------------

configure_prompt() {
	git_branch() {
		local branch
		if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
			if [[ "$branch" != "HEAD" ]]; then
				echo -n "($branch)"
			else
				echo -n "(detached)"
			fi
		fi
	}

	PS1="${debian_chroot:+($debian_chroot)}\
\[\e[38;2;211;134;155m\]\u \[\e[38;2;146;131;116m\]\w\
\[\e[38;2;131;165;152m\]\$(git_branch)\n\
\[\e[38;2;250;189;47m\]\$ \[\e[0m\]${VIRTUAL_ENV:+ ($(basename "$VIRTUAL_ENV"))}"

}
#---------------Setup env---------------
setup_environment() {
#---------------Go-related settings---------------
  export SYSTEMD_EDITOR="/usr/bin/vim"
  export GOROOT="$HOME/.local/go"
  export GOPATH="$HOME/.go"
  export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
#---------------Export path---------------
  export PATH="$PATH:$HOME/.local/bin/"
  export PATH="$PATH:$HOME/scripts/"
  export PATH="$HOME/.local/lib/nodejs/node_modules/.bin:$PATH"
  # Cargo (Rust) setup
  if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
  fi

#----------------------------------------------
}

setup_environment
configure_prompt

unset -f setup_environment
unset -f configure_prompt

# Things added automatically
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
