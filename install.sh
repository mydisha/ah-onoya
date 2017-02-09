#!/bin/bash

# ----------------------------------#
# 			AH!-Onoya!				#
# Let Waifu Take Your Server Config #
#									#
#	Coded by : Dias Taufik Rahman	#
#	https://github.com/mydisha		#
# ----------------------------------#

#Warna
white="\033[1;37m"
grey="\033[0;37m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
transparent="\e[0m"

#Direktori
NGINX_DIR="/var/www/html"
NGINX_CONFIG="/etc/nginx/sites-available"

nginx_config() {
	cat > $NGINX_CONFIG/default << EOF
server {
listen 80 default_server;
listen [::]:80 default_server;
root /var/www/html;
index index.php index.html index.htm index.nginx-debian.html;
server_name _;
location / {
try_files $uri $uri/ =404;
}
location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/run/php/php7.1-fpm.sock;
}
location ~ /\.ht {
deny all;
}
}
EOF
}

satu(){
    echo -e "$yellow"
    clear
    echo "Menambahkan repository PHP 7.1"
	sudo add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1
	clear
	echo "Melakukan apt update dan upgrade"
	sudo apt update > /dev/null 2>&1
	sudo apt upgrade -y > /dev/null 2>&1
	clear
	echo "Instalasi Nginx"
	sudo apt install nginx -y > /dev/null 2>&1
	echo "Konfigurasi Nginx"
	nginx_config
	clear
	echo "Instalasi MariaDB"
	sudo apt install mariadb-server mariadb-client -y > /dev/null 2>&1
	echo "Konfigurasi MariaDB"
	mysql_secure_installation
	clear
	echo "Instalasi PHP 7.1 dan Extensi"
	sudo apt install php7.1-fpm php7.1-mysql php7.1-curl php7.1-gd php7.1-intl php-imagick php7.1-imap php7.1-mcrypt php7.1-pspell php7.1-recode php7.1-sqlite3 php7.1-xmlrpc php7.1-xsl php7.1-mbstring php-gettext php7.1-xml -y > /dev/null 2>&1
	echo "<?php phpinfo();" | sudo tee -a $NGINX_DIR/info.php
	clear
	echo "Restart service Nginx dan PHP-FPM"
	sudo service nginx start
	sudo service php7.1-fpm start
	clear
	echo "Instalasi telah selesai!"
	sleep 0.10
}

menu() {

	clear; echo""

	sleep 0.1 && echo -e "$red "

	sleep 0.1 && echo -e " █████╗ ██╗  ██╗██╗       ██████╗ ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗ ██╗  "
	sleep 0.1 && echo -e " ██╔══██╗██║  ██║██║      ██╔═══██╗████╗  ██║██╔═══██╗╚██╗ ██╔╝██╔══██╗██║ "
	sleep 0.1 && echo -e " ███████║███████║██║█████╗██║   ██║██╔██╗ ██║██║   ██║ ╚████╔╝ ███████║██║ "
	sleep 0.1 && echo -e " ██╔══██║██╔══██║╚═╝╚════╝██║   ██║██║╚██╗██║██║   ██║  ╚██╔╝  ██╔══██║╚═╝ "
	sleep 0.1 && echo -e " ██║  ██║██║  ██║██╗      ╚██████╔╝██║ ╚████║╚██████╔╝   ██║   ██║  ██║██╗ "
	sleep 0.1 && echo -e " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝       ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝╚═╝ "
    sleep 0.1 && echo ""
    sleep 0.1 && echo -e "                 ~ LET WAIFU DO SERVER CONFIGURATION ~                     "

	echo ""

    echo -e "$grey"
	sleep 0.01 &&	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"	
	sleep 0.01 &&	echo "1. Install Nginx + PHP 7.1 + MariaDB"
	sleep 0.01 &&	echo "2. Keluar"
	sleep 0.01 &&	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
}


input_user(){
	local pilih
	read -p "Masukkan Pilihan [ 1 - 2] " pilih
	case $pilih in
		1) satu ;;
		2) exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}

trap '' SIGINT SIGQUIT SIGTSTP

while true
do
	menu
	input_user
done
