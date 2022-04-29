#!/bin/bash
#
#auto install LAMP
###

#Httpd define path variable
H_FILES=httpd-2.2.31.tar.bz2
H_FILES_DIR=httpd-2.2.31
H_URL=http://mirrors.cnnic.cn/apache/httpd/httpd-2.2.31.tar.bz2
H_PREFIX=/usr/local/apache2/
#MySQL define path variable
M_FILES=mysql-5.5.20.tar.gz
M_FILES_DIR=mysql-5.5.20
M_URL=http://down1.chinaunix.net/distfiles/ mysql-5.5.20.tar.gz
M_PREFIX=/usr/local/mysql/
#PHP define path variable
P_FILES=php-5.3.28.tar.bz2
P_FILES_DIR=php-5.3.28
P_URL=http://mirrors.sohu.com/php/
P_PREFIX=/usr/local/php5/

#Installing  Meum
echo -e '\033[32m-----------------------------\033[0m'
echo
if [ -z "$1" ];then
    echo -e "\033[36mPlease Select Install Menu follow:\033[0m" 
    echo -e "\033[32m1)编译安装 Apache 服务器\033[1m" 
    echo "2)编译安装 MySQL 服务器" 
    echo "3)编译安装 PHP 服务器" 
    echo "4)配置 index.php 并启动 LAMP 服务" 
    echo -e "\033[31mUsage: { /bin/sh $0 1|2|3|4|help}\033[0m" 
    exit
fi

if [[ "$1" -eq "help" ]];then
    echo -e "\033[36mPlease Select Install Menu follow:\033[0m" 
    echo -e "\033[32m1)编译安装 Apache 服务器\033[1m" 
    echo "2)编译安装 MySQL 服务器" 
    echo "3)编译安装 PHP 服务器" 
    echo "4)配置 index.php 并启动 LAMP 服务" 
    echo -e "\033[31mUsage: { /bin/sh $0 1|2|3|4|help}\033[0m"
    exit
fi

#Install httpd web server
if [[ "$1" -eq "1" ]];then
    wget -c $H_URL/$H_FILES && tar -jxvf $H_FILES && cd $H_FILES_DIR&&./configure --prefix=$H_PREFIX
    if [ $? -lt 0 ];then
        make && make install
    fi
fi

#Install Mysql DB server
if [[ "$1" -eq "2" ]];then
    wget -c $M_URL/$M_FILES && tar -xzvf $M_FILES && cd $M_FILES_DIR &&yum install cmake -y;cmake . -DCMAKE_INSTALL_PREFIX=$M_PREFIX 
    \ -DMYSQL_UNIX_ADDR=/tmp/mysql.sock 
    \ -DMYSQL_DATADIR=/data/mysql 
    \ -DSYSCONFDIR=/etc 
    \ -DMYSQL_USER=mysql 
    \ -DMYSQL_TCP_PORT=3306 
    \ -DWITH_XTRADB_STORAGE_ENGINE=1 
    \ -DWITH_INNOBASE_STORAGE_ENGINE=1 
    \ -DWITH_PARTITION_STORAGE_ENGINE=1 
    \ -DWITH_BLACKHOLE_STORAGE_ENGINE=1 
    \ -DWITH_MYISAM_STORAGE_ENGINE=1 
    \ -DWITH_READLINE=1 
    \ -DENABLED_LOCAL_INFILE=1 
    \ -DWITH_EXTRA_CHARSETS=1 
    \ -DDEFAULT_CHARSET=utf8 
    \ -DDEFAULT_COLLATION=utf8_general_ci 
    \ -DEXTRA_CHARSETS=all 
    \ -DWITH_BIG_TABLES=1 
    \ -DWITH_DEBUG=0
    make && make install
    /bin/cp support-files/my-small.cnf /etc/my.cnf
    /bin/cp support-files/mysql.server /etc/init.d/mysqld
    chmod +x /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig mysqld on
    if [ $? -eq 0 ];then
        make && make install
        echo -e "\n\033[32m-----------------------------------------------\033[0m" echo -e "\033[32mThe $M_FILES_DIR Server Install Success !\033[0m" else
        echo -e "\033[32mThe $M_FILES_DIR Make or Make install ERROR,Please Check......" exit 0
    fi
fi

#Install PHP server
if [[ "$1" -eq "3" ]];then
    wget -c $P_URL/$P_FILES && tar -jxvf $P_FILES && cd $P_FILES_DIR&&./configure --prefix=$P_PREFIX --with-config-file-path=$P_PREFIX/etc
--with-mysql=$M_PREFIX --with-apxs2=$H_PREFIX/bin/apxs
    if [ $? -eq 0 ];then
        make ZEND_EXTRA_LIBS='-liconv' && make install
        echo -e "\n\033[32m-----------------------------------------------\033[0m" echo -e "\033[32mThe $P_FILES_DIR Server Install
Success !\033[0m"
    else
        echo -e "\033[32mThe $P_FILES_DIR Make or Make install ERROR,Please Check......" exit 0
    fi
fi
if [[ "$1" -eq "4" ]];then
    sed -i '/DirectoryIndex/s/index.html/index.php index.html/g' $H_PREFIX/conf/httpd.conf
    $H_PREFIX/bin/apachectl restart
    echo "AddType application/x-httpd-php .php" >>$H_PREFIX/conf/httpd.conf
    IP=`ifconfig eth1|grep "Bcast"|awk '{print $2}' |cut -d: -f2` 
    echo "You can access http://$IP/" cat >$H_PREFIX/htdocs/index.php <<EOF
    <?php
    phpinfo();
    ?>
    EOF
fi
