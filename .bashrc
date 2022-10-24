#
# My custom .bashrc
# https://github.com/alexanderczigler/.env
#

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Prompt.
PS1='[\u@\h \W]\$ '

export PATH=$PATH:/opt/homebrew/bin

#
# Settings.
# 

ENV_REPO_DIR="$HOME/.env"

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

export BASH_SILENCE_DEPRECATION_WARNING=1

#
# Update .bashrc from the repo directory.
#

function bup {
  cp "$ENV_REPO_DIR/.bashrc" "$HOME/.bashrc"
  source "$HOME/.bashrc"
}

#
# Completions.
#

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
else
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  . ~/.git-completion.bash
fi

eval "$(skaffold completion bash)"

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
# NVM.
#

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
