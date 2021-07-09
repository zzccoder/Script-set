@echo off

title 强制更新组策略

:start

echo.

echo.

echo %time%

gpupdate /force 

pause

goto start