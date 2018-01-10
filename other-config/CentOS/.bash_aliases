# Aliases definitions

alias ll="ls -lh"
alias lc="ls -F"
alias lt="ls --full-time"
alias la="ls -a"
alias os-update='sudo yum check-update'
alias os-upgrade='sudo yum update -y'
alias ts='new_session(){ tmux new-session -s "$1"; unset -f new_session; }; new_session'
alias tk='kill_session(){ tmux kill-session -t "$1"; unset -f kill_session; }; kill_session'
alias os-install='install_app(){ sudo yum install -y "$1"; unset -f os-install; }; install_app'
alias pmail='patch_send_email(){ git send-email "$1"; unset -f patch_send_email; }; patch_send_email'
