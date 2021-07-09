'************************************************************************************** 
'Script Name: ExpirationNotifier.vbs 
'Author : Carlton Colter 
'Purpose : To notify users of password expiration via E-Mail 
'Created : 8/4/2008 
'Note : Modification of Michael Smith's 2005 Script: 
' http://www.benway.net/2005/09/20/223/ 
' 
' Michael Smith's code pulled the maximum age from the domain, and had a lot of 
 ' debugging lines. I chose not to pull the maximum age from the domain because 
 ' I work mostly in hosted environments, and places that use SpecOps: 
 ' http://www.specopssoft.com/products/specopspasswordpolicy/ 
 ' 
 ' I also pulled out his debugging code because I didn't need it. 
 '************************************************************************************** 
 '************************************************************************************** 
 ' Per environment constants - you should change these! 
 Const SMTP_SERVER = "mailserver.hlic.cn" 
 Const LDAPPATH = "LDAP://ad00.hlic.cn/OU=²âÊÔOU,DC=hlic,DC=cn" 
 Const DAYS_FOR_EMAIL = 5
 ' System Constants - do not change 
 Const ONE_HUNDRED_NANOSECOND = .000000100 ' .000000100 is equal to 10^-7 
 Const SECONDS_IN_DAY = 86400 
 Const ADS_UF_DONT_EXPIRE_PASSWD = &h10000 
 Const E_ADS_PROPERTY_NOT_FOUND = &h8000500D 
 Dim numDays, iResult 
 Dim strDomainDN 
 Dim objContainer 
 numdays = 3 'Maximum Password Age 
 WScript.Echo numdays
 WScript.Echo LDAPPATH
 WScript.Echo SMTP_SERVER
 WScript.Echo DAYS_FOR_EMAIL
 If numDays > 0 Then 
 Set objContainer = GetObject (LDAPPATH) 
 ProcessOU objContainer, numDays 
 ProcessFolder objContainer, numDays 
 Set objContainer = Nothing 
 End If 
 WScript.Echo "Notification Complete" 
 '************************************************************************************** 
 Sub ProcessOU (OU, numDays) 
 Dim SubOU 
 ou.Filter = Array("OrganizationalUnit") 
 For Each SubOU in OU 
 ProcessOU SubOU, numDays 
 ProcessFolder SubOU, numDays 
 Next 
 End Sub 
 '************************************************************************************** 
 Function UserIsExpired (objUser, iMaxAge, iDaysForEmail, iResult) 
 Dim intUserAccountControl, dtmValue, intTimeInterval 
 Dim strName 
 On Error Resume Next 
 Err.Clear 
 WScript.Echo iMaxAge
 strName = Mid (objUser.Name, 4) 
 WScript.Echo strName
 intUserAccountControl = objUser.Get ("userAccountControl") 
 WScript.Echo intUserAccountControl
 If intUserAccountControl And ADS_UF_DONT_EXPIRE_PASSWD Then 
 UserIsExpired = True 
 Else 
 iResult = 0 
 dtmValue = objUser.PasswordLastChanged 
 WScript.Echo dtmValue
 If Err.Number = E_ADS_PROPERTY_NOT_FOUND Then 
 UserIsExpired = True 
 Else 
 intTimeInterval = Int (Now - dtmValue) 
 WScript.Echo intTimeInterval
 If intTimeInterval >= iMaxAge Then 
 UserIsExpired = True 
 Else 
 iResult = Int ((dtmValue + iMaxAge) - Now) 
 WScript.Echo iResult
 If iResult <= iDaysForEmail Then 
 UserIsExpired = True 
 Else 
 UserIsExpired = True 
 End If 
 End If 
 End If 
 End If 
 
 End Function 
 '************************************************************************************** 
 Sub ProcessFolder (objContainer, iMaxPwdAge) 
 Dim strName, iResult 
 objContainer.Filter = Array ("User") 
 For each objUser in objContainer 
 If InStr(objUser.sAMAccountName,"$")=0 Then 
 If UserIsExpired (strName, iMaxPwdAge, DAYS_FOR_EMAIL, iResult) Then 
 Call SendEmail (strName, iResult) 
 End If 
 End If 
 Next 
 End Sub 
 '************************************************************************************** 
 Sub SendEmail (objUser, iResult) 
 On Error Resume Next 'Ignore All Errors 
 WScript.Echo "sendemail"
 WScript.Echo iResult
 WScript.Echo objUser.givenname
 If iResult > 0 Then 
 If LEN(objUser.givenname)>1 Then 
 Dim objMail 
 Set objMail = CreateObject ("CDO.Message") 
 With objMail.Configuration.Fields 
 .Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
 .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = SMTP_SERVER 
 .Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 
 .Update 
 End With 
 ' Make it a high priority 
 With objMail.Fields 
 .Item("urn:schemas:mailheader:X-MSMail-Priority") = "High" ' For Outlook 2003 
 .Item("urn:schemas:mailheader:X-Priority") = 2 ' For Outlook 2003 also 
 .Item("urn:schemas:httpmail:importance") = 2 ' For Outlook Express 
 .Update 
 End With 
 ' Send the email to the user's userprincipal name (you can change this to .mail) 
 objMail.From = "administrator@hlic.cn" 'STRFROM 
 objMail.To = objUser.UserPrincipalName 
 objMail.Subject = "Automatic Password Expiration Notification" 
 objMail.Textbody = objUser.givenname & "," & vbCRLF & vbCRLF & _ 
 "Your password will expire in " & iResult & " days. " & vbCRLF & vbCRLF & _ 
 "It is important that you change your password or you will temporarily " & _ 
 "lose access to your computer and email." & vbCRLF & vbCRLF & _ 
 "SSL VPN users: To change your password while connected through " & _ 
 "SSL VPN, press Ctrl + Alt + Delete on your keyboard and then click " & _ 
 "Change Password." & vbCRLF & vbCRLF & _ 
 "Passwords must meet the following criteria:" & vbCRLF & _ 
 " * Must not match the previous 2 passwords used. " & vbCRLF & _ 
 " * At least 8 characters. " & vbCRLF & _ 
 " * Does not contain your account or full name. " & vbCRLF & _ 
 " * Contains at least 1 uppercase character (A through Z)" & vbCRLF & _ 
 " * Contains at least 1 digit (0 through 9)" & vbCRLF & vbCRLF & _ 
 "Do not reply to this email. If you have any questions or require additional" & _ 
 "information, please contact Internal Systems at 1-555-555-1212" & vbCRLF & vbCRLF & _ 
 "Thank you," & vbCRLF & vbCRLF & _ 
 "Internal Systems" 
 objMail.Send 
 WScript.Echo objMail.From
 WScript.Echo objMail.To
 Set objMail = Nothing 
 End If 
 End If 
 Err.Clear 
 On Error Goto 0 
 End Sub 
