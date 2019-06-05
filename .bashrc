#
# My own .bashrc
# https://github.com/alexanderczigler/linux
#

export LC_ALL=""
export LC_COLLATE=C
export LANG=en_US.UTF-8

export SOURCE_DIR=$HOME/Code
export LINUX_REPO_DIR=$SOURCE_DIR/linux
export AUR_PACKAGE_LIST=$HOME/Documents/.aur
export WINEPREFIX=$HOME/WINE

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
export NVM_DIR="/usr/share/nvm"
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

function docker-clean {
  docker rm -f $(docker ps -aq)
  docker rmi -f $(docker images -q)
  docker system prune --volumes -f
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

  makepkg
  if [ $? == 0 ]; then
    makepkg -Acsi --noconfirm
  fi

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
# otp
#

function otp {
  if [ -z $1 ]; then
    echo
    echo "Usage:"
    echo "   otp google"
    echo
    echo "Configuration: $HOME/Documents/.otpkeys"
    echo "Format: name=key"
    exit
  fi
  OTPKEY="$(sed -n "s/${1}=//p" $HOME/Documents/.otpkeys)"
  if [ -z "$OTPKEY" ]; then
    echo "$(basename $0): Bad Service Name '$1'"
    $0
    exit
  fi
  oathtool --totp -b "$OTPKEY"
}

#
# .bashrc helpers
#

function bashrc-update {
  # Ensure folders exist
  mkdir -p ~/.ssh
  mkdir -p ~/.config/Code/User

  if [ "$1" == "pull" ]; then
    cd $LINUX_REPO_DIR
    echo "Going to get latest .bashrc from git"
    git pull origin master
    cd -
  fi

  # Put files to use
  cp "$LINUX_REPO_DIR"/.ssh/config ~/.ssh/config
  cp "$LINUX_REPO_DIR"/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub
  cp "$LINUX_REPO_DIR"/.ssh/git_rsa.pub ~/.ssh/git_rsa.pub
  cp "$LINUX_REPO_DIR"/.ssh/authorized_keys ~/.ssh/authorized_keys
  cp "$LINUX_REPO_DIR"/.config/Code/User/settings.json ~/.config/Code/User/settings.json
  cp "$LINUX_REPO_DIR"/.bashrc ~/.bashrc

  # Reload
  source ~/.bashrc
}

#
# stupid aliases
#
alias reset_vim="docker-compose down && docker volume rm v2_db-data && docker-compose up"

#
# directory helpers
#

function nvmuse {
  [ -z "$PS1" ] && return
  if [[ $PWD == $prev_pwd ]]; then
    return
  fi

  prev_pwd=$PWD
  if [[ -f ".nvmrc" ]]; then
    eval "nvm use" >/dev/null

    if [[ "$?" == "3" ]]; then
      eval "nvm install" >/dev/null
    fi

    nvm_dirty="1"
  elif [[ "$nvm_dirty" == "1" ]]; then
    eval "nvm use default" >/dev/null
    nvm_dirty="0"
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

_direnv_hook() {
  local previous_exit_status=$?;
  eval "$("/usr/bin/direnv" export bash)";
  return $previous_exit_status;
};
if ! [[ "$PROMPT_COMMAND" =~ _direnv_hook ]]; then
  PROMPT_COMMAND="_direnv_hook;$PROMPT_COMMAND"
fi
