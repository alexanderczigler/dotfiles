# linux

## Arch linux (workstation)

### Post-install core

```
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

### Post-install other

```
# Executing scripts from the internet is totally safe!
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
```
