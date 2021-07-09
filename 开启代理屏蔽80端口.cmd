@echo off

rem "打开代理" "排除网站+本地" "通用这个代理"

rem 打开代理

echo.

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_Dword /d 1 /f 

echo.

rem 排除网站+本地

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v Proxyoverride /t REG_SZ /d "www.baidu.com;www.qq.com;<local>" /f

echo.

rem 通用这个代理

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v Proxyserver /t REG_SZ /d "127.0.0.1:80" /f