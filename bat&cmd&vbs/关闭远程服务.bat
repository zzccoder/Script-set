@echo ���ڹر�Զ�̷��񡣡���
net stop telnet
net stop "terminal services"
echo Terminal Services---------------------------------------���ã�
sc config   TermService start= DISABLED 
echo Telnet--------------------------------------------------���ã�
sc config   TlntSvr start= DISABLED 
pause
@echo off