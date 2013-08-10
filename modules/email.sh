set -e # Quit on error
sh pacaur.sh
echo "#####################"
echo "#   Dependencies    #"
echo "#####################"

echo 'gofrias.com' > /mnt/etc/hostname

patch /mnt/etc/xdg/pacaur/config < ../chroot/etc/xdg/pacaur/config.patch
# This next command is going to take a long time to run...
arch-chroot /mnt pacaur -S postfix squirrelmail mariadb apache openssl --asroot --noconfirm

cp ../bin/* /mnt/root/aur_builds/
arch-chroot /mnt pacman -U ~/aur_builds/courier-authlib-0.65.0-11-x86_64.pkg.tar.xz --noconfirm
arch-chroot /mnt pacman -U ~/aur_builds/courier-maildrop-2.6.0-2-x86_64.pkg.tar.xz --noconfirm
arch-chroot /mnt pacman -U ~/aur_builds/courier-imap-4.13-11-x86_64.pkg.tar.xz --noconfirm

echo "#####################"
echo "#  Virtual Account  #"
echo "#####################"
user_group=vmail
arch-chroot /mnt groupadd -g 5003 $user_group
arch-chroot /mnt useradd -g $user_group -u 5003 -d /home/vmailer -s /bin/false vmailer
arch-chroot /mnt mkdir /home/vmailer
arch-chroot /mnt chown -R vmailer:vmail /home/vmailer
arch-chroot /mnt chmod -R 750 /home/vmailer
echo "vmailer:vmailer" >> /mnt/root/passwords
arch-chroot /mnt chpasswd < /mnt/root/passwords

echo "#####################"
echo "#  Patching files   #"
echo "#####################"
patch /mnt/etc/postfix/main.cf < ../chroot/etc/postfix/main.cf.patch
arch-chroot /mnt postconf -d mailbox_size_limit
arch-chroot /mnt postconf -d message_size_limit

patch /mnt/etc/postfix/aliases < ../chroot/etc/postfix/aliases.patch
arch-chroot /mnt postalias /etc/postfix/aliases

cp ../chroot/etc/postfix/virtual_alias /mnt/etc/postfix/
arch-chroot /mnt postalias /etc/postfix/virtual_alias

cp ../chroot/etc/postfix/mysql_virtual_domains.cf /mnt/etc/postfix/
cp ../chroot/etc/postfix/mysql_virtual_mailboxes.cf /mnt/etc/postfix/
cp ../chroot/etc/postfix/mysql_virtual_forwards.cf /mnt/etc/postfix/

arch-chroot /mnt postfix check
patch /mnt/etc/courier-imap/imapd < ../chroot/etc/courier-imap/imapd.patch
cp /mnt/etc/authlib/authmysqlrc ../chroot/etc/authlib/authmysqlrc

echo "#####################"
echo "# Enabling services #"
echo "#####################"
ln -s '/usr/lib/systemd/system/mysqld.service' '/mnt/etc/systemd/system/multi-user.target.wants/mysqld.service'
ln -s '/usr/lib/systemd/system/postfix.service' '/mnt/etc/systemd/system/multi-user.target.wants/postfix.service'
ln -s '/usr/lib/systemd/system/courier-imapd.service' '/mnt/etc/systemd/system/multi-user.target.wants/courier-imapd.service'
ln -s '/usr/lib/systemd/system/authdaemond.service' '/mnt/etc/systemd/system/multi-user.target.wants/authdaemond.service'

cp email.sql /mnt/root/email.sql
echo "mysql < ~/email.sql && rm ~/email-init" > /mnt/root/email-init
echo "if [ -f ~/email-init ] then 
  sh ~/email-init 
fi" >> /mnt/root/.bashrc

echo "Initial Email server setup has been done!"
echo "Email's mysql database still needs to be configured! Please reboot and run `/root/email-init' as root"
