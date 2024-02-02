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
alias gccdbg='gcc -Wall -Wextra -Wconversion -Wsign-conversion -Wshadow -pedantic-errors -ggdb -Werror --std=c90'
alias gccrls='gcc -O2 -DNDEBUG'


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

alias diff="delta"
# side by side
alias delta="delta -s"

# requires `tre`
alias tree="tre-command"

alias feh='feh --scale-down --image-bg "#1D1F21"'
alias fehnew='feh -S mtime'
alias fehrand='feh --randomize'

alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"

# I always forget how the python3 version looks like Q_Q
alias webserver="python3 -m http.server"

generate_mit_license() {
    local year=$(date +"%Y")
    local name="Lars Quentin"

    cat <<EOF
Copyright (c) $year $name

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF
}
alias MIT=generate_mit_license


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

function setup_venv() {
    if [[ ! -d venv ]]; then 
        echo "creating venv"
        python3 -m venv venv
        if [[ ! -f ./.gitignore ]] || ! grep -q "^venv/$" ./.gitignore; then
            echo "venv/" >> ./.gitignore
        fi
        if [[ -f ./requirements.txt ]]; then 
            echo "requirements.txt found, installing"
            ./venv/bin/pip install -r ./requirements.txt
        fi
    fi
    source ./venv/bin/activate
}
alias venv=setup_venv

startwork() {
  tmux new-session -d -s work
  tmux split-window -h
  tmux split-window -v
  tmux send-keys -t work:0.0 'vim ~/code/lquentin/docs/timetracking.md' C-m
  tmux send-keys -t work:0.1 'vim ~/oC/offtime.md' C-m
  tmux send-keys -t work:0.2 'python3' C-m # for calculator
  tmux attach-session -t work
}


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
export PATH=$PATH:/usr/local/go/bin
