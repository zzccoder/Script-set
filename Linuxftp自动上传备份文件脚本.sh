Linux ftp 自动上传备份文件脚本

 
       DB 用RMAN 直接将备份文件放在盘柜上了，为了以防万一，老大让把这些备份文件在copy到一个备份服务器上。 
RMAN 对目录有严格的要求，以后如果要恢复，还是还原到相同的目录。
       之前我计划是将备份服务器共享之后，直接mount 到DB 服务器上，然后在cp 过去，这样是很简单的。
但是搞系统的大哥建议用ftp来实现。 当时说是不会出现不能umount的情况，还有啥是安全什么得，这个新年一过也记不清了。 
备份服务器上安装了Server-U 的FTP 服务，配置好之后，把备份文件传过来就可以了。
 
参考：
       Linux 终端访问 FTP 及 上传下载 文件
       http://blog.csdn.net/tianlesoftware/archive/2010/08/18/5818990.aspx
 
       Linux find 命令 -exec 参数说明
       http://blog.csdn.net/tianlesoftware/archive/2011/02/09/6175439.aspx
 
 
三步实现：
（1）. 查找符合要求的文件，放到一个临时文件夹。
（2）. 在ftp中使用mput 上传，上传完从临时文件夹中删除。
（3）. 在备份服务器上做好删除策略。不然空间会撑满掉。
 
三点说明：
（1）. 如果说只保留2天的话倒简单，在mput 之前用mdelete 把文件全部删除掉，在上传就可以了，因为我这里要保留多天的记录。
 所以就只能在备份服务器上在弄个批处理的计划任务来删除了。
（2）. mput 的时候有个问题，它会要求按下回车后在上传， 这对自动脚本来说是非常麻烦的。 我们需要关闭这个指令。
 
ftp>prompt
切换交谈式指令，使用mput/mget 时不用每个文件皆询问yes/no
ftp> help prompt
prompt          force interactive prompting on multiple commands
ftp> prompt
Interactive mode off.
ftp> prompt
Interactive mode on.
ftp> prompt
Interactive mode off.
ftp>
      
不加任何参数就可以进行开发或关闭的设备，每执行一次，状态就会改变。
 
（3） find -mtime 参数说明
find /u01/backup/backupsets -mtime +1 -name "*" ：+号 表示 1天前的文件
find /u01/backup/backupsets -mtime -1 -name "*" ：表示1天内的文件
 
 
完整脚本：
 
Linux上传脚本：
[xezf@localhost scripts]$ cat uploadbackup.sh
#!/bin/sh
find /u01/backup/backupsets -mtime -1 -name "*" -exec cp -f {} /u01/backup/backuptmp /;
ftp -n 192.168.88.251 << EOF
user user password
bin
lcd /u01/backup/backuptmp
prompt
mput *
bye
EOF
cd /u01/backup/backuptmp
rm -rf /u01/backup/backuptmp/*
 
将uploadbackup.sh脚本添加到crontab，定时执行。 关于crontab，参考我的Blog：
       Linux Crontab 定时任务 命令详解
       http://blog.csdn.net/tianlesoftware/archive/2010/02/21/5315039.aspx
 
 
备份服务器删除脚本：
 
deletebackupfile.bat
forfiles /p E:/db_backup_history/xezf /m * /d -10 /c "cmd /c del @file"
 
将这个bat 文件添加到计划任务，定时执行即可。我这里保留的是10天。