@echo off
dsquery user "OU=������Ա��,DC=hlic,DC=cn" -disabled  -scope subtree >doc3.txt
for /f %%i in (doc3.txt) do dsmove %%i -newparent OU=�ܹ�˾����볡��Ա,DC=hlic,DC=cn >null
