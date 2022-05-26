# My custom .zshrc
# https://github.com/alexanderczigler/.env

ENV_LOCATION="$HOME/.env"

# History
HISTDUP=erase             # No duplicates
HISTSIZE=10000            # In memory
SAVEHIST=10000            # In ~/.zsh_history
setopt appendhistory      # Append to ~/.zsh_history
setopt sharehistory       # All open terminals share history
setopt incappendhistory   # Append continously

# Aliases

alias gp="git pull --rebase --autostash"
alias gclean="git checkout main && git fetch --all -p && git pull origin main --autostash --rebase && git branch -D $(git branch --merged | grep -v main)"

# Completions

autoload -Uz compinit
compinit

# Refresh .zshrc and other files from the .env repo

zup () {
  echo " -> Update .zshrc"
  _zup_rc

  echo " -> Reload .zshrc"
  source "$HOME/.zshrc"
}

_zup_rc () {
  cp "$ENV_LOCATION/.zshrc" "$HOME/.zshrc"
}

# direnv

eval "$(direnv hook zsh)"

# nvm

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvmuse () {
  [ -z "$PS1" ] && return
  if [[ $PWD == $prev_pwd ]]; then
    return
  fi

  prev_pwd=$PWD
  if [[ -f ".nvmrc" ]]; then
    echo " -> Found .nvmrc"
    eval "nvm use" >/dev/null

    if [[ "$?" == "3" ]]; then
      echo " -> node version not installed, installing..."
      eval "nvm install" >/dev/null
    fi

    echo " -> Using node $(node -v)"

    nvm_dirty="1"
  elif [[ "$nvm_dirty" == "1" ]]; then
    echo " -> Falling back to default node version"
    eval "nvm use default" >/dev/null
    nvm_dirty="0"

    echo " -> Using node $(node -v)"
  fi
}

function cd {
  builtin cd "$@"
  nvmuse
}

nvmuse
