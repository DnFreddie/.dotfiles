#Check if we are running interactively
[[ $- != *i* ]] && return
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
shopt -s gnu_errfmt
shopt -s histverify
shopt -s cdspell
set show-mode-in-prompt on
# ------------- Aliases --------------------
alias t="task"
alias e="v ~/Documents/Notes/"
alias cat="bat"
alias vs="sudo -E nvim "
alias ed="sudo -E nvim  /etc/nixos/configuration.nix"
##alias wallpaper=" ./Pictures/walppaers/.screenlayout.sh;  feh --bg-fill $HOME/Pictures/walppaers/nasa-53884.jpg;"
alias update='sudo nixos-rebuild switch && bash "$HOME"/scripts/backup_system.sh'
alias cl="clear"
alias b='source "$HOME"/scripts/bookmarks.sh'
alias tn="tmux new-session -s \$(pwd | sed 's/.*\///g')"
#alias lc="find -type f | fzf | sed 's/^..//' | tr -d '\n' | xclip -selection c"
alias path='echo -e "${PATH//:/\\n}"'
alias ls="ls --color=auto"
alias py="python3"
alias tn="attach_to_session"
alias la="ls -a"
alias ll='ls -lha'
alias dp='tmux capture-pane -p -S - | nvim'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias q='~/scripts/quick_search ' 
alias vi='vim'




# # ------------- Complitions --------------------
bind 'TAB:menu-complete'
# owncomp=(awk)
# for i in ${owncomp[@]};do complete -C '$HOME/scripts/snippets/$i' $i;done
bind "set completion-ignore-case on"
bind "set show-all-if-ambiguous on"
bind '"\C-l": clear-screen'
bind "set vi-ins-mode-string \1\e[5 q\e]12;cyan\a\2"
bind "set vi-cmd-mode-string \1\e[1 q\e]12;cyan\a\2"



# ------------- Functions --------------------

#   Search hisstory 
nsi(){
nix shell nixpkgs#"$1"

}

hh() {
    awk '!seen[$0]++ && !/^(lv|nu |nvim|ls|cd|tn|zsh )/' ~/.bash_history | \
    fzf --tac --height 10 | \
    xclip -sel clip
}

v() {
    if [ -z "$1" ]; then
        command nvim .
    elif [ -f "$1" ]; then
        command nvim "$1"
    elif [ -d "$1" ]; then
        command cd "$1" && nvim .
        command cd -  >> /dev/null || exit
    else
        command  nvim "$1"
    fi
}

 #  Extract most know archives with one command
ex ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "$1 cannot be extracted via ex();;"
    esac
  else
    echo "$1 is not a valid file"
  fi
}

vf(){
 local dir
  dir=$(find "$HOME" -maxdepth 4 -type d \( -name .cache -o -name go -o -name node_modules \) -prune -o -type d -print | fzf)

  v  "$dir"

}
fcd() {
  local dir
  dir=$(find "$HOME" -maxdepth 4 -type d \( -name .cache -o -name go -o -name node_modules \) -prune -o -type d -print | fzf)

  if [ -n "$dir" ]; then
    session_name=$(basename "$dir")

    if [[ "$session_name" == .* ]]; then
      session_name="${session_name:1}"
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
      echo "Attaching to existing session: $session_name"
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
      else
        tmux attach-session -t "$session_name"
      fi
    else
      echo "Creating new session: $session_name"
      tmux new-session -d -s "$session_name" -c "$dir"
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
      else
        tmux attach-session -t "$session_name"
      fi
    fi
  else
    echo "Directory not found or not selected."
    return 1
  fi
}


attach_to_session() {

    SESSION=$(tmux "ls" 2>/dev/null | fzf --height 10 | cut -d: -f1)


    if [ -n "$SESSION" ]; then

        if [ -n "$TMUX" ]; then
            tmux switch-client -t "$SESSION"
        else
            tmux attach-session -t "$SESSION"
        fi

    elif [ -z "$TMUX" ]; then
       
        tmux new-session -s "$(basename "$(pwd)")"
    else
        echo "No session selected!"
    fi
}







#   Cd to selected directory
open(){
    if [ -n "$1" ]; then
        xdg-open "$1"
    else
    xdg-open "$(find  . -type f | fzf)"
    fi
}
# Add to the path
pathappend() {
    for arg in "$@"; do
        test -d "$arg" || continue

        PATH=${PATH//:"$arg:"/:}

        PATH=${PATH/#"$arg:"/}

        PATH=${PATH/%":$arg"/}


        export PATH="${PATH}${PATH:+":$arg"}"
    done
} && export -f pathappend


up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}



remove_nonexistent_files() {
    local index_dir="$HOME/scripts/.temp_list.txt"
    local temp_file="/tmp/temp_list.txt"
    
    if [ ! -f "$index_dir" ]; then
        echo "Index file does not exist."
        return
    fi

    while IFS= read -r filename; do
        if [ -f "$filename" ]; then
            echo "$filename" >> "$temp_file"
        fi
    done < "$index_dir"

    mv "$temp_file" "$index_dir"
}

vt() {
    local personal="$HOME/Documents/Notes/Ideas.md"
    if [ "$1" ]; then
        bat "$personal"
    else
        printf "Add your idea:\n - "
        read -r idea
        echo "- $idea" >> "$personal"
    fi
}


lv() {
    local temp_md_dir="/tmp"
    local filename
    local index_dir="$HOME/scripts/.temp_list.txt"

    case "$1" in
        "")
            filename="note_$(date +%Y%m%d_%H%M%S)"
            echo "$temp_md_dir/$filename.md" >> "$index_dir"
            nvim "$temp_md_dir/$filename.md"
            ;;
            "-s")
            [ -f "$index_dir" ] && fzf --preview='head -n 20 {}' < "$index_dir" | xargs -r -I {} mv {} ~/Desktop/ || echo "no records"

                ;;
        "-l")
            remove_nonexistent_files
            fzf --preview='head -n 20 {}' < "$index_dir" | xargs -r nvim || echo "no records"
            ;;
        *)
            nvim "/tmp/$1"
            echo "$temp_md_dir/$1" >> "$HOME/scripts/.temp_list.txt"
            ;;
    esac
}















#------------- Exports --------------------
# avoid duplicates..
export HISTCONTROL=ignoredups:erasedups
# After each command, save and reload history
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTSIZE=1000
export HISTFILESIZE=2000
#export LS_COLORS="*.py=03;33:*.csv=02;36:*.tar=00;31:*.go=38;5;93:*.rs=01;31:*.json=38;5;208:$LS_COLORS"
export LS_COLORS="*.py=03;33:*.csv=02;36:*.tar=00;31:*.go=38;5;93:*.rs=01;31:*.json=38;5;208:*.nix=36;40;93:$LS_COLORS"
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline


#------------- Source --------------------










#------------- Prompt --------------------
# Source files
configure_prompt() {
    ##local prompt_symbol='Λ'

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
    # Determine the current shell depth
    local deepness=$SHLVL

    # Adjust deepness if inside tmux
    if [ -n "$TMUX" ]; then
        deepness=$((deepness - 1))
    fi

    # Display logic
    if [ "$deepness" -eq 1 ]; then
        echo "$"
    else echo "${deepness}$"
    fi
}

PS1="\u\[\e[35m\]${debian_chroot:+(\$debian_chroot)─}${VIRTUAL_ENV:+(\$(basename \$VIRTUAL_ENV))─}[\[\e[36m\]\w\[\e[35m\]]\$(git_branch)\n└─\[\e[33m\]\$(getDeep)\[\e[0m\]"
    #PS1=" \u \[\e[35m\]${debian_chroot:+(\$debian_chroot)─}${VIRTUAL_ENV:+(\$(basename \$VIRTUAL_ENV))─}[\[\e[36m\]\w\[\e[35m\]]\$(git_branch)\n└─\[\e[33m\]\$(getDeep)\[\e[0m\]"
    #PS1="\[\e[35;5;208m\]\u${debian_chroot:+(\$debian_chroot)─}${VIRTUAL_ENV:+(\$(basename \$VIRTUAL_ENV))─}[\[\e[36m\]\w\[\e[38;5;208m\]]\$(git_branch)\n└─\[\e[33m\]\$\[\e[0m\]"



}


configure_prompt


# Turso
export PATH="/home/aura/.turso:$PATH"
      if [ -n "$TMUX" ]; then
        eval "$(direnv hook bash)";

        fi


export PATH="$HOME/go/bin/:$PATH"
