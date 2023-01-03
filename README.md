# .env

When I setup or reinstall a workstation there are a bunch of applications, configuration and tools that need to be in place before I feel like home. The main goal of this repository is to hold complete instructions for setting up my environment exactly how I want it, and to keep my `~/.bashrc` file.

Feel free to use any of this if you find it useful but do it at your own risk! :)

NOTE: There may be a bit of a mix-up between intel and silicon stuff for macOS. So if something doesn't quite work it is probably adapted for silicon or vice versa.

### Applications

- [1Blocker](https://apps.apple.com/se/app/1blocker-ad-blocker/id1365531024?l=en)
- [1Password](https://1password.com/downloads/mac/)
- [1Password for Safari](https://apps.apple.com/se/app/1password-for-safari/id1569813296?l=en&mt=12)
- [DBeaver](https://dbeaver.io/download/)
- [Docker Desktop](https://docs.docker.com/desktop/linux/install/archlinux/)
- [Homebrew](https://brew.sh/)
- [Insomnia](https://insomnia.rest/download)
- [Instapaper](https://apps.apple.com/se/app/instapaper/id288545208?l=en)
- [Instapaper Save](https://apps.apple.com/se/app/instapaper-save/id1481302432?l=en&mt=12)
- [Karabiner Elements](https://karabiner-elements.pqrs.org)
- [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
- [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os/)
- [Raindrop Safari Extension](https://apps.apple.com/se/app/save-to-raindrop-io/id1549370672?l=en&mt=12)
- [SensibleSideButtons](https://sensible-side-buttons.archagon.net)
- [Slack](https://apps.apple.com/se/app/slack-for-desktop/id803453959?l=en&mt=12)
- [VSCode](https://code.visualstudio.com/download)

### Configuration

#### bash

**NOTE** If you are on Mac OS run `chsh -s /bin/bash` to change your default shell to bash.

```shell
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
export NVM_DIR="$HOME/.nvm"
export PROMPT_COMMAND="nvm_hook;$PROMPT_COMMAND"

shopt -s checkwinsize
shopt -s histappend

HISTCONTROL=ignoredups:ignorespace
HISTFILESIZE=2000
HISTSIZE=1000

eval "$(direnv hook bash)"
eval "$(kubectl completion bash)"
eval "$(skaffold completion bash)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

### Tools

#### Homebrew

Install [Homebrew](https://brew.sh/) then use it to install the following packages.

```bash
brew tap homebrew/cask-fonts
brew install awscli bash-completion direnv doctl eksctl gnupg2 helm kubectl kubectx nvm pinentry-mac skaffold telnet watch
brew install --cask font-fira-code
```

#### iTerm

1. Install [iTerm](https://iterm2.com/).
2. Configure the main iTerm profile as a hotkey window triggered by **§**.
3. Configure iTerm to launch when loggin in (hidden).
4. Fix keybinds in iTerm: [Jumping between words in iTerm](https://coderwall.com/p/h6yfda/use-and-to-jump-forwards-backwards-words-in-iterm-2-on-os-x).
5. Map Shift + Insert keybind in iTerm to "Paste...".

#### UnnaturalScrollWheels

```bash
brew install --cask unnaturalscrollwheels
```

##### Configuration

<img width="512" alt="unnaturalscrollwheels" src="https://user-images.githubusercontent.com/3116043/209099151-0f41150e-084b-461b-aa7e-fc43004d9acf.png">
