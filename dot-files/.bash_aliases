# Aliases definitions, a part of alias refer to: https://github.com/robbyrussell/oh-my-zsh

alias ll="ls -lh"
alias lc="ls -F"
alias lt="ls --full-time"
alias la="ls -a"
alias h='history'
alias tis='tig status'
alias til='tig log'
alias tib='tig blame -C'
alias ys="yum search"
alias yp="yum info"
alias ygl="yum grouplist"
alias yi="sudo yum install"
alias ygi="sudo yum groupinstall"
alias yc="sudo yum clean all"
alias yhl="sudo yum history list"
alias yhu="sudo yum history undo"
alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tad='tmux attach -d -t'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'
alias pd2='pip2 download'
alias pd3='pip3 download'
alias pi2='sudo pip2 install'
alias pi3='sudo pip3 install'
alias ps2='pip2 search'
alias ps3='pip3 search'
alias gd='git diff'
alias chromium="/bin/chromium-browser --proxy-server='http://127.0.0.1:8118;https://127.0.0.1:8118'"
# Debian/Ubuntu which command from debianutils, CentOS/Fedora > Debian/Ubuntu
alias ipython="$(which --skip-alias ipython >/dev/null 2>&1 || which ipython) --term-title --HistoryManager.hist_file=/tmp/ipython_hist.sqlite --colors Linux"
