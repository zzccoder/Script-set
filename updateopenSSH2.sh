#!/bin/bash
cd /home/kshop/software
wget http://www.zlib.net/zlib-1.2.11.tar.gz
wget https://openbsd.mirror.netelligent.ca/pub/OpenBSD/OpenSSH/portable/openssh-7.7p1.tar.gz --no-check-certificate
wget https://www.openssl.org/source/openssl-1.0.2m.tar.gz
yum  install gcc pam-devel zlib-devel -y
tar -xf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/usr
make
rpm -e --nodeps zlib
make install
echo ‘/usr/lib‘ >> /etc/ld.so.conf
ldconfig

mv /usr/lib64/openssl/ /usr/lib64/openssl.old
mv /usr/bin/openssl /usr/bin/openssl.old
mv /etc/pki/ca-trust/extracted/openssl /etc/pki/ca-trust/extracted/openssl.old
cp /usr/lib64/libcrypto.so.10 /usr/lib64/libcrypto.so.10.old
cp /usr/lib64/libssl.so.10 /usr/lib64/libssl.so.10.old
rpm -qa |grep openssl|xargs -i rpm -e --nodeps {}

cd /home/kshop/software
tar -xf openssl-1.0.2m.tar.gz
cd openssl-1.0.2m
./config --prefix=/usr/local/ssl --openssldir=/etc/ssl --shared zlib
echo $?
make
make test
make install
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
ldconfig -v
openssl version
\mv  /usr/lib64/libcrypto.so.10.old  /usr/lib64/libcrypto.so.10
\mv  /usr/lib64/libssl.so.10.old  /usr/lib64/libssl.so.10

mv /etc/ssh /etc/ssh.old
rpm -qa |grep openssh|xargs -i rpm -e --nodeps {}
install  -v -m700 -d /var/lib/sshd
chown  -v root:sys /var/lib/sshd
groupadd -g 51 sshd
useradd  -c ‘sshd PrivSep‘ -d /var/lib/sshd -g sshd -s /bin/false -u 51 sshd
cd /home/kshop/software
tar -xf openssh-7.7p1.tar.gz
cd openssh-7.7p1
./configure --prefix=/usr  --sysconfdir=/etc/ssh  --with-md5-passwords  --with-pam  --with-zlib --with-ssl-dir=/usr/local/ssl --with-privsep-path=/var/lib/sshd
make && make install
install -v -m755    contrib/ssh-copy-id /usr/bi
install -v -m644    contrib/ssh-copy-id.1 /usr/share/man/man1
install -v -m755 -d /usr/share/doc/openssh-7.7p1
install -v -m644    INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-7.7p1
ssh -V
echo ‘X11Forwarding yes‘ >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
cp -p contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig  --add  sshd
chkconfig  sshd  on

rm -rf /etc/ssh
mv /etc/ssh.old /etc/ssh
sed -i '/^#PermitRootLogin/s/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i '/^GSSAPICleanupCredentials/s/GSSAPICleanupCredentials yes/#GSSAPICleanupCredentials yes/' /etc/ssh/sshd_config
sed -i '/^UsePAM/s/UsePAM yes/#UsePAM yes/' /etc/ssh/sshd_config
sed -i '/^GSSAPIAuthentication/s/GSSAPIAuthentication yes/#GSSAPIAuthentication yes/' /etc/ssh/sshd_config
sed -i '/^GSSAPIAuthentication/s/GSSAPIAuthentication no/#GSSAPIAuthentication no/' /etc/ssh/sshd_config


