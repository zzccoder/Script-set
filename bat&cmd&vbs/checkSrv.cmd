


@echo off   
  
:begin   
ping 10.108.34.111 >nul 1>nul 2>nul && goto ok || goto err 
ping 10.108.34.112 >nul 1>nul 2>nul && goto ok || goto err 
ping 10.108.34.121 >nul 1>nul 2>nul && goto ok || goto err 
ping 10.108.34.122 >nul 1>nul 2>nul && goto ok || goto err 
ping 10.108.34.123 >nul 1>nul 2>nul && goto ok || goto err 
ping 10.108.34.125 >nul 1>nul 2>nul && goto ok || goto err 
telnet xfrsad.hlic.cn 389 >nul 1>nul 2>nul && goto ok || goto err 
  
:ok   
@echo ok!   
goto begin   
  
:err   
@echo err!   
goto begin  
