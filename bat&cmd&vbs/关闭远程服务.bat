@echo 正在关闭远程服务。。。
net stop telnet
net stop "terminal services"
echo Terminal Services---------------------------------------禁用！
sc config   TermService start= DISABLED 
echo Telnet--------------------------------------------------禁用！
sc config   TlntSvr start= DISABLED 
pause
@echo off