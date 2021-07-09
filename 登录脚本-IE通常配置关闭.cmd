@echo off

rem 打开弹出窗口阻止程序

reg add "HKCU\Software\Microsoft\Internet Explorer\New Windows" /v PopupMgr /t REG_dword /d 1 /f 

rem 打勾IE安全设置-站点-对该区域中的所有站点要求服务器验证https

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v Flags /t Reg_DWORD /d 71 /f