@echo off
cls
echo.
echo ************************************
echo MADE IN YONGFEI
echo ��
echo �����޸ļ��������IP��ַ
echo ************************************
echo.
set /p num=���������(01-99):
set name=PC-%num%
set add=192.168.1.1%num%
set gateway=192.168.1.1
set mask=255.255.255.0
set DNS1=192.168.1.11
set DNS2=202.96.209.6
set DNS3=202.96.209.133
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName" /v ComputerName /d %name% /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "NV Hostname" /d %name% /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Hostname /d %name% /f
netsh interface ip Set address name="��������" source=static addr=%add% mask=%mask% gateway=%gateway% gwmetric=1
netsh interface ip Set dns "��������" source=static addr=%DNS1%
netsh interface ip add dns "��������" addr=%DNS2% index=2
netsh interface ip add dns "��������" addr=%DNS3% index=3
echo.
echo *******************
echo ���óɹ����!
echo *******************
echo.
Pause