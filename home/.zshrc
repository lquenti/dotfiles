# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/lquenti/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="half-life"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf-tab # Needs to manually be installed
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
EDITOR="nvim"

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
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias free='free -m'
alias cls='clear'
alias cl='clear'
alias ping='ping -c 5'
alias calc='python -i -c "
from math import *
import numpy as np
import sympy
import sys
sys.ps1 = \"λ> \"
"'
alias pi='ssh 192.168.0.161'
alias dia='dia --integrated'
alias cal='ncal'

alias pacman='sudo pacman'
alias pS='pacman -S'
alias pSyu='pacman -Syu'
alias pSyy='pacman -Syy'
alias pR='pacman -R'
alias pRs='pacman -Rs'
alias pQ='pacman -Q' # all packages
alias pQet='pacman -Qet' # All installed packages w/o dependencies
alias pQl='pacman -Ql' # All files installed by all packages
alias pCl='pacman -R $(pacman -Qdtq)' # autoclean
alias pCls='pacman -R $(pacman -Qdtq)' # autoclean
alias pClean='pacman -R $(pacman -Qdtq)' # autoclean

alias aSyu='sudo apt update && sudo apt upgrade'
alias aSyuy='sudo apt update && sudo apt upgrade -y'
alias aS='sudo apt install'
alias aR='sudo apt purge'
alias aCl='sudo apt-get autoremove'
alias aCls='sudo apt-get autoremove'
alias aClean='sudo apt-get autoremove'

alias emerge='sudo emerge'
alias search='emerge --search'
alias Search='emerge -S'
alias demerge='emerge --unmerge'
alias eSyu='emerge --update --deep --with-bdeps=y @world'
alias enewuse='emerge --update --deep --with-bdeps=y @world'
alias eCl='emerge --depclean'
alias eCls='emerge --depclean'
alias eClean='emerge --depclean'

alias :r="source ~/.zshrc"
alias bashrc='echo "You are not using bash anymore ffs"'
alias zshrc='$EDITOR ~/.zshrc'
alias vimrc='$EDITOR ~/.vimrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.vim'
alias cocrc='$EDITOR ~/.config/nvim/coc-settings.json'
alias termrc='$EDITOR ~/.config/termite/config'
alias xinitrc='$EDITOR ~/.xinitrc'
alias rclua='$EDITOR ~/.config/awesome/rc.lua'
alias themelua='$EDITOR ~/.config/awesome/themes/theme.lua'
alias qtilerc='$EDITOR ~/.config/qtile/config.py'
alias termrc='$EDITOR ~/.config/xfce4/terminal/terminalrc'
alias terminalrc=termrc
alias xfcerc=termrc
alias irc='weechat'
alias matrix='weechat'
alias vim='nvim'
alias nvim_install='nvim +PlugInstall +UpdateRemotePlugins +qa'
alias pdftex='pdflatex document.tex'
alias dispatch-conf='sudo dispatch-conf'
alias gs='git status'
alias godocs="godoc -http :8000"
alias feh='feh --scale-down --image-bg "#1D1F21"'
alias fehnew='feh -S mtime'
alias fehrand='feh --randomize'
alias de='setxkbmap de'
alias us='setxkbmap us'

# Otherwise I wont learn it
function scrot() {
  # I need a function to throw away all arguments
  flameshot gui
}

# https://stackoverflow.com/a/4208191/9958281
alias xclip='xclip -selection c'

alias weather='curl wttr.in/Göttingen'

top10() { history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; }

dirsize () {
  du -shx * .[a-zA-Z0-9_]* 2> /dev/null | egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
  egrep '^ *[0-9.]*M' /tmp/list
  egrep '^ *[0-9.]*G' /tmp/list
  rm -rf /tmp/list
}

function cd() { builtin cd -- "$@" && { [ "$PS1" = "" ] || ls -hrt --color; }; }

alias youtube-dl="youtube-dl --ignore-errors --yes-playlist"
alias youtube-mp3="youtube-dl --extract-audio --audio-format mp3"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -f "/home/lquenti/.ghcup/env" ] && source "/home/lquenti/.ghcup/env" # ghcup-env
#source ${HOME}/perl5/perlbrew/etc/bashrc

export GOPATH=$HOME/Documents/Tech/go
export PATH=$PATH:$GOPATH/bin
