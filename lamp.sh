#!/bin/bash
##This is to check the services.
##To shut down the firewalld
systemctl status firewalld 1>/dev/null 2>&1
if [ $? != 0 ]
then
echo "The firewall has already been shut down."
else
systemctl stop firewalld
systemctl disable firewalld 1>/dev/null 2>&1
echo "The firewall has been shut down."
fi


## change the repo
change_repo() {
    cd /etc/yum.repos.d/
    mv *.repo *.repo.bk
    curl -O  http://mirrors.aliyun.com/repo/Centos-7.repo
    rpm -Ivh https://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
    yum clean all
    yum makecache
    }




##To shut down selinux
se_status=`getenforce`
if [ $se_status == "1" ]
then
setenforce 0
echo "Selinux Policy has been shutdown!"
fi
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

## This bash is to install some pkgs.
check_rpm() {
	if ! rpm -qa | grep -q "^$1"
	then
		yum -y install $1
        else
                echo "$1 is already installed!"
        fi
	}

change_repo

for pkgs in wget gcc perl perl-devel libaio libaio-devel pcre-devel zlib-devel pcre
do
        check_rpm $pkgs
done

##check whether it's right or wrong!
check_ok() {
	if [ $? != 0 ]
	then
		echo "Error! Please check the error log!"
		exit 1
	fi
	}


ar=`arch`


##This script is to install mysql 5.1
install_mysqld() {
	case $mysql_v in
	5.1)
		cd /usr/local/src
		[ ! -f mysql-5.1.73-linux-$ar-glibc23.tar.gz ] && wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.73-linux-$ar-glibc23.tar.gz
		tar zxf mysql-5.1.73-linux-$ar-glibc23.tar.gz
		[ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_`date +$s`
		/bin/mv /usr/local/src/mysql-5.1.73-linux-$ar-glibc23 /usr/local/mysql
		check_ok
		cd /usr/local/mysql
		if ! grep "^mysql:" /etc/passwd
			then
				useradd -M -s /sbin/nologin mysql
				check_ok
		fi
		[ ! -d /data/mysql ] && mkdir -p /data/mysql
		chown -R mysql.mysql /data/mysql
		./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
		check_ok
		[ -f /etc/my.cnf ] && rm -rf /etc/my.cnf
		cp ./support-files/my-large.cnf /etc/my.cnf
		cp ./support-files/mysql.server /etc/init.d/mysqld
		sed -i '/\[mysqld\]/a datadir=\/data\/mysql' /etc/my.cnf
		sed -i 's/^datadir=/datadir=\/data\/mysql/' /etc/init.d/mysqld
		service mysqld start
		chkconfig --add mysqld
		chkconfig mysqld on
		check_ok
		echo "Mysql_5.1 is installed!"
		sleep 3
		;;
	5.6)
		yum -y install autoconf
		cd /usr/local/src
		[ ! -f mysql-5.6.36-linux-glibc2.5-$ar.tar.gz ] && wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.36-linux-glibc2.5-$ar.tar.gz
		tar zxf mysql-5.6.36-linux-glibc2.5-$ar.tar.gz
		[ -d /usr/local/mysql ] && /bin/mv /usr/local/mysql /usr/local/mysql_bak
		/bin/mv /usr/local/src/mysql-5.6.36-linux-glibc2.5-$ar /usr/local/mysql
		check_ok
		cd /usr/local/mysql
		if ! grep "^mysql:" /etc/passwd
			then
				useradd -M -s /sbin/nologin mysql
				check_ok
		fi
		check_ok
		[ ! -d /data/mysql ] && mkdir -p /data/mysql
		chown -R mysql.mysql /data/mysql
		./scripts/mysql_install_db --user=mysql --datadir=/data/mysql
		check_ok
		[ -f /etc/my.cnf ] && rm -rf /etc/my.cnf
		cp ./support-files/my-default.cnf /etc/my.cnf
		cp ./support-files/mysql.server /etc/init.d/mysqld
		sed -i '/\[mysqld\]/a datadir=\/data\/mysql' /etc/my.cnf
		sed -i 's/^datadir=/datadir=\/data\/mysql/' /etc/init.d/mysqld
		service mysqld start
		chkconfig --add mysqld
		chkconfig mysqld on
		check_ok
		echo "Mysql_5.6 is installed!"
		sleep 3
		;;
	*)
		echo "Only 5.1 or 5.6!"
		exit 1
		;;
	esac
}



##install httpd
install_httpd() {
	echo "It'll install httpd2.2 now!"
	cd /usr/local/src
	[ -f httpd-2.2.34.tar.gz ] || wget http://mirrors.sohu.com/apache/httpd-2.2.34.tar.gz
	tar zxf httpd-2.2.34.tar.gz && cd httpd-2.2.34
	./configure \
	--prefix=/usr/local/apache2 \
	--with-included-apr \
	--enable-so \
	--enable-deflate=shared \
	--enable-expires=shared \
	--enable-rewrite=shared \
	--with-pcre
	check_ok
	make && make install
	check_ok
}

##install php
install_php() {
	case $php_v in
	5.4)
		cd /usr/local/src
		[ -f php-5.4.22.tar.gz ] || wget http://mirrors.sohu.com/php/php-5.4.22.tar.gz
		tar zxf php-5.4.22.tar.gz && cd php-5.4.22
		for i in bzip2-devel curl-devel db4-devel libjpeg-devel libpng-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel  net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel unixODBC-devel postgresql-devel pspell-devel net-snmp-devel freetype-devel libmcrypt-devel
		do
			check_rpm $i
		done
		check_ok
		./configure \
		--prefix=/usr/local/php \
		--with-apxs2=/usr/local/apache2/bin/apxs \
		--with-config-file-path=/usr/local/php/etc  \
		--with-mysql=/usr/local/mysql \
		--with-libxml-dir \
		--with-gd \
		--with-jpeg-dir \
		--with-png-dir \
		--with-freetype-dir \
		--with-iconv-dir \
		--with-zlib-dir \
		--with-bz2 \
		--with-openssl \
		--with-mcrypt \
		--enable-soap \
		--enable-gd-native-ttf \
		--enable-mbstring \
		--enable-sockets \
		--enable-exif \
		--disable-ipv6
		check_ok
		make && make install
		check_ok
		[ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production /usr/local/php/etc/php.ini
		break
		;;
	5.6)
		cd /usr/local/src
		[ -f php-5.6.6.tar.gz ] || wget http://mirrors.sohu.com/php/php-5.6.6.tar.gz
		tar zxf php-5.6.6.tar.gz && cd php-5.6.6
		for i in bzip2-devel curl-devel db4-devel libjpeg-devel libpng-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel  net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel unixODBC-devel postgresql-devel pspell-devel net-snmp-devel freetype-devel libmcrypt-devel
		do
			check_rpm $i
		done
		check_ok
		./configure \
		--prefix=/usr/local/php \
		--with-apxs2=/usr/local/apache2/bin/apxs \
		--with-config-file-path=/usr/local/php/etc  \
		--with-mysql=/usr/local/mysql \
		--with-libxml-dir \
		--with-gd \
		--with-jpeg-dir \
		--with-png-dir \
		--with-freetype-dir \
		--with-iconv-dir \
		--with-zlib-dir \
		--with-bz2 \
		--with-openssl \
		--with-mcrypt \
		--enable-soap \
		--enable-gd-native-ttf \
		--enable-mbstring \
		--enable-sockets \
		--enable-exif \
		--disable-ipv6
		check_ok
		make && make install
		check_ok
		[ -f /usr/local/php/etc/php.ini ] || /bin/cp php.ini-production /usr/local/php/etc/php.ini
		break
		;;
	*)
		echo "Only 5.4 or 5.6!"
		break
		;;
	esac		
}

##to intergrate the php and apache
apa_php() {
	sed -i '/AddType .*.gz .tgz$/a\AddType application\/x-httpd-php .php' /usr/local/apache2/conf/httpd.conf
	check_ok
	sed -i 's/DirectoryIndex index.html/DirectoryIndex index.html index.php index.htm/' /usr/local/apache2/conf/httpd.conf
	sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/' /usr/local/apache2/conf/httpd.conf
	check_ok
	cat>>/usr/local/apache2/htdocs/index.php<<EOF
	<?php
		phpinfo();
	?>
EOF

	if /usr/local/php/bin/php -i | grep -iq 'date.timezone=>no value'
	then
		sed -i '/;date.timezone =$/a\date.timezone = "Asia\/Shanghai"' /usr/local/php/etc/php.ini
	fi
	/usr/local/apache2/bin/apachectl start
	check_ok
	ln -s /usr/local/apache2/bin/* /bin/
}



check_service() {
if [ $1 == "php-fpm" ]
then
	s="php-fpm"
else
	s=$1
fi
n=$(ps aux | grep "$s" |wc -l)
if [ $n -gt 1 ]
then
	echo "$1 is already started."
else
	if [ -f /etc/init.d/$1 ]
	then
	/etc/init.d/$1 start
	else
	install_$1
	fi
fi
}

lamp_install() {
check_service mysqld
check_service httpd
install_php
apa_php
echo "LAMP done! Please try to test."
}

echo "This script is to install lamp!"
sleep 3
read -p "Please choose the version of mysql(5.1|5.6):" mysql_v
read -p "Please choose the version of php(5.4|5.6):" php_v
lamp_install
