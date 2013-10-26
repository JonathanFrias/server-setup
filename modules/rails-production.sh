arch-chroot /mnt pacman -S apache mariadb ruby nodejs
export msg="
  sudo -u $user curl -L get.rvm.io | bash
  exit # Must logout/login
  usermod -aG rvm $user
  rvm install 2.0.0
  rvm use 2.0.0 --default
  rvm rubygems current
  gem install rails --no-ri --no-rdoc
  gem install passenger mysql
  passenger-install-apache2-module
"
export msg="$msg"
echo $msg
echo "Please reboot and run the following commands as $user"
echo "$msg" > /mnt/home/$user/rails
echo "These commands have been saved in $user's home directory"
