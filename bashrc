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
# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

EDITOR="nvim"
BROWSER="firefox"

PATH=~/.cargo/bin/:~/.local/bin:$PATH

alias ls='ls --color=auto'
alias ll='ls -lahF'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ..='cd ..'
alias sl='ls'

alias :r="source ~/.bashrc"
alias bashrc='$EDITOR ~/.bashrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias vim='nvim'
alias gs='git status'
alias de='setxkbmap de'
alias us='setxkbmap us'

alias b="${BROWSER}"
alias c="code"
alias g="lazygit"

alias feh='feh --scale-down --image-bg "#1D1F21"'
alias fehnew='feh -S mtime'
alias fehrand='feh --randomize'

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

alias ba="python3 ~/code/mdtrack/main.py ~/ba_tracking.md"

function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }


# Noise loady stuff
[ -r /home/lquenti/.byobu/prompt ] && . /home/lquenti/.byobu/prompt   #byobu-prompt#
. "$HOME/.cargo/env"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
