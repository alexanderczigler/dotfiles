#
# My own .bashrc
# https://github.com/alexanderczigler/linux
#

export LC_ALL=""
export LC_COLLATE=C
export LANG=en_US.UTF-8

export SOURCE_DIR=$HOME/Source
export LINUX_REPO_DIR=$SOURCE_DIR/linux
export AUR_PACKAGE_LIST=$LINUX_REPO_DIR/.aur

# If not running interactively, stop here
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
  . /etc/bash.bashrc
fi

# PATH mods
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Android/Sdk/platform-tools

# Bash settings
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE

shopt -s histappend;
shopt -s nocaseglob;
shopt -s cdspell;
shopt -s checkwinsize

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -z "$PS1" ] && return

#
# docker helpers
#

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
# Package helpers
#

function pacman-installed {
  pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/ { if ( $3 != "base" && $3 != "base-devel" ) { print name } }' | more
}

function pacman-clean {
  sudo pacman -Syy
  sudo pacman -Scc
  sudo pacman -Suu
}

function aur-install-package {
  PKG="$SOURCE_DIR/$1"

  if [ -d "${PKG}" ]
  then
    cd "${PKG}"
    git checkout .
    git pull origin master
  else
    git clone "https://aur.archlinux.org/$1.git" "$PKG"
    cd "$PKG"
  fi

  makepkg -Acsi --noconfirm

  touch "$AUR_PACKAGE_LIST"
  grep -q -F "$1" $AUR_PACKAGE_LIST || echo "$1" >> $AUR_PACKAGE_LIST

  cd -
}

function aur-update-packages {
  while read package; do
    aur-install-package "$package"
  done < $AUR_PACKAGE_LIST
}

function aur-cache-list {
  cat $AUR_PACKAGE_LIST | more
}

function aur-cache-delete {
  sed -i "/$1/d" $AUR_PACKAGE_LIST
}

#
# .bashrc helpers
#

function bashrc-update {
  LINUX="$HOME/Source/linux/"

  # Ensure folders exist
  mkdir -p ~/.ssh
  mkdir -p ~/.config/Code/Users

  if [ "$1" == "pull" ]; then
    cd $LINUX
    echo "Going to get latest .bashrc from git"
    git pull origin master
    cd -
  fi

  # Put files to use
  cp "$LINUX".ssh/config ~/.ssh/config
  cp "$LINUX".ssh/authorized_keys ~/.ssh/authorized_keys
  cp "$LINUX".config/Code/Users/settings.json ~/.config/Code/Users/settings.json
  cp "$LINUX".bashrc ~/.bashrc

  # Reload
  source ~/.bashrc
}

#
# directory helpers
#

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

#
# custom tab completions
#

if [ -f /usr/share/git/completion/git-completion.bash ]; then
  source /usr/share/git/completion/git-completion.bash
fi
