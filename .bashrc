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
set -o vi
bind -m vi-command '"\C-l": clear-screen'
bind -m vi-insert '"\C-l": clear-screen'

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
alias tn="g s tn"
alias ta="tmux a"
alias rn="tmux rename-window"
alias sys="systemctl"
alias sysu="systemctl --user"
alias c="bat -p"
alias grepi="grep -i -r --exclude-dir=.git"
alias k='kubectl'
alias chmox='chmod +x'
alias vm="venvpy"
alias vi="vim"
alias dps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
alias dpi="docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'"
alias pps="podman ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
alias ppi="podman images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'"

alias files="nautilus"

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
alias view='vim -R'
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
export PROMPT_COMMAND='history -a; history -r; __ps1'


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
export PR="$HOME/.junk/"

export LESS_TERMCAP_mb=$'\E[1;38;2;245;194;231m'             # Pink
export LESS_TERMCAP_md=$'\E[1;38;2;137;180;250m'             # Blue
export LESS_TERMCAP_me=$'\E[0m'                              # Reset
export LESS_TERMCAP_us=$'\E[4;38;2;166;227;161m'             # Green
export LESS_TERMCAP_ue=$'\E[0m'                              # Reset underline
export LESS_TERMCAP_so=$'\E[38;2;17;17;27;48;2;243;139;168m' # Red search highlighting
export LESS_TERMCAP_se=$'\E[0m'                              # Reset search highlighting

#---------------Prompt---------------

__ps1() {
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
if _have tmux && [[ -n "$TMUX" ]]; then
tmux rename-window "$(wd)"
fi
}

  wd() {
      dir="${PWD##*/}"
      parent="${PWD%"/${dir}"}"
      parent="${parent##*/}"
      echo "$parent/$dir"
  } && export wd


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


unset -f setup_environment

# Things added automatically
#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source "$HOME/.bash_aliases"
