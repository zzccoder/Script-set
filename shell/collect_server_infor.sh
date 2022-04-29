#!/bin/bash
#Auto get system info
#By author jfedu.net 2019
#Define Path variables
echo -e "\033[34m \033[1m" cat <<EOF
++++++++++++++++++++++++++++++++++++++++++++++
++++++++Welcome to use system Collect+++++++++
++++++++++++++++++++++++++++++++++++++++++++++
EOF
ip_info=`ifconfig |grep "Bcast"|tail -1 |awk '{print $2}'|cut -d: -f 2` 
cpu_info1=`cat /proc/cpuinfo |grep 'model name'|tail -1 |awk -F: '{print $2}'|sed 's/^ //g'|awk '{print $1,$3,$4,$NF}'` 
cpu_info2=`cat /proc/cpuinfo |grep "physical id"|sort |uniq -c|wc -l`
serv_info=`hostname |tail -1` 
disk_info=`fdisk -l|grep "Disk"|grep -v "identifier"|awk '{print $2,$3,$4}'|sed 's/,//g'` 
mem_info=`free -m |grep "Mem"|awk '{print "Total",$1,$2"M"}'`
load_info=`uptime |awk '{print "Current Load: "$(NF-2)}'|sed 's/\,//g'`
mark_info='BeiJing_IDC' 

echo -e "\033[32m-------------------------------------------\033[1m" 
echo IPADDR:${ip_info}
echo HOSTNAME:$serv_info
echo CPU_INFO:${cpu_info1} X${cpu_info2}
echo DISK_INFO:$disk_info
echo MEM_INFO:$mem_info
echo LOAD_INFO:$load_info
echo -e "\033[32m-------------------------------------------\033[0m" echo -e -n "\033[36mYou want to write the data to the databases? \033[1m" ；

read ensure
if [ "$ensure" == "yes" -o "$ensure" == "y" -o "$ensure" == "Y" ]；then
    echo "--------------------------------------------" 
    echo -e '\033[31mmysql -uaudit -p123456 -D audit -e ''' "insert into audit_system values('','${ip_info}','$serv_info','${cpu_info1} X${cpu_info2}','$disk_info','$mem_info','$load_info','$mark_info')" ''' \033[0m '
    mysql -uroot -p123456 -D test -e "insert into audit_system values('','${ip_info}','$serv_info','${cpu_info1} X${cpu_info2}','$disk_info','$mem_info','$load_info','$mark_info')"
else
    echo "Please wait，exit......" exit
fi