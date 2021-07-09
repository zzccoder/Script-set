Const ADS_UF_DONT_EXPIRE_PASSWD = &h10000
Const LDAPPATH = "LDAP://ad00.hlic.cn/OU=总公司部门,DC=hlic,DC=cn"
Dim objContainer 

Set objContainer = GetObject (LDAPPATH)
ProcessOU objContainer
ProcessFolder objContainer
Set objContainer = Nothing 

'************************************************************************************** 
Sub ProcessOU (OU)
Dim SubOU 
ou.Filter = Array("OrganizationalUnit") 
For Each SubOU in OU 
ProcessOU SubOU 
ProcessFolder SubOU
Next 
End Sub 
'************************************************************************************** 
Sub ProcessFolder (objContainer)
Dim objUser
objContainer.Filter = Array ("User") 
For each objUser in objContainer 
intUAC = objUser.Get("userAccountControl")
If ADS_UF_DONT_EXPIRE_PASSWD AND intUAC Then
objUser.Put "userAccountControl", intUAC XOR _
ADS_UF_DONT_EXPIRE_PASSWD
objUser.SetInfo
'WScript.Echo "Password never expires is now disabled"
Else
'Wscript.echo "Already disabled"
End If
Next 
End Sub 
'************************************************************************************** 

