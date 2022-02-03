export ZSH=/home/lquenti/.oh-my-zsh
ZSH_THEME="half-life"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
plugins=(
  git
  fzf-tab # Needs to manually be installed
)
source $ZSH/oh-my-zsh.sh
EDITOR="nvim"
BROWSER="firefox"

PATH=~/.cargo/bin/:~/.local/bin:$PATH

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ..='cd ..'
alias home='cd ~/'
alias sl='ls' # Because fuck you all
alias ll='ls -lahF'
alias cls='clear'
alias cl='clear'
alias calc='python -i -c "
from math import *
import numpy as np
import sys
sys.ps1 = \"λ> \"
"'
alias dia='dia --integrated'

alias :r="source ~/.zshrc"
alias bashrc='$EDITOR ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias vim='nvim'
alias gs='git status'
alias de='setxkbmap de'
alias us='setxkbmap us'
alias b="${BROWSER}"

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

# Based on: https://github.com/carloscuesta/gitmoji-cli
alias gc="gitmoji -c"
# https://stackoverflow.com/a/4208191/9958281
alias xclip='xclip -selection c'
alias weather='curl wttr.in/Göttingen'

function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
