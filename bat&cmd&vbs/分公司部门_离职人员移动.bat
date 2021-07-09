@echo off
dsquery user "OU=分公司或筹备组,DC=hlic,DC=cn" -disabled  -scope subtree -limit 0  > doc2.txt
for /f %%i in (doc2.txt) do dsmove %%i -newparent OU=分公司离职人员,DC=hlic,DC=cn 