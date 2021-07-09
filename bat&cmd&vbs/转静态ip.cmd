@echo on

读取本机Mac地址

if exist ipconfig.txt del ipconfig.txt

ipconfig all ipconfig.txt

读取本机ip地址

if exist IPAddr.txt del IPaddr.txt

find IP Address ipconfig.txt IPAddr.txt

find Subnet Mask ipconfig.txt MASKAddr.txt

for f skip=2 tokens=15 %%I in (IPAddr.txt) do set IP=%%I

for f skip=2 tokens=15 %%m in (MASKAddr.txt) do set MASKS=%%m

读取网关地址

if exist GateIP.txt del GateIP.txt

find Default Gateway ipconfig.txt GateIP.txt

for f skip=2 tokens=13 %%G in (GateIP.txt) do set GateIP=%%G

读取DNS地址

if exist DNSServers.txt del DNSServers.txt

find DNS Servers ipconfig.txt DNSServers.txt

for f skip=2 tokens=15 %%e in (DNSServers.txt) do set DNSIP=%%e

设置本机IP地址

netsh interface ip set address name=本地连接 static %IP% %MASKS% %GateIP% 1

netsh int ip add dns name=本地连接 %DNSIP% index=1

清理文件

del q ipconfig.txt

del q IPAddr.txt

del q MASKAddr.txt

del q GateIP.txt

del q DNSServers.txt

echo 任务完成