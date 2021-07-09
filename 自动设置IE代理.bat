@echo off 
echo 开始设置IE代理上网 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f 
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "123.57.1.253:888" /f 
echo 代理设置完成按任意键关闭 
pause>nul