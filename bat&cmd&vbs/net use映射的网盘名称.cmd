@echo off
rem 映射磁盘
rem net use x: \\127.0.0.1\test username "password" /savecred /persistent:yes
for /f "tokens=* delims=" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MountPoints2" ^| find /i "##" ') do call :func %%i
echo OK
pause>nul
goto :end

:func
set pth=%*
set nm=%pth:*##=%
set nm=%nm:*#=%
reg add "%pth%" /v _LabelFromDesktopINI /t reg_sz /d "%nm%" /f >nul
goto :end
