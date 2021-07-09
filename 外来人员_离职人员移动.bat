@echo off
dsquery user "OU=外来人员组,DC=hlic,DC=cn" -disabled  -scope subtree >doc3.txt
for /f %%i in (doc3.txt) do dsmove %%i -newparent OU=总公司外包离场人员,DC=hlic,DC=cn >null
