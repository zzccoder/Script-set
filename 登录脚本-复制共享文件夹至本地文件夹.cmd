@echo off

if exist d:\everything%username% (exit) else (goto xcopy )

:xcopy

md d:\everything%username%

xcopy \\172.168.1.80\ad通用工具 d:\everything%username% /e /y >nul

exit



