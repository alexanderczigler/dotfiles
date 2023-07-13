# 🧑‍💻 dotfiles

A minimalistic bash profile for developers.

## Installing

### Mac OS

> **Tip:** If you want to make your own adjustments, [fork](https://github.com/alexanderczigler/dotfiles/fork) this repository first.

1. Clone this repository

```bash
git clone https://github.com/alexanderczigler/dotfiles.git ~/.dotfiles
```

2. Copy the .bash_profile to your ~

```bash
cp ~/.dotfiles/.bash_profile ~/.bash_profile
```

#### Installing utilities

##### Install Homebrew

[Homebrew](https://brew.sh/) is a package manager for Mac OS that I recommend you use. With `brew` you can install several useful cli tools ranging from `awscli` to `direnv` and `kubectl`.

```shell
# Install instruction taken from https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Load brew into your current shell.
eval "$(/opt/homebrew/bin/brew shellenv)"
```

##### Setting up the latest bash as your default shell

The `bash` version that comes bundled with Mac OS is very old. Therefore it is a good idea to install the latest `bash`. Setting it as the default shell requires a couple of commands.

```shell
brew install bash
sudo vim /etc/shells

# Set default shell
sudo vim /etc/shells # Add /opt/homebrew/bin/bash
chsh -s /opt/homebrew/bin/bash
```

###### bash completion

```shell
brew install bash-completion
```

##### Common tools

Here is a list of cli tools that I always install on my computers.

```shell
brew install direnv jq nvm opendevtools/supreme/supreme telnet watch yq
```

##### Fira Code

[Fira Code](https://github.com/tonsky/FiraCode) is a free monospaced font with programming ligatures.

```shell
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
```

#### Other

##### SensibleSideButtons

[SensibleSideButtons](https://sensible-side-buttons.archagon.net) will let you use the side buttons on a mouse just like in Linux or Windows.

##### Homebrew

Install [Homebrew](https://brew.sh/) then use it to install the following packages.

```bash
brew install argocd awscli bash-completion direnv doctl eksctl gnupg2 helm jq kubectl kubectx nvm opendevtools/supreme/supreme pinentry-mac skaffold telnet terraform watch

brew install --cask visual-studio-code
```

##### UnnaturalScrollWheels

[UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) lets you configure a _normal_ scroll direction on the wheel of a mouse, while keeping the _natural_ scroll direction on your trackpad. Very smart!

Install UnnaturalScrollWheel with brew or download it from their website.

```bash
brew install --cask unnaturalscrollwheels
```

<img width="512" alt="unnaturalscrollwheels" src="https://user-images.githubusercontent.com/3116043/209099151-0f41150e-084b-461b-aa7e-fc43004d9acf.png">

### Linux

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
