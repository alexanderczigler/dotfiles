# dotENV

In this repository I collect scripts and settings for my development environment. I tend to switch between using linux and Mac OS every once in a while so I keep this README as a memorandum to myself. The main goal is that this README should contain complete instructions for setting up my environment exactly how I want it.

Feel free to use any of this if you find it useful but do it at your own risk! :)

## SSH

Configure the ssh client to use and IdentityAgent for all hosts. Put the following lines in `~/.ssh/config`. NOTE: This is for macOS.

```config
Host *
	IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

## Git

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

## Environment

### Shell (bash)

```bash
# Add this to `~/.bash_profile` to ensure that `~/.bashrc` is loaded.
if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
```

**NOTE** If you are on Mac OS run `chsh -s /bin/bash` to change your default shell to bash.

### .bashrc

Clone the repo and load up the bash profile.

```shell
# Clone the .env repo
git clone git@github.com:alexanderczigler/.env.git ~/.env

# Install .bashrc
cp ~/.env/.bashrc ~/.bashrc
source ~/.bashrc
```

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

#### Using a regular mouse in Mac OS

When using a regular mouse I want the scroll wheel to behave like I am used to. So I use [UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) to keep mouse and trackpad scrolling settings opposite of each other. Install and configure it to launch on login.

```bash
brew install --cask unnaturalscrollwheels
```

After that, install [SensibleSideButtons](https://sensible-side-buttons.archagon.net) and also configure it to launch on login.

#### Non-Apple keyboards

Install [Karabiner Elements](https://karabiner-elements.pqrs.org).
