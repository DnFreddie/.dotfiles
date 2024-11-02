# ~/.bashrc
#Check if we are running interactively
[[ $- != *i* ]] && return

# ------------- Complitons --------------------
if ! shopt -oq posix; then
  if [ -f "/usr/share/bash-completion/bash_completion" ]; then
    source "/usr/share/bash-completion/bash_completion"
  elif [ -f /etc/bash_completion ]; then
    source "/etc/bash_completion"
  fi
else
  printf "No complitons found\n"
fi
# ------------- Options --------------------
set -o vi
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
alias play="ansible-playbook"
alias gits="git status"
alias g="gosh"
alias "?"="ddg"
alias pf="pandoc -f markdown -t gfm"
alias vs="sudo -E nvim "
alias "??"="gpt"
alias gitl="git log -n 5 --graph --decorate --oneline"
alias issue="gh issue create"
alias cat="bat"
alias cl="clear"
alias less="bat"
alias vi="nvim"
#alias tn="tmux new-session -s \$(pwd | sed 's/.*\///g')"
alias grep='grep --color=auto'
alias path='echo -e "${PATH//:/\\n}"'
alias ls="ls --color=auto"
alias py="python3"
alias la="ls -a"
alias ll='ls -lha'
alias dump='tmux capture-pane -p -S - | nvim'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias k='kubeclt'

#---------------Binds---------------
# owncomp=(awk)
# for i in ${owncomp[@]};do complete -C '$HOME/scripts/snippets/$i' $i;done
bind '"\C-l": clear-screen'
bind 'set bell-style none'
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"
bind '"\e[Z": menu-complete-backward'
bind '"\t": menu-complete'

#---------------Functions---------------
ram() {
  ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -n
}

hed() {
  head -n1 "$@" | perl -lane 'for my $i (0..$#F) { print "$i: $F[$i]" }'

}

hh() {

  history -a # Append new history lines to the HISTFILE
  history -r # Read history from HISTFILE into memory
  local selected
  selected="$(history | perl -lane 'print join(" ", @F[1..$#F])' | perl -ne 'print unless $seen{$_}++' | fzf --tac --layout=reverse)"

  if [ -n "$selected" ]; then
    echo "$selected"
  else
    echo "No command selected."

  fi

}

#---------------Editor Commands---------------

tn() {
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
  esac
  if ! tmux list-sessions > /dev/null 2>&1; then
    tcreate "$(pwd | sed 's/.*\///g')" "$PWD"
  fi
  printf "Select:\n"
  mapfile -t sessions_array < <(tmux list-sessions)
  for i in "${!sessions_array[@]}"; do
    session_name="${sessions_array[$i]%%:*}"
    session_description="${sessions_array[$i]#*:}"
    printf "\033[38;2;181;126;220m%d.\033[0m " "$((i + 1))"
    printf "\033[1;38;2;150;150;170m%s\033[0m " "$session_name"
    printf "\033[38;2;120;120;120m%s\033[0m\n" "$session_description"
  done
  printf ":"
  read -r choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#sessions_array[@]}" ]; then
    selected="${sessions_array[$((choice - 1))]}"
    session_name="${selected%%:*}"
    tcreate "$session_name" "$PWD"
  elif [ -n "$choice" ]; then
    echo "Invalid selection!"
  else
    echo "No session selected!"
  fi
}

#---------------Utilites-----------------------
ex() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *) echo "$1 cannot be extracted via ex();;" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}

open() {
  if [ -n "$1" ]; then
    xdg-open "$1"
  else
    xdg-open "$(find . -type f | fzf --layout=reverse)"
  fi
}

pathappend() {
  for arg in "$@"; do
    test -d "$arg" || continue

    PATH=${PATH//:"$arg:"/:}

    PATH=${PATH/#"$arg:"/}

    PATH=${PATH/%":$arg"/}

    export PATH="${PATH}${PATH:+":$arg"}"
  done
} && export -f pathappend


ddg() {
    local search="${*// /+}"  
    w3m -o confirm_qq=false "https://lite.duckduckgo.com/lite?q=$search"
}
#------------- Bash settings --------------------

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000
export LS_COLORS="*.py=04;33:*.csv=02;36:*.tar=00;31:*.go=38;5;93:*.rs=01;31:*.json=38;5;208:*.nix=36;40;93:$LS_COLORS"

export MANPAGER="nvim +Man!"
export EDITOR="nvim"
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
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
      if [[ "$branch" != "HEAD" ]]; then
        echo -n "($branch)"
      else
        echo -n "(detached)"
      fi
    fi
  }
  getDeep() {
    local deepness=$SHLVL
    if [ -n "$TMUX" ]; then
      deepness=$((deepness - 1))
    fi
    if [ "$deepness" -eq 1 ]; then
      if [ -z "$TMUX" ]; then
        printf "\001\e[38;2;150;150;170m\002$\001\e[0m\002"
      else
        printf "\001\e[33m\002$\001\e[0m\002"
      fi
    else
      if [ -z "$TMUX" ]; then
          printf "\e[38;2;150;150;170m%s$\e[0m" "$deepness"

      else
        printf "\e[33m%s$\e[0m" "$deepness"

      fi
    fi
  }
  
  get_user_and_session() {
    if [ -n "$TMUX" ]; then
        local session_name
       session_name=$(tmux display-message -p '#S')
      echo -n "\u:$session_name"
    else
      echo -n "\u"
    fi
  }
  
  PS1="${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV"))─}\[\e[38;2;150;150;170m\]$(get_user_and_session) \[\e[38;2;150;150;170m\]\w\[\e[37m\]\$(git_branch)\n\$(getDeep) "
}
#---------------Setup env---------------
setup_environment() {
#---------------Go-related settings---------------
  export GOROOT="$HOME/.local/go"
  export GOPATH="$HOME/.go"
  export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
#---------------Export path---------------
  export PATH="$PATH:$HOME/.local/bin/"
  export PATH="$PATH:$HOME/.local/bin/"
  export PATH="$PATH:$HOME/scripts/"
  # Cargo (Rust) setup
  if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
  fi

#----------------------------------------------
  # Terraform autocomplete
  if command -v terraform &> /dev/null; then
    complete -C /usr/bin/terraform terraform
  fi
}

setup_environment
configure_prompt

unset -f setup_environment
unset -f configure_prompt

# Things added automatically
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
