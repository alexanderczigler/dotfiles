# .env

When I setup or reinstall a workstation there are a bunch of applications, configuration and tools that need to be in place before I feel like home. The main goal of this repository is to hold complete instructions for setting up my environment exactly how I want it, and to keep my `~/.bashrc` file.

Feel free to use any of this if you find it useful but do it at your own risk! :)

NOTE: There may be a bit of a mix-up between intel and silicon stuff for macOS. So if something doesn't quite work it is probably adapted for silicon or vice versa.

### Applications

- [1Password](https://1password.com/downloads/mac/)
- [1Password for Safari](https://apps.apple.com/se/app/1password-for-safari/id1569813296?l=en&mt=12)
- [Slack](https://apps.apple.com/se/app/slack-for-desktop/id803453959?l=en&mt=12)
- [VSCode](https://code.visualstudio.com/download)

### Configuration

#### bash

```bash
# Add this to `~/.bash_profile` to ensure that `~/.bashrc` is loaded.
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
```

**NOTE** If you are on Mac OS run `chsh -s /bin/bash` to change your default shell to bash.

##### .bash_profile

```shell
# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

# Prompt.
PS1='[\u@\h \W]\$ '

export PATH=$PATH:/opt/homebrew/bin

#
# Settings.
# 

ENV_REPO_DIR="$HOME/.env"

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

export BASH_SILENCE_DEPRECATION_WARNING=1

#
# Update .bashrc from the repo directory.
#

function bup {
  cp "$ENV_REPO_DIR/.bashrc" "$HOME/.bashrc"
  source "$HOME/.bashrc"
}

#
# Completions.
#

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
else
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
  . ~/.git-completion.bash
fi

eval "$(skaffold completion bash)"

#
# Custom tools
#

function docker-clean {
  docker rm -f $(docker ps -aq)
  docker rmi -f $(docker images -q)
  docker system prune --volumes -f
}

function close-ssh-tunnels {
  pkill -f 'ssh.*-f'
}

#
# NVM.
#

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

nvm_hook () {
  [ -z "$PS1" ] && return
  if [[ $PWD == $prev_pwd ]]; then
    return
  fi

  prev_pwd=$PWD
  if [[ -f ".nvmrc" ]]; then
    eval "nvm use" > /dev/null

    if [[ "$?" == "3" ]]; then
      echo "nvm: going to install desired node version..."
      eval "nvm install" > /dev/null
    fi

    echo "nvm: using node $(node -v)"

    nvm_dirty="1"
  elif [[ "$nvm_dirty" == "1" ]]; then
    echo "nvm: falling back to default node version"
    eval "nvm use default" > /dev/null
    nvm_dirty="0"

    echo "nvm: using node $(node -v)"
  fi
}

#
# Hooks
#

eval "$(direnv hook bash)"
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"
```

#### Git

Git commits are signed using an SSH key, the signing program is 1password.

```shell
# Configure git (macOS).
cat >~/.gitconfig << EOL
[user]
  signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJM5HFfhL/8n8w3C9hyo5btCNMp0RYYwILioNDvQVb6R
  name = Alexander Czigler
  email = dev@ilix.se
[init]
  defaultBranch = main
[commit]
  gpgsign = true
[gpg]
  format = ssh
[gpg "ssh"]
  program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
EOL
```

#### SSH

Configure the ssh client to use and IdentityAgent for all hosts. Put the following lines in `~/.ssh/config`. NOTE: This is for macOS.

```config
Host *
	IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

## Environment



### .bashrc



**NOTE:** Whenever you make changes to .bashrc, run `bup` to refresh it.

### Tools

#### Homebrew

Install [Homebrew](https://brew.sh/) then use it to install the following packages.

```bash
brew install awscli bash-completion direnv doctl eksctl gnupg2 helm kubectl kubectx nvm pinentry-mac skaffold watch

# FiraCode font
# https://github.com/tonsky/FiraCode/wiki/Installing
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
```

##### GnuPG + pinentry

GnuPG needs to be configured to use pinentry-mac

```bash
mkdir -p ~/.gnupg
echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
```

#### iTerm

1. Install [iTerm](https://iterm2.com/).
2. Configure the main iTerm profile as a hotkey window triggered by **§**.
3. Configure iTerm to launch when loggin in (hidden).
4. Fix keybinds in iTerm: [Jumping between words in iTerm](https://coderwall.com/p/h6yfda/use-and-to-jump-forwards-backwards-words-in-iterm-2-on-os-x).
5. Map Shift + Insert keybind in iTerm to "Paste...".

### Other

- Install [Docker Desktop](https://docs.docker.com/desktop/linux/install/archlinux/)

#### UnnaturalScrollWheels

```bash
brew install --cask unnaturalscrollwheels
```

##### Configuration

<img width="512" alt="unnaturalscrollwheels" src="https://user-images.githubusercontent.com/3116043/209099151-0f41150e-084b-461b-aa7e-fc43004d9acf.png">

#### SensibleSideButtons

After that, install [SensibleSideButtons](https://sensible-side-buttons.archagon.net) and also configure it to launch on login.

#### Non-Apple keyboards

Install [Karabiner Elements](https://karabiner-elements.pqrs.org).
