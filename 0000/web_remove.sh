#!/bin/sh

PHP_VER="php7"

opkg remove nginx --force-remove
opkg remove mysql-server --force-remove
opkg remove $PHP_VER-fpm  --force-remove
opkg remove $PHP_VER-fastcgi --force-remove
opkg remove $PHP_VER-cgi --force-remove
opkg remove $PHP_VER-mod-gd --force-remove
opkg remove $PHP_VER-mod-session --force-remove
opkg remove $PHP_VER-mod-pdo-mysql --force-remove
opkg remove $PHP_VER-mod-pdo --force-remove
opkg remove $PHP_VER-mod-mysqli --force-remove
opkg remove $PHP_VER-mod-mysql --force-remove
opkg remove $PHP_VER-mod-mcrypt --force-remove
opkg remove $PHP_VER-mod-mbstring --force-remove
opkg remove $PHP_VER-mod-xml --force-remove
opkg remove $PHP_VER-mod-ctype --force-remove
opkg remove $PHP_VER-mod-curl --force-remove
opkg remove $PHP_VER-mod-exif --force-remove
opkg remove $PHP_VER-mod-ftp --force-remove
opkg remove $PHP_VER-mod-iconv --force-remove
opkg remove $PHP_VER-mod-json --force-remove
opkg remove $PHP_VER-mod-sockets --force-remove
opkg remove $PHP_VER-mod-sqlite3 --force-remove
opkg remove $PHP_VER-mod-tokenizer --force-remove
opkg remove $PHP_VER-mod-zip --force-remove
opkg remove $PHP_VER-mod-simplexml --force-remove
opkg remove $PHP_VER-mod-dom --force-remove
opkg remove $PHP_VER-mod-xmlwriter --force-remove
opkg remove $PHP_VER-mod-xmlreader --force-remove
opkg remove $PHP_VER-mod-hash --force-remove
opkg remove $PHP_VER-mod-opcache --force-remove
opkg remove $PHP_VER --force-remove
	
rm /usr/bin/www 2>/dev/null
rm /etc/init.d/wwwset 2>/dev/null
rm -R /tmp/weblog 2>/dev/null