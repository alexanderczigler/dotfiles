# linux

## Arch linux (workstation)

### Post-install

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
useradd ilix
passwd ilix

# Setup KDE (with xorg, plasma)
pacman -S extra/xf86-video-intel xorg-server plasma xorg-xdm kde-applications
systemctl enable xdm
echo "startkde" > /home/ilix/.xsession
chmod 700 /home/ilix/.xsession
```

### Software and settings

```bash
# Executing scripts from the internet is totally safe!
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Install interesting packages
sudo pacman -Sy dnsutils docker guake

# Setup .bashrc and such
mkdir -p ~/Source/ilix
git clone git@github.com:ilix/kubernetes.git ~/Source/ilix/linux
cd ~/Source/ilix/linux
sh put.sh

# Install AUR packages
install-aur-package visual-studio-code-bin
install-aur-package openh264
install-aur-package freerdp-git
install-aur-package remmina-git
install-aur-package remmina-plugin-rdesktop
```

### AUR

- chromium-widevine
- kubectl-bin
- minecraft-launcher
- openttd-git
- slack-desktop
- syncthing-git
- visual-studio-code-bin
- kubernetes-helm-bin

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
