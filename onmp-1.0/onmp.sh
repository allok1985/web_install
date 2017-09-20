#!/bin/sh
## 一个梨的博客 https://www.mliys.top

URL_ONMP="https://code.aliyun.com/aa1319996958/amoli/raw/master/onmp-1.0"

MD5_CONFIG="0ae7bd59c911b5fbd0fe99f0bb5065b4"
MD5_TYPECHO="3782105dfd80142135f8d06f49727d9f"
MD5_KODEXPLORER="ac372b6a4c113a9da1846714dec0d73c"

ONMP="1.1"

onmp_install() {

	opkg update

	install_ipk "shadow-useradd" "1" || return 1

	install_ipk "zoneinfo-core" "1" || return 1

	install_ipk "zoneinfo-asia" "1" || return 1

	install_ipk "tar" "1" || return 1

	install_ipk "wget" "1" || return 1

	install_ipk "$PHP_VER" "1" || return 1

	install_ipk "$PHP_VER-mod-pdo" "1" || return 1

	install_ipk "$PHP_VER-mod-pdo-mysql" "1" || return 1

	install_ipk "$PHP_VER-mod-mysqli" "1" || return 1

	install_ipk "$PHP_VER-fastcgi" "1" || return 1

	install_ipk "$PHP_VER-cgi" "1" || return 1

	install_ipk "$PHP_VER-fpm" "1" || return 1

	install_ipk "mysql-server" "1" || return 1

	install_ipk "$PHP_VER-mod-curl" "1" || return 1

	install_ipk "$PHP_VER-mod-mbstring" "1" || return 1

	if [ "$PHP_VER" == "php5" ]; then
	    install_ipk "$PHP_VER-mod-mysql" "0" || return 1
	fi

	install_ipk "$PHP_VER-mod-gd" "0" || return 1

	install_ipk "$PHP_VER-mod-session" "0" || return 1

	install_ipk "$PHP_VER-mod-mcrypt" "0" || return 1

	install_ipk "$PHP_VER-mod-xml" "0" || return 1

	install_ipk "$PHP_VER-mod-ctype" "0" || return 1

	install_ipk "$PHP_VER-mod-exif" "0" || return 1

	install_ipk "$PHP_VER-mod-ftp" "0" || return 1

	install_ipk "$PHP_VER-mod-iconv" "0" || return 1

	install_ipk "$PHP_VER-mod-json" "0" || return 1

	install_ipk "$PHP_VER-mod-sockets" "0" || return 1

	install_ipk "$PHP_VER-mod-sqlite3" "0" || return 1

	install_ipk "$PHP_VER-mod-tokenizer" "0" || return 1

	install_ipk "$PHP_VER-mod-zip" "0" || return 1

	install_ipk "$PHP_VER-mod-simplexml" "0" || return 1

	install_ipk "$PHP_VER-mod-dom" "0" || return 1

	install_ipk "$PHP_VER-mod-xmlwriter" "0" || return 1

	install_ipk "$PHP_VER-mod-xmlreader" "0" || return 1

	install_ipk "$PHP_VER-mod-hash" "0" || return 1

	install_ipk "$PHP_VER-mod-opcache" "0" || return 1
	
	install_ipk "nginx" "1" || return 1
 
	/usr/sbin/nginx -s stop > /dev/null 2>&1
	/etc/init.d/mysqld stop > /dev/null 2>&1
	/etc/init.d/$PHP_VER-fpm stop > /dev/null 2>&1
	/etc/init.d/nginx disable > /dev/null 2>&1
	/etc/init.d/$PHP_VER-fpm disable > /dev/null 2>&1
	/etc/init.d/mysqld disable > /dev/null 2>&1

	dir_check || return 1

	if file_download "${URL_ONMP}/onmp_conf.tar.gz" "${MD5_CONFIG}"; then

		if ! tar -zxf "${ONMP_PATH}/onmp_dl/onmp_conf.tar.gz" -C "${ONMP_PATH}/onmp_tmp"; then
			echo
			echo -e "\e[31m致命错误: 解压 onmp_conf.tar.gz 失败\e[0m"
			rm -rf ${ONMP_PATH}/onmp
			rm -rf ${ONMP_PATH}/onmp_tmp
			echo
			read -p "按回车键继续" TMP_VAR
			return 1
		fi
	else
			rm -rf ${ONMP_PATH}/onmp
			rm -rf ${ONMP_PATH}/onmp_tmp
			return 1
	fi

	mkdir -p ${ONMP_PATH}/onmp/www/default
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/index.php" "${ONMP_PATH}/onmp/www/default"

	mkdir ${ONMP_PATH}/onmp/mysqldb
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/mysql" "${ONMP_PATH}/onmp/mysqldb"

	rm -rf /etc/nginx
	rm -rf /etc/${PHP_VER}-fpm.d
	rm /etc/${PHP_VER}-fpm.conf
	rm /etc/my.cnf
	rm /etc/php.ini

	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/phpmyadmin" "${ONMP_PATH}/onmp/www"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/nginx" "/etc"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/${PHP_VER}-fpm.conf" "/etc"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/${PHP_VER}-fpm.d" "/etc"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/my.cnf" "/etc"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/php.ini" "/etc"
	mv "${ONMP_PATH}/onmp_tmp/onmp_conf/onmp" "/usr/bin"

	chmod 0755 -R /etc/nginx
	chmod 0755 -R /etc/${PHP_VER}-fpm.d
	chmod 0755 /etc/${PHP_VER}-fpm.conf
	chmod 0755 /etc/my.cnf
	chmod 0755 /etc/php.ini
	chmod 0755 /usr/bin/onmp

	useradd www > /dev/null 2>&1
	useradd mysql > /dev/null 2>&1

	sed  "s|path_sock|/var/run/${PHP_VER}-fpm.sock|" -i /etc/nginx/fastcgi_pass

	sed  "s|ONMP_PATH|${ONMP_PATH}|" -i /usr/bin/onmp
	sed  "s|php-fpm|${PHP_VER}-fpm|" -i /usr/bin/onmp
	sed  "s|#\ onmp|#\ onmp-${ONMP}|" -i /usr/bin/onmp
	sed  "s|#\ php|#\ ${PHP_VER}|" -i /usr/bin/onmp

	# 配置数据库路径
	sed  "s|database_path|${ONMP_PATH}/onmp/mysqldb/|" -i /etc/my.cnf

	# default主机 nginx配置
	sed  "s|server_port|${DEFAULT_PORT}|" -i /etc/nginx/sites-available/default
	sed  "s|server_path|${ONMP_PATH}/onmp/www/default|" -i /etc/nginx/sites-available/default
	ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

	# phpmyadmin nginx配置
	cp /etc/nginx/sites-available/template /etc/nginx/sites-available/phpmyadmin
	sed  "s|server_port|${PHPMYADMIN_PORT}|" -i /etc/nginx/sites-available/phpmyadmin
	sed  "s|server_path|${ONMP_PATH}/onmp/www/phpmyadmin|" -i /etc/nginx/sites-available/phpmyadmin
	ln -s /etc/nginx/sites-available/phpmyadmin /etc/nginx/sites-enabled/phpmyadmin

	if [ "$TYPECHO" == "1" ]; then

		if file_download "${URL_ONMP}/typecho.tar.gz" "${MD5_TYPECHO}"; then

			if tar -zxf "${ONMP_PATH}/onmp_dl/typecho.tar.gz" -C "${ONMP_PATH}/onmp_tmp"; then
				rm -rf ${ONMP_PATH}/onmp/www/default
				rm  /etc/nginx/sites-available/default
				rm  /etc/nginx/sites-enabled/default
			
				mkdir ${ONMP_PATH}/onmp/mysqldb/typecho
				mv ${ONMP_PATH}/onmp_tmp/typecho ${ONMP_PATH}/onmp/www
				mv ${ONMP_PATH}/onmp_tmp/typecho_nginx/typecho /etc/nginx/sites-available/typecho
				sed  "s|server_port|${DEFAULT_PORT}|" -i /etc/nginx/sites-available/typecho
				sed  "s|server_path|${ONMP_PATH}/onmp/www/typecho|" -i /etc/nginx/sites-available/typecho
				ln -s /etc/nginx/sites-available/typecho /etc/nginx/sites-enabled/typecho
			else
				echo
				echo -e "\e[35m警告: typecho.tar.gz 解压失败。\e[0m"
				echo -e "\e[31m typecho将不会被安装\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
			fi
		else
			echo
			echo -e "\e[31mtypecho将不会被安装\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
		fi
	fi

	if [ "$KODEXPLORER" == "1" ]; then

		if file_download "${URL_ONMP}/kodexplorer.tar.gz" "${MD5_KODEXPLORER}"; then

		if tar -zxf "${ONMP_PATH}/onmp_dl/kodexplorer.tar.gz" -C "${ONMP_PATH}/onmp_tmp"; then
				mv ${ONMP_PATH}/onmp_tmp/kodexplorer ${ONMP_PATH}/onmp/www
				cp /etc/nginx/sites-available/template /etc/nginx/sites-available/kodexplorer
				sed  "s|server_port|${KODEXPLORER_PORT}|" -i /etc/nginx/sites-available/kodexplorer
				sed  "s|server_path|${ONMP_PATH}/onmp/www/kodexplorer|" -i /etc/nginx/sites-available/kodexplorer
				ln -s /etc/nginx/sites-available/kodexplorer /etc/nginx/sites-enabled/kodexplorer		
			else
				echo
				echo -e "\e[31m错误: 解压 kodexplorer.tar.gz 失败。\e[0m"
				echo -e "\e[31m kodexplorer将不会被安装\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
			fi
		else
			echo
			echo -e "\e[31mkodexplorer将不会被安装\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
		fi	
	fi

	/usr/bin/onmp set

	echo
	echo -e "\e[32m启动mysql\e[0m"
	/etc/init.d/mysqld start
	sleep 3s

	if ! ps | grep -v 'grep mysqld'| grep 'mysqld' > /dev/null 2>&1; then
		echo
		echo -e "\e[31m致命错误: mysql启动失败\e[0m"
		rm -rf ${ONMP_PATH}/onmp_tmp
		echo
		read -p "按回车键继续" TMP_VAR
		return 1
	fi

	echo
	echo -e "\e[32m启动nginx\e[0m"
	/usr/sbin/nginx
	sleep 2s

	if ! ps | grep -v 'grep nginx'| grep 'nginx' > /dev/null 2>&1; then
		echo
		echo -e "\e[31m致命错误: nginx启动失败\e[0m"
		rm -rf ${ONMP_PATH}/onmp_tmp
		echo
		read -p "按回车键继续" TMP_VAR
		return 1
	fi

	echo
	echo -e "\e[32m启动php\e[0m"
	/etc/init.d/$PHP_VER-fpm start
	sleep 2s

	if ! ps | grep -v "grep ${PHP_VER}-fpm" | grep "${PHP_VER}-fpm" > /dev/null 2>&1; then
		echo
		echo -e "\e[31m致命错误: php启动失败\e[0m"
		rm -rf ${ONMP_PATH}/onmp_tmp
		echo
		read -p "按回车键继续" TMP_VAR
		return 1
	fi

	/etc/init.d/nginx enable
	/etc/init.d/mysqld enable
	/etc/init.d/$PHP_VER-fpm enable

	/usr/bin/onmp restart > /dev/null 2>&1

	rm -rf ${ONMP_PATH}/onmp_tmp
	rm -rf ${ONMP_PATH}/onmp_dl

	echo -e "\n\n"
	echo -e "\t\e[32m onmp安装完成 \e[0m"
	echo
	read -p "按回车键继续" TMP_VAR

	return 0

}

onmp_set() {

	if [ `df / | grep -v 'Filesystem' | awk '{print $4}'` -lt "10000" ]; then
		echo -e "\e[35m警告: 系统根目录可用空间少于10MB，可能会安装失败\e[0m"
		echo
		read -p "按回车键继续" TMP_VAR
	fi

	while :
	do
		echo
		echo -e "\e[36m输入onmp数据储存路径(如: /mnt/sda1) \e[0m"
		echo -e "\e[36m脚本会在此目录下生成一个onmp目录，用来储存网站程序，以及mysql数据库文件\e[0m"
		read -p ":" ONMP_PATH
		
		# 检测是否为目录
		if [ ! -d "${ONMP_PATH}" ]; then
			echo -e "\e[31m错误: ${ONMP_PATH} 路径错误或目录不存在，请重新输入。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			continue
		fi

		# 检查用户输入路径，最后是否带有 "/" 如果有则去除
		if [ `echo $ONMP_PATH | awk '{print substr($0,length($0)-0,length($0))}'` == "/" ]; then
			ONMP_PATH="${ONMP_PATH%?}"
		fi

		# 检查文件系统，文件系统只能是 ext2~4，rootfs
		TMP_VAR=`df -T ${ONMP_PATH} | grep -v 'Filesystem' | awk '{print $2}'`
		if ! [ "$TMP_VAR" == "ext2" -o "$TMP_VAR" == "ext3" -o "$TMP_VAR" == "ext4" -o "$TMP_VAR" == "rootfs" ]; then
			echo -e "\e[31m错误: 请使用 ext2，ext3，ext4 文件系统\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			continue
		fi

		# 路径可用空间不得少于100000KB
		if [ `df ${ONMP_PATH} | grep -v 'Filesystem' | awk '{print $4}'` -lt "100000" ]; then
			echo -e "\e[31m错误: 可用空间少于100MB，需要更大的储存空间\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			continue
		fi

		break
	done

	while :
	do
		echo
		echo -e "\e[36m请选择PHP版本. (1|2)(默认：1)\e[0m"
		echo -e "\t\e[32m1\e[0m. PHP5"
		echo -e "\t\e[32m2\e[0m. PHP7"
		read -p ":" PHP_VER

		[ -z "$PHP_VER" ] && PHP_VER="1"

		case "$PHP_VER" in
			1)
				PHP_VER="php5"
				break
			;;
			2)
				PHP_VER="php7"
				break
			;;
			*)
				echo -e "\e[31m输入错误，请重新输入。\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
				continue
			;;
		esac
	done

	while :
	do
		echo
		echo -e "\e[36m是否安装typeho (博客) (1|2) (默认：2)\e[0m"
		echo -e "\t\e[32m1\e[0m. 是"
		echo -e "\t\e[32m2\e[0m. 否"
		read -p ":" TYPECHO

		[ -z "$TYPECHO" ] && TYPECHO="2"
		
		case "$TYPECHO" in
			1|2)
				break
			;;
			*)
				echo -e "\e[31m输入错误，请重新输入。\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
				continue
			;;
		esac
	done

	while :
	do
		echo
		echo -e "\e[36m是否安装kodexplorer (私有云) (1|2) (默认：2)\e[0m"
		echo -e "\t\e[32m1\e[0m. 是"
		echo -e "\t\e[32m2\e[0m. 否"
		read -p ":" KODEXPLORER
		
		[ -z "$KODEXPLORER" ] && KODEXPLORER="2"

		case "$KODEXPLORER" in
			1|2)
				break
			;;
			*)
				echo -e "\e[31m输入错误，请重新输入。\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
				continue
			;;
		esac
	done

	if [ "$TYPECHO" == "1" ]; then
		while :
		do
			echo
			echo -e "\e[36m输入typecho的端口号。(默认：81)\e[0m"
			read -p ":" DEFAULT_PORT
			
			[ -z "$DEFAULT_PORT" ] && DEFAULT_PORT="81"

			if port_check $DEFAULT_PORT; then
				break
			fi
		done
	else
		while :
		do
			echo
			echo -e "\e[36m输入默认网站端口号。(默认：81)\e[0m"
			read -p ":" DEFAULT_PORT
			
			[ -z "$DEFAULT_PORT" ] && DEFAULT_PORT="81"

			if port_check $DEFAULT_PORT; then
				break
			fi
		done
	fi

	if [ "$KODEXPLORER" == "1" ]; then
		while :
		do
			echo
			echo -e "\e[36m输入kodexplorer的端口号。(默认：82)\e[0m"
			read -p ":" KODEXPLORER_PORT

			[ -z "$KODEXPLORER_PORT" ] && KODEXPLORER_PORT="82"

			if [ "$DEFAULT_PORT" == "$KODEXPLORER_PORT" ]; then
				echo
				echo -e "\e[31m错误: ${KODEXPLORER_PORT}端口被占用。\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
				continue
			fi

			if port_check $KODEXPLORER_PORT; then
				break
			fi
		done
	fi

	while :
	do
		echo
		echo -e "\e[36m输入phpmyadmin的端口号。(默认：83)\e[0m"
		read -p ":" PHPMYADMIN_PORT

		[ -z "$PHPMYADMIN_PORT" ] && PHPMYADMIN_PORT="83"

		if [ "$PHPMYADMIN_PORT" == "$KODEXPLORER_PORT" -o "$PHPMYADMIN_PORT" == "$DEFAULT_PORT" ]; then
			echo
			echo -e "\e[31m错误: ${PHPMYADMIN_PORT}端口被占用。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			continue
		fi

		if port_check $PHPMYADMIN_PORT; then
			break
		fi
	done

	return 0

}

# file_download <下载地址> <文件md5值>
file_download() {

	NUMBER="1"

	while :
	do
		if [ -f $ONMP_PATH/onmp_dl/${1##*/} ]; then
			if [ `md5sum $ONMP_PATH/onmp_dl/${1##*/} | awk '{print $1}'` != "$2" ]; then
				echo -e "\e[35m错误: ${1##*/} md5值不符\e[0m"
				rm $ONMP_PATH/onmp_dl/${1##*/}
			else
				return 0
			fi
		fi

		if [ "$NUMBER" -le "3" ]; then
			if ! wget ${1} --no-check-certificate -P $ONMP_PATH/onmp_dl; then
				echo -e "\e[35m错误: ${1##*/} 下载失败.重试(${NUMBER})\e[0m"
			fi
		else
			echo
			echo -e "\e[31m致命错误: ${1##*/} 下载失败。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			return 1
		fi

		NUMBER=`expr $NUMBER + 1`
	done

}

# port_check <端口号>
port_check() {

	if [ "$1" -gt "0" -a "$1" -lt "65535" ]; then
		if netstat -tlpn | grep -w "$1" > /dev/null 2>&1; then
			echo
			echo -e "\e[35m错误: ${1}端口被占用。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			return 1
		fi
	else
			echo
			echo -e "\e[35m错误: \"${1}\" 端口号不正确\e[0m" 
			echo -e "\e\[32m请将端口设置在 1 ~ 65534 之间\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			return 1
	fi

	return 0
}

dir_check() {

	if [ -e "${ONMP_PATH}/onmp" ]; then
		while :
		do
			echo
			echo -e "\e[35m警告：${ONMP_PATH}/onmp文件或文件夹已存在。\e[0m"
			echo -e "\e[36m提示：你可以手动将它重命名,然后重试。(1|2|3)(默认：1)\e[0m"
			echo -e "\t\e[32m1\e[0m. 重试"
			echo -e "\t\e[32m2\e[0m. 退出 onmp安装"
			echo -e "\t\e[32m3\e[0m. 删除 ${ONMP_PATH}/onmp"
			read -p ":" TMP_VAR

			[ -z "$TMP_VAR" ] && TMP_VAR="1"

			case "$TMP_VAR" in
				1)
					[ -e "${ONMP_PATH}/onmp" ] && continue
					break
				;;
				2)
					return 1
				;;
				3)
					rm -rf ${ONMP_PATH}/onmp
					break
				;;
				*)
					echo -e "\e[31m输入错误，请重新输入。\e[0m"
					echo
					read -p "按回车键继续" TMP_VAR
					continue
				;;
			esac
		done
	fi

	if [ -e "${ONMP_PATH}/onmp_tmp" ]; then
		rm -rf ${ONMP_PATH}/onmp_tmp
		mkdir ${ONMP_PATH}/onmp_tmp
	else
		mkdir ${ONMP_PATH}/onmp_tmp
	fi

	if [ ! -d "${ONMP_PATH}/onmp_dl" ]; then
		rm -rf ${ONMP_PATH}/onmp_dl
		mkdir ${ONMP_PATH}/onmp_dl
	fi

	return 0

}

# install_ipk <包名> <安装失败可否跳过"0"可以 "1"不可以>
install_ipk() {

	NUMBER="1"

	while :
	do
		if opkg install ${1}; then
			return 0
		else
			if [ "$NUMBER" -le "3" ]; then
				echo
				echo -e "\e[35m错误: 安装 $1 失败, 重试(${NUMBER})。\e[0m"
				NUMBER=`expr $NUMBER + 1`
				continue
			fi

			echo
			echo -e "\e[31m致命错误: 安装 $1 失败。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR

			if [ "$2" == "0" ]; then
				while :
				do
					echo
					echo -e "\e[36m你可以跳过安装 ${1}，但不推荐你这么做 (1|2)(默认：2)\e[0m"
					echo -e "\t\e[32m1\e[0m. 跳过安装 ${1}"
					echo -e "\t\e[32m2\e[0m. 退出 onmp安装"
					read -p ":" TMP_VAR
					
					[ -z "$TMP_VAR" ] && TMP_VAR="2"

					case "$TMP_VAR" in
						1)
							return 0
						;;
						2)
							return 1
						;;
						*)
							echo
							echo -e "\e[31m输入错误，请重新输入。\e[0m"
							echo
							read -p "按回车键继续" TMP_VAR
							continue
						;;
					esac
				done
			fi

			return 1
		fi
	done

}

onmp_uninstall() {

	echo -e "\e[31m
	nginx
	mysql-server
	php5(7)-fpm
	php5(7)-fastcgi
	php5(7)-cgi
	php5(7)-mod-gd
	php5(7)-mod-session
	php5(7)-mod-pdo-mysql
	php5(7)-mod-pdo
	php5(7)-mod-mysqli
	php5(7)-mod-mcrypt
	php5(7)-mod-mbstring
	php5(7)-mod-xml
	php5(7)-mod-ctype
	php5(7)-mod-curl
	php5(7)-mod-exif
	php5(7)-mod-ftp
	php5(7)-mod-iconv
	php5(7)-mod-json
	php5(7)-mod-sockets
	php5(7)-mod-sqlite3
	php5(7)-mod-tokenizer
	php5(7)-mod-zip
	php5(7)-mod-simplexml
	php5(7)-mod-dom
	php5(7)-mod-xmlwriter
	php5(7)-mod-xmlreader
	php5(7)-mod-hash
	php5(7)-mod-opcache
	php5(7)
	\e[0m
	"
	echo -e "\e[35m警告：将要卸载以上包。\e[0m"

	while :
	do
		echo -e "\e[36m确定要卸载？(1|2)(默认：2)\e[0m"
		echo -e "\t\e[32m1\e[0m. 是"
		echo -e "\t\e[32m2\e[0m. 否"
		read -p ":" TMP_VAR

		[ -z "$TMP_VAR" ] && TMP_VAR="2"

		case "$TMP_VAR" in
			1)
				break
			;;
			2)
				echo
				echo -e "\e[32m取消卸载\e[0m"
				return 1
			;;
			*)
				echo
				echo -e "\e[31m输入错误，请重新输入。\e[0m"
				echo
				read -p "按回车键继续" TMP_VAR
				continue
			;;
		esac
	done
	
	/usr/sbin/nginx -s stop > /dev/null 2>&1
	/etc/init.d/php5-fpm stop > /dev/null 2>&1
	/etc/init.d/php7-fpm stop > /dev/null 2>&1
	/etc/init.d/mysqld stop > /dev/null 2>&1

	PHP_VER="php5"

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
	
	rm /usr/bin/onmp > /dev/null 2>&1

	echo
	echo -e "\t\e[32m卸载完成\e[0m"
	echo
	read -p "按回车键继续" TMP_VAR

	return 0
}

logo() {
    cat <<logo
###########################################
#                                         #
#  ooo    n    nn   mm       mm   ppppp   #
# o   o   n   n n   m m     m m   p    p  #
# o   o   n  n  n   m  m   m  m   ppppp   #
# o   o   n n   n   m   m m   m   p       #
#  ooo    nn    n   m    m    m   p       #
#                                         #
###########################################
logo
}

# 主循环
while :
do
	echo -e "\n\n\n\n\n"
	logo
	
	echo
	echo -e "\e[36m请选择操作。(1|2|3)(默认：3)\e[0m"
	echo -e "\t\e[32m1\e[0m. 安装"
	echo -e "\t\e[32m2\e[0m. 卸载"
	echo -e "\t\e[32m3\e[0m. 退出"
	read -p ":" TMP_VAR

	[ -z "$TMP_VAR" ] && exit 0

	case "$TMP_VAR" in
		1)
			onmp_set
			onmp_install
		;;
		2)
			onmp_uninstall
		;;
		3)
			exit 0
		;;
		*)
			echo -e "\e[31m输入错误，请重新输入。\e[0m"
			echo
			read -p "按回车键继续" TMP_VAR
			continue
		;;
	esac
done
