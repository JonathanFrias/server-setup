arch-chroot /mnt pacman -S apache mariadb
arch-chroot /mnt pacman -S ruby nodejs
arch-chroot /mnt gem install rails --no-ri --no-rdoc
arch-chroot /mnt gem install passenger mysql
arch-chroot /mnt passenger-isntall-apache2-module

