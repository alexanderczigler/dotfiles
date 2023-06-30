# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Setup bash prompt.
PS1='[\u@\h \W]\$ '

# Custom nvm hook.
# This will detect .nvmrc files and run nvm <install | use> automatically.
_nvm_hook () {
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

      nvm_dirty="1"
   elif [[ "$nvm_dirty" == "1" ]]; then
      eval "nvm use default" > /dev/null
      nvm_dirty="0"
   fi
}

# Make bash check window size after each command.
shopt -s checkwinsize

# Setup bash history.
# https://askubuntu.com/questions/15926/how-to-avoid-duplicate-entries-in-bash-history
HISTSIZE=1000
HISTFILESIZE=1000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; _nvm_hook; $PROMPT_COMMAND"

# Silence deprecation warning.
export BASH_SILENCE_DEPRECATION_WARNING=1

# Setup path.
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# Setup NVM.
export NVM_DIR="/opt/homebrew/opt/nvm"

# direnv hook.
eval "$(direnv hook bash)"

# Load Homebrew completion.
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

# Load Git completion.
[ -s "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash" ] && \. "/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"

# Load NVM.
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Load RVM.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Google Cloud SDK.
GC_PATH="$HOME/.local/google-cloud-sdk"
[ -s "$GC_PATH/path.bash.inc" ] && \. "$GC_PATH/path.bash.inc"
[ -s "$GC_PATH/completion.bash.inc" ] && \. "$GC_PATH/completion.bash.inc"
