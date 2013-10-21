arch-chroot /mnt pacman -S apache mariadb ruby nodejs
arch-chroot /mnt curl -L get.rvm.io | bash -e stable
arch-chroot /mnt rvm install 2.0.0
arch-chroot /mnt rvm use 2.0.0 --default
arch-chroot /mnt rvm rubygems current
arch-chroot /mnt gem install rails --no-ri --no-rdoc
arch-chroot /mnt gem install passenger mysql
arch-chroot /mnt passenger-install-apache2-module
