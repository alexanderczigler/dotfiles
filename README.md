# .env

## Mac OS

```shell

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Setup bash
brew install bash
sudo vim /etc/shells

# Set default shell
sudo vim /etc/shells # Add /opt/homebrew/bin/bash
chsh -s /opt/homebrew/bin/bash

# Setup dotfiles
bash
git clone git@github.com:alexanderczigler/dotfiles.git .github/dotfiles
cp .github/dotfiles/.bash_profile ~/.bash_profile
```

### Applications

- [1Blocker](https://apps.apple.com/se/app/1blocker-ad-blocker/id1365531024?l=en)
- [1Password](https://1password.com/downloads/mac/)
- [1Password for Safari](https://apps.apple.com/se/app/1password-for-safari/id1569813296?l=en&mt=12)
- [DBeaver](https://dbeaver.io/download/)
- [Docker Desktop](https://docs.docker.com/desktop/linux/install/archlinux/)
- [Homebrew](https://brew.sh/)
- [Insomnia](https://insomnia.rest/download)
- [Karabiner Elements](https://karabiner-elements.pqrs.org)
- [NVM](https://github.com/nvm-sh/nvm#installing-and-updating)
- [OpenVPN Connect](https://openvpn.net/client-connect-vpn-for-mac-os/)
- [SensibleSideButtons](https://sensible-side-buttons.archagon.net)
- [Slack](https://apps.apple.com/se/app/slack-for-desktop/id803453959?l=en&mt=12)

### Tools

#### Homebrew

Install [Homebrew](https://brew.sh/) then use it to install the following packages.

```bash
brew tap homebrew/cask-fonts
brew install argocd awscli bash-completion direnv doctl eksctl gnupg2 helm jq kubectl kubectx nvm opendevtools/supreme/supreme pinentry-mac skaffold telnet terraform watch
brew install --cask font-fira-code
brew install --cask visual-studio-code
```

#### UnnaturalScrollWheels

```bash
brew install --cask unnaturalscrollwheels
```

##### Configuration

<img width="512" alt="unnaturalscrollwheels" src="https://user-images.githubusercontent.com/3116043/209099151-0f41150e-084b-461b-aa7e-fc43004d9acf.png">
