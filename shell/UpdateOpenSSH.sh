#!/bin/bash
cd /etc/yum.repos.d/
mv ./CentOS-Base.repo ./CentOS-Base.repo.bak
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O CentOS-Base.repo
yum clean all && yum makecache
yum update
ssh -V
openssl version
yum install gcc zlib-devel openssl-devel pam-devel –y
cd ~
wget --no-check-certificate https://www.openssl.org/source/openssl-1.0.2j.tar.gz
tar zxvf openssl-1.0.2j.tar.gz
cd openssl-1.0.2j
./config  && make  && make install
mv /usr/bin/openssl /usr/bin/openssl_v101e   
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl  
openssl version
cd ~
wget https://mirrors.sonic.net/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz
tar zxvf openssh-7.4p1.tar.gz
cd openssh-7.4p1
./configure   --prefix=/usr --sysconfdir=/etc/ssh --with-md5-passwords   --with-pam  --with-tcp-wrappers   --with-ssl-dir=/usr/local/ssl   --without-hardening
make && make install
sed -i '/GSSAPIAuthentication yes/s/GSSAPIAuthentication yes/#GSSAPIAuthentication yes/' /etc/ssh/sshd_config
sed -i '/GSSAPICleanupCredentials yes/s/GSSAPICleanupCredentials yes/#GSSAPICleanupCredentials yes/' /etc/ssh/sshd_config
sed -i '/^#PermitRootLogin/s/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
/etc/init.d/sshd restart
ssh -V
