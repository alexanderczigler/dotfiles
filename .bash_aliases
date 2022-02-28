alias gp="git pull --rebase --autostash"
alias gclean="git checkout main && git fetch --all -p && git pull origin main --autostash --rebase && git branch -D $(git branch --merged | grep -v main)"

export AUR_PACKAGE_LIST=$HOME/Documents/.aur
export UNINSTALL_PACKAGE_LIST=$HOME/Documents/.uninstall

function rcupdate () {
  echo " -> Update .bashrc"
  cp "$ENV_LOCATION/.bashrc" "$HOME/.bashrc"
  cp "$ENV_LOCATION/.bash_aliases" "$HOME/.bash_aliases"
  
  echo " -> Reload .bashrc"
  source "$HOME/.bashrc"
}

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
  SAVE="false"

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
    touch "$AUR_PACKAGE_LIST"
    grep -q -F "$1" $AUR_PACKAGE_LIST || echo "$1" >> $AUR_PACKAGE_LIST
  fi

  cd -
}

function aur-update-packages {
  uninstall-packages

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

function uninstall-packages {
  touch "$UNINSTALL_PACKAGE_LIST"
  while read package; do
    aur-cache-delete "$package"
    sudo pacman -Rns --noconfirm "$package"
  done < $UNINSTALL_PACKAGE_LIST
}