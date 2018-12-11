#
# My own .bashrc
# https://github.com/ilix/linux
# # # # # # #

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

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
alias discord="~/.local/Discord/Discord"
alias minecraft="java -jar ~/.local/Minecraft.jar &>/dev/null &"
alias oadm="~/.local/openshift/oadm"
alias oc="~/.local/openshift/oc"
alias sqldeveloper="sh ~/.local/sqldeveloper/sqldeveloper.sh &>/dev/null &"
alias syncthing="screen -d -m -S syncthing bash -c ""~/.local/syncthing/syncthing"""
alias vpn_up="screen -d -m -S openvpn sudo openvpn --config ~/Documents/iteam-acr.ovpn"
alias vpn_dn="sudo killall openvpn"
alias wejay="~/.local/wejay"

alias remove-orphaned-packages="sudo pacman -Rns $(pacman -Qtdq)"

# alias use-with-caution="~/Source/ilix/linux/get.sh"
# alias update-bashrc-from-git="source ~/Source/ilix/linux/put.sh"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -z "$PS1" ] && return

function docker-swarm-tunnel {
  ssh -fNL localhost:2374:/var/run/docker.sock $1
  export DOCKER_HOST=localhost:2374
}

function docker-local {
  export DOCKER_HOST=
}

function cpkubeconfig {
  KUBE_CONFIG=`ssh root@$1 cat /root/.kube/config`
  echo -e $"$KUBE_CONFIG" > "$HOME/.kube/config"
}

#
# .bashrc helpers
# # # # # # #
function bashrc_from_local_repo {
  LINUX="$HOME/Source/linux/"

  # Ensure folders exist
  mkdir -p ~/.ssh
  mkdir -p ~/.config/Code/Users

  # Put files to use
  cp "$LINUX".ssh/config ~/.ssh/config
  cp "$LINUX".ssh/authorized_keys ~/.ssh/authorized_keys
  cp "$LINUX".config/Code/Users/settings.json ~/.config/Code/Users/settings.json
  cp "$LINUX".bashrc ~/.bashrc

  # Reload
  source ~/.bashrc
}

#
# AUR helpers
# # # # # # #
function insaur {
  AUR="$HOME/.aur"
  PKG="$AUR/$1"
  AURCACHE="$HOME/.aurcache"
  
  if [ -d "${PKG}" ]
  then
    cd "${PKG}"
    git checkout .
    git reset --hard HEAD
    git pull origin master
  else
    git clone "https://aur.archlinux.org/$1.git" "$PKG"
    cd "$PKG"
  fi
  
  makepkg -Acsi --noconfirm

  touch "$AURCACHE"
  grep -q -F "$1" $AURCACHE || echo "$1" >> $AURCACHE

  cd -
}

function updaur {
  AURCACHE="$HOME/.aurcache"

  while read package; do
    insaur "$package"
  done < $AURCACHE
}

function delaur {
  AURCACHE="$HOME/.aurcache"
  sed -i "/$1/d" $AURCACHE
  sudo pacman -Rns "$1"
}

#
# Ensure that `nvm use` is run whenever entering a dir containing an .nvmrc file
# # # # # # #

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

if [ -f /usr/share/git/completion/git-completion.bash ]; then
  source /usr/share/git/completion/git-completion.bash
fi

export LC_ALL=C; unset LANGUAGE
