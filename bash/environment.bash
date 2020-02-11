#
#
#
###
## environment
#

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=$HISTSIZE

shopt -s histappend;
shopt -s nocaseglob;
shopt -s cdspell;
shopt -s checkwinsize

export VISUAL=vim
export SOURCE_DIR=$HOME/Code
export LINUX_REPO_DIR=$SOURCE_DIR/linux
export AUR_PACKAGE_LIST=$HOME/Documents/.aur
export UNINSTALL_PACKAGE_LIST=$HOME/Documents/.uninstall
export WINEPREFIX=$HOME/WINE

# GnuPG
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# PATH mods
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Android/Sdk/platform-tools

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
