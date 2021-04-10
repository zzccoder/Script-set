#--root
#jjsc_1024Mysql
#--MySQL status
#mysql -uroot -pjjsc_1024Mysql
#show variables like 'log_bin';
#--Create BakDIR at /Data
#mkdir mysql_bakup
#configure crontab task
#crontab -e
#0 3 * * * /Data/mysql_bakup/mysqlFullBackup.sh >/dev/null 2>&1

#!/bin/bash
#Name:mysqlFullBackup.sh
#PS:MySQL DataBase Full Backup.
#Write by:zzc
#Last Modify:2017-4-17
#
#Use mysqldump --hlep get more detail.

scriptsDir=`pwd`
mysqlDir=/Data/mysql
dataBackupDir=/Data/mysql_bakup/
user=root
userPWD=jjsc_1024Mysql
logFile=$dataBackDir/mysqlbackup.log
DATE=`date -I`

cd $dataBackupDir
dumpFile=mysql_$DATE.sql
GZDumpFile=mysql_$DATE.sql.tar.gz

mysqldump -u$user -p$userPWD --opt --default-character-set=utf8 --extended-insert=false --triggers -R --hex-blob --all-databases --flush-logs --delete-master-logs --delete-master-logs 
-x > $dumpFile







30 1 * * 6 root mysqldump -u root -pPASSWORD --all-databases | gzip > /mnt/disk2/database_`date '+%m-%d-%Y'`.sql.gz

 