# 🧑‍💻 dotfiles

My shell profile and CLI settings, geared towards backend dev/devops tooling.

The main purpose of this repo is to get up and running as fast as possible each time I install a new system. If you find anything useful in here, feel free to use it!

## ✨ Quick Start

> **NOTE:**
> - If you want to make your own adjustments, [fork](https://github.com/alexanderczigler/dotfiles/fork) this repository first and change the URL in step 1 below.
> - Backup your .zshrc and .gitconfig files before running the steps below, in case you want to revert back to any settings you currently have.

1. Clone this repo
  ```shell
  git clone https://github.com/alexanderczigler/dotfiles.git ~/.dotfiles
  ```
2. Bootstrap .zshrc
  ```shell
  echo ". ~/.dotfiles/.zshrc" > ~/.zshrc
  ```
3. Load .zshrc
  ```shell
  source ~/.zshrc
  ```
4. Configure GIT
  ```bash
  cat <<EOF > ~/.gitconfig
  [include]
    path = ~/.dotfiles/.gitconfig
  EOF
  ```

## 🍏 Mac OS

### 🍺 Homebrew

[Homebrew](https://brew.sh/) is a package manager for Mac OS that I recommend you use. With `brew` you can install several useful cli tools ranging from `awscli` to `direnv` and `kubectl`.

```shell
# Install instruction taken from https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Load brew into your current shell.
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### 💻 Apps

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

### ⚙️ Utilities

#### SensibleSideButtons

[SensibleSideButtons](https://sensible-side-buttons.archagon.net) will let you use the side buttons on a mouse just like in Linux or Windows. Once installed, add it to `Login items` in System Settings.

```shell
brew install --cask sensiblesidebuttons
```

> Once installed, add it to `Login items` in System Settings.

##### UnnaturalScrollWheels

[UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) lets you configure a _normal_ scroll direction on the wheel of a mouse, while keeping the _natural_ scroll direction on your trackpad. I love it!

```shell
brew install --cask unnaturalscrollwheels
```

> Once installed, add it to `Login items` in System Settings.

###### Configuration

![unnaturalscrollwheels](https://github.com/alexanderczigler/dotfiles/assets/3116043/b9b52edc-c7ea-4bcc-82ad-a66676784150)
