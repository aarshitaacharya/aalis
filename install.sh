#!/bin/sh

# Format the target disk into two partitions: SWAP & ROOT
(echo o; echo n; echo p; echo 1; echo ""; echo +$(grep MemTotal /proc/meminfo | grep -o '[[:digit:]]*')K; echo t; echo 82; echo n; echo p; echo 2; echo ""; echo ""; echo w) | fdisk ${1}

# Initialize the ROOT filesystem and configure the SWAP partition
mkfs.ext4 -F ${1}2
mount ${1}2 /mnt
mkswap ${1}1
swapon ${1}1

# Enable parallel downloads (upto 5 connections at a time)
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Install base system along with some utilities
pacstrap -K /mnt base linux grub systemd vi

# Generate a filesystem table
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the installed system and configure settings
arch-chroot /mnt <<EOF
ln -sf /usr/share/zoneinfo/${2} /etc/localtime
hwclock --systohc
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo ${3} > /etc/hostname
mkinitcpio -P
echo "root:${4}" | chpasswd
grub-install --target=i386-pc ${1}
grub-mkconfig -o /boot/grub/grub.cfg
echo -en "[Match]\nName=enp*\n[Network]\nDHCP=yes" > /etc/systemd/network/20-wired.network
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
EOF
ln -sf ../run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf


# Unmount the drive
umount -R /mnt
