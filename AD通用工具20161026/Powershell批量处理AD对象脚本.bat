@echo off
color 2f
title  Powershellִ�� 


:start
cls
echo.                 �˽ű�������
echo.                 ������������ѡ�����
echo.                 1.�鿴OU��OU��Ϣ
echo.                 2.�鿴OU������Ϣ
echo.                 3.�鿴OU���û���Ϣ
echo                  4.�����޸�OU���û�����
echo                    4.1 �����޸������û�����
echo.                 5.ɾ��OU��ȫ���û�
echo.                   5.1 ɾ��OU��ȫ����
echo.                   5.2 ɾ��OU��ȫ������
echo.                 6.OU���û��´ε�¼�����޸�����
echo.                 7.OU���û��ʺ�����/����
echo.                 8.��ӵ����û�
echo.                     8.1 ��ӵ���OU
echo.                     8.2 ��ӵ�����
echo.                     8.3 ���OU���û�����
echo.                 
set  /p a=            ��������:
if %a%==1 goto :�鿴OU��OU��Ϣ
if %a%==2 goto �鿴OU������Ϣ
if %a%==3   goto :�鿴OU���û���Ϣ
if %a%==4   goto �����޸�OU���û�����
if %a%==4.1   goto �����޸������û�����
if %a%==5 goto ����ɾ��OU���û�
if %a%==5.1  goto ����ɾ��OU����
if %a%==5.2 goto ɾ��OU��ȫ������
if %a%==6 goto OU���û��´ε�¼�����޸�����
if %a%==7 goto OU���û��ʺ�����/����
if %a%==8 goto ��ӵ����û�
if %a%==8.1 goto ��ӵ���OU
if %a%==8.2 goto ��ӵ�����
if %a%==8.3 goto ���OU���û�����

cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:�鿴OU��OU��Ϣ
cls
set /p a=����OU��DN��,��:ou=��˾����dc=abc,dc=com  : 
echo  Get-adorganizationalUnit -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getadou01.ps1
powershell .\getadou01.ps1
del .\getadou01.ps1
echo �����κμ��˳�
pause >nul
goto exit

:�鿴OU���û���Ϣ
cls
echo �鿴OU���û���Ϣ
set /p a=����OU��DN��,��:ou=��˾����dc=abc,dc=com  :
echo  Get-aduser -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getaduser01.ps1 
powershell .\getaduser01.ps1 
del .\getaduser01.ps1 
echo �����κμ��˳�
pause >nul
goto exit

:�鿴OU������Ϣ
cls
set /p a=����OU��DN��,��:ou=��˾����dc=abc,dc=com :
echo  Get-adgroup -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getadgroup01.ps1
powershell .\getadgroup01.ps1 
del .\getadgroup01.ps1 
echo �����κμ��˳�
pause >nul
goto exit


:�鿴ĳ������ȫ����Ա
cls
echo �鿴ĳ������ȫ����Ա
set /p a=�������� 
Get-ADGroupMember  -Identity "%a%"
echo �����κμ��˳�
pause >nul
goto exit


:�����޸�OU���û�����
cls
echo �����޸�OU���û�����
set /p a=�����˺ŵ�������,��Ҫ���������������:
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo $pw=ConvertTo-SecureString -String "%a%" -AsPlainText -Force >password.ps1
echo Get-ADUser -Filter * -searchbase "%b%" ^| Set-ADAccountPassword  -NewPassword $pw >>password.ps1
powershell .\password.ps1
echo �����κμ��˳�
pause >nul
del .\password.ps1 /q
goto exit

:�����޸������û�����
cls
echo �����޸������û�����
set /p a=�����˺ŵ�������,��Ҫ���������������:
set /p b=�����û������ƣ���"Sales":
echo $pw=ConvertTo-SecureString -String "%a%" -AsPlainText -Force >password2.ps1
echo Get-ADGroupMember "%b%" ^| Set-ADAccountPassword -NewPassword $pw >>password2.ps1
powershell .\password2.ps1
echo �����κμ��˳�
pause >nul
del .\password.ps1 /q
goto exit

:����ɾ��OU���û�
cls
echo ����ɾ��OU���û�
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo Get-ADUser -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADUser -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo �����κμ��˳�
pause >nul
del .\201607211626.ps1 /q
goto exit

:����ɾ��OU����
cls
echo ����ɾ��OU����
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo Get-ADgroup -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADgroup -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo �����κμ��˳�
pause >nul
del .\201607211626.ps1 /q
goto exit

:ɾ��OU��ȫ������
cls
echo ����ɾ��OU����
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo Get-ADobject -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo �����κμ��˳�
pause >nul
del .\201607211626.ps1 /q
goto exit

:OU���û��´ε�¼�����޸�����
cls
echo.
echo.
echo OU���û��´ε�¼�����޸�����
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo Get-ADUser -Filter * -searchbase "%b%" ^| set-aduser -ChangePasswordAtLogon:$true  >201607212025.ps1
powershell .\201607212025.ps1
echo �����κμ��˳�
pause >nul
del .\201607212025.ps1 /q
goto exit

:OU���û��ʺ�����/����
echo.
cls
echo.
echo.
echo  OU���û��ʺ�����/����
echo.
echo 1.����
echo 2.����

set /p a=

if %a%==1 set c=true&goto 2016
if %a%==2 set c=false&goto 2016



cls
echo.
echo.
echo ������� ���κμ�����ҳ
pause >nul
goto start

:2016
set /p b=����Ou��DN��,��"ou=��˾��,dc=abc,dc=com"�����������ţ�:
echo Get-ADUser -Filter * -searchbase "%b%" ^| set-aduser -ChangePasswordAtLogon:$%c% >201607212025.ps1
powershell .\201607212025.ps1
echo �����κμ��˳�
pause >nul
del .\201607212025.ps1 /q
goto exit


:��ӵ����û�
cls
echo.
echo.
echo.
echo �û���(Ӣ��):yuanw 
echo ����OU DN��:OU=��Ѷ��,Ou=��Խ��˾,DC=xifan,DC=com
echo ����:ԭί
echo ����:��Ѷ��
echo.
echo.
echo ����������
set /p a=�û���:
set /p b=����OU��DN��:
set /p c=����:
set /p d=����:

cls
echo.
echo New-ADUser -Name %a% -SamAccountName %a% -description %d%-%a% -UserPrincipalName %a%@%userdnsdomain%  -department %d%  -path "%b%" -displayname %c%  -Surname %c%  -AccountPassword(ConvertTo-SecureString -String "Cisco1988" -AsPlainText -Force) -ChangePasswordAtLogon:$true -Enabled:$true  >user20160721.ps1
echo Get-ADUser %a% ^| Set-ADObject -ProtectedFromAccidentalDeletion:$true >>user20160721.ps1
powershell .\user20160721.ps1
echo �����κμ��˳�
pause >nul
del .\user20160721.ps1 /q
goto exit

:��ӵ���OU
cls
echo. ��ӵ���OU
echo.
echo.
echo OU��:����
echo Path:ou=��Խ��˾��dc=xifan,dc=com
echo.
echo.
echo ����������
set /p a=OU��:
set /p b=Path:

cls
echo.
echo New-ADOrganizationalUnit -Name %a% -Path "%b%" -Description %a% -ProtectedFromAccidentalDeletion:$true >ou20160722.ps1
powershell .\ou20160722.ps1
echo �����κμ��˳�
pause >nul
del .\ou20160722.ps1 /q
goto exit

:��ӵ�����
cls
echo ��ӵ���Group
echo.
echo.
set /p a=����:
set  b=global
set  c=security
set /p d=·��Path:
echo new-adgroup -name %a% -samaccountname %a% -groupscope %b% -groupcategory %c% -path "%d%" -description %a% >group20160726.ps1
echo Get-ADgroup %a% ^| Set-ADObject -ProtectedFromAccidentalDeletion:$true >>group20160726.ps1
powershell .\group20160726.ps1
echo �����κμ��˳�
pause >nul
del .\group20160726.ps1 /q
goto exit

:���OU���û�����
cls
echo ���OU���û�����
echo.
echo.
set /p a=Path:
set /p b=����:
echo Get-ADUser -Filter * -SearchBase "%a%" ^| %%{Add-ADGroupMember "%b%" -Members $_.DistinguishedName} >groupmember.ps1
powershell .\groupmember.ps1 
echo �����κμ��˳�
pause >nul
del .\groupmember.ps1 /q
goto exit


:exit
goto start




