#!/bin/bash
# Program
# use cp to backup mysql data everyday!
# History
# Path
BakDir=/home/mysql/backup/daily                     //��������ʱ����mysql-bin.00000*��Ŀ��Ŀ¼����ǰ�ֶ��������Ŀ¼
BinDir=/home/mysql/data                                   //mysql������Ŀ¼
LogFile=/home/mysql/backup/bak.log
BinFile=/home/mysql/data/mysql-bin.index           //mysql��index�ļ�·������������Ŀ¼�µ�
/usr/local/mysql/bin/mysqladmin -uroot -p123456 flush-logs
#��������ڲ����µ�mysql-bin.00000*�ļ�
Counter=`wc -l $BinFile |awk '{print $1}'`
NextNum=0
#���forѭ�����ڱȶ�$Counter,$NextNum������ֵ��ȷ���ļ��ǲ��Ǵ��ڻ����µ�
for file in `cat $BinFile`
do
    base=`basename $file`
    #basename���ڽ�ȡmysql-bin.00000*�ļ�����ȥ��./mysql-bin.000005ǰ���./
    NextNum=`expr $NextNum + 1`
    if [ $NextNum -eq $Counter ]
    then
        echo $base skip! >> $LogFile
    else
        dest=$BakDir/$base
        if(test -e $dest)
        #test -e���ڼ��Ŀ���ļ��Ƿ���ڣ����ھ�дexist!��$LogFileȥ
        then
            echo $base exist! >> $LogFile
        else
            cp $BinDir/$base $BakDir
            echo $base copying >> $LogFile
         fi
     fi
done
echo `date +"%Y��%m��%d�� %H:%M:%S"` $Next Bakup succ! >> $LogFile