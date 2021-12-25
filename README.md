# .env

This is where I gather scripts and settings for my development environments.

## Mac OS

## Fresh install

- Install [iTerm](https://iterm2.com/)
- Install [Homebrew](https://brew.sh/)
- Install [nvm](https://github.com/nvm-sh/nvm)
- Install [SensibleSideButtons](https://sensible-side-buttons.archagon.net)

```bash
brew install awscli direnv doctl gnupg2 kubectl pinentry-mac

# UnnaturalScrollWheels
# https://github.com/ther0n/UnnaturalScrollWheels
brew install --cask unnaturalscrollwheels

# FiraCode font
# https://github.com/tonsky/FiraCode/wiki/Installing
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

mkdir -p ~/GitHub
git clone git@github.com:alexanderczigler/.env.git ~/GitHub/.env
cp ~/GitHub/.env/.zhsrc ~/.zshrc
source ~/.zshrc
```

Then;
 - Import gpg key
 - Put ssh keys (id_rsa, id_rsa.git) into ~/.ssh

### Useful links

- https://coderwall.com/p/h6yfda/use-and-to-jump-forwards-backwards-words-in-iterm-2-on-os-x
- https://stackoverflow.com/questions/41502146/git-gpg-onto-mac-osx-error-gpg-failed-to-sign-the-data/41506446

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
