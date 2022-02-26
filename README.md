# My environments

This repository is where I gather scripts and settings for my development environments. I tend to switch between using linux and Mac OS every few years so I keep this README as a memorandum to myself, reminding me what to install and configure when I setup a new system.

## Setup

### Initial setup

1. Install `git` for your OS
2. Generate a new ssh key: `ssh-keygen -f ~/.ssh/git_rsa`
3. Upload `~/.ssh/git_rsa.pub` to version control servers
4. Edit `~/.ssh/config` and add the following

```config
Host bitbucket.org github.com gitlab.com visualstudio.com
  IdentityFile ~/.ssh/git_rsa
  IdentitiesOnly yes
```

5. Clone this repo `mkdir ~/Source && git clone git@github.com:alexanderczigler/.env.git ~/Source/.env`
6. Generate a new gpg key `gpg --full-generate-key`
7. Upload public gpg key to version control servers
8. Get gpg key id `gpg --list-secret-keys --keyid-format=long`
9. Configure `git` by editing `~/.gitconfig`

```config
[user]
  signingkey = <keyid>
  name = Alexander Czigler
  email = alexander@czigler.eu
[gpg]
  program = gpg
[init]
  defaultBranch = main
[commit]
  gpgsign = true
```

### Linux

1. Install [guake](http://guake-project.org/)
2. Install packages: `apt update && apt install -y awscli curl direnv fonts-firacode otpclient-cli vim wget whois`
3. Install docker: https://docs.docker.com/engine/install/ubuntu/
4. Install eksctl: https://eksctl.io/
5. Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
6. Install nvm: https://github.com/nvm-sh/nvm
7. Install terraform: https://www.terraform.io/cli/install/apt

### Mac OS

#### Terminal

1. Install [iTerm](https://iterm2.com/)
2. Configure the main iTerm profile as a hotkey window
3. Configure iTerm to launch when loggin in (hidden)
4. Fix keybinds in iTerm: [Jumping between words in iTerm](https://coderwall.com/p/h6yfda/use-and-to-jump-forwards-backwards-words-in-iterm-2-on-os-x)

#### Homebrew

Install [Homebrew](https://brew.sh/) then use it to install the following packages.

```bash
brew install awscli direnv doctl eksctl gnupg2 helm kubectl nvm pinentry-mac watch

# FiraCode font
# https://github.com/tonsky/FiraCode/wiki/Installing
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

mkdir -p ~/GitHub
git clone git@github.com:alexanderczigler/.env.git ~/GitHub/.env
source ~/.zshrc && zup # Install the .zshrc
```

#### GnuPG & SSH

1. Import gpg key: `gpg --import git.gpg`
2. Put ssh keys (id_rsa, id_rsa.git) into ~/.ssh
3. Put ssh keys (git_rsa, git_rsa.git) into ~/.ssh

GnuPG needs to be configured to use pinentry-mac

```bash
mkdir -p ~/.gnupg
echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
```

https://stackoverflow.com/questions/41502146/git-gpg-onto-mac-osx-error-gpg-failed-to-sign-the-data/41506446

#### Using a regular mouse in Mac OS

When using a regular mouse I want the scroll wheel to behave like I am used to. So I use [UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) to keep mouse and trackpad scrolling settings opposite of each other. Install and configure it to launch on login.

```bash
brew install --cask unnaturalscrollwheels
```

After that, install [SensibleSideButtons](https://sensible-side-buttons.archagon.net) and also configure it to launch on login.
