set logdate=%date:~0,4%%date:~5,2%%date:~8,2%
(echo open 10.179.201.135
echo log
echo log.135
echo lcd %SystemRoot%\System32\winevt\Logs
echo cd yht
echo cd 0.78
echo mkdir %logdate%
echo cd %logdate%
echo bin
echo prompt off
echo put System.evtx
echo put Security.evtx 
echo put Application.evtx
echo bye) > c:\ftp_log.txt

c:\windows\system32\ftp.exe -s:c:\ftp_log.txt