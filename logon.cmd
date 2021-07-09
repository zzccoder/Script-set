@echo off 

rem 该脚本会在登陆系统时在C盘创建一个用户名加当前日期的文件夹

set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2% 

md "c:\%y%+%username%" 

exit 

