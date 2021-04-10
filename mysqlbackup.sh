#�������ݿ��������ݿ��¼�������룬����·������־·���������ļ�λ�ã�
#�Լ����ݷ�ʽ 
#Ĭ������±��ݷ�ʽ��tar����������mysqldump,mysqldotcopy 
#Ĭ������£���root(��)��¼mysql���ݿ⣬������/root/dbxxxxx.tgz 

DBName="test"
DBUser="root"
DBPasswd="123456"
BackupPath="/data/mysql_backup/"
LogFile="/data/mysql_backup/db.log"
#DBPath="/opt/lamp/mysql/"
BackupMethod="mysqldump"
BackupMethodPath="/opt/lamp/bin/mysqldump"

NewFile="$BackupPath"db$(date +%y%m%d).tgz
DumpFile="$BackupPath"db$(date +%y%m%d) 
OldFile="$BackupPath"db$(date +%y%m%d --date='5 days ago').tgz

echo "-------------------------------------------" >> $LogFile 
echo $(date +"%y-%m-%d %H:%M:%S") >> $LogFile 
echo "--------------------------" >> $LogFile

#Delete Old File 
if [ -f $OldFile ]
then
   rm -f $OldFile >> $LogFile 2>&1
   echo "[$OldFile]Delete Old File Success!" >> $LogFile 
else
   echo "[$OldFile]No Old Backup File!" >> $LogFile 
fi

if [ -f $NewFile ] 
then 
   echo "[$NewFile]The Backup File is exists, Can't Backup!" >> $LogFile 
else 
   case $BackupMethod in 
   mysqldump)
      if [ -z $DBPasswd ] 
      then
        echo "$BackupMethodPath -u $DBUser --opt $DBName > $DumpFile"
        $BackupMethodPath -u $DBUser --opt $DBName > $DumpFile 
      else 
        echo "$BackupMethodPath -u $DBUser -p$DBPasswd --opt $DBName"
        $BackupMethodPath -u $DBUser -p$DBPasswd --opt $DBName > $DumpFile 
      fi
      tar -czvf $NewFile $DumpFile >> $LogFile 2>&1 
      echo "[$NewFile]Backup Success!" >> $LogFile 
      rm -rf $DumpFile 
      ;; 
   mysqlhotcopy) 
      rm -rf $DumpFile
      mkdir $DumpFile
      if [ -z $DBPasswd ]
      then
         mysqlhotcopy -u $DBUser $DBName $DumpFile >> $LogFile 2>&1
      else
         mysqlhotcopy -u $DBUser -p $DBPasswd $DBName $DumpFile >>$LogFile 2>&1
      fi
      tar czvf $NewFile $DumpFile >> $LogFile 2>&1
      echo "[$NewFile]Backup Success!" >> $LogFile
      rm -rf $DumpFile
      ;;
   esac
fi

echo "-------------------------------------------" >> $LogFile