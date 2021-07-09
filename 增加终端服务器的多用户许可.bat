@echo off
　　setlocal
　　set regkey="HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\Licensing Core"
　　reg add %regkey% /v EnableConcurrentSessions /T REG_DWORD /D 1 /f
　　endlocal
