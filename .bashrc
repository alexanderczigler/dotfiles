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
# Completions
#

if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
fi

#
# Custom tools
#

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

#
# Hooks
#

eval "$(direnv hook bash)"
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"
