## A minimalistic shell profile for developers.
## https://github.com/alexanderczigler/dotfiles
####

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Prompt.
PS1='%~$ '

# Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

# direnv.
if type direnv &>/dev/null
then
  eval "$(direnv hook zsh)"
fi

# NVM.
NVM_DIR="/opt/homebrew/opt/nvm"
NVM_COMPLETION_PATH="/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s $NVM_COMPLETION_PATH ] && \. $NVM_COMPLETION_PATH

if type nvm &>/dev/null
then
  

  # Custom nvm hook.
  # This will detect .nvmrc files and run nvm <install | use> automatically.
  load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [ "$nvmrc_node_version" = "N/A" ]; then
        nvm install
      elif [ "$nvmrc_node_version" != "$node_version" ]; then
        nvm use
      fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
      nvm use default
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
fi
