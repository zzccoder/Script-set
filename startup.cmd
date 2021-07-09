@echo off 

rem 该脚本会在启动时在C盘根目录创建一个计算机名称加日期的文件夹

set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2% 

md "c:\%y%+%computername%"  

exit 