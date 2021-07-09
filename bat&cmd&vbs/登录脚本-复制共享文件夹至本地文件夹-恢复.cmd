@echo off

if exist d:\everything%username% (goto xcopy) else (exit)

:xcopy

rd d:\everything%username% /s /q >nul

exit