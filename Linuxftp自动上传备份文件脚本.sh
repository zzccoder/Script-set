Linux ftp �Զ��ϴ������ļ��ű�

 
       DB ��RMAN ֱ�ӽ������ļ������̹����ˣ�Ϊ���Է���һ���ϴ��ð���Щ�����ļ���copy��һ�����ݷ������ϡ� 
RMAN ��Ŀ¼���ϸ��Ҫ���Ժ����Ҫ�ָ������ǻ�ԭ����ͬ��Ŀ¼��
       ֮ǰ�Ҽƻ��ǽ����ݷ���������֮��ֱ��mount ��DB �������ϣ�Ȼ����cp ��ȥ�������Ǻܼ򵥵ġ�
���Ǹ�ϵͳ�Ĵ�罨����ftp��ʵ�֡� ��ʱ˵�ǲ�����ֲ���umount�����������ɶ�ǰ�ȫʲô�ã��������һ��Ҳ�ǲ����ˡ� 
���ݷ������ϰ�װ��Server-U ��FTP �������ú�֮�󣬰ѱ����ļ��������Ϳ����ˡ�
 
�ο���
       Linux �ն˷��� FTP �� �ϴ����� �ļ�
       http://blog.csdn.net/tianlesoftware/archive/2010/08/18/5818990.aspx
 
       Linux find ���� -exec ����˵��
       http://blog.csdn.net/tianlesoftware/archive/2011/02/09/6175439.aspx
 
 
����ʵ�֣�
��1��. ���ҷ���Ҫ����ļ����ŵ�һ����ʱ�ļ��С�
��2��. ��ftp��ʹ��mput �ϴ����ϴ������ʱ�ļ�����ɾ����
��3��. �ڱ��ݷ�����������ɾ�����ԡ���Ȼ�ռ���������
 
����˵����
��1��. ���˵ֻ����2��Ļ����򵥣���mput ֮ǰ��mdelete ���ļ�ȫ��ɾ���������ϴ��Ϳ����ˣ���Ϊ������Ҫ��������ļ�¼��
 ���Ծ�ֻ���ڱ��ݷ���������Ū��������ļƻ�������ɾ���ˡ�
��2��. mput ��ʱ���и����⣬����Ҫ���»س������ϴ��� ����Զ��ű���˵�Ƿǳ��鷳�ġ� ������Ҫ�ر����ָ�
 
ftp>prompt
�л���̸ʽָ�ʹ��mput/mget ʱ����ÿ���ļ���ѯ��yes/no
ftp> help prompt
prompt          force interactive prompting on multiple commands
ftp> prompt
Interactive mode off.
ftp> prompt
Interactive mode on.
ftp> prompt
Interactive mode off.
ftp>
      
�����κβ����Ϳ��Խ��п�����رյ��豸��ÿִ��һ�Σ�״̬�ͻ�ı䡣
 
��3�� find -mtime ����˵��
find /u01/backup/backupsets -mtime +1 -name "*" ��+�� ��ʾ 1��ǰ���ļ�
find /u01/backup/backupsets -mtime -1 -name "*" ����ʾ1���ڵ��ļ�
 
 
�����ű���
 
Linux�ϴ��ű���
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
 
��uploadbackup.sh�ű���ӵ�crontab����ʱִ�С� ����crontab���ο��ҵ�Blog��
       Linux Crontab ��ʱ���� �������
       http://blog.csdn.net/tianlesoftware/archive/2010/02/21/5315039.aspx
 
 
���ݷ�����ɾ���ű���
 
deletebackupfile.bat
forfiles /p E:/db_backup_history/xezf /m * /d -10 /c "cmd /c del @file"
 
�����bat �ļ���ӵ��ƻ����񣬶�ʱִ�м��ɡ������ﱣ������10�졣