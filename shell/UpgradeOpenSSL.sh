#!/bin/bash
#下载安装最新openssl
wget http://www.openssl.org/source/openssl-1.0.1g.tar.gz
tar xzvf openssl-1.0.1g.tar.gz
cd openssl-1.0.1g
./config shared zlib
make && make install
cd /usr/local/ssl/
./bin/openssl version -a
#替换旧版openssl
mv /usr/bin/openssl /usr/bin/openssl.old
mv /usr/include/openssl /usr/include/openssl.old
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl/ /usr/include/openssl
#配置库文件搜索路径
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
ldconfig
#测试新版是否正常
openssl version -a






OpenSSL 1.0.1e-fips 升级
openssl version -a
wget http://www.openssl.org/source/openssl-1.1.0c.tar.gz
yum install -y zlib
tar zxf openssl-1.1.0c.tar.gz
cd openssl-1.1.0c
./config shared zlib
make
make install
mv /usr/bin/openssl /usr/bin/openssl.bak
mv /usr/include/openssl /usr/include/openssl.bak
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
echo “/usr/local/ssl/lib” >> /etc/ld.so.conf
n -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
openssl version -a