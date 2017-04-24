# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

case $- in
  *i*) ;;
    *) return;;
esac

# PATH mods
export PATH=$PATH:/home/ilix/.local/bin

# Keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups         # no duplicate entries
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history

shopt -s histappend;
shopt -s nocaseglob;
shopt -s cdspell;
shopt -s checkwinsize

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Custom aliases
alias discord="~/Program/Discord/Discord"
alias docker_clean_containers="docker rm $(docker ps -aq)"
alias docker_clean_containers="docker rmi -f $(docker images -aq)"
alias docker_clean_volumes="docker volume rm $(docker volume ls -qf dangling=true)"
alias minecraft="java -jar ~/Program/Minecraft.jar &>/dev/null &"
alias oadm="~/Program/openshift/oadm"
alias oc="~/Program/openshift/oc"
alias sqldeveloper="sh ~/Program/sqldeveloper/sqldeveloper.sh &>/dev/null &"
alias update="cp ~/Dokument/home/.bashrc ~/.bashrc && source ~/.bashrc"
alias vpn_dn="sudo killall -9 openvpn" # seriously? I mean, seriously?
alias vpn_up="sudo openvpn --config ~/alexander@iteam.se/Access/iteam-acr.ovpn"
alias wejay="./home/ilix/Program/wejay"
alias xps_wifi="sudo systemctl restart network-manager.service"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export NVM_DIR="/home/ilix/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -z "$PS1" ] && return

function nvmuse {
  [ -z "$PS1" ] && return
  if [ -f .nvmrc ]; then
    nvm use
  fi
}

function cd {
  builtin cd "$@"
  nvmuse
}

nvmuse
