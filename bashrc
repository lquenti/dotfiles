# UBUNTU BOILERPLATE (the useful ones)
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
PS1='\[\033[01;32m\]\w\[\033[00m\] \$ '


EDITOR="nvim"
BROWSER="firefox"

PATH=/usr/local/go/bin:~/.cargo/bin/:~/.local/bin:~/.local/share/gem/ruby/3.0.0/bin:~/.config/emacs/bin:$PATH

alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gs='git status'
alias gp='git push'
alias gpu='git pull'

alias ls='ls --color=auto'
alias ll='ls -lahF'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias gppdbg='g++ -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Wshadow -pedantic-errors -ggdb -Werror --std=c++23'
alias gpprls='g++ -O2 -DNDEBUG'

alias ..='cd ..'
alias sl='ls'

alias :r="source ~/.bashrc"
alias bashrc='$EDITOR ~/.bashrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'
alias vim='nvim'
alias gs='git status'
alias glo='git log --oneline'
alias de='setxkbmap de'
alias us='setxkbmap us'

alias b="${BROWSER}"

alias feh='feh --scale-down --image-bg "#1D1F21"'
alias fehnew='feh -S mtime'
alias fehrand='feh --randomize'

alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"

# I always forget how the python3 version looks like Q_Q
alias webserver="python3 -m http.server"

# Based on: https://github.com/azu/license-generator
alias MIT="license-generator MIT --author 'Lars Quentin' --output /dev/stdout"

wtfpl="
            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar
  14 rue de Plaisance, 75014 Paris, France
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO."

alias WTFPL="echo '$wtfpl'"

# https://stackoverflow.com/a/4208191/9958281
alias xclip='xclip -selection c'

# Thanks, https://write.corbpie.com/downloading-youtube-videos-as-audio-with-yt-dlp/
alias yt-mp3="yt-dlp -f 'ba' -x --audio-format mp3"

function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }

# Git autocomplete
# https://stackoverflow.com/a/18898614
source /usr/share/bash-completion/completions/git


# Noise loady stuff
. "$HOME/.cargo/env"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "/home/lquenti/.ghcup/env" ] && source "/home/lquenti/.ghcup/env" # ghcup-env
