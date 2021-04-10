#!/bin/bash
# Program
# use mysqldump to Fully backup mysql data per week!
# History
# Path
BakDir=/home/mysql/backup
LogFile=/home/mysql/backup/bak.log
Date=`date +%Y%m%d`
Begin=`date +"%Y年%m月%d日 %H:%M:%S"`
cd $BakDir
DumpFile=$Date.sql
GZDumpFile=$Date.sql.tgz
/usr/local/mysql/bin/mysqldump -uroot -p123456 --quick --events --all-databases --flush-logs --delete-master-logs --single-transaction > $DumpFile
/bin/tar -zvcf $GZDumpFile $DumpFile
/bin/rm $DumpFile
Last=`date +"%Y年%m月%d日 %H:%M:%S"`
echo 开始:$Begin 结束:$Last $GZDumpFile succ >> $LogFile
cd $BakDir/daily
/bin/rm -f *