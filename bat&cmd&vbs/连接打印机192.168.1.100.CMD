@echo off

echo 添加网络打印机

echo 等待....

sc config spooler start= auto

net stop spooler & net start spooler


net use \\192.168.1.100\IPC$ "" /user:"guest"

rundll32 printui.dll,PrintUIEntry /in /n "\\192.168.1.100\HP"

echo 连接成功

pause