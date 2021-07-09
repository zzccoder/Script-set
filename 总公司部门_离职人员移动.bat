@echo off
dsquery user "OU=总公司部门,DC=hlic,DC=cn" -disabled  -scope subtree > doc1.txt
for /f %%i in (doc1.txt) do dsmove %%i -newparent OU=总公司离职人员,DC=hlic,DC=cn 
