@echo off 
echo ��ʼ����IE�������� 
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f 
rem reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /d "123.57.1.253:888" /f 
echo ����������ɰ�������ر� 
pause>nul