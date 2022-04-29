
#!/bin/bash
#auto backup mysql
####


#Define PATH 定义变量
BAK_DIR=/data/backup/mysql/`date +%Y-%m-%d` MYSQLDB=webapp
MYSQLPW=backup
MYSQLUSR=backup
#must use root user run scripts 必须使用 root 用户运行，$UID 为系统变量
if
[ $UID -ne 0 ]；then
echo This script must use the root user ! ! !
sleep 2
exit 0
fi
#Define DIR and mkdir DIR 判断目录是否存在，不存在则新建
if
[ ！ -d $BAKDIR ]；then
mkdir -p $BAKDIR
fi
#Use mysqldump backup Databases
/usr/bin/mysqldump -u$MYSQLUSR -p$MYSQLPW -d
$MYSQLDB >$BAKDIR/webapp_db.sql
echo "The mysql backup successfully "