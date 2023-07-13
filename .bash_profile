## A minimalistic bash profile for developers.
## https://github.com/alexanderczigler/dotfiles
####

# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Setup bash prompt.
PS1='\W$ '

# Make bash check window size after each command.
shopt -s checkwinsize

# Setup bash history.
# https://askubuntu.com/questions/15926/how-to-avoid-duplicate-entries-in-bash-history
HISTSIZE=1000
HISTFILESIZE=1000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -n; history -w; history -c; history -r; $PROMPT_COMMAND"

# Silence deprecation warning.
export BASH_SILENCE_DEPRECATION_WARNING=1




## Homebrew.
## https://brew.sh/
####

if [ -d "/opt/homebrew" ]
then
   export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

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
fi




## git
####

GIT_COMPLETION_PATH="/Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash"
[ -s $GIT_COMPLETION_PATH ] && \. $GIT_COMPLETION_PATH




## direnv
## https://direnv.net/
####

if type direnv &>/dev/null
then
  eval "$(direnv hook bash)"
fi




## Node version manager.
## https://github.com/nvm-sh/nvm
####

NVM_DIR="/opt/homebrew/opt/nvm"
NVM_COMPLETION_PATH="/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s $NVM_COMPLETION_PATH ] && \. $NVM_COMPLETION_PATH

if type nvm &>/dev/null
then
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

  PROMPT_COMMAND="_nvm_hook; $PROMPT_COMMAND"
fi




## Ruby version manager.
## https://rvm.io/
####
RVM_PATH="$HOME/.rvm/scripts/rvm"
[[ -s $RVM_PATH ]] && source $RVM_PATH # Load RVM into a shell session *as a function*




## Google Cloud SDK.
## https://cloud.google.com/sdk/docs/quickstart
####

GC_PATH="$HOME/.local/google-cloud-sdk"
[ -s "$GC_PATH/path.bash.inc" ] && \. "$GC_PATH/path.bash.inc"
[ -s "$GC_PATH/completion.bash.inc" ] && \. "$GC_PATH/completion.bash.inc"




## Updating.
####

DOTFILES_PATH="$HOME/.dotfiles"
function dotfiles_update {
    cd $DOTFILES_PATH

  if [ "$1" == 'pull' ]
  then
    echo 'Updating dotfiles repo from git...'
    echo "Remote is $(git remote get-url origin)"
    git pull
    cd -
  fi

  cd -

  echo 'Installing dotfiles...'
  cp $DOTFILES_PATH/.bash_profile $HOME/.bash_profile
  source $HOME/.bash_profile
}
