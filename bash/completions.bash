#
#
#
###
## Tab completions
#

# kubectl
source <(kubectl completion bash)

# GIT
COMPLETION_GIT='/usr/share/git/completion/git-completion.bash'

if [ ! -z 'uname -v | grep -i ubuntu' ]; then
  COMPLETION_GIT='/usr/share/bash-completion/completions/git'
fi

if [ -f ${COMPLETION_GIT} ]; then
  source ${COMPLETION_GIT}
fi

if [ -f /usr/local/etc/bash_completion.d ]; then
  source /usr/local/etc/bash_completion.d
fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion