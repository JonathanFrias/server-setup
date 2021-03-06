arch-chroot /mnt pacman -S apache mariadb nodejs python python2
ln -s '/usr/lib/systemd/system/sshd.service' '/etc/systemd/system/multi-user.target.wants/sshd.service'
export msg="
  # Connect to Internet
  dhcpcd
  curl -L get.rvm.io | bash
  logout # Must logout/login
  rvm install 2.0.0
  rvm 2.0.0 --default
  gem install rails --no-ri --no-rdoc
  gem install passenger mysql
  passenger-install-apache2-module
"
export msg="$msg"
echo $msg
echo "Please reboot and run the following commands as root"
echo "$msg" > /mnt/root/rails
echo "These commands have been saved in root home directory"

