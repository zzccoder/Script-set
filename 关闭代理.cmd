@echo off

rem 关闭代理

echo.

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_Dword /d 0 /f 