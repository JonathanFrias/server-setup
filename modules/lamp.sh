echo "#####################"
echo "#   Dependencies    #"
echo "#####################"

#LAMP STACk
pacman -S apache  php php-apache mariadb php-pear
pear list-all
pear install pear/MDB2_Driver_mysqli
pear install pear/MDB2#mysqli 
pear install pear/mysqli
pear list-all | grep mysqli

#apache configurations

#httpd files to configure
#vim /etc/httpd/conf/extra/httpd-userdir.conf                                  
#vim /etc/httpd/conf/httpd.conf                                                
#vim /etc/httpd/conf/httpd.conf
#vim /etc/php/php.ini
