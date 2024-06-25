## My shell profile.
## https://github.com/alexanderczigler/dotfiles

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Prompt.
PS1='\w$ '

# Settings.
export HISTCONTROL=ignoreboth:erasedups

# Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# direnv.
if type direnv &>/dev/null
then
  eval "$(direnv hook bash)"
fi

# NVM.
NVM_DIR="/opt/homebrew/opt/nvm"
NVM_COMPLETION_PATH="/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s $NVM_COMPLETION_PATH ] && \. $NVM_COMPLETION_PATH

if type nvm &>/dev/null
then
  _nvmrc_hook() {
    if [[ $PWD == $PREV_PWD ]]; then
      return
    fi
    
    PREV_PWD=$PWD
    [[ -f ".nvmrc" ]] && nvm use
  }

  if ! [[ "${PROMPT_COMMAND:-}" =~ _nvmrc_hook ]]; then
    PROMPT_COMMAND="_nvmrc_hook${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
  fi
fi

if type gcloud &>/dev/null
then
  source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"
  source "$(brew --prefix)/share/google-cloud-sdk/completion.bash.inc"
fi

function loop {
  while true; do $@; sleep 10; done
}

# rbenv
if type rbenv &>/dev/null
then
  eval "$(rbenv init - bash)"
fi

# bash completions

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/bash-completions:$FPATH

  # Load bash completion
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi
fi

# update the shell profile

function update-dotfiles {
  cd ~/.dotfiles
  git pull
  cd -
  source ~/.bashrc
}
