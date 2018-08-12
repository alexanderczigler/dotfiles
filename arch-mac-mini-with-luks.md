# Installing arch linux on mac mini late 2014

Minimal instructions for installing arch linux on a Mac Mini late 2014 model. With LUKS.

```bash
loadkeys sv-latin1

echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf

ip address add 5.35.191.60/26 broadcast + dev enp3s0f0
ip link set dev enp3s0f0 up
route add default gw 5.35.191.3

fdisk /dev/sda
  sda1 EFI 500 MB
  sda3 Linux (remainder of disk)

mkfs.vfat -F32 /dev/sda1

cryptsetup -c aes-xts-plain64 -y --use-random luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 luks

pvcreate /dev/mapper/luks
vgcreate vg0 /dev/mapper/luks
lvcreate -l +100%FREE vg0 --name root

mkfs.ext4 /dev/mapper/vg0-root
mount /dev/mapper/vg0-root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base base-devel vim git efibootmgr dialog wpa_supplicant curl

genfstab -pU /mnt >> /mnt/etc/fstab
echo "tmpfs	/tmp	tmpfs	defaults,noatime,mode=1777	0	0" >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash

rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc --utc

echo MYHOSTNAME > /etc/hostname

echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo LANGUAGE=en_US >> /etc/locale.conf
echo LC_ALL=C >> /etc/locale.conf

bootctl --path=/boot install

vim /etc/mkinitcpio.conf
  Add 'ext4' to MODULES
  Add 'encrypt' and 'lvm2' to HOOKS before filesystems

mkinitcpio -p linux

vim /boot/loader/loader.conf
  default arch
  timeout 3
  editor no

vim /boot/loader/entries/arch.conf
  title   Arch Linux
  linux   /vmlinuz-linux
  initrd  /initramfs-linux.img
  options cryptdevice=/dev/sda3:vgcrypt:allow-discards root=/dev/mapper/vgcrypt-root rw

exit
umount -R /mnt
reboot
```
