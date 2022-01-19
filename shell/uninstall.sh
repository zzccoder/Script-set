#! /bin/bash
LOG=/tmp/uninstall_`date "+%m%d%Y_%H_%M_%S"`.log
PKG_Name=`rpm -aq|grep -i occm`
val1=y
val2=n

#if [ -f $LOG ];then
#    sudo rm -rf $LOG
#fi

echo "Starting Un-install `date` Log File: $LOG" | tee -a $LOG

if [ -z $PKG_Name ];then
echo "Occm not installed"|tee -a $LOG
	if [ ! -d /backup/logs ]; then
		sudo mkdir -p /backup/logs
		sudo chmod 755 /backup/logs
	fi
exit 1
fi

declare -l string=$1
case $string in
silent )
silent=1
;;
esac

function oscheck {
	  cat /etc/*release*|grep "Amazon Linux 2" > /dev/null
	  if [ $? -eq 0 ]; then
		  AMZNLinux=1
    fi
  return
}

function uninstall {
echo "Please make sure to take a backup before uninstalling existing NetApp OnCommand Cloud Manager,"
echo -en "Type \e[1m'Y'\e[0m to continue with uninstall or \e[1m'N'\e[0m to go back and take a backup: "
read input
declare -l str=$input
while [[ "$str" != $val1 && "$str" != $val2 ]];do
	echo -n "ERROR: Must Enter [Y / N]: "
	read str
done

if [ $str == y ];then
	echo -n "Are you sure you want to completely remove NetApp OnCommand Cloud Manager? [Y / N]: "
	read input1
	declare -l str1=$input1
	while [[ "$str1" != $val1 && "$str1" != $val2 ]];do
		echo -n "ERROR: Must Enter [Y / N]: "
		read str1
	done
	if [ $str1 == y ];then
		sudo rpm -e $PKG_Name | tee -a $LOG
		sudo rpm -aq|grep -i occm
		sudo rm -f /etc/yum.repos.d/my.repo
		sudo yum clean all
		if [ $? == 1 ];then
			echo "***** Netapp OnCommand Cloud Manager was successfully removed from you computer *****" | tee -a $LOG
		fi

		echo -n "Do you wish to remove all the components installed by NetApp OnCommand Cloud Manager (awscli, tridentctl, kubectl, p7zip, Squid, MySQL and Java 1.8 applications, docker) from your computer? [Y / N]: "
		read input2
		declare -l str2=$input2
		while [[ "$str2" != $val1 && "$str2" != $val2 ]];do
			echo -n "ERROR: Must Enter [Y / N]: "
			read str2
		done
		if [ $str2 == y ];then
            if [[ $AMZNLinux -eq 0 ]];then
            sudo yum remove -y docker
            sudo rm -f /usr/local/bin/docker-compose
            echo " ***** Docker was  successfully removed from you computer *****" | tee -a $LOG
            fi
          if [[ $AMZNLinux -ne 1 ]];then
			yum makecache fast >> $LOG
  			sudo docker stop $(docker ps -a -q)
	  		sudo docker rm $(docker ps -a -q)
			sudo rm -rf /usr/local/aws
			sudo rm -f /usr/bin/aws
			echo "***** awscli was successfully removed removed from you computer *****" | tee -a $LOG
          fi

			sudo rm -rf /usr/bin/tridentctl
			echo "***** tridentctl was successfully removed removed from you computer *****" | tee -a $LOG

			sudo rm -rf /usr/bin/kubectl >> $LOG
			echo "***** kubectl was successfully removed removed from you computer *****" | tee -a $LOG

			#sudo yum -y remove mysql-community-server >> $LOG
			sudo yum-complete-transaction >> $LOG
			sudo yum -y remove mysql-community-common >> $LOG
			sudo yum -y remove mysql-community-release >> $LOG
			#sudo yum -y remove mysql-community-client >> $LOG
			sudo rm -Rf /var/lib/mysql
			sudo rm -Rf /usr/share/mysql
			sudo rpm -aq|grep -i mysql
			if [ $? == 1 ];then
				echo "***** MySQL was successfully removed removed from you computer *****" | tee -a $LOG
			fi

			sudo yum -y remove java-1.8.0-openjdk >> $LOG
			sudo yum -y remove java-1.8.0-openjdk-headless >> $LOG
			sudo rpm -aq|grep -i java-1.8.0-openjdk
			if [ $? == 1 ];then
				echo "***** Java 1.8 was successfully removed removed from you computer *****" | tee -a $LOG
			fi

            if [[ $AMZNLinux -ne 1 ]];then
             sudo yum -y remove createrepo >> $LOG
			 sudo yum -y remove deltarpm >> $LOG
			 cd /tmp/
			 sudo rpm -qa |egrep "deltarpm|createrepo"
			  if [ $? == 1 ];then
			    echo "***** CreateRepo was successfully removed from you computer  *****" | tee -a $LOG
			  fi

    		 sudo yum -y remove docker-ce >> $LOG
             sudo yum -y remove container-selinux >> $LOG
             sudo yum -y remove docker-ce-cli >> $LOG
             sudo rm -f /usr/local/bin/docker-composea
             cd /tmp/
             sudo rpm -qa |egrep "docker-ce|container-selinux"
             if [ $? == 1 ];then
			    echo "***** Docker was  successfully removed from you computer *****" | tee -a $LOG
			fi
           fi

			sudo yum -y erase 'p7zip*' >> $LOG
			sudo rpm -aq|grep -i p7zip
			if [ $? == 1 ];then
				echo "***** p7zip was successfully removed removed from you computer *****" | tee -a $LOG
			fi

			sudo yum -y remove squid >> $LOG
			sudo yum -y remove squid-migration-script >> $LOG
			sudo rpm -aq|grep -i squid
			if [ $? == 1 ];then
				echo "***** Squid was successfully removed removed from you computer *****" | tee -a $LOG
			fi

			#sudo yum -y erase wget >> $LOG
			#sudo rpm -aq|grep -i wget
			#if [ $? == 1 ];then
			#	echo "***** wget was successfully removed removed from you computer *****" | tee -a $LOG
			#fi
		fi
	elif [ $str1 == n ];then
		if [ ! -d /backup/logs ]; then
		sudo mkdir -p /backup/logs
		sudo chmod 755 /backup/logs
	fi
		sudo /bin/cp -rf $LOG /backup/logs
		exit 2
	fi
elif [ $str == n ];then
	if [ ! -d /backup/logs ]; then
		sudo mkdir -p /backup/logs
		sudo chmod 755 /backup/logs
	fi
	sudo /bin/cp -rf $LOG /backup/logs
	exit 3
fi
}

function uninstallsilent {
	echo "Uninstall using silent mode" >> $LOG
	if [[ $AMZNLinux -ne 1 ]];then
    sudo rpm -e $PKG_Name
	sudo rm -f /etc/yum.repos.d/my.repo
	sudo yum clean all
	sudo docker stop $(docker ps -a -q)
	sudo docker rm $(docker ps -a -q)
	sudo rpm -aq|grep -i occm
		if [ $? == 1 ];then
			echo "***** Netapp OnCommand Cloud Manager was successfully removed from your computer *****"| tee -a $LOG
		fi

	yum makecache fast >> $LOG
	sudo rm -rf /usr/local/aws
	sudo rm -f /usr/bin/aws
	  echo "***** awscli was successfully removed from your computer *****" | tee -a $LOG
	fi

    sudo rm -rf /usr/bin/tridentctl
    echo "***** tridentctl was successfully removed removed from you computer *****" | tee -a $LOG

    sudo rm -rf /usr/bin/kubectl >> $LOG
    echo "***** kubectl was successfully removed removed from you computer *****" | tee -a $LOG

	#sudo yum -y remove mysql-community-server >> $LOG
	sudo yum-complete-transaction >> $LOG
	sudo yum -y remove mysql-community-common >> $LOG
	sudo yum -y remove mysql-community-release >> $LOG
	#sudo yum -y remove mysql-community-client >> $LOG
	sudo rm -Rf /var/lib/mysql
	sudo rm -Rf /usr/share/mysql
	sudo rpm -aq|grep -i mysql
	if [ $? == 1 ];then
		echo "***** MySQL was successfully removed from your computer *****" | tee -a $LOG
	fi

	sudo yum -y remove java-1.8.0-openjdk >> $LOG
	sudo yum -y remove java-1.8.0-openjdk-headless >> $LOG
	sudo rpm -aq|grep -i java-1.8.0-openjdk
	if [ $? == 1 ];then
		echo "***** Java 1.8 was successfully removed from your computer *****" | tee -a $LOG
	fi


	sudo yum -y erase 'p7zip*' >> $LOG
	sudo rpm -aq|grep -i p7zip
	if [ $? == 1 ];then
		echo "***** p7zip was successfully removed from your computer *****" | tee -a $LOG
	fi
    if [[ $AMZNLinux -eq 0 ]];then
    sudo yum remove -y docker
    sudo rm -f /usr/local/bin/docker-compose
    echo " ***** Docker was  successfully removed from you computer *****" | tee -a $LOG
    fi
    if [[ $AMZNLinux -ne 1 ]];then
    sudo yum -y remove createrepo >> $LOG
	sudo yum -y remove deltarpm >> $LOG
	cd /tmp/
	sudo rpm -qa|egrep "deltarpm|createrepo"
	if [ $? == 1 ];then
	    echo " ***** CreateRepo was successfully removed from you computer  *****" | tee -a $LOG
	fi
    sudo yum -y remove docker-ce >> $LOG
    sudo yum -y remove container-selinux >> $LOG
    sudo yum -y remove docker-ce-cli >> $LOG
    cd /tmp/
    sudo rpm -qa|egrep "docker-ce|container-selinux"
    sudo rm -f /usr/local/bin/docker-composea
    sudo rm -f /etc/yum.repos.d/my.repo
    if [ $? == 1 ];then
			    echo " ***** Docker was  successfully removed from you computer *****" | tee -a $LOG
    fi
    fi
	#sudo yum -y erase wget >> $LOG
	#sudo rpm -aq|grep -i wget
	#if [ $? == 1 ];then
	#	echo "***** wget was successfully removed from your computer *****" | tee -a $LOG
	#fi

}

function removeenv {
	sudo sed -i '/OCCM_/d' /etc/environment
	return
}

function copylog {
	if [ ! -d /backup/logs ]; then
		sudo mkdir -p /backup/logs
		sudo chmod 755 /backup/logs
	fi
	sudo /bin/cp -rf $LOG /backup/logs
	return
}

function removeservicemanager {
	sudo systemctl stop service-manager
	sudo systemctl disable service-manager
	sudo systemctl daemon-reload
	sudo rm -Rf /usr/lib/systemd/scripts/service-manager
	sudo rm -Rf /usr/lib/systemd/system/service-manager.service
	return
}

if [[ $silent -ne 1 ]];then
uninstall
fi
if [[ $silent -eq 1 ]];then
uninstallsilent
fi
removeenv
copylog
removeservicemanager
