For /F "tokens=1,2,3 Delims=," %a in (c:\UserList.txt) do dsadd user "CN=%c,OU=%a,DC=nmky,DC=Com" -upn %b@nmky.com -display %c -pwd p@ssw0rd -pwdneverexpires yes -disabled no -mustchpwd yes
