# linux

This is where I keep scripts and profile related things for my linux installations. My desktop and laptop run arch linux so that is the main focus. If you happen to find anything here useful, please feel free to take it!

## Arch linux (workstation)

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
# Executing scripts from the internet is totally safe!
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install interesting packages
sudo pacman -Sy dnsutils docker guake

# Setup .bashrc and such
mkdir -p ~/Source/alexander
git clone git@github.com:alexander/linux.git ~/Source/linux
source ~/Source/alexander/linux/.bashrc
bashrc-update

# Install AUR packages (see .aur file for a list)
aur-update-packages
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
