# 🧑‍💻 dotfiles

My shell profile and CLI settings, geared towards backend developer/devops tooling.

The main purpose of this repo is to get up and running as fast as possible each time I install a new system. If you find anything useful in here, feel free to use it!

## Quick Start

```shell
# NOTE: Backup your ~/.zshrc before running this.

git clone https://github.com/alexanderczigler/dotfiles.git ~/.dotfiles
echo ". ~/.dotfiles/.zshrc" > ~/.zshrc
source ~/.zshrc
```

> **Tip:** If you want to make your own adjustments, [fork](https://github.com/alexanderczigler/dotfiles/fork) this repository first.

## Mac OS

### Homebrew

[Homebrew](https://brew.sh/) is a package manager for Mac OS that I recommend you use. With `brew` you can install several useful cli tools ranging from `awscli` to `direnv` and `kubectl`.

```shell
# Install instruction taken from https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Load brew into your current shell.
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Apps

```shell
# Applications
brew install --cask firefox orbstack raycast visual-studio-code

# CLI
brew install argocd awscli doctl eksctl helm kubectl kubectx skaffold terraform direnv jq nvm opendevtools/supreme/supreme telnet watch yq
brew install fluxcd/tap/flux
brew install --cask google-cloud-sdk
gcloud components install gke-gcloud-auth-plugin

# Fonts.
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

# Shell
brew install zsh-completions

# Work things
brew install microsoft-outlook microsoft-teams
```

### Utilities

```shell
# Utilities
brew install --cask sensiblesidebuttons unnaturalscrollwheels
```

#### SensibleSideButtons

[SensibleSideButtons](https://sensible-side-buttons.archagon.net) will let you use the side buttons on a mouse just like in Linux or Windows.

##### UnnaturalScrollWheels

[UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) lets you configure a _normal_ scroll direction on the wheel of a mouse, while keeping the _natural_ scroll direction on your trackpad. I love it!

![unnaturalscrollwheels](https://github.com/alexanderczigler/dotfiles/assets/3116043/b9b52edc-c7ea-4bcc-82ad-a66676784150)

## Linux

// TODO

## Configuring git

1. Configure git to load .gitconfig in this repo.

```bash
cat <<EOF >> ~/.gitconfig
[include]
  path = ~/.dotfiles/.gitconfig
EOF
```

2. Create a `~/.gitconfig.local` with your user-specific settings

```bash
cat <<EOF >> ~/.gitconfig.local
[commit]
gpgsign = true

[gpg]
  format = ssh

[gpg "ssh"]
  program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

[user]
  signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOaA1MQ+BwLPLPJSl8GHQ510Odd+/n8Pdd0eSpdSAZwJ
  name = Alexander Czigler
  email = git@ilix.se
EOF
```

In the example above, I am signing my commits with an SSH key, using 1Password as the signing program.

## Updating

There is a built-in function that copies the `.bash_profile` to your `~`. Simply run `dotfiles_update` in bash, or `dotfiles_update pull` if you want to pull the latest version from git.
