# Installation Script

This script automates the installation process of a Linux system on a target disk. It performs the following steps:

1. Formats the target disk into two partitions: SWAP & ROOT.
2. Initializes the ROOT filesystem and configures the SWAP partition.
3. Enables parallel downloads (up to 5 connections at a time) in `pacman.conf`.
4. Installs the base system along with some utilities using `pacstrap`.
5. Generates a filesystem table.
6. Chroots into the installed system and configures settings such as timezone, locale, hostname, and password.
7. Installs and configures GRUB bootloader.
8. Sets up networking with DHCP.
9. Unmounts the drive.

## Usage
Advisable to pass arguments within quotes.

```bash
./install.sh [DRIVE] [TIMEZONE] [HOSTNAME] [PASSWORD]
```

## Arguments:
1. DRIVE: The drive to be installed on. (e.g. /dev/sda)
2. TIMEZONE: The timezone to be set. (e.g. Asia/Kolkata)
3. HOSTNAME: The hostname of the system.
4. PASSWORD: The root password.

## Example
```bash
./install.sh "/dev/sda" "Asia/Kolkata" "myhostname" "mypassword"
