set -e # Stop script upon error
echo "#####################"
echo "#   Dependencies    #"
echo "#####################"
sudo pacman -Syy
sudo pacman -S --noconfirm patch git 

echo "#####################"
echo "#    Partitions     #"
echo "#####################"
#Simulate user keystrokes to the fdisk program
# +6G is the size of the first partition
# +2G is the size of the swap partition
echo "
n
p
1

+6G

n
p
2

+2G
a
1
w
" | fdisk /dev/sda
mkfs.ext4 /dev/sda1
mkswap /dev/sda2

echo "#####################"
echo "#  Mount Device     #"
echo "#####################"
mount /dev/sda1 /mnt

echo "#####################"
echo "#  Install Base     #"
echo "#####################"
pacstrap /mnt base

echo "#####################"
echo "#  Generate Fstab   #"
echo "#####################"
genfstab -p /mnt >> /mnt/etc/fstab

echo "#####################"
echo "#   Boot Manager    #"
echo "#####################"
arch-chroot /mnt pacman -S grub-bios os-prober --noconfirm
arch-chroot /mnt grub-install --recheck /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "#####################"
echo "# Configure Locale  #"
echo "#####################"
patch /mnt/etc/locale.gen < chroot/etc/locale.gen.patch
echo "Arch" > /mnt/etc/hostname
arch-chroot /mnt locale-gen
arch-chroot /mnt loadkeys us #US keyboard
arch-chroot /mnt ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

echo "#####################"
echo "#  Root Account     #"
echo "#####################"
cp passwords /mnt/root/
arch-chroot /mnt chpasswd < /mnt/root/passwords

echo "#####################"
echo "#   User Account    #"
echo "#####################"
arch-chroot /mnt pacman -S sudo --noconfirm
export user=jf
arch-chroot /mnt mkdir /home/$user
arch-chroot /mnt useradd -d /home/$user $user
arch-chroot /mnt chown $user:$user /home/$user
arch-chroot /mnt chmod u+w /etc/sudoers
echo "$user ALL=(ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt chmod u-w /etc/sudoers
echo "$user:$user" >> /mnt/root/passwords
arch-chroot /mnt chpasswd < /mnt/root/passwords

echo "#####################"
echo "#   Extra Packages  #"
echo "#####################"
arch-chroot /mnt pacman -S --noconfirm vim zsh ntp sudo wget curl net-tools bash-completion sudo expac
arch-chroot /mnt pacman -S openssh --noconfirm
# Install network manager
# arch-chroot /mnt pacman -S network-manager-applet

echo "#####################"
echo "#   Extra Configs   #"
echo "#####################"
cp -r /etc/zsh /mnt/etc/
cp ~/.zshrc /mnt/root/
patch /mnt/etc/pacman.conf < chroot/etc/pacman.conf.patch

#Don't use persistent names
ln -s /dev/null /mnt/etc/udev/rules.d/80-net-name-slot.rules
cd modules

echo "Arch linux has been installed!"
