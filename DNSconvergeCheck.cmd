:: DNSconvergeCheck.CMD / Microsoft Corporation / October 2008
:: Version 1.0

:: PURPOSE & USAGE: locate ':HELP' label toward bottom of script or run and supply a help switch

@echo off

:: Define operating environment
setlocal ENABLEDELAYEDEXPANSION

set stdOUT=nul
set retryDELAY=30
set retryCOUNT=0
set canaryNAME=_canary
set canaryVALUE=127.0.0.1
set scriptNAME=DNSconvergeCheck

:: Prepare window/console
title %scriptNAME%
echo/

:: Verify core binaries are present
for %%e in (find.exe findstr.exe dnscmd.exe nslookup.exe ping.exe) do (
	set where="%%~$PATH:e"
	if "!where!"=="""" (
		echo #ERROR - A required executable was not located within the path^^!
		echo          = '%%e'
		goto :END
	)
)

:: Define and verify arguments and operating environment
set sourceDNS=%1
set destinationDNS=%2
set DNSdomain=%3
set /a pingCOUNT=%retryDELAY% + 1

:: Check for help switches and sufficient arguments
echo "%*" | find /i "?" 1>%stdOUT% 2>&1
if not errorlevel 1 goto :HELP
echo "%*" | findstr /i "/help -help -h /h" 1>%stdOUT% 2>&1
if not errorlevel 1 goto :HELP
if "%~3"=="" (
	echo #ERROR - Insufficient arguments^^!
	echo/
	goto :HELP
)

:: Verify that source and destination name servers are NOT the same
if "%sourceDNS%"=="%destinationDNS%" (
	echo #ERROR - 'source' and 'destination' name servers are the same^^!
	echo/
	goto :HELP
)

:: Main script-body begins
echo ['%scriptNAME%' begins at %TIME:~0,-3% on %DATE%]
echo/

:: Confirming source name server is listening
set /p=- Confirming source name server [DNS] is listening     : <nul
ping -n 1 %sourceDNS% 1>%stdOUT% 2>&1 || (
	echo #FAILED^^! & echo/
	goto :ERROR1
)
nslookup -norecurse . %sourceDNS% 2>&1 | find /i "timed-out" 1>%stdOUT% 2>&1
if errorlevel 1 (
	echo SUCCESS^^!
) else (
	echo #FAILED^^! & echo/
	goto :ERROR1
)

:: Confirming destination name server is listening
set /p=- Confirming destination name server [DNS] is listening: <nul
ping -n 1 %destinationDNS% 1>%stdOUT% 2>&1 || (
	echo #FAILED^^! & echo/
	goto :ERROR2
)
nslookup -norecurse . %destinationDNS% 2>&1 | find /i "timed-out" 1>%stdOUT% 2>&1
if errorlevel 1 (
	echo SUCCESS^^!
) else (
	echo #FAILED^^! & echo/
	goto :ERROR2
)

echo/
echo + Verifying source name server holds supplied DNS domain [zone]
echo   = server's addresss: %sourceDNS%
echo   = querying domain  : %DNSdomain%
echo   = record [RR] type : SOA
echo   = DNS query type   : iterative

ping -n 3 localhost 1>nul 2>&1
nslookup -type=SOA -norecurse %DNSdomain%. %sourceDNS% 2>nul | find /i "primary name server" 1>%stdOUT% 2>&1
if errorlevel 1 (
	echo  #FAILED^^! & echo/
	goto :ERROR5
) else (
	echo / SUCCESS^^!
)

:: Confirming canary does NOT already exist on source
echo/
set /p=- Confirming test record does NOT exist on source      : <nul
nslookup %canaryNAME%.%DNSdomain%. %sourceDNS% 2>&1 | find /v "***" | find /i "%canaryNAME%" 1>%stdOUT% 2>&1
if not errorlevel 1 (
	echo #FAILED^^! & echo/
	goto :ERROR3
) else (
	echo SUCCESS^^!
)

:: Confirming canary does NOT already exist on destination
set /p=- Confirming test record does NOT exist on destination : <nul
nslookup %canaryNAME%.%DNSdomain%. %destinationDNS% 2>&1 | find /v "***" | find /i "%canaryNAME%" 1>%stdOUT% 2>&1
if not errorlevel 1 (
	echo #FAILED^^! & echo/
	goto :ERROR4
) else (
	echo SUCCESS^^!
)

echo/

:: Inject canary RR
echo/
echo  + Creating test RR on source name server
echo    = server's address : %sourceDNS%
echo    = record [RR] type : A
echo    = record [RR] name : %canaryNAME%.%DNSdomain%.
echo    = record [RR] value: %canaryVALUE%

set COMMANDline=dnscmd %sourceDNS% /recordadd %DNSdomain% %canaryNAME% A %canaryVALUE% 
%COMMANDline% 1>%stdOUT% 2>%TEMP%\%~n0.$$$
if errorlevel 1 (
	echo   #FAILED^^! & echo/
	call :ERROR6 add
	goto :END
	
) else (
	echo  / SUCCESS^^!
)

:: Begin repeatedly querying destination name server for replicated canary RR
echo/
echo  + Querying destination name server for test record
echo    [review title-bar for progress]
echo    = server's address    : %destinationDNS%
echo    = query retry interval: %retryDELAY% seconds
echo    = RR record's FQDN    : %canaryNAME%.%DNSdomain%.

:LOOP
set /a retryCOUNT+=1
title %scriptNAME% / Query #%retryCOUNT%

nslookup %canaryNAME%.%DNSdomain%. %destinationDNS% 2>%stdOUT% | find "%canaryVALUE%" 1>%stdOUT% 2>&1
if errorlevel 1 (
	ping -n %pingCOUNT% localhost 1>%stdOUT% 2>&1
	goto :LOOP
)

:: Record found in destination name server
echo      - test record successfully resolved by destination name server
echo      - %retryCOUNT% queries were submitted
echo  / SUCCESS^^! 

:: Remove canary RR from destination server
set COMMANDline=dnscmd %sourceDNS% /recorddelete %DNSdomain% %canaryNAME% A /f
%COMMANDline% 1>%stdOUT% 2>%TEMP%\%~n0.$$$
if errorlevel 1 (
	echo/
	echo #NOTE - a non-critical error occurred; see below.
	echo/
	call :ERROR6 remove
	goto :END
)

goto :END

:: Define functions/subs

:ERROR1
echo #ERROR - Source DNS server is NOT responding^^!
echo          = server's address: %sourceDNS%
goto :END

:ERROR2
echo #ERROR - Destination DNS server is NOT responding^^!
echo          = server's address: %destinationDNS%
goto :END

:ERROR3
echo #ERROR - Test RR already exists on source DNS server^^!
echo          = server's address: %sourceDNS%
echo          = record [RR] type: A
echo          = record [RR] name: %canaryNAME%.%DNSdomain%.
echo          = DNS query type  : iterative
echo/
call :RESOLUTION source
goto :END

:ERROR4
echo #ERROR - Test RR already exists on destination DNS server^^!
echo          = server's address: %destinationDNS%
echo          = record [RR] type: A
echo          = record [RR] name: %canaryNAME%.%DNSdomain%.
echo          = DNS query type  : iterative
echo/
call :RESOLUTION destination
goto :END

:ERROR5
echo #ERROR - Source DNS server does not host supplied domain^^!
echo          = server's address: %sourceDNS%
echo          = domain queried  : %DNSdomain%
echo          = record [RR] type: SOA
echo          = DNS query type  : iterative
goto :END

:ERROR6
echo #ERROR - 'dnscmd' failed to %1 the test RR^^!
echo          = Syntax and error[s] as follows -
echo/
echo %CD%^>%COMMANDline%
echo/
type %~n0.$$$
goto :EOF

:RESOLUTION
echo SOLUTION - In order to allow '%scriptNAME%' to run, the test
echo            record MUST first be removed from the %1 DNS server.
echo            This is achieved as follows -
echo/
echo             1. run the'DNS Management' console [DNSMGMT.MSC]
echo             2. focus the console on the %1 server
echo                a] right click on 'DNS'
echo                b] select 'Connect to DNS Server'
echo                c] select 'The following computer' radio-button
echo                d] enter the source server's IP address [%sourceDNS%]
echo                e] click 'OK'
echo             3. expand the source server [listed as server-name]
echo             4. expand 'Forward Lookup Zones'
echo             5. locate the '%DNSdomain%' zone and click it
echo             6. in the right pane, locate the '%canaryNAME%' record
echo             7. right click the '%canaryNAME%' record and select 'Delete'
goto :EOF

:HELP
echo SYNTAX -
echo/
echo  %~n0 ^<source name server^> ^<destination name server^> ^<FQDN of domain^>
echo/
echo HELP -
echo/
echo  %~n0 provides a means of verifying that a newly
echo  created DNS server has completed the replication of content from 
echo  an assumed/known-good 'source' DNS server.  The new DNS server is 
echo  referred to herein as the 'destination' server.
echo/

echo  %~n0 requires three arguments: 
echo            1) IP address of 'source' server
echo            2) IP address of 'destination' server
echo            3) DNS-name of the Active Directory domain housing the
echo               'source' and 'destination' name servers
echo/
echo  e.g. %~n0 10.1.0.1 10.7.4.1 northwindtraders.com
goto :STOP

:END
echo/
echo ['%scriptNAME%' completed at %TIME:~0,-3% on %DATE%]
echo/
title Command Prompt

:STOP
