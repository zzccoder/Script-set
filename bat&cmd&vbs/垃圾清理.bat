@echo off 
echo ��������ϵͳ�����ļ������Ե�...... 
del /f /s /q %systemdrive%\*.tmp 
del /f /s /q %systemdrive%\*._mp 
del /f /s /q %systemdrive%\*.log 
del /f /s /q %systemdrive%\*.gid 
del /f /s /q %systemdrive%\*.chk 
del /f /s /q %systemdrive%\*.old 
del /f /s /q %systemdrive%\recycled\*.* 
del /f /s /q %windir%\*.bak 
del /f /s /q %windir%\prefetch\*.* 
rd /s /q %windir%\temp & md %windir%\temp 
del /f /q %userprofile%\cookies\*.* 
del /f /q %userprofile%\recent\*.* 
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*" 
del /f /s /q "%userprofile%\Local Settings\Temp\*.*" 
del /f /s /q "%userprofile%\recent\*.*" 
echo ����ϵͳ������ɣ� 
ECHO �ļ�������ϣ���������3����˳������ڽ��뵹��ʱ......... 
@echo off 
echo WScript.Sleep 300 > %temp%.\tmp$$$.vbs 
set /a i =3 
:Timeout 
if %i% == 0 goto Next 
setlocal 
set /a i = %i% - 1 
echo ����ʱ����%i% 
cscript //nologo %temp%.\tmp$$$.vbs 
goto Timeout 
goto End 
:Next 
cls & 
echo. 
for %%f in (%temp%.\tmp$$$.vbs*) do del %%f 
echo.