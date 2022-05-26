# My custom .bashrc
# https://github.com/alexanderczigler/.env

# Install location
ENV_LOCATION="$HOME/.env"

# Continue only when running interactively
case $- in
    *i*) ;;
      *) return;;
esac

# Bash settings.
HISTCONTROL=ignoreboth
HISTFILESIZE=2000
HISTSIZE=1000

shopt -s checkwinsize
shopt -s histappend

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -x /home/linuxbrew/.linuxbrew/bin/kubectl ] && source <(/home/linuxbrew/.linuxbrew/bin/kubectl completion bash)

if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]; then
  . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi

# direnv
eval "$(direnv hook bash)"

# kubectl
if [ -f /usr/local/etc/bash_completion.d/kubectl ]; then
  . /usr/local/etc/bash_completion.d/kubectl
fi

# brew
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

alias gp="git pull --rebase --autostash"
alias gclean="git checkout main && git fetch --all -p && git pull origin main --autostash --rebase && git branch -D $(git branch --merged | grep -v main)"

export AUR_PACKAGE_LIST=$HOME/Documents/.aur
export UNINSTALL_PACKAGE_LIST=$HOME/Documents/.uninstall

function rcupdate () {
  echo " -> Update .bashrc"
  cp "$ENV_LOCATION/.bashrc" "$HOME/.bashrc"
  
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

# A primitive npm hook
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"
