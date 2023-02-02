[[ $- != *i* ]] && return # If not running interactively, don't do anything.
PS1='[\u@\h \W]\$ '

nvm_hook () {
   [ -z "$PS1" ] && return
   if [[ $PWD == $prev_pwd ]]; then
      return
   fi

   prev_pwd=$PWD
   if [[ -f ".nvmrc" ]]; then
      eval "nvm use" > /dev/null

      if [[ "$?" == "3" ]]; then
         echo "nvm: installing..."
         eval "nvm install" > /dev/null
      fi

      echo "nvm: using node $(node -v)"
      nvm_dirty="1"
   elif [[ "$nvm_dirty" == "1" ]]; then
      echo "nvm: using node $(node -v)"
      eval "nvm use default" > /dev/null
      nvm_dirty="0"
   fi
}

export PATH=$PATH:/opt/homebrew/bin
export BASH_SILENCE_DEPRECATION_WARNING=1
export NVM_DIR="/opt/homebrew/opt/nvm"
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

eval "$(direnv hook bash)"

# Completions.
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Load NVM.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
