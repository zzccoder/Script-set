#!/bin/bash
export LC_ALL="en_US.UTF-8"
yweth=`/bin/netstat -rn |grep UG |awk -F' ' '{print $8}'`
ywip=`/sbin/ifconfig $yweth |grep "inet addr" |awk -F' ' '{print $2}' |awk -F':' '{print $2}'`
/sbin/lspci |grep "Xen Platform"  &>/dev/null
if [ $? -eq 0 ]; then
        hwplatform="Xen Virtual Machine"
	hwptm=xen
else
	/sbin/lspci |grep "VMware" &>/dev/null
	if [ $? -eq 0 ]; then
		hwplatform="VMware Virtual Machine"
       		hwptm=vmware
	else
		hwplatform="Physical Machine"
        	hwptm=phy
	fi
fi
os_level=`uname -r |awk -F"el" '{print $2}'|awk -F'.' '{print $1}'`
run_level=`runlevel |awk -F' ' '{print $2}'`
CHECK_REPORT_PATH=/tmp
CHECK_NAME=$hwptm-$ywip-`date +%F`.log

function check_linux {

echo "{"

###############Check operating system version##############
a="OS_version"
b=`cat /etc/redhat-release|awk '{print $7}'`
c=6.5
if [ `echo "$b < $c|bc" ` ];
then
	echo "\"$a\":\"Unqualified\","
else
	echo "\"$a\":\"Qualified\","
fi

###############Check operating system bits##############
a="OS_bits"
b=`getconf LONG_BIT` &>/dev/null
if [ $b -eq 64 ];
then
	echo "\"$a\":\"Qualified\","
else
	echo "\"$a\":\"Unqualified\","
fi

##############Check system hostname###############
a="Hostname"
b=`uname -n`
c="localhost.localdomain"
if [ $b == $c ];
then
	echo "\"$a\":\"Unqualified\","
else
	echo "\"$a\":\"Qualified\","
fi

#############Check DNS configuration##############
a="DNS"
cat  /etc/resolv.conf | grep -v ^#|grep nameserver  &>/dev/null
b=$?
cat /etc/sysconfig/network-scripts/ifcfg-* |grep -v ^# |grep DNS|grep [0-9].[0-9].[0-9].[0-9] &>/dev/null
c=$?
if [ $b -ne 0 ] && [ $c -ne 0 ];
then
	echo "\"$a\":\"Unqualified\","
else 
	echo "\"$a\":\"Qualified\","
fi

##############Check system time zone#############
a="Timezone"
b=`cat /etc/sysconfig/clock |grep ZONE`
c='ZONE="Asia/Shanghai"'
if [ "$b" == "$c" ];
then 
	echo "\"$a\":\"Qualified\","
else 
	echo "\"$a\":\"Unqualified\","
fi

##############Check network adapter bonding##########
a="Bonding"
if [ $hwptm == "phy" ];
then

	echo "\"$a\":\"Unqualified\","
else
	echo "\"$a\":\"Qualified\","
fi

#############Check NTP Service status################
a="NTP"
ps -ef |grep ntpd |grep -Ev "grep ntpd"  &>/dev/null
b=$?
if [ $b -eq 0 ];
then
	ntpstat  |grep ^synchronised &>/dev/null
	b=$?
	cat /etc/ntp.conf  |grep ^server |grep  "10.109.192.9" &>/dev/null
	c=$?
	if [ $b -eq 0 ] && [ $c -eq 0 ];
	then
        	echo "\"$a\":\"Qualified\","
	else
       		echo "\"$a\":\"Unqualified\","
	fi
else
	echo "\"$a\":\"Unqualified\","
fi

################Check host selinux configuration##########
a="SELinux"
/usr/sbin/sestatus  |grep disabled &>/dev/null
b=$?
if [ $b -eq 0 ];
then
        echo "\"$a\":\"Qualified\","
else
        echo "\"$a\":\"Unqualified\","
fi

#############Check host yum configuration#################
a="YUM"
yum grouplist &>/dev/null
b=$?
if [ $b -eq 0 ];
then
        echo "\"$a\":\"Qualified\","
else
        echo "\"$a\":\"Unqualified\","
fi

############Check monitor user configuration#############
a="Monitor_user"
id srvmnt &>/dev/null
b=$?
id hpsis  &>/dev/null
c=$?
if [ $b -ne 0 ] && [ $c -ne 0 ];
then
	echo "\"$a\":\"Unqualified\","
else
	if [ $b -eq 0 ];
	then
		chage -l srvmnt |grep "Password expires" |grep "never" &>/dev/null
		b=$?
	else
		b=1
	fi
	if [ $c -eq 0 ];
        then
                chage -l hpsis |grep "Password expires" |grep "never" &>/dev/null
                c=$?
        else
                c=1
        fi
	if [ $b -eq 0 ] || [ $c -eq 0 ];
	then
		echo "\"$a\":\"Qualified\","
	else
		echo "\"$a\":\"Unqualified\","
	fi
fi

########Check the other super users###########

a="Other_super_user"
cat /etc/passwd |grep -v ^#|grep -v root|awk -F : '{print $3}'|grep -w 0 &>/dev/null
b=$?
if [ $b -ne 0 ];
then
       echo "\"$a\":\"Qualified\","
else
       echo "\"$a\":\"Unqualified\","
fi

##########Check default user status###########
a="Disable_default_user"
b=0
for user in bin daemon adm lp sync shutdown halt mail uucp operator games gopher ftp nobody dbus usbmuxd vcsa avahi-autoipd abrt postfix pulse oprofile xguest tcpdump saslauth apache
do
	id $user &>/dev/null
	c=$?
	if [ $c -eq 0 ];
	then
		passwd -S $user |grep PS &>/dev/null
		c=$?
		if [ $c -eq 0 ];
		then
			let b=b+1
			echo $user  >>/tmp/disable_user.uqlf	
		else
			echo $user  >>/tmp/disable_user.qlf
		fi
	else
		echo $user  >>/tmp/disable_user.qlf
	fi
done
if [ $b -eq 0 ];
then
        echo "\"$a\":\"Qualified\","
        e=`cat /tmp/disable_user.qlf |wc -l`
        d=0
        echo "\"Disable_default_users\":{"
        for users in `cat /tmp/disable_user.qlf`
        do
                echo -e "\t\"$users\":\"Qualified\""
                let d=d+1
                if [ $d -lt $e ];
                then
                echo -e "\t,"
                fi
        done
        echo -e "\t},"
else
        echo "\"$a\":\"Unqualified\","
        echo "\"Disable_default_users\":{"
        if [ -f /tmp/disable_user.qlf ]
        then
                for users in `cat /tmp/disable_user.qlf`
                do
                        echo -e "\t\"$users\":\"Qualified\""
                        echo -e "\t,"
                done
        fi
        d=0
        e=`cat /tmp/disable_user.uqlf |wc -l`
        for users in `cat /tmp/disable_user.uqlf`
        do
             echo -e "\t\"$users\":\"Unqualified\""
             let d=d+1
             if [ $d -lt $e ];
             then
                  echo -e "\t,"
             fi
        done
        echo -e "\t},"
fi
rm -f /tmp/disable_user.uqlf &>/dev/null
rm -f /tmp/disable_user.qlf &>/dev/null

############Check SU permissions for users##########
a="SU_permissions"	
cat /etc/pam.d/su |grep -Ev ^# |grep pam_wheel &>/dev/null
b=$?
if [ $b -eq 0 ];
then
        echo "\"$a\":\"Qualified\","
else
        echo "\"$a\":\"Unqualified\","
fi


##############Check the service need been enabled n##########
a="Enable_service"
if [ $os_level -eq 6 ] || [ $os_level -eq 7 ];
then
	log_server=rsyslog
else
	log_server=syslog
fi
c=0
for service in $log_server ntpd auditd sshd
do
	ls  /etc/rc$run_level.d/ |grep -E ^S |grep $service &>/dev/null
        b=$?
        if [ $b -ne 0 ];
        then
           let c=c+1
	   echo $service >>/tmp/enable_service.uqlf
	else
	   echo $service >>/tmp/enable_service.qlf
        fi
done
if [ $c -gt 0 ];
then
        echo "\"$a\":\"Unqualified\","
	echo "\"Enable_services\":{"
	if [ -f /tmp/enable_service.qlf ]
	then	
	  	for service in `cat /tmp/enable_service.qlf`
        	do
                	echo -e "\t\"$service\":\"Qualified\""
                	echo -e "\t,"
        	done
	fi
	d=0
        e=`cat /tmp/enable_service.uqlf |wc -l`
        for service in `cat /tmp/enable_service.uqlf`
        do
             echo -e "\t\"$service\":\"Unqualified\""
             let d=d+1
             if [ $d -lt $e ];
             then
                  echo -e "\t,"
             fi
        done
        echo -e "\t},"
else
        echo "\"$a\":\"Qualified\","
	e=`cat /tmp/enable_service.qlf |wc -l`
	d=0
	echo "\"Enable_services\":{"
	for service in `cat /tmp/enable_service.qlf`
	do
		echo -e "\t\"$service\":\"Qualified\""
		let d=d+1
		if [ $d -lt $e ];
		then
		echo -e	"\t,"
		fi
        done
        echo -e "\t},"
fi
rm -f /tmp/enable_service.qlf &>/dev/null
rm -f /tmp/enable_service.uqlf &>/dev/null


##############Check the service need been dissbled n##########
a="Disable_service"
c=0
for service in NetworkManager abrt-ccpp abrtd acpid autofs bluetooth certmonger cpuspeed cups dnsmasq firstboot httpd ip6tables mdmonitor netconsole netfs nfs nfslock ntpdate numad portreserve postfix rngd rpcgssd rpcidmapd rpcsvcgssd saslauthd spice-vdagentd sssd rhnsd rhsmcertd  wdaemon winbind wpa_supplicant ypbind xinetd sendmail smb vsftpd dhcpd isdn
do
        ls  /etc/rc$run_level.d/ |grep -E ^S |grep $service &>/dev/null
        b=$?
        if [ $b -eq 0 ];
        then
           let c=c+1
           echo $service >>/tmp/disable_service.uqlf
        else
           echo $service >>/tmp/disable_service.qlf
        fi
done
if [ $c -gt 0 ];
then
        echo "\"$a\":\"Unqualified\","
        echo "\"Disable_services\":{"
        if [ -f /tmp/disable_service.qlf ]
        then
                for service in `cat /tmp/disable_service.qlf`
                do
                        echo -e "\t\"$service\":\"Qualified\""
                        echo -e "\t,"
                done
        fi
        d=0
        e=`cat /tmp/disable_service.uqlf |wc -l`
        for service in `cat /tmp/disable_service.uqlf`
        do
             echo -e "\t\"$service\":\"Unqualified\""
             let d=d+1
             if [ $d -lt $e ];
             then
                  echo -e "\t,"
             fi
        done
        echo -e "\t},"
else
        echo "\"$a\":\"Qualified\","
        e=`cat /tmp/disable_service.qlf |wc -l`
        d=0
        echo "\"Disable_services\":{"
        for service in `cat /tmp/disable_service.qlf`
        do
                echo -e "\t\"$service\":\"Qualified\""
                let d=d+1
                if [ $d -lt $e ];
                then
                echo -e "\t,"
                fi
        done
        echo -e "\t},"
fi
rm -f /tmp/disable_service.qlf &>/dev/null
rm -f /tmp/disable_service.uqlf &>/dev/null

###############Check system history size############
a="History_size"
if [ -z $HISTSIZE ] || [ -z $HISTFILESIZE ];
then
	echo "\"$a\":\"Unqualified\","
else
	if [ $HISTSIZE -gt 4095 ] && [ $HISTFILESIZE -gt 65535 ];
	then
		echo "\"$a\":\"Qualified\","
	else
		echo "\"$a\":\"Unqualified\","
	fi
fi

#################Check operation system umask############
a="Umask"
b=0
d=0
grep "umask 022" /etc/profile &>/dev/null
c=$?
if [ $c -eq 0 ]
then
	grep "umask 077" /etc/profile &>/dev/null
	c=$?
	if [ $c -eq 0 ];
	then
	b=1
	fi
fi
grep "umask 022" /etc/bashrc &>/dev/null
c=$?
if [ $c -eq 0 ]
then    
        grep "umask 077" /etc/bashrc &>/dev/null
        c=$?
        if [ $c -eq 0 ];
        then
        d=1
	fi
fi
if [ $b -eq 1 ] && [ $d -eq 1 ];
then
	echo  "\"$a\":\"Qualified\","
else
	echo  "\"$a\":\"Unqualified\","
fi

###########Check whether the file cancels special privilege##########
a="Cancel_special_privileges"
c=0
for file in /usr/bin/chage /usr/bin/gpasswd /usr/bin/wall /usr/bin/chfn /usr/bin/chsh /usr/bin/newgrp /usr/bin/write /usr/sbin/usernetctl /bin/mount /bin/umount /sbin/netreport
do
	ls -l $file |cut -d'.' -f 1 |grep s &>/dev/null
	b=$?
	if [ $b -eq 0 ];
	then
	let c=c+1
	fi
done
if [ $c -gt 0 ];
then
	echo  "\"$a\":\"Unqualified\","
else
	echo  "\"$a\":\"Qualified\","	
fi

#######Verify the passwd file modification is prohibited########
a="Forbid_modify_important_files"
c=0
for file in /etc/passwd /etc/shadow /etc/group /etc/gshadow
do
	lsattr $file |cut -d' ' -f 1 |grep i &>/dev/null
	b=$?
        if [ $b -ne 0 ];
        then
        let c=c+1
        fi
done
if [ $c -gt 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
fi
#############Check important file permissions###########
a="Important_file_permissions"
c=0
for file in /etc/audit/auditd.conf /var/log/audit/audit.log /var/log/messages /var/log/cron /var/log/secure /etc/$log_server.conf
do
	ls -l $file  |cut -b 4,6,7,8,9,10  |grep -e '------' &>/dev/null
        b=$?
        if [ $b -ne 0 ];
        then
        let c=c+1
        fi
done
if [ $c -gt 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
fi

#############Check Whether to disable the Ctrl-alt-delete shuotcut key##########
a="Disable_ctrl_alt_del"
if [ $os_level -eq 6 ];
then
	if [ -f /etc/init/control-alt-delete.conf ]
	then
		cat /etc/init/control-alt-delete.conf |grep -Ev ^# |grep "Control-Alt-Delete" |grep ^exec &>/dev/null
		b=$?
		if [ $b -eq 0 ];
		then
			echo  "\"$a\":\"Unqualified\","
		else
			echo  "\"$a\":\"Qualified\","
		fi
	else
		echo  "\"$a\":\"Qualified\","
	fi
elif [ $os_level -lt 6 ];
then
	cat /etc/inittab |grep ^ca::ctrlaltdel &>/dev/null
        b=$?
        if [ $b -eq 0 ];
        then
                echo  "\"$a\":\"Unqualified\","
        else
                echo  "\"$a\":\"Qualified\","
        fi
elif [ -f /usr/lib/systemd/system/ctrl-alt-del.target ];
then
	echo  "\"$a\":\"Unqualified\","
else
	echo  "\"$a\":\"Qualified\","
fi

##########check Whether to allow root to log on#############
a="Allow_remote_root"
cat /etc/ssh/sshd_config |grep -Ev ^# |grep PermitRootLogin |grep no &>/dev/null
b=$?
if [ $b -ne 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
        fi
###############check sshd server Port####################
a="SSH_port"
cat /etc/ssh/sshd_config |grep -Ev ^# |grep Port |grep 10022 &>/dev/null
b=$?
if [ $b -ne 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
        fi

#############Check SSH banner#############
a="SSH_banner"
cat /etc/ssh/sshd_config |grep -Ev ^# |grep Banner &>/dev/null
b=$?
if [ $b -eq 0 ];
then
	grep $os_level `cat /etc/ssh/sshd_config |grep -Ev ^# |grep Banner | awk -F' ' '{print $2}'` &>/dev/null
	b=$?
	if [ $b -eq 0 ];
	then
        	echo  "\"$a\":\"Unqualified\","
	else
        	echo  "\"$a\":\"Qualified\","
        fi	
else
        echo  "\"$a\":\"Qualified\","
        fi

#############Check SSH client address restrictions#############
a="SSH_host_restriction"
cat /etc/hosts.deny  |grep "sshd:all" &>/dev/null
b=$?
if [ $b -ne 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
fi

#############Check passwd maximum vaildity#############
a="Password_max_days"
b=`cat /etc/login.defs |grep -Ev ^# |grep PASS_MAX_DAYS |awk -F' ' '{print $2}'` &>/dev/null
c=$?
if [ $c -eq 0 ];
then
	if [ $b -gt 90 ];
	then
		echo  "\"$a\":\"Unqualified\","
	else
		echo  "\"$a\":\"Qualified\","
	fi
else
	echo  "\"$a\":\"Unqualified\","
fi

#############Check minimum password length#############
a="Password_min_len"
b=`cat /etc/login.defs |grep -Ev ^# |grep PASS_MIN_LEN |awk -F' ' '{print $2}'`
c=$?
if [ $c -eq 0 ];
then
        if [ $b -lt 8 ];
        then
                echo  "\"$a\":\"Unqualified\","
        else
                echo  "\"$a\":\"Qualified\","
	fi
else
        echo  "\"$a\":\"Unqualified\","
fi

#############Check password complexity#############
a="Password_complexity"
cat /etc/pam.d/system-auth |grep pam_cracklib.so  |grep dcredit=2 &>/dev/null
b=$?
if [ $b -eq 0 ];
then
	cat /etc/pam.d/system-auth |grep pam_cracklib.so  |grep lcredit=2 &>/dev/null
	b=$?
        if [ $b -eq 0 ];
        then
		cat /etc/pam.d/system-auth |grep pam_cracklib.so  |grep ucredit=2 &>/dev/null
        	b=$?
		if [ $b -eq 0 ];
		then
			cat /etc/pam.d/system-auth |grep pam_cracklib.so  |grep minclass &>/dev/null
                	b=$?
                	if [ $b -eq 0 ];
                	then
				echo  "\"$a\":\"Qualified\","
			else
				echo  "\"$a\":\"Unqualified\","
			fi
		else
			echo  "\"$a\":\"Unqualified\","
		fi
	else
		echo  "\"$a\":\"Unqualified\","
        fi
else
        echo  "\"$a\":\"Unqualified\","
fi


#############Check login timeout exit time#############
a="TMOUT"
if [ -z $TMOUT ];
then
	echo  "\"$a\":\"Unqualified\","
elif [ $TMOUT -gt 300 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
fi

#############Check log contents#############
a="Log_record"
cat /etc/$log_server.conf |grep -Ev ^# |grep messages |grep kern.debug  &>/dev/null
b=$?
if [ $b -eq 0 ];
then	
	echo  "\"$a\":\"Qualified\","
else
	echo  "\"$a\":\"Unqualified\","
fi


#############Check log retention period#############
a="Log_archive_policy"
head -20 /etc/logrotate.conf |grep -Ev ^# |grep monthly &>/dev/null
b=$?
if [ $b -eq 0 ];
then
        b=`head -20 /etc/logrotate.conf |grep -Ev ^# |grep ^rotate |cut -d' ' -f2`
	if [ -z $b ];
	then
		echo  "\"$a\":\"Unqualified\","
	else
		if [ $b -lt 5 ];
		then
			echo  "\"$a\":\"Unqualified\","
		else
			echo  "\"$a\":\"Qualified\","
		fi
	fi
else
        echo  "\"$a\":\"Unqualified\","
fi


#############Check the number of failed logins#############
a="User_authentication"
cat /etc/pam.d/system-auth |grep -Ev ^# |grep "pam_tally" |grep "deny=5" |grep "unlock_time=300" &>/dev/null
b=$?
if [ $b -ne 0 ];
then
        echo  "\"$a\":\"Unqualified\","
else
        echo  "\"$a\":\"Qualified\","
fi


###############Check openssl version##############
a="Upgrade_openssl"
b=`openssl  version -v |cut -d' ' -f2`
if [ -z $b ];
then
        echo  "\"$a\":\"Unqualified\","
else
        if [ $b == 1.0.2l ] || [ $b == 1.1.0b ]
        then
                echo  "\"$a\":\"Qualified\","
        else
                echo  "\"$a\":\"Unqualified\","
        fi
fi

###############Check NTPD version##############
a="Upgrade_ntpd"
ntpd --version |grep "4.2.8p10" &>/dev/null
b=$?
if [ $b -eq 0 ];
then
	echo  "\"$a\":\"Qualified\""
else
        echo  "\"$a\":\"Unqualified\""
        fi

echo "}"

}

###################Output to file or screen######################

#check_linux >$CHECK_REPORT_PATH/$CHECK_NAME;

check_linux;
