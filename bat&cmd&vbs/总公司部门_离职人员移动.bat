@echo off
dsquery user "OU=�ܹ�˾����,DC=hlic,DC=cn" -disabled  -scope subtree > doc1.txt
for /f %%i in (doc1.txt) do dsmove %%i -newparent OU=�ܹ�˾��ְ��Ա,DC=hlic,DC=cn 
