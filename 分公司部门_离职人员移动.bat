@echo off
dsquery user "OU=�ֹ�˾��ﱸ��,DC=hlic,DC=cn" -disabled  -scope subtree -limit 0  > doc2.txt
for /f %%i in (doc2.txt) do dsmove %%i -newparent OU=�ֹ�˾��ְ��Ա,DC=hlic,DC=cn 