#!/bin/bash
 
# Author : Hongbao Wang
# Date : 2021/09/28
# Description : This script is used to detect F5 status information.
 
 
#define variable
hostname=`uname -a |cut -d ' ' -f2`
date=`date +"%y%m%d"`
 
 
# begin_function
function begin_execute(){
  echo -e "\033[32m\nBegin to execute shell script,Please Wait for a few minutes.\033[0m"
  echo "------------------------------------------------------------"
}
 
# output base_info
function base_info(){
 
  echo -e "\033[33m1. Basic equipment information\033[0m"
 
  #output hostname
  echo -e "\t 1). Hostname :\t\t\t\t $hostname"
 
  #output model
  model=`tmsh  show sys hardware|grep -A 1 "Platform"|grep ^"  Name"|awk -F "Name  " '{print $2}'`
  echo -e "\t 2). BIG-IP Model : \t\t\t $model"
 
  #output Serial Number
  sn=`tmsh show sys hardware | grep "Chassis Serial"|awk '{print $3}'`
  echo -e "\t 3). Serial Number : \t\t\t $sn"
 
  #output ManagementIP
  ManagementIP=`tmsh list sys management-ip |awk '{print $3}'`
  echo -e "\t 4). Management_IP : \t\t\t $ManagementIP"
 
  #output Version
  F5version=`tmsh show sys version|grep 'Version '|awk '{print $2}'`
  echo -e "\t 5). BIG-IP Version : \t\t\t $F5version \n"
}
 
 
# output cluster_info
function cluster_info(){
 
  echo -e "\033[33m2. Cluster status information\033[0m"
 
  #output Failover-status
  failoverstatus=`tmsh  show cm failover-status  | grep ^"Status" | awk '{print $2}'`
  echo -e "\t 1). Failover Status : \t\t\t $failoverstatus"
 
  #output Sync-status
  syncstatus=`tmsh  show cm sync-status  | grep ^"Status" | awk '{print $2,$3}' `
  echo -e "\t 2). Sync Status : \t\t\t $syncstatus \n"
}
 
 
 
function stastistic(){
 
  echo -e "\033[33m3. Business status information\033[0m"
 
  #output CPU Utilization
  cpu=`tmsh show sys cpu|grep "Utilization"|awk '{print $3}'`
  echo -e "\t 1). CPU Utilization :\t\t\t $cpu%"
 
  #output Memory Utilization
  mem=`tmsh show sys memory|grep "TMM Memory Used"|awk '{print $5}' `
  echo -e "\t 2). Memory Utilization :\t\t $mem%"
 
  #output Number of New Connnections
  new_conn=`tmsh show sys performance | grep "Client Connections"|awk '{print $3}'`
  echo -e "\t 3). New Connections : \t\t\t $new_conn"
 
  #output Number of Total Connections
  active_conn=`tmsh show sys performance connections| grep ^"Connections"|awk '{print $3}'`
  echo -e "\t 4). Total Connections : \t\t $active_conn"
 
  #output Throughout
  throughput=`tmsh show sys performance throughput | grep "Service"|head -1|awk '{print $2}'`
  echo -e "\t 5). Throughput : \t\t\t $throughput \n"
 
  #output virtual Status
  echo -e "\033[33m4. Virtual Server Health Information\033[0m"
  virtual_name=`tmsh list ltm virtual| grep "ltm virtual "|awk '{print $3}'`
  available_=0
  unknown_=0
  offline_=0
 
  for virtual_ in $virtual_name
  do
    vs_status=`tmsh show ltm virtual $virtual_ | grep Availability|awk '{print $3}'`
    if [[ $vs_status = "available" ]] ;then
        available_=$[$available_+1]
    elif [[ $vs_status = "unknown" ]] ;then
      unknown_=$[$unknown_+1]
    elif [[ $vs_status = "offline" ]] ;then
      offline_=$[$offline_+1]
    fi
  done
  echo -e "\t 1). Virtial Available : \t\t $available_"
  echo -e "\t 2). Virtial unknown : \t\t\t $unknown_"
  echo -e "\t 3). Virtial offline : \t\t\t $offline_ \n"
}
 
 
function log_status(){
 
  #output Nummber of System Warning Log
  echo -e "\033[33m5. Log Warning Information\033[0m"
 
  sys_log=`cat /var/log/messages|grep -E 'warning|err|emerg|crit|alert'|wc -l`
  echo -e "\t 1). System Warning Log : \t\t $sys_log"
 
  #output Number of Ltm Warning Log
  ltm_log=`cat /var/log/ltm|grep -E 'warning|err|emerg|crit|alert'|wc -l`
  echo -e "\t 2). LTM Warning Log : \t\t\t $ltm_log"
 
  #output Number of GTM Warning Log
  gtm_log=`cat /var/log/gtm|grep -E 'warning|err|emerg|crit|alert'|wc -l`
  echo -e "\t 3). GTM Warning Log : \t\t\t $gtm_log"
 
  #LCD log
  lcd_log=`tmsh show sys alert|grep -E 'warning|err|emerg|crit|alert'|wc -l`
  echo -e "\t 4). LCD Warning Log : \t\t\t $lcd_log \n"
}
 
 
function device_hardware(){
 
  echo -e "\033[33m6. Device Hardware Information\033[0m"
 
  #output fanstatus
  fanstatus=`tmsh show sys hardware field-fmt | grep fan-speed | awk '{if($2<1000){print $2}}'|wc -l`
  if [ $fanstatus == "0" ];then
    echo -e "\t 1). Device Fans Status : \t\t Success"
  else
    echo -e "\t\033[31m1). Device Fans Status : \t\t Failed\033[0m"
  fi
 
 
  #output Temperature status
  temperature=`tmsh show sys hardware |grep "Main board"|awk '{if($3>=$4){print "Temperature High"}}'|wc -l`
 
  if [ $temperature == '0' ];then
    echo -e "\t 2). Device Temperature Status : \t Success"
  else
    echo -e "\t\033[31m2). Device Temperature Status : \t Failed\033[0m"
  fi
 
  #powerstatus
  power_number=`tmsh show sys hardware field-fmt | grep "chassis-power-supply-status-index"|awk '{print $4}'`
 
  for power_name in $power_number
  do
    power_status=`tmsh show sys hardware field-fmt | grep -A4 "chassis-power-supply-status-index $power_name"| grep "status up"|wc -l`
    if [ $power_status == "1" ];then
      echo -e "\t 3). Power Supply $power_name : \t\t\t Success"
    else
      echo -e "\t\033[31m 3). Power Supply $power_name : \t\t\t Failed\033[0m"
    fi
  done
 
  #Trunk Used Interface Status
  echo -e "\033[33m\n7. Device Interface Information\033[0m"
 
  trunk_name=`tmsh list net vlan one-line | grep "interfaces"| awk -F "interfaces { " '{print $2}'|awk -F " {" '{print $1}'|sort -u|grep -v ^"[0-9]"`
  for trunk_ in $trunk_name
  do
  trunk_interface=`tmsh list net trunk $trunk_ interfaces | awk '{print $1}'|grep ^[0-9]`
  for interface_ in $trunk_interface
    do
      isun=`tmsh show net interface $interface_ field-fmt | grep "status up"|wc -l`
      if [[ $isun == "1" ]];then
        echo -e "\t Trunk : $trunk_ Interface $interface_ Status : \t Success"
      else
 
    echo -e "\t\033[31m Trunk : $trunk_ Interface $interface_ Status : \t Failed\033[0m"
      fi
    done
  done
 
  #Vlan Used Interface Status
  interface_name=`tmsh list net vlan one-line | grep "interfaces"| awk -F "interfaces { " '{print $2}'|awk -F " {" '{print $1}'|sort -u|grep ^[0-9]
`
  for inte_name in $interface_name
  do
    interface_sta=`tmsh show net interface $inte_name field-fmt | grep "status up"|wc -l`
    if [[ $interface_sta == "1" ]];then
        echo -e "\t Interface $inte_name Status : \t\t Success"
      else
        echo -e "\t\033[31m Interface $inte_name Status : \t\t Failed\033[0m"
      fi
    done
}
 
 
function backup_config(){
 
  #backup config
  echo -e "\n\033[33m8. Backup configuration\033[0m"
 
  dir="/var/local/ucs/"
 
  tmsh save sys ucs $date$hostname.ucs  >/dev/null 2>&1
 
  backup=`find $dir -name $date$hostname.ucs`
  if [[ $backup =~ ".ucs" ]]
  then
    echo -e "\tUCS Backup :  \t\t\t\t Success"
  else
    echo -e "\t\033[31m UCS Backup :  \t\t\t\t Failed\033[0m"
  fi
}
 
# finish_execute
function finish_execute(){
 
  echo -e "\n------------------------------------------------------------"
  echo -e "\033[32mDevice Check Finish .\n\033[0m"
}
 
begin_execute
base_info
cluster_info
stastistic
log_status
device_hardware
backup_config
finish_execute