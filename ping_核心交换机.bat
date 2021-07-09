:b
ping -n 10 10.182.5.190

rem echo. >>ping_10.182.5.190.txt

echo |set /p=  %date%;%time% >>ping_10.182.5.190.txt

ping -n 1 -w 1000 10.182.5.190 | find "TTL" >>ping_10.182.5.190.txt
ping -n 1 -w 1000 10.182.5.190 | find "TTL"
if errorlevel 1 goto err
for /L %%i in (1,1,3) do echo delay %%is/30s & ping -n 1 -w 1000 1.1.1.1 >NUL
goto b
:err
echo. >>ping_10.182.5.190_err.txt
echo %date% %time% >>ping_10.182.5.190_err.txt
tracert -d -w 1000 10.182.5.190 >>ping_10.182.5.190_err.txt
echo. >>ping_10.182.5.190_err.txt
goto b
