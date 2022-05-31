# My environments

In this repository I collect scripts and settings for my development environments. I tend to switch between using linux and Mac OS every few years so I keep this README as a memorandum to myself, reminding me what to install and configure when I setup a new system.

Feel free to use any of this if you want but do it at your own risk :)

## Setup

### Core setup (git, pgp, ssh)

```shell
# Clone the .env repo
git clone git@github.com:alexanderczigler/.env.git ~/.env

# Install .bashrc
cp ~/.env/.bashrc ~/.bashrc
source ~/.bashrc

# Setup nvm
aur-install nvm

# Configure git
ssh-keygen -f ~/.ssh/git_rsa
~/.ssh/git_rsa.pub # Upload the public key to GitHub etc.

# Configure ssh
cat >~/.ssh/config << EOL
Host bitbucket.org github.com gitlab.com visualstudio.com
  IdentityFile ~/.ssh/git_rsa
  IdentitiesOnly yes
EOL

# Configure pgp
gpg --full-generate-key
gpg --list-secret-keys --keyid-format=long # Copy the key id

# Configure git, replace <keyid> with the id you copied above
cat >~/.gitconfig << EOL
[user]
  signingkey = <keyid>
  name = Alexander Czigler
  email = dev@ilix.se
[init]
  defaultBranch = main
[commit]
  gpgsign = true
EOL

# Export public key to github etc.
gpg --output ~/public.pgp --armor --export dev@ilix.se
```

### Tools

```shell
# Install packages
pacman -Sy aws-cli curl direnv docker doctl eksctl evolution gnome-keyring kubectl terraform tilda ttf-fira-code vim wget whois`

# Install other packages from AUR
aur-install minecraft-launcher
aur-install slack-desktop
aur-install visual-studio-code-bin
```

NOTE: I am using tilda instead of yakuake at the moment because of [this issue](https://forum.garudalinux.org/t/w-key-not-working-while-yakuake-active/19259)

### Mac OS

Create `~/.bash_profile` and add the following:

```
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
```

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
