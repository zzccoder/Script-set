net start MpsSvc
::开启服务

sc config MpsSvc start= auto
::开机启动

netsh advfirewall set allprofiles state on
::启用防火墙

netsh advfirewall firewall add rule name="Allow Ping" dir=in protocol=icmpv4 action=allow
netsh advfirewall firewall add rule name="FTP" protocol=TCP dir=in localport=20 action=allow
netsh advfirewall firewall add rule name="FTP" protocol=TCP dir=in localport=21 action=allow
netsh advfirewall firewall add rule name="SSH" protocol=TCP dir=in localport=22 action=allow
netsh advfirewall firewall add rule name="Telnet" protocol=TCP dir=in localport=23 action=allow
netsh advfirewall firewall add rule name="SMTP" protocol=TCP dir=in localport=25 action=allow
netsh advfirewall firewall add rule name="TFTP" protocol=UDP dir=in localport=69 action=allow
netsh advfirewall firewall add rule name="POP3" protocol=TCP dir=in localport=110 action=allow
netsh advfirewall firewall add rule name="HTTPS" protocol=TCP dir=in localport=443 action=allow
netsh advfirewall firewall add rule name="Netbios-ns" protocol=UDP dir=in localport=137 action=allow 
netsh advfirewall firewall add rule name="Netbios-dgm" protocol=UDP dir=in localport=138 action=allow 
netsh advfirewall firewall add rule name="Netbios-ssn" protocol=TCP dir=in localport=139 action=allow 
netsh advfirewall firewall add rule name="Netbios-ds" protocol=TCP dir=in localport=445 action=allow 
netsh advfirewall firewall add rule name="HTTP" protocol=TCP dir=in localport=80 action=allow
netsh advfirewall firewall add rule name="HTTP" protocol=TCP dir=in localport=8080 action=allow
::常用端口


@echo off
net start SessionEnv
net start TermService
::开启服务

sc config SessionEnv start= demand
sc config TermService start= demand
::开机手动启动


REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
::开启选项

netsh advfirewall firewall add rule name="Remote Desktop" protocol=TCP dir=in localport=3389 action=allow
::开启3389端口