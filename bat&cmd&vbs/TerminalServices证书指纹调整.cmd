echo off
cls
set /p cert='a4 cd 6c 18 fc eb 4c 87 7a 48 86 2f 9c a9 e3 5e dd 90 e9 67'	
wmic /namespace:\\root\cimv2\TerminalServices PATH Win32_TSGeneralSetting Set SSLCertificateSHA1Hash="%cert%"
