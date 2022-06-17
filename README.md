# My environments

In this repository I collect scripts and settings for my development environments. I tend to switch between using linux and Mac OS every few years so I keep this README as a memorandum to myself, reminding me what to install and configure when I setup a new system.

Feel free to use any of this if you want but do it at your own risk :)

## Arch Linux

### Core setup

#### SSH

```shell
# Create a new rsa key to use with git
ssh-keygen -f ~/.ssh/git_rsa

# Configure ssh
cat >~/.ssh/config << EOL
Host bitbucket.org github.com gitlab.com visualstudio.com
  IdentityFile ~/.ssh/git_rsa
  IdentitiesOnly yes
EOL
```

**NOTE:** Remember to `cat ~/.ssh/git_rsa.pub` and upload it to GitHub and other relevant places. Also remove any unused key(s) while you add the new one.

#### Shell

```shell
# Clone the .env repo
git clone git@github.com:alexanderczigler/.env.git ~/.env

# Install .bashrc
cp ~/.env/.bashrc ~/.bashrc
source ~/.bashrc
```

**NOTE:** Whenever you make changes to .bashrc, run `update-bashrc` to refresh it.

#### GPG

```shell
# Generate a new key to use when signing git commits.
gpg --full-generate-key

# Export public key and add it to GitHub and other relevant places.
gpg --output ~/public.gpg --armor --export dev@ilix.se
cat ~/public.gpg
```

#### GIT

```shell
# Get the gpg key id.
gpg --list-secret-keys --keyid-format=long

# Configure git, replace <keyid> with the id from the command above.
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
```

### Tools

```shell
# Install packages
pacman -Sy aws-cli curl direnv docker doctl eksctl evolution gnome-keyring kubectl terraform tilda ttf-fira-code vim wget whois`

# Install other packages from AUR
aur-install 1password
aur-install datagrip
aur-install en_se
aur-install minecraft-launcher
aur-install notion-app
aur-install nvm
aur-install slack-desktop
aur-install visual-studio-code-bin
```

NOTE: I am using tilda instead of yakuake at the moment because of [this issue](https://forum.garudalinux.org/t/w-key-not-working-while-yakuake-active/19259)

### Locale

Add `en_SE.UTF-8 UTF-8` to `/etc/locale.gen` and run `locale-gen` again. Then edit `/etc/locale.conf` to look like this:

```conf
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8
LANG=en_SE.UTF-8
```

### Other

- Install [Docker Desktop](https://docs.docker.com/desktop/linux/install/archlinux/)

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
