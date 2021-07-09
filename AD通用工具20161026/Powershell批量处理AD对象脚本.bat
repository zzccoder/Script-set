@echo off
color 2f
title  Powershell执行 


:start
cls
echo.                 此脚本适用于
echo.                 输入以下数字选择操作
echo.                 1.查看OU内OU信息
echo.                 2.查看OU内组信息
echo.                 3.查看OU内用户信息
echo                  4.批量修改OU内用户密码
echo                    4.1 批量修改组内用户密码
echo.                 5.删除OU下全部用户
echo.                   5.1 删除OU下全部组
echo.                   5.2 删除OU下全部对象
echo.                 6.OU下用户下次登录必须修改密码
echo.                 7.OU下用户帐号启用/禁用
echo.                 8.添加单个用户
echo.                     8.1 添加单个OU
echo.                     8.2 添加单个组
echo.                     8.3 添加OU下用户到组
echo.                 
set  /p a=            输入数字:
if %a%==1 goto :查看OU内OU信息
if %a%==2 goto 查看OU内组信息
if %a%==3   goto :查看OU内用户信息
if %a%==4   goto 批量修改OU内用户密码
if %a%==4.1   goto 批量修改组内用户密码
if %a%==5 goto 批量删除OU下用户
if %a%==5.1  goto 批量删除OU下组
if %a%==5.2 goto 删除OU下全部对象
if %a%==6 goto OU下用户下次登录必须修改密码
if %a%==7 goto OU下用户帐号启用/禁用
if %a%==8 goto 添加单个用户
if %a%==8.1 goto 添加单个OU
if %a%==8.2 goto 添加单个组
if %a%==8.3 goto 添加OU下用户到组

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:查看OU内OU信息
cls
set /p a=输入OU的DN名,如:ou=公司名，dc=abc,dc=com  : 
echo  Get-adorganizationalUnit -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getadou01.ps1
powershell .\getadou01.ps1
del .\getadou01.ps1
echo 输入任何键退出
pause >nul
goto exit

:查看OU内用户信息
cls
echo 查看OU内用户信息
set /p a=输入OU的DN名,如:ou=公司名，dc=abc,dc=com  :
echo  Get-aduser -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getaduser01.ps1 
powershell .\getaduser01.ps1 
del .\getaduser01.ps1 
echo 输入任何键退出
pause >nul
goto exit

:查看OU内组信息
cls
set /p a=输入OU的DN名,如:ou=公司名，dc=abc,dc=com :
echo  Get-adgroup -Filter * -SearchBase "%a%" ^| FL DistinguishedName >getadgroup01.ps1
powershell .\getadgroup01.ps1 
del .\getadgroup01.ps1 
echo 输入任何键退出
pause >nul
goto exit


:查看某个组内全部成员
cls
echo 查看某个组内全部成员
set /p a=输入组名 
Get-ADGroupMember  -Identity "%a%"
echo 输入任何键退出
pause >nul
goto exit


:批量修改OU内用户密码
cls
echo 批量修改OU内用户密码
set /p a=输入账号的新密码,需要符合密码策略需求:
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo $pw=ConvertTo-SecureString -String "%a%" -AsPlainText -Force >password.ps1
echo Get-ADUser -Filter * -searchbase "%b%" ^| Set-ADAccountPassword  -NewPassword $pw >>password.ps1
powershell .\password.ps1
echo 输入任何键退出
pause >nul
del .\password.ps1 /q
goto exit

:批量修改组内用户密码
cls
echo 批量修改组内用户密码
set /p a=输入账号的新密码,需要符合密码策略需求:
set /p b=输入用户组名称，如"Sales":
echo $pw=ConvertTo-SecureString -String "%a%" -AsPlainText -Force >password2.ps1
echo Get-ADGroupMember "%b%" ^| Set-ADAccountPassword -NewPassword $pw >>password2.ps1
powershell .\password2.ps1
echo 输入任何键退出
pause >nul
del .\password.ps1 /q
goto exit

:批量删除OU下用户
cls
echo 批量删除OU下用户
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo Get-ADUser -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADUser -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo 输入任何键退出
pause >nul
del .\201607211626.ps1 /q
goto exit

:批量删除OU下组
cls
echo 批量删除OU下组
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo Get-ADgroup -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADgroup -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo 输入任何键退出
pause >nul
del .\201607211626.ps1 /q
goto exit

:删除OU下全部对象
cls
echo 批量删除OU下组
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo Get-ADobject -Filter * -searchbase "%b%" ^| Set-ADObject -ProtectedFromAccidentalDeletion:$false >201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
echo Get-ADobject -Filter * -searchbase "%b%" ^| Remove-ADObject -Confirm:$false >>201607211626.ps1
powershell .\201607211626.ps1
echo 输入任何键退出
pause >nul
del .\201607211626.ps1 /q
goto exit

:OU下用户下次登录必须修改密码
cls
echo.
echo.
echo OU下用户下次登录必须修改密码
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo Get-ADUser -Filter * -searchbase "%b%" ^| set-aduser -ChangePasswordAtLogon:$true  >201607212025.ps1
powershell .\201607212025.ps1
echo 输入任何键退出
pause >nul
del .\201607212025.ps1 /q
goto exit

:OU下用户帐号启用/禁用
echo.
cls
echo.
echo.
echo  OU下用户帐号启用/禁用
echo.
echo 1.启用
echo 2.禁用

set /p a=

if %a%==1 set c=true&goto 2016
if %a%==2 set c=false&goto 2016



cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:2016
set /p b=输入Ou的DN名,如"ou=公司名,dc=abc,dc=com"（不包括引号）:
echo Get-ADUser -Filter * -searchbase "%b%" ^| set-aduser -ChangePasswordAtLogon:$%c% >201607212025.ps1
powershell .\201607212025.ps1
echo 输入任何键退出
pause >nul
del .\201607212025.ps1 /q
goto exit


:添加单个用户
cls
echo.
echo.
echo.
echo 用户名(英文):yuanw 
echo 所在OU DN名:OU=资讯部,Ou=天越公司,DC=xifan,DC=com
echo 姓名:原委
echo 部门:资讯部
echo.
echo.
echo 请依次输入
set /p a=用户名:
set /p b=所在OU的DN名:
set /p c=姓名:
set /p d=部门:

cls
echo.
echo New-ADUser -Name %a% -SamAccountName %a% -description %d%-%a% -UserPrincipalName %a%@%userdnsdomain%  -department %d%  -path "%b%" -displayname %c%  -Surname %c%  -AccountPassword(ConvertTo-SecureString -String "Cisco1988" -AsPlainText -Force) -ChangePasswordAtLogon:$true -Enabled:$true  >user20160721.ps1
echo Get-ADUser %a% ^| Set-ADObject -ProtectedFromAccidentalDeletion:$true >>user20160721.ps1
powershell .\user20160721.ps1
echo 输入任何键退出
pause >nul
del .\user20160721.ps1 /q
goto exit

:添加单个OU
cls
echo. 添加单个OU
echo.
echo.
echo OU名:管理部
echo Path:ou=天越公司，dc=xifan,dc=com
echo.
echo.
echo 请依次输入
set /p a=OU名:
set /p b=Path:

cls
echo.
echo New-ADOrganizationalUnit -Name %a% -Path "%b%" -Description %a% -ProtectedFromAccidentalDeletion:$true >ou20160722.ps1
powershell .\ou20160722.ps1
echo 输入任何键退出
pause >nul
del .\ou20160722.ps1 /q
goto exit

:添加单个组
cls
echo 添加单个Group
echo.
echo.
set /p a=组名:
set  b=global
set  c=security
set /p d=路径Path:
echo new-adgroup -name %a% -samaccountname %a% -groupscope %b% -groupcategory %c% -path "%d%" -description %a% >group20160726.ps1
echo Get-ADgroup %a% ^| Set-ADObject -ProtectedFromAccidentalDeletion:$true >>group20160726.ps1
powershell .\group20160726.ps1
echo 输入任何键退出
pause >nul
del .\group20160726.ps1 /q
goto exit

:添加OU下用户到组
cls
echo 添加OU下用户到组
echo.
echo.
set /p a=Path:
set /p b=组名:
echo Get-ADUser -Filter * -SearchBase "%a%" ^| %%{Add-ADGroupMember "%b%" -Members $_.DistinguishedName} >groupmember.ps1
powershell .\groupmember.ps1 
echo 输入任何键退出
pause >nul
del .\groupmember.ps1 /q
goto exit


:exit
goto start




