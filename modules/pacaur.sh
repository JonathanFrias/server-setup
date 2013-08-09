set -e # Quit on error

echo "#####################"
echo "#   Dependencies    #"
echo "#####################"
arch-chroot /mnt pacman -S base-devel --noconfirm

arch-chroot /mnt mkdir ~/aur_builds


arch-chroot /mnt bash -c 'cd ~/aur_builds && wget https://aur.archlinux.org/packages/co/cower/cower.tar.gz && tar xvf ~/aur_builds/cower.tar.gz'
arch-chroot /mnt bash -c 'cd ~/aur_builds/cower && makepkg -si --asroot --noconfirm'

echo "#####################"
echo "#     Pacaur        #"
echo "#####################"
arch-chroot /mnt bash -c 'cd ~/aur_builds/ && wget https://aur.archlinux.org/packages/pa/pacaur/pacaur.tar.gz && tar xvf pacaur.tar.gz'

arch-chroot /mnt bash -c 'cd ~/aur_builds/pacaur && makepkg -si --asroot --noconfirm'
