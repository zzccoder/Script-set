@echo off
color 2f
title ����ϵͳ����ԱȨ�����д˽ű� 
rem ����ps�����Զ���ű�
echo.
echo.
echo.
echo.
:start
cls
echo.
echo.
echo.
echo.                 �˽ű�������Windows20012R2 ���ּ���Windows2008R2
echo.                 ������������ѡ�����
echo.                 1.������һ̨Win2012R2 AD�������
echo.                   1.1  ��װ�������
echo.                   1.2  �ӿ�д������������������/RODC��װ����
echo.                       1.2.1  ͨ����װ���ʰ�װ�������
echo.                       1.2.2  ��װRODCֻ�����
echo.                              1.2.2.1 �鿴RODC���ع���Ա��/�����˺���RODC���ع���Ա��
echo.                       1.2.3 ��װ��������
echo.                       1.2.4 ��װ����
echo.                   1.3  ж�ض������
echo.                       1.3.1  ����ʹ�õķ������Ķ���
echo.                       1.3.2  ж�����ڶ����������һ�����
echo.                       1.3.3  ж���������һ�����
echo.                       1.3.4  ж��RODCֻ�����
echo.                   1.4  ���DNS SRV��¼
echo.                   1.5  ���NTDS.dit�Ƿ񴴽��Լ�SYSVOL�ļ����Ƿ�ɹ�����������
echo.                   1.6  ��ѯ��5���ɫ��GC/ȫ���¼��������λ��
echo.                   1.7  �鿴�ֹ��ܼ�������ܼ���
echo.                          1.7.1  �����ֹ��ܼ�������ܼ���
echo.                   1.8  ע�����̨�е�ACtiveDirectory �ܹ�
echo.                   1.9  PDCģ����ʱ��ͬ���趨���ѯ
echo.                   1.10 ִ��AD���ݿ���ƶ�������������
echo.                   1.11 ִ��AD���ݿ��ѻ����飨����������  
echo.                   1.12 ִ��AD���ݿ��������
echo.                 2.�޸�Ŀ¼��ԭģʽ����
echo.                 3.����ֱ�ӽ���Ŀ¼��ԭģʽ/������������ģʽ
echo.                       3.1 ����Ŀ¼��ԭģʽ�޸������Ա����
echo.                 4.�����Զ���ȡ���ֶ��̶�IP
echo.                 5.�������ݼƻ�
echo.                 6.�鿴���޸�Win7����ϵͳ��SID
echo.                 7.Win2012����ͼ������
echo.                 8.����Win2008R2/2012R2 AD����վ����
echo.                 9.�ѻ�������
echo.                 10.ǿ�Ƹ��������
echo.                    10.1 �������������͵�½�ű�
echo.                 11.��ӿ�����������
echo.                 12.ǿ�Ƹ��������
echo.                    12.1 �ָ�Ĭ������Ժ�Ĭ�����������������ʼ״̬
echo.                    12.2 ÿ������Ա��ݼƻ�
echo.                 13.ÿ�մ浵DCDIAG��ⱨ��
echo.                 14.�������IP��ַ ������������
echo.                   14.1 ������ؼ������������������
echo.                 15.���������ת�Ʋ���������ɫ 
echo.                   15.1 ǿ���������������ɫ ������������
echo.                 16.��������ǿ���޸���ͻ��˵�����
echo.                 99.�˳�



set  /p a=            ��������:

if %a%==1 goto :������һ̨Win2012R2 AD�������
if %a%==1.1  goto :ֱ�Ӱ�װ��һ̨�������
if %a%==1.2  goto :�ӿ�д������������������/RODC��װ����
if %a%==1.2.1  goto :ͨ����װ���ʰ�װ�������
if %a%==1.2.2  goto :��װRODCֻ�����
if %a%==1.2.3  goto :��װ��������
if %a%==1.2.4  goto :��װ����
if %a%==1.2.2.1 goto :�鿴RODC���ع���Ա��/�����˺���RODC���ع���Ա��
if %a%==1.3  goto :ж�ض������
if %a%==1.3.1  goto :����ʹ�õķ������Ķ���
if %a%==1.3.2  goto :ж�����ڶ����������һ�����
if %a%==1.3.3  goto :ж���������һ�����
if %a%==1.3.4  goto :ж��RODCֻ�����
if %a%==1.4  goto :���DNS SRV��¼
if %a%==1.5  goto :���NTDS.dit�Ƿ񴴽��Լ�SYSVOL�ļ����Ƿ�ɹ�����������
if %a%==1.6  goto :��ѯ��5���ɫ��GC/ȫ���¼��������λ��
if %a%==1.7  goto :�鿴�ֹ��ܼ�������ܼ���
if %a%==1.7.1  goto :�����ֹ��ܼ�������ܼ���
if %a%==1.8  goto ע��ACtiveDirectory�ܹ�����̨
if %a%==1.9  goto PDCģ����ʱ��ͬ���趨���ѯ
if %a%==1.10 goto :ִ��AD���ݿ���ƶ�������������
if %a%==1.11 goto ִ��AD���ݿ��ѻ����飨����������
if %a%==1.12 goto ִ��AD���ݿ��������
if %a%==2 goto :�޸�Ŀ¼��ԭģʽ����
if %a%==3 goto :����ֱ�ӽ���Ŀ¼��ԭģʽ/������������ģʽ
if %a%==3.1 goto :����Ŀ¼��ԭģʽ�޸������Ա����
if %a%==4 goto :�ű�����IP
if %a%==5 goto :�������ݼƻ�
if %a%==6 goto :�鿴���޸�Win7����ϵͳ��SID
if %a%==7 goto :Win2012����ͼ������
if %a%==8 goto :����Win2008R2/2012R2AD����վ����
if %a%==9 goto :�ѻ�������
if %a%==10 goto :ǿ�Ƹ��������
if %a%==10.1 goto :�������������͵�½�ű�
if %a%==11 goto :��ӿ�����������
if %a%==12 goto :ǿ�Ƹ��������
if %a%==12.1 goto :�ָ�Ĭ������Ժ�Ĭ�����������������ʼ״̬
if %a%==12.2 goto :ÿ������Ա��ݼƻ�
if %a%==13 goto :ÿ�մ浵DCDIAG��ⱨ��
if %a%==14 goto :�������IP��ַ
if %a%==14.1 goto :������ؼ��������
if %a%==15  goto ���������ת�Ʋ���������ɫ
if %a%==15.1  goto ǿ���������������ɫ
if %a%==16 goto ��������ǿ���޸���ͻ��˵�����
if %a%==99 goto exit


cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ִ��AD���ݿ���ƶ�������������
cls
echo ת��AD���ݿ�ntds.dit�������ļ��У������ڴ��̿ռ䲻��ʱ��
echo ִ�иò�����ر�ADDS������ȷ����������DC���ߣ������û��򱾻�����ʱ�޷���¼��ִ����Ϻ����������
echo.               ����ȷ���Ƿ����AD���ݿ���ƶ�
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ver1.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:ver1.1
set /p directory=����Ҫת�Ƶ�Ŀ��Ŀ¼ ��ʽ�� "C:\abc"��
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds

ntdsutil "activate instance ntds " "files" "info" "move db to %directory%" "move logs to %directory%" "integrity" "quit" "quit"

echo.
echo.
echo.                 ������������ѡ�����
echo.                 1.��ʾ"Integrity Check Successful"���ݿ������Լ��ɹ���ֱ���˳���
echo.                 2.�����������Լ�鲻�ɹ���������������������޸�
echo.
echo.
echo.

set /p b= ��������:
if %b%==1 goto b1
if %b%==2 goto b2

:ִ��AD���ݿ��ѻ����飨����������
cls
echo �ѻ�����ADDS���ݿ⣬ʹ�������и����룬��ȡ���졣ͬʱ�������ɾ������ռ�õĿռ䡣
echo ִ�иò�����ر�ADDS������ȷ����������DC���ߣ������û��򱾻�����ʱ�޷���¼��ִ����Ϻ����������
echo.               ����ȷ���Ƿ����AD���ݿ������
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ver2.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ver2.1
echo 
set /p directory0=����Ҫת�Ƶ�Ŀ��Ŀ¼ ��ʽ�� "C:\abc"��
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds
ntdsutil "activate instance ntds " "files" "info" "compact to %directory0%" "quit" "quit"
set /p directory2=����ԭNTDS����Ŀ¼ Ĭ������"C:\windows\ntds":
set /p directory3=����һ����ű���NTDS���ļ��� ��"C:\ntdsbackup":
md %directory3%
rem ����ԭntds
copy %directory2%\ntds.dit %directory3% /y
rem �������������ݿ⸲��ԭ���ݿ�
copy %directory0%\ntds.dit %directory2% /y
rd %directory0% /s /q
rem ɾ��ԭ���ݿ��ļ�������־�ļ�
del %directory2%\*.log  /q 
echo  ���潫�������ݿ��������
ping 127.0.0.1 -n 5 >nul
goto b2.1

:b1
net start ntds
goto exit

:ִ��AD���ݿ��������
cls
echo �ò����������ݿ��Ƿ��д���
echo ִ�иò�����ر�ADDS������ȷ����������DC���ߣ������û��򱾻�����ʱ�޷���¼��ִ����Ϻ����������
echo.
echo.               ����ȷ���Ƿ����AD���ݿ���������
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto b2.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:b2.1 
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds
ntdsutil "activate instance ntds " "semantic database analysis" "verbose on" "go fixup" "quit" "quit"  
echo.                 ������������ѡ�����
echo.                 1.��������������ɹ�,ֱ���˳���
echo.                 2.����������������ɹ��������޸�
echo.
echo.
echo.
set /p c= ��������:
if %c%==1 goto c1
if %c%==2 goto c2

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:c1
net start ntds
goto exit

:c2
ntdsutil "activate instance ntds " "files" "info" "recover" "quit" "quit"
net start ntds
goto exit

:�޸�Ŀ¼��ԭģʽ����
cls
echo.               ����ȷ���Ƿ�����޸�Ŀ¼��ԭģʽ����
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto �޸�Ŀ¼��ԭģʽ����2
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:�޸�Ŀ¼��ԭģʽ����2
cls
echo ��Ҫ�������븴����Ҫ��
ntdsutil "set DSRM password" "reset password on server null" "quit" "quit"
echo Ŀ¼��ԭģʽ�����޸ĳɹ�
echo �����˳�
pause >nul
goto exit

:����ֱ�ӽ���Ŀ¼��ԭģʽ/������������ģʽ
cls
echo.
echo.               ִ������ѡ��
echo.               1.����ֱ�ӽ���Ŀ¼��ԭģʽ������ģʽ�����ã�
echo                2.������������ģʽ��Ŀ¼��ԭģʽ���ã�
echo.               3.������ҳ
echo.               4.�˳�
set  /p a=            ��������:
if %a%==1 goto ����ֱ�ӽ��뻹ԭģʽ
if %a%==2 goto ������������ģʽ
if %a%==3 goto start
if %a%==4 go to exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:����ֱ�ӽ��뻹ԭģʽ
bcdedit /set safeboot dsrepair
goto reboot20160616
exit

:������������ģʽ
bcdedit /deletevalue safeboot
goto reboot20160616
exit

:reboot20160616
cls
echo 1.��������
echo 2.������ҳ
echo 3.�˳�
set /p a=����
if %a%==1 shutdown /r /t 00 /f
if %a%==2 goto start
if %a%==3 goto exit

:����Ŀ¼��ԭģʽ�޸������Ա����
cls
echo  ����Ŀ¼��ԭģʽ�޸������Ա����
echo  ���������Ա����������룬���������븴����Ҫ��.
set /p a=����:
echo  net user administrator %a% >password.bat
echo  del %%0 >>password.bat
copy  password.bat %systemroot%\System32\GroupPolicy\Machine\Scripts\Startup /y 
del  password.bat /q
cls  
echo.
echo ��ʾ����������
echo.
type %systemroot%\System32\GroupPolicy\Machine\Scripts\Startup\password.bat
echo ��ִ�����²���:
echo ����-gpedit.msc-���������-windows����-����/�ػ��ű�-����-���-���-password.bat
echo �����κμ���һ��
pause >nul
goto exit

:������һ̨Win2012R2 AD�������
cls
echo.    ������һ̨Win2012R2 AD�������
echo.
echo.
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���ĵ�����
if %a%==2 goto ��һ��
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���ĵ�����
cls
echo �����µ����� ������������
set /p mingzi=: 
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��
cls
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP ��һ��

set /p ip= ����ѡ��
if %ip%==1 goto static
if %ip%==2 goto ������һ̨Win2012R2 AD�������2

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start



:������һ̨Win2012R2 AD�������2
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=��������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=����������벿�֣���ʽ��"abc.com"��������"com"��
cls
echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.����"%y%.%z%"
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��3
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��3
powershell.exe .\AD\installActivedirectory.ps1 -a %x% -b %y% -c %z%
echo �����κμ��˳�
pause >nul
goto exit


cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:�������ݼƻ�
cls
echo ��Ҫ����WindowsServerBackup���� 
echo.
echo 1.ִ������
echo 2.ֱ����һ��
echo 3.������ҳ

set /p a=��������:
if "%a%" == "1"  powershell.exe Add-WindowsFeature Windows-Server-Backup &goto 1
if "%a%" == "2" goto 1
if "%a%" == "3" goto start

:1
cls
echo.               ѡ��
echo.               0.ִ��һ��ϵͳ״̬����
echo.               1.ִ��һ�����ļ��б���
echo.               2.ִ�ж���ϵͳ״̬����
echo.               3.ִ�ж����ļ��б���
echo.               4.������ҳ
echo.               5.�˳�
set  /p a=            ��������:
if %a%==0 goto һ����ϵͳ״̬����
if %a%==1 goto һ�����ļ��б���
if %a%==2 goto ����ϵͳ״̬����
if %a%==3 goto �����ļ��б���
if %a%==4 goto start
if %a%==5 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:һ����ϵͳ״̬����
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget=  ��"F:" "\\192.168.1.1\abc":
wbadmin start backup -backuptarget:%backuptarget% -systemstate -quiet
pause ���κμ��˳�
goto :exit


:һ�����ļ��б���
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
echo. ������Ҫ���ݵ�Դ���̻��ļ��� ��������
set /p backuptarget2=  ��"D:\abc"       :
wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet 
pause ���κμ��˳�
goto :exit


:����ϵͳ״̬����
cls
echo.               ѡ����Ƶ��
echo.               1.ÿ�ձ���
echo.               2.ÿ�ܱ���
echo.               3.ÿ�±���
echo.               4.������ҳ
echo.               5.�˳�
set  /p a=            ��������:
if %a%==1 goto ÿ�ձ���
if %a%==2 goto ÿ�ܱ���
if %a%==3 goto ÿ�±���
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ÿ�ձ���
cls
set pinlv=daily
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
set /p time=���뱸��ʱ�� ��ʽ"22:00"     :
echo @echo off >%~dp0daily.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0daily.bat
set /p weizhi=����ƻ��ô��� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ�ϵͳ״̬�������ļ���
copy %~dp0daily.bat %weizhi%\����ƻ�ϵͳ״̬�������ļ���
schtasks /create /sc %pinlv%  /tn DailySystemstate /tr "%weizhi%\����ƻ�ϵͳ״̬�������ļ���\daily.bat" /st %time% /rl highest 
del %~dp0daily.bat /q
pause 
goto :exit

:ÿ�ܱ���
set pinlv=weekly
echo. �����ű��ݵ�Ŀ����̻��ļ��� �������� ʹ��Ӣ��
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
set /p time=���뱸��ʱ�� ��ʽ"22:00"      :
set /p date=���뱸������ ��ʽ"MON��TUE��WED��THU��FRI��SAT��SUN" "mon,tue": 
echo @echo off >%~dp0weekly.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0weekly.bat
set /p weizhi=����ƻ��ô��� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ�ϵͳ״̬�������ļ���
copy %~dp0weekly.bat %weizhi%\����ƻ�ϵͳ״̬�������ļ���
schtasks /create /sc %pinlv%  /d %date%   /tn WeeklySystemstate /tr "%weizhi%\����ƻ����ļ���\weekly.bat"  /st %time% /rl highest
del %~dp0weekly.bat /q
pause 
goto :exit

:ÿ�±���
set pinlv=monthly
echo. �����ű��ݵ�Ŀ����̻��ļ��� �������� ʹ��Ӣ��
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
set /p time=���뱸��ʱ�� ��ʽ"22:00" :
set /p date=���뱸������ ÿ�µ�N�죬��ʽΪ����1-31��һ:
echo @echo off >%~dp0monthly.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0monthly.bat
set /p weizhi=����ƻ��ô��� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ�ϵͳ״̬�������ļ���
copy %~dp0monthly.bat %weizhi%\����ƻ�ϵͳ״̬�������ļ���
schtasks /create /sc %pinlv%  /d %date%   /tn MonthlySystemstate /tr "%weizhi%\����ƻ����ļ���\monthly.bat"  /st %time% /rl highest
del %~dp0monthly.bat /q
pause 
goto :exit

:�����ļ��б���
cls
echo.               ѡ����Ƶ��
echo.               1.ÿ�ձ���
echo.               2.ÿ�ܱ���
echo.               3.ÿ�±���
echo.               4.������ҳ
echo.               5.�˳�
set  /p a=            ��������:
if %a%==1 goto ÿ�ձ���
if %a%==2 goto ÿ�ܱ���
if %a%==3 goto ÿ�±���
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ÿ�ձ���
cls
set pinlv=daily
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
echo. ������Ҫ���ݵ�Դ���̻��ļ��� ��������
set /p backuptarget2=  ��"D:\abc"       :
set /p time=���뱸��ʱ�� ��ʽ"22:00"     :
echo @echo off >%~dp0daily.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet >>%~dp0daily.bat
set /p weizhi=�������ƻ��ýű����� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ��ļ��б������ļ���
copy %~dp0daily.bat %weizhi%\����ƻ��ļ��б������ļ���
schtasks /create /sc %pinlv%  /tn DailyFile /tr "%weizhi%\����ƻ��ļ��б������ļ���\daily.bat" /st %time% /rl highest 
del %~dp0daily.bat /q
pause ���κμ��˳�
goto :exit

:ÿ�ܱ���
cls
set pinlv=weekly
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
echo. ������Ҫ���ݵ�Դ���̻��ļ��� ��������
set /p backuptarget2=  ��"D:\abc"       :
set /p time=���뱸��ʱ�� ��ʽ"22:00"     :
set /p date=���뱸������ ��ʽ"MON��TUE��WED��THU��FRI��SAT��SUN" "mon,tue": 
echo @echo off >%~dp0weekly.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet >>%~dp0weekly.bat
set /p weizhi=�������ƻ��ýű����� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ��ļ��б������ļ���
copy %~dp0weekly.bat %weizhi%\����ƻ��ļ��б������ļ���
schtasks /create /sc %pinlv% /D %date% /tn WeeklyFile /tr "%weizhi%\����ƻ��ļ��б������ļ���\weekly.bat" /st %time% /rl highest 
del %~dp0weekly.bat /q
pause ���κμ��˳�
goto :exit

:ÿ�±���
set pinlv=monthly
echo. �����ű��ݵ�Ŀ����̻��ļ��� �������� ʹ��Ӣ��
set /p backuptarget1=  ��"F:" "\\192.168.1.1\abc"     :
echo. ������Ҫ���ݵ�Դ���̻��ļ��� �������� 
set /p backuptarget2=  ��"D:\abc"       :
set /p time=���뱸��ʱ�� ��ʽ"22:00" :
set /p date=���뱸������ ÿ�µ�N�죬��ʽΪ����1-31��һ:
echo @echo off >%~dp0monthly.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet>>%~dp0monthly.bat
set /p weizhi=�������ƻ��ýű����� ֻ��������̼��� ��ʽ���� "E:"       :
md %weizhi%\����ƻ��ļ��б������ļ���
copy %~dp0monthly.bat %weizhi%\����ƻ��ļ��б������ļ���
schtasks /create /sc %pinlv%  /d %date%   /tn MonthlyFile /tr "%weizhi%\����ƻ��ļ��б������ļ���\monthly.bat"  /st %time% /rl highest
del %~dp0monthly.bat /q
pause ���κμ��˳�
goto :exit

:�鿴���޸�Win7����ϵͳ��SID
cls
echo      ��һ�������ֱ�Ӹ��ƣ������������򿪵Ļ��������û���SID����ȫһ�µ�
echo      ͨ���޸�ϵͳSID���ı��û�SID
echo.     ִ�еڶ��������ỹԭ��������ɾ����ǰ�û����������ݣ���һ��ע�⣡
echo.
echo      �鿴���޸�Win7����ϵͳ��SID
echo.     1.ֻ�鿴��ǰ�û���SID
echo.     2.���浱ǰ�û���SID����ǰĿ¼�²�ִ���޸�SID��5S������
echo.     3.�Ѿ�ͨ��Sysoprep�����޸���SID���鿴��ǰ��SID���Ա�δ�޸�ǰ��SID
echo.     4.������ҳ
echo.     5.�˳�
set  /p a=            ��������:
if %a%==1 goto ֻ�鿴��ǰ�û���SID
if %a%==2 goto �������޸� 
if %a%==3 goto �Ա�SID
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ֻ�鿴��ǰ�û���SID
cls
echo ֻ�鿴��ǰ�û���SID
whoami /user 
pause �����ⰴ���˳�
goto :exit

:�������޸�
cls
echo ���浱ǰ�û���SID����ǰĿ¼�²�ִ���޸�SID��5S������ 
whoami /user 
set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
echo %y% >%~dp0whoamisid.txt
echo Ϊ����ǰ��SID >>%~dp0whoamisid.txt
whoami /user >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
%systemroot%\system32\sysprep\sysprep.exe /quiet /generalize /oobe /reboot
goto exit

:�Ա�SID
cls
echo �Ѿ�ͨ��Sysoprep�����޸���SID���鿴��ǰ��SID���Ա�δ�޸�ǰ��SID
set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
echo %y% >>%~dp0whoamisid.txt
echo ���ĺ�ĵ�SID >>%~dp0whoamisid.txt
whoami /user >>%~dp0whoamisid.txt
type %~dp0whoamisid.txt
pause ���κμ�ɾ����txt���˳�
del %~dp0whoamisid.txt /q
goto exit 

:Win2012����ͼ������
rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
goto exit


:�ű�����IP
cls
echo     �˽ű����԰��������ñ���IP  �������ֺ�س����� 
echo.
echo.     
echo     1.�Զ���ȡIP
echo     2.�̶�IP
echo     3.�˳�   
set /p a=����:
if "%a%"=="1" goto dhcp
if "%a%"=="2" goto static
if "%a%"=="3" goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start


:dhcp
cls
echo �����Զ���ȡIP
set /p  net1=        ������������������(Ĭ��Ϊ��������):
netsh interface ip set address name="%net1%" source=dhcp 
netsh interface ip set dns name="%net1%" source=dhcp
pause �����κΰ������˳�
goto exit

:static
cls 
echo ���ù̶�IP
set /p ip1=          ����̶�IP:
set /p mark1=        ������������:
set /p router1=      ����Ĭ������:
set /p dns1=         ������ѡDNS:
set /p dns2=         �����ѡDNS:
set /p  net1=        ������������������(Ĭ��Ϊ��������):

cls
echo �������������£�
echo %ip1%
echo %mark1%
echo %router1%
echo %dns1%
echo %dns2%
echo %net1%
echo.
echo.
echo 1.ȷ�ϲ�ִ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto �̶�IP
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start


:�̶�IP
netsh interface ip set address name="%net1%" dhcp
netsh interface ip set dns name="%net1%" dhcp
netsh interface ip set address name="%net1%" static %ip1% %mark1% %router1% 1
netsh interface ip set dns name="%net1%" static %dns1% primary 
netsh interface ip add dns name="%net1%" %dns2% index=2 
pause �����κΰ������˳�
goto :exit

:����Win2008R2/2012R2AD����վ����
cls
echo �����Win2008R2�����иýű�ǰ��ȷ���Ѿ��ֹ��ܺ����ܼ���������Win2008R2
echo ���κμ�����
pause >nul
set /p y=��������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=����������벿�֣���ʽ��"abc.com"��������"com"��
powershell.exe .\ad\recycle.ps1 -a %y% -b %z%
echo Win2008R2����վ���ܹ��ڷ������Ƽ�ʹ�õ���������ADRestore.msi �������ڲ���������վ������»ָ�ADɾ������ �������ϲ��ᶪʧ
echo ���κΰ����˳�
pause >nul
goto :exit

:��ѯ��5���ɫ��GC/ȫ���¼��������λ��
cls
echo.
echo.
echo ��ѯ��5���ɫ��GC/ȫ���¼��������λ��
echo.
echo.
echo 5���ɫ
netdom query fsmo
echo.
echo ����GC/ȫ���¼������
dsquery server -isgc
echo.
echo ����GC/ȫ���¼������
powershell.exe  "Get-ADForest | FL GlobalCatalogs"
echo ���κΰ����˳�
pause >nul
goto exit

:�ӿ�д������������������/RODC��װ����
cls
echo. 
echo ���ð�װ��������װ�������.��������ذ�װ�����紫���ٶȽ�����
echo ������װ����

echo.
echo 1.������д���������װ���ʣ��洢����ǰӢ��Ŀ¼�ļ�����
echo 2.����ֻ���������(RODC)��װ���ʣ��洢��Ӣ��Ŀ¼�ļ�����
echo.
set /p a=��������:
if "%a%" == "1" goto :������д���������װ����
if "%a%" == "2" goto :����ֻ���������(RODC)��װ����

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:������д���������װ����
set /p a=����Ŀ���ļ���·�������ɰ������ĵ��ַ���������"D:\InstallationMediaFull":
ntdsutil "activate instance ntds" "ifm" "create sysvol full %a%" "quit" "quit"
echo  ���κμ��˳�
pause >nul
goto exit

:����ֻ���������(RODC)��װ����
cls
echo.
set /p a=����Ŀ���ļ���·�������ɰ������ĵ��ַ���������"D:\InstallationMediaRODC":
ntdsutil "activate instance ntds" "ifm" "create sysvol RODC %a%" "quit" "quit"
echo  ���κμ��˳�
pause >nul
goto exit


:���DNS SRV��¼
cls
echo ��������SRV��¼ ���һ���������������е�����Ŀ¼��ѡ�������ͣ��������з�������
echo ��ʹ����������nslookup  set type=srv  ls -t srv %userdnsdomain%��
echo  ���κμ�����
pause >nul
echo ���DNS SRV ��¼
echo set type=srv >nslookup.txt
echo. >>nslookup.txt
echo _gc._tcp.%userdnsdomain% >>nslookup.txt
echo.  >>nslookup.txt
echo _ldap._tcp.%userdnsdomain% >>nslookup.txt
echo.  >>nslookup.txt
echo _kerberos._tcp.%userdnsdomain% >>nslookup.txt
echo. >>nslookup.txt
cls
nslookup <nslookup.txt  >SRV.txt
del nslookup.txt /q /f 
type srv.txt
echo  ���κμ��˳�
pause >nul
del srv.txt /q /f 
goto exit

:���NTDS.dit�Ƿ񴴽��Լ�SYSVOL�ļ����Ƿ�ɹ�����������
cls
echo.
echo ���NTDS.dit�Ƿ񴴽�
echo.
dir %systemroot%\NTDS\ /b /w
echo.
echo --------------------------------------------------------
echo.
echo ���SYSVOL�ļ����Ƿ�ɹ�����������
dir %systemroot%\sysvol\sysvol /b /w
net share
pause >nul
goto exit


:ֱ�Ӱ�װ��һ̨�������
cls
echo.    �����������
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���Ķ�����ص�����
if %a%==2 goto ��һ��0609
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���Ķ�����ص�����
cls
echo.
echo �����µ����� ������������
set /p mingzi= �����룺
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��0609
cls
echo.
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP������һ��
set /p ip= ����ѡ��:
if %ip%==1 goto static
if %ip%==2 goto ��һ��06092

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��06092
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=��������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=����������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:
cls
echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.����"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��06093
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��06093
powershell.exe .\AD\installBackupActivedirectory.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo �����κμ��˳�
pause >nul
goto exit

:ͨ����װ���ʰ�װ�������
cls
echo.    ͨ����װ���ʰ�װ�������
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���Ķ�����ص�����06092317
if %a%==2 goto ��һ��06092317
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���Ķ�����ص�����06092317
cls
echo.
echo �����µ����� ������������
set /p mingzi= �����룺
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��06092317
cls
echo.
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP������һ��
set /p ip= ����ѡ��:
if %ip%==1 goto static
if %ip%==2 goto ��һ��06092318

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��06092318
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=��������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=����������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:
set /p zz=���밲װ��������Ŀ¼����ʽ��"D:\installationmedia":
cls
echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.����"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.��װ��������Ŀ¼��%zz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��06092320
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��06092320
powershell.exe .\AD\installBackupActivedirectoryfrominstallationmedia.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %zz%
echo �����κμ��˳�
pause >nul
goto exit



:ж�ض������
cls
echo.
echo ж�ض������
echo.
echo.
echo.               ����ȷ��ж�ض������
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo ж�����ڶ����������һ�����
set /p x=����ж�غ󱾵ع���Ա����,���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=����������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=������������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:

cls
echo ���������
echo ���ع���Ա���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��07081458
powershell.exe .\AD\uninstallBackupActivedirectory.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo �����κμ��˳�
pause >nul
goto exit



:��һ��07081458
:ж�����ڶ����������һ�����
cls
echo.
echo ж�����ڶ����������һ�����
echo.
echo.
echo.               ����ȷ���Ƿ�ж�����ڶ����������һ�����
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:20160708
cls
echo ж�����ڶ����������һ�����
set /p x=����ж�غ󱾵ع���Ա����,���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=����������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=������������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:

cls
echo ���������
echo ���ع���Ա���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��07081458
powershell.exe .\AD\uninstallSecondDomainTree.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo �����κμ��˳�
pause >nul
goto exit

:ж���������һ�����
cls
echo.
echo ж���������һ�����
echo.
echo.
echo.               ����ȷ���Ƿ�ж��ж���������һ�����
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo ж�����ڶ����������һ�����
set /p x=����ж�غ󱾵ع���Ա����,���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=���븸����ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=���븸������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:

cls
echo ���������
echo ���ع���Ա���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��07081458
powershell.exe .\AD\uninstallChildDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo �����κμ��˳�
pause >nul
goto exit

:ж��RODCֻ�����
cls
echo.
echo ж��RODCֻ�����
echo.
echo.
echo.               ����ȷ���Ƿ�ж��RODCֻ�����
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo ж��RODCֻ�����
set /p x=����ж�غ󱾵ع���Ա����,���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=����������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=������������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:

cls
echo ���������
echo ���ع���Ա���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��07081458
powershell.exe .\AD\uninstallRODC.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo �����κμ��˳�
pause >nul
goto exit


:��װRODCֻ�����
cls
echo ��װRODCֻ�����
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���Ķ�����ص�����0612
if %a%==2 goto ��һ��0612
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���Ķ�����ص�����0612
cls
echo.
echo �����µ����� ������������
set /p mingzi= �����룺
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��0612
cls
echo.
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP������һ��
set /p ip= ����ѡ��:
if %ip%==1 goto static
if %ip%==2 goto ��һ��0612

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��0612
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=���븸����ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=���븸������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:
set /p leo=������ΪRODC���ع���Ա���ʺţ���ʽ��"test":

echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.����"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo.RODC����Ա�ʺţ�%leo%
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��06121606
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��06121606
powershell.exe ".\AD\installRodcDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo �����κμ��˳�
pause >nul
goto exit

:�鿴�ֹ��ܼ�������ܼ���
cls
echo.
echo. �鿴�ֹ��ܼ�������ܼ���
echo.
echo �ֹ��ܼ���
powershell.exe "Get-ADForest | Select-Object Forestmode"

echo ���ܼ���
powershell.exe "Get-ADDomain | Select-Object Domainmode"
echo.
echo.
echo.
echo.
echo.
echo �����κμ�����
pause >nul
cls
echo.
echo.
:�����ֹ��ܼ�������ܼ���
cls
echo 1.�����ֹ��ܼ���
echo 2.�������ܼ���
echo 3.������ҳ
echo 4.�˳�

set /p a=��������:
if %a%==1 goto ������ǰ�ֹ��ܼ���
if %a%==2 goto ������ǰ���ܼ���
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start



:������ǰ�ֹ��ܼ���
cls
echo.
echo  ������ǰ�ֹ��ܼ���
echo 1.Windows2008R2Forest
echo 2.Windows2012R2Forest
echo 3.������ҳ
echo 4.�˳�

set /p a=��������:

if "%a%" == "1" (set forestmode=Windows2008R2Forest)&goto ������ǰ�ֹ��ܼ���2
if "%a%" == "2" (set forestmode=Windows2012R2Forest)&goto ������ǰ�ֹ��ܼ���2
if "%a%" == "3" goto start
if "%a%" == "4" goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start

:������ǰ�ֹ��ܼ���2
cls
powershell "Set-ADForestMode -ForestMode %forestmode% -Identity $env:USERDNSDOMAIN -Confirm:$false"
echo �����κμ�����
pause >nul
cls
echo �����������ܼ���
echo 1.����
echo 2.�˳�
set /p a=��������:
if "%a%" == "1" goto ������ǰ���ܼ���
if "%a%" == "2" goto exit


:������ǰ���ܼ���
cls
echo.
echo  ������ǰ���ܼ���
echo 1.Windows2008R2Domain
echo 2.Windows2012R2Domain
echo 3.������ҳ
echo 4.�˳�
echo.
set /p a=��������:
if "%a%" == "1" (set domainmode=Windows2008R2Domain)&goto ������ǰ���ܼ���2
if "%a%" == "2" (set domainmode=Windows2012R2Domain)&goto ������ǰ���ܼ���2
if "%a%" == "3" goto start
if "%a%" == "4" goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start

:������ǰ���ܼ���2
cls
powershell "Set-ADDomainMode -DomainMode %domainmode% -Identity $env:USERDNSDOMAIN -Confirm:$false"
echo ����ִ�����
echo �����κμ��˳�
pause >nul
goto exit

:�鿴RODC���ع���Ա��/�����˺���RODC���ع���Ա��
cls
echo �鿴RODC���ع���Ա��
dsmgmt "local roles" "show role administrators" "quit" "quit"
echo.
echo.
echo �Ƿ�ִ�б༭�˺Ų���
echo 1.�����˺���RODC���ع���Ա��
echo 2.��RODC���ع����Ƴ��˺�
echo 3.������ҳ
echo 4.�˳�
echo.
echo.
set /p a= ���룺
if %a%==1 goto �����˺���RODC���ع���Ա��
if %a%==2 goto ��RODC���ع����Ƴ��˺�
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start

:�����˺���RODC���ع���Ա��
cls
echo.
echo �����˺���RODC���ع���Ա��
echo.
set /p a=����Ҫ��ӵ��˺ţ���ʽ��"abc\user":
echo.
dsmgmt "local roles" "add %a% administrators" "show role administrators" "quit" "quit"
echo �����κμ��˳�
pause >nul
goto exit

:��RODC���ع����Ƴ��˺�
cls
echo ��RODC���ع����Ƴ��˺�
echo.
set /p a=����Ҫ��ӵ��˺ţ���ʽ��"abc\user":
echo.
dsmgmt "local roles" "remove %a% administrators" "show role administrators" "quit" "quit"
echo.
echo.
echo �����κμ��˳�
pause >nul
goto exit

:�ѻ�������
cls
echo.
echo �ѻ�������
echo.

echo 1.�����ִ��
echo 2.��Ŀ�������ִ��
echo 3.������ҳ
echo 4.�˳�
echo.
echo.
set /p a= ���룺
if %a%==1 (set /p b=����Ҫ����ĵ�����:)&(djoin /provision /domain %userdnsdomain% /machine %b% /savefile djoin.txt)&goto 20160614
if %a%==2 (djoin /requestODJ /loadfile djoin.txt /windowspath %systemroot% /localos)&goto 20160614
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start

:20160614
echo.
echo.
echo �����κμ��˳�
pause >nul
goto exit

:ǿ�Ƹ��������
cls
echo no | gpupdate /force

echo.
echo.
echo �����κμ��˳�
pause >nul
goto exit


:�������������͵�½�ű�
cls
echo.
echo �������������͵�½�ű�
echo @echo off >Startup.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%% >>Startup.bat
echo md "c:\%%y%%+%%computername%%"  >>Startup.bat
echo exit >>Startup.bat
echo.
echo @echo off >Logon.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%% >>Logon.bat
echo md "c:\%%y%%+%%username%%" >>Logon.bat
echo exit >>Logon.bat
echo �ű�������� �ڵ�ǰĿ¼��
echo.
echo.
echo �����κμ��˳�
pause >nul
goto exit


:��ӿ�����������
cls 
echo.
echo 1.��ӿ���������
echo 2.���һ���Կ���������
set /p a=����:
if %a%==1 goto run
if %a%==2 goto runonce

echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start

:run
cls
set /p name=����ע���Ӣ����:
set type=reg_sz
set /p router= ���Ƴ���·�����˴�,��:"c:\abc\qq.exe" : 

reg add HKLM\software\microsoft\windows\currentversion\run /v "%name%" /t "%type%" /d "%router%" /f
pause
goto exit

:runonce
cls 
set /p name=����ע���Ӣ����:
set type=reg_sz
set /p router= ���Ƴ���·�����˴�,��:"c:\abc\qq.exe" : 

reg add HKLM\software\microsoft\windows\currentversion\runonce /v "%name%" /t "%type%" /d "%router%" /f

pause
goto exit

:ǿ�Ƹ��������
echo %time%
echo no | gpupdate /force
echo ����ˢ�� �˳�������Ͻ�X
pause >nul
goto :ǿ�Ƹ��������


:�ָ�Ĭ������Ժ�Ĭ�����������������ʼ״̬
cls
echo. 
echo.
echo �ָ�Ĭ������Ժ�Ĭ�����������������ʼ״̬
echo 1.�ָ�Ĭ�������
echo 2.�ָ�Ĭ�������������
echo 3.�������ָ�
set /p a=���룺
if %a%==1 (dcgpofix /target:domain)&goto exit
if %a%==2 (dcgpofix /target:dc)&goto exit
if %a%==3 (dcgpofix /target:both)&goto exit

echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start


:��װ��������
cls
echo.    �����������
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���Ķ�����ص�����
if %a%==2 goto ��һ��0704
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���Ķ�����ص�����
cls
echo.
echo �����µ����� ������������
set /p mingzi= �����룺
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��0704
cls
echo.
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP������һ��
set /p ip= ����ѡ��:
if %ip%==1 goto static
if %ip%==2 goto ��һ��07042

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��07042
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=����������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=������������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:
set /p leo=������������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��

cls
echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo ���������� "%leo%.%z%"
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07043
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��07043
powershell.exe .\AD\installSecondDomainTree.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo �����κμ��˳�
pause >nul
goto exit



:����ʹ�õķ������Ķ���
cls
echo.
echo.
echo.
echo ����ִ�д�����ǿ������ʹ�õķ������Ķ���
echo.
echo �����κμ����� �����Ͻ�X�˳�
pause >nul
set abc=%computername%
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "quit" "quit" "quit"
echo.
echo.
echo.
echo �������Ӧ��վ����� ������Ͻ�X�˳�
set /p a=�����Ӧ���֣�
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "quit" "quit" "quit"
echo.
echo.
echo.
echo ������Ҫɾ��������� ������Ͻ�X�˳�
set /p b=�����Ӧ���֣�
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "select domain %b%" "list servers for domain in site" "quit" "quit" "quit"
echo.
echo.
echo.
echo ������Ҫɾ���ķ�������� ������Ͻ�X�˳�
set /p c=�����Ӧ���֣�
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "select domain %b%" "list servers for domain in site" "select server %c%" "quit" "remove selected server" "quit" "quit"
echo.
echo.
echo.
echo ������ǿ��ɾ�������Ѿ����
echo 1.����ҳ
echo 2.�˳�

set /p a=��������:
if "%a%" == "1" goto start
if "%a%" == "2" goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:ÿ������Ա��ݼƻ�
cls
set pinlv=daily
echo. �����ű��ݵ�Ŀ����̻��ļ��� ��������
set /p backuptarget1=  ��"F:\abc":
set /p time=���뱸��ʱ�� ��ʽ"22:00":
echo @echo off >%~dp0dailyGPO.bat
echo rd %backuptarget1% /s /q >>%~dp0dailyGPO.bat
echo md %backuptarget1%  >>%~dp0dailyGPO.bat
echo xcopy %%systemroot%%\sysvol\sysvol\%%userdnsdomain%%\policies %backuptarget1% /e >>%~dp0dailyGPO.bat
set /p weizhi=�������ƻ��ýű����� ֻ��������̼��� ��ʽ���� "E:":
md %weizhi%\����ƻ��ļ��б������ļ���
copy %~dp0dailyGPO.bat %weizhi%\����ƻ��ļ��б������ļ��� /y
schtasks /create /sc %pinlv%  /tn DailyFile /tr "%weizhi%\����ƻ��ļ��б������ļ���\dailyGPO.bat" /st %time% /rl highest 
del %~dp0dailyGPO.bat /q
pause ���κμ��˳�
goto :exit

:��װ����
cls
echo.    ��������
echo ����������:   %computername%
echo                �Ƿ���ĵ�����
echo.               1.����
echo.               2.����ִ����һ��
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto ���Ķ�����ص�����
if %a%==2 goto ��һ��0704
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:���Ķ�����ص�����
cls
echo.
echo �����µ����� ������������
set /p mingzi= �����룺
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo ������������

:��һ��0704
cls
echo.
echo �̶�����IP������DNS(����)
echo 1.ǰȥ�̶�IP
echo 2.�Ѿ��̶���IP������һ��
set /p ip= ����ѡ��:
if %ip%==1 goto static
if %ip%==2 goto ��һ��07042

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:��һ��07042
cls
set /p x=����Ŀ¼��ԭģʽ���룬���������븴����Ҫ��,��ʽ��"Suzhou123":
set /p y=���븸����ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p z=���븸������벿�֣���ʽ��"abc.com"��������"com"��
set /p xy=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p xz=��������صĹ���Ա����:
set /p leo=��������ǰ�벿�֣���ʽ��"xx.abc.com"��������"xx"��

cls
echo ���������
echo Ŀ¼��ԭģʽ���� "%x%"
echo.������"%y%.%z%"
echo.����ع���Ա�˺����룺%xy%  %xz%
echo �������� "%leo%.%y%.%z%"
echo.
echo.
echo 1.ȷ�ϲ�ִ����һ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto ��һ��07043
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start


:��һ��07043
powershell.exe .\AD\installChildDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo �����κμ��˳�
pause >nul
goto exit


:ÿ�մ浵DCDIAG��ⱨ��
cls
echo.
echo.
echo ÿ�մ浵DCDIAG��ⱨ��
set pinlv=daily
set /p a=��������־��¼�Ĵ��̣�����"D:" :
set /p time=���뱸��ʱ�� ��ʽ"22:00" :
set /p weizhi=����ƻ��ô��� ֻ��������̼��� ��ʽ���� "D:":
md %weizhi%\����ƻ�ϵͳ״̬�������ļ���
md %a%\DIDIAGÿ�մ浵
echo @echo off >dcdiag123.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%>>dcdiag123.bat
echo dcdiag /c ^>%a%\DIDIAGÿ�մ浵\%%y%%.txt >>dcdiag123.bat
echo exit >>dcdiag123.bat
copy %~dp0dcdiag123.bat %weizhi%\����ƻ�ϵͳ״̬�������ļ���
schtasks /create /sc %pinlv%  /tn DailyDcdiag /tr "%weizhi%\����ƻ�ϵͳ״̬�������ļ���\dcdiag123.bat" /st %time% /rl highest 
del %~dp0dcdiag123.bat /q
pause ���κμ��˳�
goto :exit

:�������IP��ַ
cls
echo.
echo.
echo ��������ֹͣNetlogon���� ��ȷ�Ϻ�ִ����һ��
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto �������IP��ַ2
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:�������IP��ַ2
net stop netlogon 
goto static

:static
cls 
echo ���ù̶�IP

set /p ip1=          ����̶�IP:
set /p mark1=        ������������:
set /p router1=      ����Ĭ������:
set /p dns1=         ������ѡDNS:
set /p dns2=         �����ѡDNS:
netsh interface ip show interfaces
set /p net1=         ������������������(Ĭ��Ϊ��������):

cls
echo �������������£�
echo %ip1%
echo %mark1%
echo %router1%
echo %dns1%
echo %dns2%
echo %net1%
echo.
echo.
echo 1.ȷ�ϲ�ִ��
echo 2.������ҳ

set /p a=��������:
if "%a%" == "1" goto �̶�IP
if "%a%" == "2" goto start

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto :start


:�̶�IP
netsh interface ip set address name="%net1%" dhcp
netsh interface ip set dns name="%net1%" dhcp
netsh interface ip set address name="%net1%" static %ip1% %mark1% %router1% 1
netsh interface ip set dns name="%net1%" static %dns1% primary 
netsh interface ip add dns name="%net1%" %dns2% index=2 

ipconfig /flushdns

net start netlogon 

ipconfig /registerdns

cls
echo.
echo.
echo ����ִ�����²���
echo 0.��DNS��������ɾ��ԭʼIP��A��¼�ͷ�������
echo 1.�����DNS����,��Ҫ�ֶ����´��������DNS��������¼
echo 2.���������dns������������forward����ЩDC,��Ҫ�޸Ķ�Ӧ��forward����.
echo 3.�����������DNS����������̨DNS��������������,�޸�����ЩDNS�������ϵļ�¼
echo 4.������Ա(���������߿ͻ���)ʹ���ֶ����õ�IP��ַ,��Ҫ���·ֱ������Щ��ַ.���ʹ��DHCP,����Ҫ�޸Ķ�Ӧ��DHCP����
goto exit


:������ؼ��������
cls
echo ������ؼ��������
echo ע���˲��������������
set /p a=�����޸ĺ�ļ������:
netdom computername %computername%.%userdnsdomain% /add:%a%.%userdnsdomain%
netdom computername %computername%.%userdnsdomain% /makeprimary:%a%.%userdnsdomain%
echo.
echo.
echo ��������������������ִ�����²���������DNS����ͷ��������в鿴�����¾ɼ��������Ӧ�ļ�¼����ɾ���ɼ��������Ӧ�ļ�¼��
echo �����κμ�����
pause >nul
shutdown /r /t 00 /f 

:������� 
cls
echo.
echo �������OU,Group,Users
echo.
echo.����ǵ�һ�β��� �밴��˳��ִ��
echo.               1.���OUs
echo.               2.���Groups
echo.               3.���Users
echo.               4.�˳�
set  /p a=    ��������:
if %a%==1 goto ous
if %a%==2 goto groups
if %a%==3 goto uers
if %a%==4 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start




:ע��ACtiveDirectory�ܹ�����̨
cls
echo.
echo.
echo ��������ע��AD�ܹ�����̨ ����MMC��� ��ȷ�Ϻ�ִ����һ��
echo.               1.ȷ��
echo.               2.������ҳ
echo.               3.�˳�
set  /p a=            ��������:
if %a%==1 goto 20160827
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:20160827
regsvr32 schmmgmt.dll
goto exit


:PDCģ����ʱ��ͬ���趨���ѯ
cls
echo.
echo.               PDCģ����ʱ��ͬ���趨���ѯ
echo.               1.��ѯ��ǰͬ��ʱ��Դ
echo.               2.��ѯʱ��Դ��Ϣ
echo.               3.�ֶ���ʱ��Դͬ��
echo.               4.�趨ʱ��ͬ��������
set  /p a=            ��������:
if %a%==1 goto 1
if %a%==2 goto 2
if %a%==3 goto 3

:1
w32tm /query /source
echo.
echo �����κμ�������ҳ
pause >nul
goto start

:2
w32tm /query /peers
echo �����κμ�������ҳ
pause >nul
goto start

:3
w32tm /resync
echo �����κμ�������ҳ
pause >nul
goto start

:4
cls 
echo  �趨ʱ��ͬ��������
echo �����κμ���ʾ����ʱ��ͬ�������� 
echo ʹ��ǰ����ping����������ͨ��
pause >nul

echo NTP Server��ַ��
echo ���ã�
echo 1.cn.pool.ntp.org
echo 2.cn.pool.ntp.org
echo 3.cn.pool.ntp.org
echo 0.cn.pool.ntp.org
echo cn.pool.ntp.org
echo tw.pool.ntp.org
echo 0.tw.pool.ntp.org
echo 1.tw.pool.ntp.org
echo 2.tw.pool.ntp.org
echo 3.tw.pool.ntp.org

echo ���ڣ�
echo s2a.time.edu.cn �廪��ѧ
echo s2b.time.edu.cn �廪��ѧ
echo s2c.time.edu.cn �����ʵ��ѧ
echo s2e.time.edu.cn ����������������
echo s2f.time.edu.cn ����������������
echo s2g.time.edu.cn �����ϵ�����������
echo s2k.time.edu.cn CERNET�������ڵ�
echo s2m.time.edu.cn ������ѧ  ok


echo �����κμ������趨
pause >nul
set /p a=����ʱ��Դ��ַ1:
set /p b=����ʱ��Դ��ַ2:
w32tm /config /update /manualpeerlist:"%a% %b%" /syncfromflags:manual /reliable:Yes 

echo �����κμ�������ҳ
pause >nul
goto start


:���������ת�Ʋ���������ɫ
cls
echo.
echo ���������ת�Ʋ���������ɫ
echo.
echo PDCģ������������=0
echo RID��������=1
echo �����ṹ��������=2
echo �ܹ�������������=3
echo ��������������=4
echo.
set /p a=����ת����Ŀ������������:
set /p b=��Ҫת�ƵĲ����������룬���������"��"��������"1,2,3":
powershell Move-ADDirectoryServerOperationMasterRole -Identity "%a%" -OperationMasterRole %b% -Confirm:$false
echo.
echo.
echo.
echo ת�����5���ɫ
netdom query fsmo
echo �����κμ�������ҳ
pause >nul
goto start

:ǿ���������������ɫ
cls
echo.
echo ǿ���������������ɫ
echo.
echo ע�⣺һ���ܹ���������������������������RID����������ɫ����ȡ������Զ��Ҫ��ԭ��������Щ����������ɫ��������������ӵ������ϡ�
echo.
echo PDCģ������������=0
echo RID��������=1
echo �����ṹ��������=2
echo �ܹ�������������=3
echo ��������������=4
echo.
set /p a=����ת����Ŀ������������:
set /p b=��Ҫת�ƵĲ����������룬���������"��"��������"1,2,3":
powershell Move-ADDirectoryServerOperationMasterRole -Identity "%a%" -OperationMasterRole %b% -Confirm:$false -force
echo.
echo.
echo.
echo ת�����5���ɫ
netdom query fsmo
echo �����κμ�������ҳ
pause >nul
goto start

:��������ǿ���޸���ͻ��˵�����
cls
echo.
echo NETDOM RENAMECOMPUTER �����������������������������Ҫ���������е�
echo ���������ĳЩ����(����֤��䷢����)�����̶��ļ��������
echo ����κ��������͵ķ���������Ŀ�������ϣ������������Ļ��������Ӱ�졣
echo �����Ӧ�������������������
echo.
echo.
set /p a=����Ҫ�޸ĵļ��������:
set /p b=�����¼������: 
set /p c=����������ǰ�벿�֣���ʽ��"abc.com"��������"abc"��
set /p d=��������صĹ���Ա���ƣ�Ĭ��"administrator":
set /p e=��������صĹ���Ա����:
echo ���������
echo Ҫ�޸ĵļ������:%a%
echo �¼������:%b%
echo.���� %c%
echo.����ع���Ա�˺����룺%d% %e%
echo �����κμ�������X�˳�
pause >nul
netdom renamecomputer "%a%" /newname:%b% /usero:%c%\%d% /passwordo:%e% /userd:%c%\%d% /passwordd:%e% /force
echo.
echo Ŀ��ͻ��˱�������Ӧ���¼������
echo �����κμ�������ҳ��X�˳�
pause >nul
goto start


:exit
echo �����κμ�������ҳ
pause >nul
goto start



