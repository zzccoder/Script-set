#!/bin/bash
#
# Install dependencies package
rpm -qa | grep openssl-devel &> /dev/null
if [ $? -ne 0 ];then
  yum -y install openssl-devel &> /dev/null
fi

# Backup old openssh config file
if [ -d /etc/ssh ];then
  mv /etc/ssh /etc/ssh.old
fi

if [ -d /etc/init.d/sshd ];then
  mv /etc/init.d/sshd /etc/init.d/sshd.old
fi

# check packages
if [ ! -f /root/openssh-8.0p1.tar.gz ];then
  echo "No such file..."
  exit 1
fi

# Uninstall old openssh
for PACKAGE in $(rpm -qa | grep openssh);do
  echo "Uninstall $PACKAGE"
  rpm -e --nodeps $PACKAGE &> /dev/null
  if [ $? -ne 0 ];then
    rpm -e --noscripts $PACKAGE &> /dev/null
  fi
done

# Config Environment before
install  -v -m700 -d /var/lib/sshd
chown  -v root:sys /var/lib/sshd

# Install new openssh

echo "Install openssh..."
cd /root
tar xf openssh-8.0p1.tar.gz
cd openssh-8.0p1
./configure --prefix=/usr  --sysconfdir=/etc/ssh  --with-md5-passwords  --with-pam  --with-zlib --with-openssl-includes=/usr --with-privsep-path=/var/lib/sshd &> /root/install-openssh.log
if [ $? -ne 0 ];then
  echo "Configure openssh failure,Please check compile Environment..."
  exit 1
fi

make &> /root/install-openssh.log
if [ $? -ne 0 ];then
  echo "Error,please look install-openssh.log for more information..."  
  exit 1
fi
make install &> /root/install-openssh.log
if [ $? -ne 0 ];then
  echo "Error,please look install-openssh.log for more information..."  
  exit 1
fi

# Config Environment after
echo "Config Environment install after..."
install -v -m755    contrib/ssh-copy-id /usr/bin
install -v -m644    contrib/ssh-copy-id.1 /usr/share/man/man1
install -v -m755 -d /usr/share/doc/openssh-8.0p1
install -v -m644    INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-8.0p1
echo 'X11Forwarding yes' >> /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
cp -p contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig --add sshd
chkconfig sshd on
cp /etc/ssh.old/ssh_host_key.pub /etc/ssh/
echo "Install openssh success..."





yum install -y telnet-server
	yum install -y xinetd
	sed -i '/SELINUX=/s/enforcing/disabled/g' /etc/sysconfig/selinux
	cat > /etc/xinetd.d/telnet << END
	service telnet
	{
			flags           = REUSE
			socket_type     = stream
			wait            = no
			user            = root
			server          = /usr/sbin/in.telnetd
			log_on_failure  += USERID
			disable         = no
	}
	END
	mv /etc/securetty /etc/securetty.old
	sed -i 's/auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so/#auth [user_unknown=ignore success=ok ignore=ignore default=bad] pam_securetty.so/g' /etc/pam.d/login
	sed -i 's/auth       required     pam_securetty.so/#auth       required     pam_securetty.so/g'  /etc/pam.d/remote
	echo "pts/0" >> /etc/securetty
	echo "pts/1" >> /etc/securetty
	echo "pts/2" >> /etc/securetty
	echo "pts/3" >> /etc/securetty
	echo "pts/4" >> /etc/securetty
	systemctl enable xinetd.service
	systemctl start xinetd
	ps -ef |grep xinetd
	
	systemctl disable xinetd.service
	systemctl stop xinetd.service 
	systemctl disable telnet.socket 
	systemctl stop telnet.socket 
	
	yum update --skip-broken --setopt=protected_multilib=false
	yum update openssh -y --skip-broken
	
	echo 'nameserver 211.138.106.7' >>/etc/resolv.conf
	
	yum install  -y gcc gcc-c++ glibc make autoconf openssl openssl-devel pcre-devel  pam-devel --skip-broken
	yum install  -y pam* zlib*
	
	wget https://openbsd.hk/pub/OpenBSD/OpenSSH/portable/openssh-8.0p1.tar.gz
	wget https://ftp.openssl.org/source/openssl-1.0.2s.tar.gz
	tar xfz openssl-1.0.2s.tar.gz
	mv /usr/bin/openssl /usr/bin/openssl_bak
	mv /usr/include/openssl /usr/include/openssl_bak
	cd openssl-1.0.2s
	./config shared && make && make install
	echo $?
	ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
	ln -s /usr/local/ssl/include/openssl /usr/include/openssl
	echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
	openssl version
	/sbin/ldconfig
	
	
	tar xfz openssh-8.0p1.tar.gz 
	cd openssh-8.0p1
	chown -R root.root ../openssh-8.0p1
	mkdir /etc/ssh.bak
	mv /etc/ssh/* /etc/ssh.bak
	./configure --prefix=/usr/ --sysconfdir=/etc/ssh  --with-openssl-includes=/usr/local/ssl/include  --with-ssl-dir=/usr/local/ssl   --with-zlib   --with-md5-passwords   --with-pam  && make && make install
	grep "^PermitRootLogin"  /etc/ssh/sshd_config
	grep  "UseDNS"  /etc/ssh/sshd_config
	sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config 

	cp -a contrib/redhat/sshd.init /etc/init.d/sshd
	cp -a contrib/redhat/sshd.pam /etc/pam.d/sshd.pam
	chmod +x /etc/init.d/sshd
	chkconfig --add sshd
	systemctl enable sshd
	mv  /usr/lib/systemd/system/sshd.service //usr/lib/systemd/system/sshd.service.old
	chkconfig sshd on
	/etc/init.d/sshd restart
