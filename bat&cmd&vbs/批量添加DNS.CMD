for /f "tokens=1,2,3,4 delims=," %%a in (c:\dnslist.csv) do (
dnscmd . /recordadd hlic.cn %%a A %%b
dnscmd . /recordadd %%c.in-addr.arpa %%d PTR %%a.hlic.cn
)