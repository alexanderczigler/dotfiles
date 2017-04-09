# ~/.bashrc: executed by bash(1) for non-login shells.

SOURCE_LOCATION=~/Source

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export PATH=$PATH:/home/ilix/.local/bin

# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTTIMEFORMAT='%F %T '

# Keep history up to date, across sessions, in realtime
#  http://unix.stackexchange.com/a/48113
export HISTCONTROL=ignoredups:erasedups         # no duplicate entries
export HISTSIZE=100000                          # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                   # big big history
which shopt > /dev/null && shopt -s histappend  # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Use up/down arrows to search on partially typed command
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Custom aliases
alias docker_clean_containers="docker rm $(docker ps -aq)"
alias docker_clean_containers="docker rmi -f $(docker images -aq)"
alias docker_clean_volumes="docker volume rm $(docker volume ls -qf dangling=true)"
alias minecraft="java -jar ~/Applications/Minecraft.jar &>/dev/null &"
alias oadm="~/Applications/openshift/oadm"
alias oc="~/Applications/openshift/oc"
alias sqldeveloper="sh ~/Applications/sqldeveloper/sqldeveloper.sh &>/dev/null &"
alias update="cp $SOURCE_LOCATION/home/.bashrc ~/.bashrc && source ~/.bashrc"
alias vpn_dn=""
alias vpn_up=""
alias xps_wifi="sudo systemctl restart network-manager.service"

# Unfinished git status output.
if [ -n `command -v git 2>/dev/null` ]; then
  export PS1='\
  $(git branch &>/dev/null; \
    if [ $? -eq 0 ]; then \
      echo "\n\e[0m\]git:\e[0;34m\] $(git branch | grep ^*|sed s/\*\ //) \
      $(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
        if [ "$?" -eq "0" ]; then \
          echo "\e[0;32m^_^\e[0m"; \
        else \
          echo "\e[0;33m-\e[0m_\e[0;33m-\e[0m"; \
        fi \
      )"; \
    fi) \
  \e[0m\]\n\w\n→ '
else
  export PS1='\e[0m\]\n\w\n→ '
fi;

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/ilix/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/home/ilix/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/ilix/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/home/ilix/Downloads/google-cloud-sdk/completion.bash.inc'
fi

function fixwifi {
  sudo systemctl restart network-manager.service
}

export NVM_DIR="/home/ilix/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

[ -z "$PS1" ] && return

function nvmuse {
  [ -z "$PS1" ] && return
  if [ -f .nvmrc ]; then
    nvm use
  fi
}

function cd {
  builtin cd "$@"
  nvmuse
}

nvmuse
