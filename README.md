# .env

When I setup or reinstall a workstation there are a bunch of applications, configuration and tools that need to be in place before I feel like home. The main goal of this repository is to hold complete instructions for setting up my environment exactly how I want it, and to keep my `~/.bashrc` file.

Feel free to use any of this if you find it useful but do it at your own risk! :)

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

##### Mac OS

On Mac OS, install bash via Homebrew and set it as your default shell.

```shell
brew install bash
which -a bash

# Add /opt/homebrew/bin/bash to /etc/shells
sudo vim /etc/shells

chsh -s /opt/homebrew/bin/bash
```

#### UnnaturalScrollWheels

```bash
brew install --cask unnaturalscrollwheels
```

##### Configuration

<img width="512" alt="unnaturalscrollwheels" src="https://user-images.githubusercontent.com/3116043/209099151-0f41150e-084b-461b-aa7e-fc43004d9acf.png">
