dns.bat
for /f "tokens=1,2,3,4 delims=," %%a in (C:\DNS.txt) do(
dnscmd localhost /RecordAdd test.cn %%a A %%b
dnscmd localhost /RecordAdd %%c.in-addr.arpa %%d PTR %%a test.cn
)