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
    yum -y remove epel-release
    for i in `ls`;do mv $i $i.bk;done
    curl -O  http://mirrors.163.com/.help/CentOS7-Base-163.repo
    yum -y install epel-release
    :>/etc/yum.repos.d/epel.repo
    cat>/etc/yum.repos.d/epel.repo<<-EOF
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/\$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Debug
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/\$basearch/debug
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=\$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=0

[epel-source]
name=Extra Packages for Enterprise Linux 7 - \$basearch - Source
baseurl=https://mirrors.tuna.tsinghua.edu.cn/epel/7/SRPMS
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=\$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=0
EOF
    }




##To shut down selinux
se_status=`getenforce`
if [ $se_status == "Enforcing" ]
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

for pkgs in wget gcc perl perl-devel libaio libaio-devel pcre-devel zlib-devel pcre openssl openssl-devel
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
		[ ! -f mysql-5.1.73-linux-$ar-glibc23.tar.gz ] && wget -c http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.73-linux-$ar-glibc23.tar.gz
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
		[ ! -f mysql-5.6.36-linux-glibc2.5-$ar.tar.gz ] && wget -c http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.36-linux-glibc2.5-$ar.tar.gz
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
	[ -f httpd-2.2.34.tar.gz ] || wget -c http://mirrors.sohu.com/apache/httpd-2.2.34.tar.gz
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
		[ -f php-5.4.22.tar.gz ] || wget -c http://mirrors.sohu.com/php/php-5.4.22.tar.gz
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
		[ -f php-5.6.6.tar.gz ] || wget -c http://mirrors.sohu.com/php/php-5.6.6.tar.gz
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



#################install php-fpm
install_php_fpm() {
	case $php_v in
	5.4)
		useradd -s /sbin/nologin php-fpm -M
		cd /usr/local/src
		[ -f php-5.4.22.tar.gz ] || wget -c http://mirrors.sohu.com/php/php-5.4.22.tar.gz
		tar zxf php-5.4.22.tar.gz && cd php-5.4.22
		for i in  bzip2-devel curl-devel db4-devel libjpeg-devel libpng-devel libcurl-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel  net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel unixODBC-devel postgresql-devel pspell-devel net-snmp-devel freetype-devel libtomcrypt-devel.x86_64  php-mcrypt  libmcrypt  libmcrypt-devel wget sysstat  gcc  gcc-c++ libstdc++-devel lrzsz make  cmake bison-devel ncurses-devel libaio libaio-devel  perl-Data-Dumper net-tools unzip vim-enhanced
		do
			check_rpm $i
		done
		check_ok
		./configure \
		--prefix=/usr/local/php-fpm \
		--with-config-file-path=/usr/local/php-fpm/etc  \
		--with-mysql=/usr/local/mysql \
		--enable-fpm \
		--with-fpm-user=php-fpm \
		--with-fpm-group=php-fpm \
		--with-mysql-sock=/tmp/mysql.sock \
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
		--disable-ipv6 \
		--with-curl \
		--with-gd-native-ttf \
		--enable-mbstring \
		--enable-exif \
		--enable-ftp \
		--with-openssl 
		check_ok
		make && make install
		check_ok
		cp php.ini-production /usr/local/php-fpm/etc/php.ini
		cat >/usr/local/php-fpm/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php-fpm/var/run/php-fpm.pid
error_log = /usr/local/php-fpm/var/log/php-fpm.log
[www]
listen = /tmp/php-fcgi.sock
listen.mode = 666
user = php-fpm
group = php-fpm
pm = dynamic
pm.max_children = 50
pm.start_servers = 20
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500
rlimit_files = 1024
EOF
		/usr/local/php-fpm/sbin/php-fpm -t
		check_ok
		cp /usr/local/src/php-5.4.22/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
		chmod 755 /etc/init.d/php-fpm
		service php-fpm start
		check_ok
		chkconfig php-fpm on
		break
		;;
	5.6)
	useradd -s /sbin/nologin php-fpm -M
	cd /usr/local/src
	[ -f php-5.6.6.tar.gz ] || wget -c http://mirrors.sohu.com/php/php-5.6.6.tar.gz
	tar zxf php-5.6.6.tar.gz && cd php-5.6.6
	for i in  bzip2-devel curl-devel db4-devel libjpeg-devel libcurl-devel  libpng-devel libXpm-devel gmp-devel libc-client-devel openldap-devel unixODBC-devel postgresql-devel sqlite-devel aspell-devel  net-snmp-devel libxslt-devel libxml2-devel pcre-devel mysql-devel unixODBC-devel postgresql-devel pspell-devel net-snmp-devel freetype-devel libtomcrypt-devel.x86_64  php-mcrypt  libmcrypt  libmcrypt-devel wget sysstat  gcc  gcc-c++ libstdc++-devel lrzsz make  cmake bison-devel ncurses-devel libaio libaio-devel  perl-Data-Dumper net-tools unzip vim-enhanced
	do
		check_rpm $i
	done
	check_ok
	./configure \
	--prefix=/usr/local/php-fpm \
    --with-config-file-path=/usr/local/php-fpm/etc  \
    --with-mysql=/usr/local/mysql \
    --enable-fpm \
    --with-fpm-user=php-fpm \
    --with-fpm-group=php-fpm \
    --with-mysql-sock=/tmp/mysql.sock \
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
    --disable-ipv6 \
	--with-curl \
    --with-gd-native-ttf \
    --enable-mbstring \
    --enable-exif \
    --enable-ftp \
    --with-openssl
	check_ok
	make && make install
	check_ok
    cp php.ini-production /usr/local/php-fpm/etc/php.ini
                cat >/usr/local/php-fpm/etc/php-fpm.conf<<EOF
[global]
pid = /usr/local/php-fpm/var/run/php-fpm.pid
error_log = /usr/local/php-fpm/var/log/php-fpm.log
[www]
listen = /tmp/php-fcgi.sock
listen.mode = 666
user = php-fpm
group = php-fpm
pm = dynamic
pm.max_children = 50
pm.start_servers = 20
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500
rlimit_files = 1024
EOF
    /usr/local/php-fpm/sbin/php-fpm -t
    check_ok
    cp /usr/local/src/php-5.6.6/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
    chmod 755 /etc/init.d/php-fpm
    service php-fpm start
    check_ok
	chkconfig php-fpm on
	break
		;;
	*)
		echo "Only 5.4 or 5.6!"
		break
		;;

	esac
}




#######install nginx

install_nginx() {
	cd /usr/local/src
	[ -f nginx-1.10.3.tar.gz ] ||  wget -c http://mirrors.sohu.com/nginx/nginx-1.10.3.tar.gz
	tar zxvf nginx-1.10.3.tar.gz
	cd nginx-1.10.3
	./configure \
	--prefix=/usr/local/nginx \
    --with-http_ssl_module
	make && make install
	cat > /etc/init.d/nginx <<EOF
#!/bin/bash
# chkconfig: - 30 21
# description: http service.
# Source Function Library
. /etc/init.d/functions
# Nginx Settings

NGINX_SBIN="/usr/local/nginx/sbin/nginx"
NGINX_CONF="/usr/local/nginx/conf/nginx.conf"
NGINX_PID="/usr/local/nginx/logs/nginx.pid"
RETVAL=0
prog="Nginx"

start() {
        echo -n $"Starting \$prog: "
        mkdir -p /dev/shm/nginx_temp
        daemon \$NGINX_SBIN -c \$NGINX_CONF
        RETVAL=\$?
        echo
        return \$RETVAL
}

stop() {
        echo -n $"Stopping \$prog: "
        killproc -p \$NGINX_PID \$NGINX_SBIN -TERM
        rm -rf /dev/shm/nginx_temp
        RETVAL=\$?
        echo
        return \$RETVAL
}

reload(){
        echo -n $"Reloading \$prog: "
        killproc -p \$NGINX_PID \$NGINX_SBIN -HUP
        RETVAL=\$?
        echo
        return \$RETVAL
}

restart(){
        stop
        start
}

configtest(){
    \$NGINX_SBIN -c \$NGINX_CONF -t
    return 0
}

case "\$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  reload)
        reload
        ;;
  restart)
        restart
        ;;
  configtest)
        configtest
        ;;
  *)
        echo $"Usage: \$0 {start|stop|reload|restart|configtest}"
        RETVAL=1
esac

exit \$RETVAL 
EOF
	chmod 755 /etc/init.d/nginx
	chkconfig --add nginx
	chkconfig nginx on
	>/usr/local/nginx/conf/nginx.conf
	cat >/usr/local/nginx/conf/nginx.conf <<EOF
user nobody nobody;
worker_processes 2;
error_log /usr/local/nginx/logs/nginx_error.log crit;
pid /usr/local/nginx/logs/nginx.pid;
worker_rlimit_nofile 51200;
events
{
    use epoll;
    worker_connections 6000;
}
http

{
    include mime.types;
    default_type application/octet-stream;
    server_names_hash_bucket_size 3526;
    server_names_hash_max_size 4096;
    log_format combined_realip '\$remote_addr \$http_x_forwarded_for [\$time_local]'
    '\$host "\$request_uri" \$status'
    '"\$http_referer" "\$http_user_agent"';
    sendfile on;
    tcp_nopush on;
    keepalive_timeout 30;
    client_header_timeout 3m;
    client_body_timeout 3m;
    send_timeout 3m;
    connection_pool_size 256;
    client_header_buffer_size 1k;
    large_client_header_buffers 8 4k;
    request_pool_size 4k;
    output_buffers 4 32k;
    postpone_output 1460;
    client_max_body_size 10m;
    client_body_buffer_size 256k;
    client_body_temp_path /usr/local/nginx/client_body_temp;
    proxy_temp_path /usr/local/nginx/proxy_temp;
    fastcgi_temp_path /usr/local/nginx/fastcgi_temp;
    fastcgi_intercept_errors on;
    tcp_nodelay on;
    gzip on;
    gzip_min_length 1k;
    gzip_buffers 4 8k;
    gzip_comp_level 5;
    gzip_http_version 1.1;
    gzip_types text/plain application/x-javascript text/css text/htm application/xml;

server

{
    listen 80;
    server_name localhost;
    index index.html index.htm index.php;
    root /usr/local/nginx/html;

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/tmp/php-fcgi.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html\$fastcgi_script_name;
    }
}
#include vhosts/*.conf;
}
EOF
	/usr/local/nginx/sbin/nginx -t
	service nginx start
	cat > /usr/local/nginx/html/2.php<<EOF
<?php
	phpinfo();
?>
EOF
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

lnmp_install() {
    check_service mysqld
    check_service nginx
	install_php_fpm
	echo "lnmp done!"
}


echo "This script is to install lanmp!"
sleep 3
read -p "You want to install (lamp|lnmp):" arch_ver
read -p "Please choose the version of mysql(5.1|5.6):" mysql_v
read -p "Please choose the version of php(5.4|5.6):" php_v
#lamp_install

if [ $arch_ver == 'lamp' ];then
	lamp_install
fi

if [ $arch_ver == 'lnmp' ];then
	lnmp_install
fi
