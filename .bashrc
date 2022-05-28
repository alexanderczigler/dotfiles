#
# My custom .bashrc
# https://github.com/alexanderczigler/.env
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#
# Settings
# 

ENV_REPO_DIR="$HOME/.env"

HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000

shopt -s checkwinsize
shopt -s histappend

#
# .bashrc controls
#

function update-bashrc {
  cp "$ENV_REPO_DIR/.bashrc" "$HOME/.bashrc"
  source "$HOME/.bashrc"
}

#
# Arch things
#

function pacman-installed {
  pacman -Qei | awk '/^Name/ { name=$3 } /^Groups/ { if ( $3 != "base" && $3 != "base-devel" ) { print name } }' | more
}

function pacman-clean {
  sudo pacman -Syy
  sudo pacman -Scc
  sudo pacman -Suu
}

#
# AUR things
#

export AUR_DIR=$HOME/.aur
export AUR_PACKAGE_LIST=$AUR_DIR/packages

function aur-install {
  if [ ! -d "${PKG}" ]
  then
    mkdir $PKG
  fi

  PKG="$AUR_DIR/$1"

  if [ -d "${PKG}" ]
  then
    cd "${PKG}"
    git checkout . # NOTE: Should I use git clean -fdx instead?
    git pull origin master # NOTE: What if they do not use master?
  else
    git clone "https://aur.archlinux.org/$1.git" "$PKG"
    cd "$PKG"
  fi

  if [ $? == 0 ]; then
    makepkg -Acsi --noconfirm
    touch "$AUR_PACKAGE_LIST"
    grep -q -F "$1" $AUR_PACKAGE_LIST || echo "$1" >> $AUR_PACKAGE_LIST
  fi

  cd -
}

function aur-update {
  while read package; do
    aur-install "$package"
  done < $AUR_PACKAGE_LIST
}

function aur-cache-list {
  cat $AUR_PACKAGE_LIST | more
}

function aur-cache-delete {
  sed -i "/$1/d" $AUR_PACKAGE_LIST
}

#
# Custom tools
#

function otp {
  OTPKEY="$(sed -n "s/${1}=//p" $HOME/Documents/.otpkeys)"
  if [ ! -z "$OTPKEY" ]; then
    oathtool --totp -b "$OTPKEY"
  fi
}

function docker-swarm-tunnel {
  SSH_DOCKER_SOCK=$(pwd)/.ssh-docker.sock
  rm $SSH_DOCKER_SOCK

  ssh -fNL $SSH_DOCKER_SOCK:/var/run/docker.sock $1
  export DOCKER_HOST=unix://$SSH_DOCKER_SOCK

  echo "OK!"
  echo "DOCKER_HOST=$DOCKER_HOST"
  echo "Connection: $1"
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

function close-ssh-tunnels {
  pkill -f 'ssh.*-f'
}

#
# nvm things
#

source /usr/share/nvm/init-nvm.sh # NOTE: This will fail if nvm is not installed

nvm_hook () {
  [ -z "$PS1" ] && return
  if [[ $PWD == $prev_pwd ]]; then
    return
  fi

  prev_pwd=$PWD
  if [[ -f ".nvmrc" ]]; then
    eval "nvm use" > /dev/null

    if [[ "$?" == "3" ]]; then
      echo "nvm: going to install desired node version..."
      eval "nvm install" > /dev/null
    fi

    echo "nvm: using node $(node -v)"

    nvm_dirty="1"
  elif [[ "$nvm_dirty" == "1" ]]; then
    echo "nvm: falling back to default node version"
    eval "nvm use default" > /dev/null
    nvm_dirty="0"

    echo "nvm: using node $(node -v)"
  fi
}

#
# Hooks
#

eval "$(direnv hook bash)"
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"