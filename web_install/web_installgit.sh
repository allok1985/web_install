# https://blog.sunxyz.com
# update 1 date 2017.06.12



#############################################################################################
# 用户配置

# 网站安装路径及数据库储存路径. 路径最后不要添加 /
# 脚本会在这个路径下创建 mysql与www 文件夹,确保这个路径下没有这两个文件夹
WEB_PATH="/mnt/sda3"
# 安装文件所在目录
PHPWEB="/mnt/sda3/web_install"

MYSQL_PASSWORD="456789xx"  # 数据库密码
 
# 根据需求选择
# 1 是
# 0 否
ZBLOG=0         # 安装 Z-Blog (博客系统) 
KODEXPLORER=0   # 安装 KODExplorer (芒果云) 
PHPMYADMIN=0    # 安装 phpMyAdmin (管理数据库) 
OWNCLONUD=0     # 安装 ownCloud (私有云) , 单核路由不建议安装，非常卡，会导致整个路由崩溃 

REINSTALL=1     # 是否重新安装 

# 没有特别需求 默认即可
WEB_ROOT_PORT=81    # 网站根wwwroot 端口 
OWNCLONUD_PORT=82   # ownCloud 端口
KODEXPLORER_PORT=83 # KODExplorer 端口
PHPMYADMIN_PORT=84  # phpMyAdmin 端口

# 配置文件下载地址（注意路由管理地址修正）
CONFIG_DOWN_SITE="https://raw.githubusercontent.com/allok1985/web_install/master/web_install"

###############################################################################################
# 重新安装

if [ "$REINSTALL" == "1" ]; then
echo -e "\n重新安装"
mv $WEB_PATH/www $WEB_PATH/www0
mv $WEB_PATH/mysql $WEB_PATH/mysql0
echo -e "\n目录及数据库文件夹重命名"
fi
###############################################################################################
# 这里是系统配置，不要修改

# LEDE只能安装php7 

PHP_VER="php7"

check_port() {
		if [ "$1" -gt "0" ]&&[ "$1" -lt "65535" ]; then
			if netstat -tlpn | grep "\b$1\b" > /dev/null 2>&1; then
				echo -e "\n错误: ${1}端口被占用, 换个端口试试？"
				exit 1
			fi
		else
			echo -e "\n错误: ${2}=\"${1}\" 端口设置不正确" 
			echo "请将端口设置在 0 ~ 65535 之间"
			exit 1
		fi
}

# 安装并验证是否安装成功
install_ipk() {
		if (opkg install $1); then :; else
			echo -e "\n错误: 安装 $1 失败。"
			exit 1
		fi
}

# 检查php 配置是否正确
if [ "$PHP_VER" != "php5" ]&&[ "$PHP_VER" != "php7" ]; then
		echo -e "\n配置错误。 未知的 PHP_VER=\"$PHP_VER\""
		echo "请检查后重试"
		exit 1
fi

# 检查 用户设置 WEB_PATH 是否存在
if [ ! -d "$WEB_PATH" ]; then
	echo -e "\n错误: 网站路径不存在 $WEB_PATH"
	exit 1
fi

check_port $WEB_ROOT_PORT
[ $OWNCLONUD == 1 ]&& check_port $OWNCLONUD_PORT OWNCLONUD_PORT
[ $KODEXPLORER == 1 ]&& check_port $KODEXPLORER_PORT KODEXPLORER_PORT
[ $PHPMYADMIN == 1 ]&& check_port $PHPMYADMIN_PORT PHPMYADMIN_PORT

[ ! -d "/tmp/weblog" ]&& mkdir /tmp/weblog

if [ ! -f "/tmp/weblog/web_install.log" ]; then

	
	echo -e "\n开始安装程序"

opkg install $CONFIG_DOWN_SITE/ipk/libpng_1.2.57-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/shadow-useradd_4.2.1-6_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/shadow-common_4.2.1-6_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/zoneinfo-core_2017b-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/zoneinfo-asia_2017b-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/tar_1.29-3_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/wget_1.18-2_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-gd_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-session_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-pdo_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-pdo-mysql_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-mysqli_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/libmysqlclient_5.1.73-2_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-mcrypt_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/libmcrypt_2.5.8-2_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-mbstring_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-cgi_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-fastcgi_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-cgi_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-xml_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-ctype_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-curl_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-exif_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-ftp_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-iconv_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-json_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-sockets_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-sqlite3_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-tokenizer_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-zip_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-simplexml_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-dom_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-xmlwriter_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-xmlreader_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-hash_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-fpm_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/php7-mod-opcache_7.1.1-1_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/mysql-server_5.1.73-2_x86_64.ipk --force-depends
opkg install $CONFIG_DOWN_SITE/ipk/nginx_1.10.3-2_x86_64.ipk --force-depends

	/etc/init.d/nginx stop
	/etc/init.d/mysqld stop
	/etc/init.d/$PHP_VER-fpm stop
	/etc/init.d/nginx disable
	/etc/init.d/$PHP_VER-fpm disable
	/etc/init.d/mysqld disable
	
	echo "安装完成" > /tmp/weblog/web_install.log
fi

PACKAGE_NAME="$PHP_VER.tar.gz"
if [ ! -f "/tmp/weblog/web_config.log" ]; then

	if [ -d "$WEB_PATH/mysql" ]; then
		echo -e "\n错误: $WEB_PATH/mysql 已存在。"
		echo "请备份后删除再重试，或将其重命名"
		echo -e "\n使用这条命令可以直接删除，确保你已经不需要它了"
		echo "rm -rf $WEB_PATH/mysql"
		exit 1
	fi

	[ ! -d "$WEB_PATH/www" ]&& mkdir $WEB_PATH/www

	if [ ! -f "$WEB_PATH/www/$PACKAGE_NAME" ]; then
		echo -e "\n开始下载 $PACKAGE_NAME"
		if (wget "$CONFIG_DOWN_SITE/$PACKAGE_NAME" --no-check-certificate -P $WEB_PATH/www); then :; else
			echo -e "\n错误: $CONFIG_DOWN_SITE/$PACKAGE_NAME 下载失败。"
			exit 1
		fi
	fi
	
	[ -f "$WEB_PATH/www/$PHP_VER" ] && rm -rf $WEB_PATH/www/$PHP_VER
	
	if (tar -zxvf $WEB_PATH/www/$PACKAGE_NAME -C $WEB_PATH/www); then :; else
		echo -e "\n错误: 解压 $WEB_PATH/www/$PACKAGE_NAME 失败"
		exit 1
	fi
	
	rm -rf /etc/nginx
	rm /etc/$PHP_VER-fpm.conf
	rm /etc/my.cnf
	rm /etc/php.ini
	rm /etc/$PHP_VER-fpm.d/www.conf
	
	mv $WEB_PATH/www/$PHP_VER/nginx /etc
	mv $WEB_PATH/www/$PHP_VER/$PHP_VER-fpm.conf /etc
	mv $WEB_PATH/www/$PHP_VER/www.conf /etc/$PHP_VER-fpm.d
	mv $WEB_PATH/www/$PHP_VER/my.cnf /etc
	mv $WEB_PATH/www/$PHP_VER/php.ini /etc
	mv $WEB_PATH/www/$PHP_VER/www /usr/bin
	
	chmod 0755 -R /etc/nginx
	chmod 0755 -R /etc/$PHP_VER-fpm.d
	chmod 0755 -R $WEB_PATH/www
	chmod 0755 /etc/$PHP_VER-fpm.conf
	chmod 0755 /etc/my.cnf
	chmod 0755 /etc/php.ini
	chmod 0755 /usr/bin/www
	
	useradd www > /dev/null 2>&1

	# mysql 配置路径
	sed  "s#mysqldata#$WEB_PATH/mysql/data/#" -i /etc/my.cnf
	sed  "s#mysqltmp#$WEB_PATH/mysql/tmp/#" -i /etc/my.cnf
	
	# /usr/bin/www 配置
	sed  "s#phpn-fpm#$PHP_VER-fpm#" -i /usr/bin/www

	# wwwroot 配置端口，路径
	sed  "s#wwwport#$WEB_ROOT_PORT#" -i /etc/nginx/vhost/www.conf
	sed  "s#wwwpath#$WEB_PATH/www/wwwroot#" -i /etc/nginx/vhost/www.conf

	# phpmyadmin 配置端口，路径
	sed  "s#wwwport#$PHPMYADMIN_PORT#" -i /etc/nginx/host/phpmyadmin.conf
	sed  "s#wwwpath#$WEB_PATH/www/phpmyadmin#" -i /etc/nginx/host/phpmyadmin.conf
	
	# kodexplorer 配置端口，路径
	sed  "s#wwwport#$KODEXPLORER_PORT#" -i /etc/nginx/host/kodexplorer.conf
	sed  "s#wwwpath#$WEB_PATH/www/kodexplorer#" -i /etc/nginx/host/kodexplorer.conf
	
	# owncloud 配置端口，路径
	sed  "s#wwwport#$OWNCLONUD_PORT#" -i /etc/nginx/host/owncloud.conf
	sed  "s#wwwpath#$WEB_PATH/www/owncloud#" -i /etc/nginx/host/owncloud.conf
	
	mkdir $WEB_PATH/mysql
	mkdir $WEB_PATH/mysql/data
	mkdir $WEB_PATH/mysql/data/owncloud
	mkdir $WEB_PATH/mysql/data/test
	mkdir $WEB_PATH/mysql/data/zblog
	mkdir $WEB_PATH/mysql/tmp
	
	mv $WEB_PATH/www/$PHP_VER/mysql $WEB_PATH/mysql/data
	
	echo -e "\n启动mysql"
	/etc/init.d/mysqld start
	sleep 3s

	if [ ! -n "$(pgrep mysqld)" ]; then
		echo -e "\n错误: mysql启动失败"
		rm -R $WEB_PATH/mysql
		exit 1
	else
		/usr/bin/mysqladmin -u root -p123456 password $MYSQL_PASSWORD
	fi
	
	echo "配置完成" > /tmp/weblog/web_config.log
fi

if [ ! -f "/tmp/weblog/tz.php.log" ]&&[ "$ZBLOG" != "1" ]; then

	[ ! -d "$WEB_PATH/www/wwwroot" ]&& mkdir $WEB_PATH/www/wwwroot

	if [ ! -f "$WEB_PATH/www/wwwroot/tz.php" ]; then
		if (wget "$CONFIG_DOWN_SITE/tz.php" --no-check-certificate -P $WEB_PATH/www/wwwroot); then :; else
			echo -e "\n错误: $CONFIG_DOWN_SITE/tz.php 下载失败。"
		fi
	fi

	echo "tz.php下载完成" > /tmp/weblog/tz.php.log
fi

PACKAGE_NAME="zblog.tar.gz"
if [ ! -f "/tmp/weblog/$PACKAGE_NAME.log" ]&&[ "$ZBLOG" == "1" ]; then

	if [ -d "$WEB_PATH/www/wwwroot" ]; then
		echo -e "\n错误: $WEB_PATH/www/wwwroot 已存在。"
		echo "请备份后删除再重试，或将其重命名"
		echo -e "\n使用这条命令可以直接删除，确保你已经不需要它了"
		echo "rm -rf $WEB_PATH/www/wwwroot"
		exit 1
	fi

	if [ ! -f "$WEB_PATH/www/$PACKAGE_NAME" ]; then
		echo -e "\n开始下载 $PACKAGE_NAME"
		if (wget "$CONFIG_DOWN_SITE/$PACKAGE_NAME" --no-check-certificate -P $WEB_PATH/www); then :; else
			echo -e "\n错误: $CONFIG_DOWN_SITE/$PACKAGE_NAME 下载失败。"
			exit 1
		fi
	fi
	
	[ -f "$WEB_PATH/www/zblog" ]&& rm -rf $WEB_PATH/www/zblog

	mkdir $WEB_PATH/www/wwwroot
	echo -e "\n正在解压 $PACKAGE_NAME"
		
	if (tar -zxvf $WEB_PATH/www/$PACKAGE_NAME  -C $WEB_PATH/www); then :; else
		echo -e "\n错误: $WEB_PATH/www/$PACKAGE_NAME 解压失败"
		rm -rf $WEB_PATH/www/wwwroot
		exit 1 
	fi

	mv $WEB_PATH/www/zblog/* $WEB_PATH/www/wwwroot

	echo "zblog配置完成" > /tmp/weblog/$PACKAGE_NAME.log
fi

PACKAGE_NAME="phpmyadmin.tar.gz"
if [ ! -f "/tmp/weblog/$PACKAGE_NAME.log" ]&&[ "$PHPMYADMIN" == "1" ]; then

	[ -d "$WEB_PATH/www/phpmyadmin" ] && rm -rf $WEB_PATH/www/phpmyadmin
	
	if [ ! -f "$WEB_PATH/www/$PACKAGE_NAME" ]; then
		echo -e "\n开始下载 $PACKAGE_NAME"
		if (wget "$CONFIG_DOWN_SITE/$PACKAGE_NAME" --no-check-certificate -P $WEB_PATH/www); then :; else
			echo -e "\n错误: $CONFIG_DOWN_SITE/$PACKAGE_NAME 下载失败。"
			exit 1
		fi
	fi

	echo -e "\n正在解压 $PACKAGE_NAME"
	if (tar -zxvf $WEB_PATH/www/$PACKAGE_NAME  -C $WEB_PATH/www); then :; else
		echo -e "\n错误: $WEB_PATH/www/$PACKAGE_NAME 解压失败"
		exit 1
	fi
		
	cp /etc/nginx/host/phpmyadmin.conf /etc/nginx/vhost
		
	echo "phpmyadmin配置完成" > /tmp/weblog/$PACKAGE_NAME.log
fi

PACKAGE_NAME="kodexplorer.tar.gz"
if [ ! -f "/tmp/weblog/$PACKAGE_NAME.log" ]&&[ "$KODEXPLORER" == "1" ]; then

	[ -d "$WEB_PATH/www/kodexplorer" ] && rm -rf $WEB_PATH/www/kodexplorer
	
	if [ ! -f "$WEB_PATH/www/$PACKAGE_NAME" ]; then
		echo -e "\n开始下载 $PACKAGE_NAME"
		if (wget "$CONFIG_DOWN_SITE/$PACKAGE_NAME" --no-check-certificate -P $WEB_PATH/www); then :; else
			echo -e "\n$CONFIG_DOWN_SITE/$PACKAGE_NAME 下载失败。"
			exit 1
		fi
	fi
	
	echo -e "\n正在解压 $PACKAGE_NAME"
	if (tar -zxvf $WEB_PATH/www/$PACKAGE_NAME  -C $WEB_PATH/www); then :; else
		echo -e "\n$WEB_PATH/www/$PACKAGE_NAME 解压失败"
		exit 1
	fi
		
	cp /etc/nginx/host/kodexplorer.conf /etc/nginx/vhost
		
	echo "kodexplorer完成" > /tmp/weblog/$PACKAGE_NAME.log
fi

PACKAGE_NAME="owncloud.tar.gz"
if [ ! -f "/tmp/weblog/$PACKAGE_NAME.log" ]&&[ "$OWNCLONUD" == "1" ]; then

	[ -d "$WEB_PATH/www/owncloud" ] && rm -rf $WEB_PATH/www/owncloud
	
	if [ ! -f "$WEB_PATH/www/$PACKAGE_NAME" ]; then
		echo -e "\n开始下载 $PACKAGE_NAME"
		if (wget "$CONFIG_DOWN_SITE/$PACKAGE_NAME" --no-check-certificate -P $WEB_PATH/www); then :; else
			echo -e "\n错误: $CONFIG_DOWN_SITE/$PACKAGE_NAME 下载失败。"
			exit 1
		fi
	fi
	
	echo -e "\n正在解压 $PACKAGE_NAME"
	if (tar -zxvf $WEB_PATH/www/$PACKAGE_NAME  -C $WEB_PATH/www); then :; else
		echo -e "\n错误: $WEB_PATH/www/$PACKAGE_NAME 解压失败"
		exit 1
	fi
		
	cp /etc/nginx/host/owncloud.conf /etc/nginx/vhost
		
	echo "owncloud完成" > /tmp/weblog/$PACKAGE_NAME.log
fi

echo -e "\n启动nginx"
/etc/init.d/nginx start
sleep 2s

if [ ! -n "$(pgrep nginx)" ]; then
	echo -e "\n错误: nginx启动失败"
	exit 1
fi

echo -e "\n启动$PHP_VER-fpm"
/etc/init.d/$PHP_VER-fpm start
sleep 2s

if [ ! -n "$(pgrep $PHP_VER-fpm)" ]; then
	echo -e "\n错误: $PHP_VER-fpm启动失败"
	exit 1
fi

echo "
你可以在终端使用 www 命令来控制网站
www start   启动服务器
www stop    关闭服务器
www restart 重启服务器

上传文件到网站时记得设置所有者为: www 用户组: www
你可以使用 /etc/init.d/wwwset start 来快捷设置

你可以使用phpmyadmin 来管理你的数据库 增与删

数据库用户名：root 密码：$MYSQL_PASSWORD

可用的空数据库
zblog
owncloud
test

网站信息
网站根目录 $WEB_PATH/www/wwwroot
端口 $WEB_ROOT_PORT
" > $WEB_PATH/web.info

chmod 0600 $WEB_PATH/web.info

echo "#!/bin/sh /etc/rc.common
START=69

start() {
	chown -R www:www $WEB_PATH/www
	chmod -R 0750 $WEB_PATH/www
}

" > /etc/init.d/wwwset

chmod 0755 /etc/init.d/wwwset
/etc/init.d/wwwset start

/etc/init.d/wwwset enable
/etc/init.d/nginx enable
/etc/init.d/mysqld enable
/etc/init.d/$PHP_VER-fpm enable

if [ "$KODEXPLORER" == "1" ]; then
	rm $WEB_PATH/www/kodexplorer.tar.gz

	echo "kodexplorer 目录 $WEB_PATH/www/kodexplorer
端口 $KODEXPLORER_PORT
" >> $WEB_PATH/web.info
fi

if [ "$OWNCLONUD" == "1" ]; then
	rm $WEB_PATH/www/owncloud.tar.gz
	
	echo "owncloud 目录 $WEB_PATH/www/owncloud
端口 $OWNCLONUD_PORT
" >> $WEB_PATH/web.info
fi

if [ "$PHPMYADMIN" == "1" ]; then
	rm $WEB_PATH/www/phpmyadmin.tar.gz
	
	echo "phpmyadmin 目录 $WEB_PATH/www/phpmyadmin
端口 $PHPMYADMIN_PORT
" >> $WEB_PATH/web.info
fi

if [ "$ZBLOG" == "1" ]; then
	rm -rf $WEB_PATH/www/zblog
	rm $WEB_PATH/www/zblog.tar.gz
fi

rm  $WEB_PATH/www/$PHP_VER.tar.gz
rm -rf $WEB_PATH/www/$PHP_VER
rm -rf /etc/nginx/host

cat $WEB_PATH/web.info
echo "这些信息你可以从 $WEB_PATH/web.info 中找到"
echo -e "\nWEB环境安装完成"

# 重启 nginx php mysql
/usr/bin/www restart > /dev/null 2>&1 

# 挂载网站配置文件
ln -s /etc/nginx/vhost $WEB_PATH/

###############################################################################################
# 重新安装文件还原
if [ "$REINSTALL" == "1" ]; then
echo -e "\n重新安装文件还原"
rm -rf $WEB_PATH/www
rm -rf $WEB_PATH/mysql
mv $WEB_PATH/www0 $WEB_PATH//www
mv $WEB_PATH//mysql0 $WEB_PATH/mysql
echo -e "\n修复文件权限"
/etc/init.d/wwwset start
echo -e "\n文件权限修复完成"
www restart
echo -e "\n重新安装后重启PHP7"
echo -e "\n安装完成"
fi
###############################################################################################