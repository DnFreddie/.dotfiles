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
#view in vim 
alias zg="zig run -I . src/main.zig -lc"
alias vv='v  "$HOME"/Documents/Notes/'
alias vs="sudo -E nvim "
alias vm="sudo virsh"
alias t="task"
alias gt="gh issue list"
alias gr="go run main.go"
alias cat="bat"
alias ed="sudo -E nvim  /etc/nixos/configuration.nix"
alias fcl="fc -l"

##alias wallpaper=" ./Pictures/walppaers/.screenlayout.sh;  feh --bg-fill $HOME/Pictures/walppaers/nasa-53884.jpg;"
alias update='sudo nixos-rebuild switch && bash "$HOME"/scripts/backup_system.sh'
alias cl="clear"
alias b='source "$HOME"/scripts/bookmarks.sh'
#alias tn="tmux new-session -s \$(pwd | sed 's/.*\///g')"
#alias lc="find -type f | fzf | sed 's/^..//' | tr -d '\n' | xclip -selection c"

alias grep='grep --color=auto'
alias path='echo -e "${PATH//:/\\n}"'
alias ls="ls --color=auto"
alias py="python3"
alias la="ls -a"
alias ll='ls -lha'
alias dp='tmux capture-pane -p -S - | nvim'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
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
bind 'set bell-style none'




# ------------- Functions --------------------

#   Search hisstory 
nsi(){
nix shell nixpkgs#"$1"

}

ram() {
    ps aux | awk '{print $6/1024 " MB\t\t" $11}' | sort -n
}


hh() {
    local selected_command
    selected_command=$(history | awk '!seen[$0]++ && !/^(lv|nu |nvim|ls|cd|tn|zsh|v|fcd |vf|vs)/' | awk '{$1=""; print substr($0,2)}'| fzf --tac  --layout=reverse )
    if [ -n "$selected_command" ]; then
        echo "$selected_command" 
        echo "$selected_command"   | xclip -sel clip 
    else
        echo "No command selected."
    fi
}



# ------------- V commands --------------------

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


vf(){
 local dir

  dir=$(find "$HOME" -maxdepth 2 -type d \( -name .cache -o -name go -o -name node_modules \) -prune -o -type d -print | sed "s|^$HOME/||" | fzf --layout=reverse)
  v  "$HOME/$dir"

}

vl() {
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
            [ -f "$index_dir" ] && fzf  --layout=reverse --preview='head -n 20 {}' < "$index_dir" | xargs -r -I {} mv {} ~/Desktop/ || echo "no records"

                ;;
        "-l")
            remove_nonexistent_files
            fzf --layout=reverse --preview='head -n 20 {}' < "$index_dir" | xargs -r nvim || echo "no records"
            ;;
        *)
            nvim "/tmp/$1"
            echo "$temp_md_dir/$1" >> "$HOME/scripts/.temp_list.txt"
            ;;
    esac
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
# ------------- fc commands --------------------

fcs(){

 local selected_host   
 local session_name
 selected_host=$(grep -oP '^(?:Host)\s+\K\w+' "$HOME/.ssh/config" | fzf  --layout=reverse)

if [ -n "$selected_host" ]; then
  session_name="ssh@$selected_host"

  if [ -n "$TMUX" ]; then
    tmux new-session -d -A -s "$session_name" -n "ssh" "ssh $selected_host"
    tmux switch-client -t "$session_name"
  else
    tmux new-session -d -A -s "$session_name" -n "ssh" "ssh $selected_host"
    tmux attach-session -t "$session_name"
  fi
else
  echo "No host selected."
fi


}
fcd() {
  local dir
  dir=$(find "$HOME" -maxdepth 2 -type d \( -name .cache -o -name go -o -name node_modules \) -prune -o -type d -print | sed "s|^$HOME/||" | fzf --layout=reverse)
  local session_name

  if [ -n "$dir" ]; then
    session_name=$(basename "$dir")

    if [[ "$session_name" == .* ]]; then
      session_name="${session_name:1}"
    fi

    if tmux has-session -t "$session_name" 2>/dev/null; then
      echo "Attaching to existing session: $session_name" > /dev/null
      if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session_name"
      else
        tmux attach-session -t "$session_name"
      fi
    else
      echo "Creating new session: $session_name" > /dev/null
      if [ "$dir" == "$HOME" ]; then
        tmux new-session -d -s "$session_name"
      else
        tmux new-session -d -s "$session_name" -c "$HOME/$dir"
      fi

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


#---------------Utilites-----------------------
tn() {

    local SESSION 
    SESSION=$(tmux "ls" 2>/dev/null | fzf --layout=reverse | cut -d: -f1)


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


open(){
    if [ -n "$1" ]; then
        xdg-open "$1"
    else
    xdg-open "$(find  . -type f | fzf --layout=reverse)"
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
    local deepness=$SHLVL

    if [ -n "$TMUX" ]; then
        deepness=$((deepness - 1))
    fi

    if [ "$deepness" -eq 1 ]; then
        echo "$"
    else echo "${deepness}$"
    fi
}

#V1
#PS1="\u\[\e[35m\]${debian_chroot:+(\$debian_chroot)─}${VIRTUAL_ENV:+(\$(basename \$VIRTUAL_ENV))─}[\[\e[36m\]\w\[\e[35m\]]\$(git_branch)\n└─\[\e[33m\]\$(getDeep)\[\e[0m\]"
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
PS1="\u\[\e[35m\]${debian_chroot:+(\$debian_chroot)─}${VIRTUAL_ENV:+(\$(basename \$VIRTUAL_ENV))─}[\[\e[36m\]\w\[\e[35m\]]\$(git_branch)\n\[\e[33m\]\$(getDeep)\[\e[0m\]"
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
