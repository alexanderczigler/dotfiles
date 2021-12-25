# .env

This repository is where I gather scripts and settings for my development environments. I tend to switch between using linux and Mac OS every few years so I keep this README as a memorandum to myself, reminding me what to install and configure when I setup a new system.

## Mac OS

### Terminal

1. Install [iTerm](https://iterm2.com/)
2. Configure the main iTerm profile as a hotkey window
3. Configure iTerm to launch when loggin in (hidden)
4. Fix keybinds in iTerm: [Jumping between words in iTerm](https://coderwall.com/p/h6yfda/use-and-to-jump-forwards-backwards-words-in-iterm-2-on-os-x)

### Homebrew

Install [Homebrew](https://brew.sh/)

```bash
brew install awscli direnv doctl gnupg2 kubectl nvm pinentry-mac

# FiraCode font
# https://github.com/tonsky/FiraCode/wiki/Installing
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

mkdir -p ~/GitHub
git clone git@github.com:alexanderczigler/.env.git ~/GitHub/.env
cp ~/GitHub/.env/.zhsrc ~/.zshrc
source ~/.zshrc
```

### GnuPG & SSH

1. Import gpg key
2. Put ssh keys (id_rsa, id_rsa.git) into ~/.ssh

```bash
mkdir -p ~/.gnupg
echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
```

https://stackoverflow.com/questions/41502146/git-gpg-onto-mac-osx-error-gpg-failed-to-sign-the-data/41506446

### Using a regular mouse in Mac OS

When using a regular mouse I want the scroll wheel to behave like I am used to. So I use [UnnaturalScrollWheels](https://github.com/ther0n/UnnaturalScrollWheels) to keep mouse and trackpad scrolling settings opposite of each other. Install and configure it to launch on login.

```bash
brew install --cask unnaturalscrollwheels
```

After that, install [SensibleSideButtons](https://sensible-side-buttons.archagon.net) and also configure it to launch on login.

## Arch linux

### Post-install

Once done with the arch linux installation, setup a normal user, desktop environment etc. 

```bash
# Load swedish keyboard layout
loadkeys sv-latin1

# Setup DNS (replace with relevant IPs)
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

# Setup network (if applicable)
ip address add 5.35.191.60/26 broadcast + dev enp3s0f0
ip link set dev enp3s0f0 up
ip route add default via 5.35.191.3

# Set root password
passwd

# Create user
useradd alexander
passwd alexander

# Setup KDE (with xorg, plasma)
pacman -S extra/xf86-video-intel xorg-server plasma xorg-xdm kde-applications
systemctl enable xdm
echo "startkde" > /home/alexander/.xsession
chmod 700 /home/alexander/.xsession
```

### Software and settings

```bash
# NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install interesting packages
sudo pacman -Sy dnsutils docker guake python-pip

# Setup .bashrc and such
mkdir -p ~/Source/alexander
git clone git@github.com:alexander/linux.git ~/Source/linux
source ~/Source/alexander/linux/.bashrc
bashrc-update

# Install AUR packages (see .aur file for a list)
aur-update-packages

# AWS
pip3 install aws --upgrade --user
curl -o ~/.local/bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x ~/.local/bin/aws-iam-authenticator
```

### AUR

This repo contains a `.aur` file with a list of the aur packages I use. Running aur-update-packages installs/updates all of them in one go. Running aur-install-package <package> installs/updates a package and makes sure it is saved in `.aur`.

## CentOS (server)

### NFS server

```bash
yum update
yum install -y nfs-utils vim
chown -R nfsnobody:nfsnobody /mnt/volume*
chmod -R 755 /mnt/volume*
cd /mnt/volume*
mkdir share

# Edit /etc/exports (change path and IP)
echo "/mnt/volume_bla_bla/share 1.2.3.4(rw,sync,no_subtree_check)" > /etc/exports

systemctl start nfs.service
systemctl enable nfs.service

exportfs -a
```
