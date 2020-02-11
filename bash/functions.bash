#
#
#
###
## Docker
#

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
#
#
###
## Pacman and AUR
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

#
#
#
###
## OTP
#

function otp {
  OTPKEY="$(sed -n "s/${1}=//p" $HOME/Documents/.otpkeys)"
  if [ ! -z "$OTPKEY" ]; then
    oathtool --totp -b "$OTPKEY"
  fi
}

#
#
#
###
## .bashrc helpers
#

function src {
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

  # Reload
  source ~/.bashrc
}

#
#
#
###
## DevOps
#

function conf_eks {
  alias eks="eksctl --profile $1"
  echo "-> Created alias eks for 'eksctl --profile $1'"
}

function kube {
  if [ "$1" == "ns" ]; then
    alias k="kubectl -n $2"
    echo "-> Create alias k=\"kubectl -n $2\""
  fi
}

#
#
#
###
## Dev
#

function v2reset {
  if [ -z "$1" ]; then
    echo "Are you sure? Think about it."
  else
    cd ~/Code/v2
    git clean -fdx
    git checkout .
    docker-compose down
    docker volume rm v2_db-data
    npm ci
    v2envrc
    cd ~/Code/v2/api && direnv allow . && npm ci
    cd ~/Code/v2/cabby && direnv allow . && npm ci
    cd ~/Code/v2/web && npm ci
    cd ..
    v2resetdb
  fi
}

function v2start {
  cd ~/Code/v2

  session=v2
  tmux start-server
  tmux new-session -d -s $session -n api
  tmux selectp -t 1
  tmux send-keys "cd api" C-m
  if [ "$1" = "i" ]; then
    tmux send-keys "npm ci" C-m
  fi
  tmux send-keys "npm run dev" C-m

  tmux split-window
  tmux send-keys "cd cabby" C-m
  if [ "$1" = "i" ]; then
    tmux send-keys "npm ci" C-m
  fi
  tmux send-keys "npm run dev" C-m

  tmux split-window
  tmux send-keys "cd web" C-m
  tmux send-keys "nvm use v12.8" C-m
  if [ "$1" = "i" ]; then
    tmux send-keys "npm ci" C-m
  fi
  tmux send-keys "npm run build" C-m
  tmux send-keys "npm run dev" C-m

  tmux split-window
  tmux send-keys "cd pdf" C-m
  if [ "$1" = "i" ]; then
    tmux send-keys "npm ci" C-m
  fi
  tmux send-keys "npm run dev" C-m

  tmux select-layout even-horizontal
  tmux attach-session -t $session
}

function v2tests {
  cd ~/Code/v2

  session=v2tests
  tmux start-server
  tmux new-session -d -s $session -n api
  tmux selectp -t 1
  tmux send-keys "cd api" C-m
  tmux send-keys "npm run test:watch" C-m

  tmux split-window
  tmux send-keys "cd cabby" C-m
  tmux send-keys "npm run test:watch" C-m

  tmux split-window
  tmux send-keys "cd web" C-m
  tmux send-keys "nvm use v12.8" C-m
  tmux send-keys "npm run build" C-m
  tmux send-keys "npm run test:watch" C-m

  tmux select-layout even-horizontal
  tmux attach-session -t $session
}

function v2dockerbuild {
  cd ~/Code/v2
  docker build -t v2_api api --no-cache && \
    docker build -t v2_cabby cabby --no-cache && \
    docker build -t v2_web web --no-cache
}

function setup-v2 {
  guake -r home

  # git
  guake -n guake -e 'cd ~/Source/mrf/v2' guake -r git
  guake --split-vertical -e 'cd ~/Source/mrf/v2/api && docker-compose up --build'

  # api
  guake -n guake -e 'cd ~/Source/mrf/v2/api && npm run dev' guake -r api
  guake --split-vertical -e 'cd ~/Source/mrf/v2/api && npm run test -- --watch'

  # cabby
  guake -n guake -e 'cd ~/Source/mrf/v2/cabby && npm run dev' guake -r cabby
  guake --split-vertical -e 'cd ~/Source/mrf/v2/cabby && npm run test -- --watch'

  # fortnox
  guake -n guake -e 'cd ~/Source/mrf/v2/fortnox && npm run dev' guake -r fortnox
  guake --split-vertical -e 'cd ~/Source/mrf/v2/fortnox && npm run test -- --watch'

  # web
  guake -n guake -e 'cd ~/Source/mrf/v2/web && npm run test -- --watch' guake -r web
  guake --split-vertical -e 'cd ~/Source/mrf/v2/web && npm run start'
  guake --split-horizontal -e 'cd ~/Source/mrf/v2/web && npm run dev'
}

function setup-vevo {
  guake -r home

  # git
  guake -n guake -e 'cd ~/Source/v3vo/monorepo' guake -r git
  guake --split-vertical -e 'cd ~/Source/v3vo/monorepo/api && docker-compose up --build'

  # api
  guake -n guake -e 'cd ~/Source/v3vo/monorepo/api && npm run dev' guake -r api
  guake --split-vertical -e 'cd ~/Source/v3vo/monorepo/api && npm run test -- --watch'

  # app
  guake -n guake -e 'cd ~/Source/v3vo/monorepo/app && npm run start' guake -r app
  guake --split-vertical -e 'cd ~/Source/v3vo/monorepo/app && npm run dev'

  # web
  guake -n guake -e 'cd ~/Source/v3vo/monorepo/admin && python3 -m http.server' guake -r web
  guake --split-vertical -e 'cd ~/Source/v3vo/monorepo/web && npm run start'
  guake --split-horizontal -e 'cd ~/Source/v3vo/monorepo/web && npm run dev'
}