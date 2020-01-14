#
#
#
###
## Directory magic
#

function nvmuse {
  [ -z "$PS1" ] && return
  if [[ $PWD == $prev_pwd ]]; then
    return
  fi

  prev_pwd=$PWD
  if [[ -f ".nvmrc" ]]; then
    eval "nvm use" >/dev/null

    if [[ "$?" == "3" ]]; then
      eval "nvm install" >/dev/null
    fi

    nvm_dirty="1"
  elif [[ "$nvm_dirty" == "1" ]]; then
    eval "nvm use default" >/dev/null
    nvm_dirty="0"
  fi
}

# Override cd
function cd {
  builtin cd "$@"
  nvmuse
}

# Run nvmuse right now!
nvmuse