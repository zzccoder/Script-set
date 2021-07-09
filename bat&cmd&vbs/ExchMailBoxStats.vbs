'=============================================================================== 
' ExchMailBoxStats.vbs 
'=============================================================================== 
' Purpose: 
' Create a CSV Exchange Mailbox Statistics Report 
'=============================================================================== 
' References: 
' http://gallery.technet.microsoft.com/3c58eb37-30ee-44a3-adf0-b487684ae7bc
' http://msdn.microsoft.com/en-us/library/aa143732.aspx 
'=============================================================================== 
' Syntax: 
' cscript //NoLogo ExchMailBoxStats.vbs ["CN=Users,DC=CONTOSO,DC=COM"]
'=============================================================================== 
' Created by Martin Schvartzman
' Updated at 2014/01/17
'=============================================================================== 

Option Explicit

Dim sOutputFile: sOutputFile = OutputFileName() 
WScript.Echo Now & " - Starting " & WScript.ScriptName & " script" 
Dim arrServerNames: arrServerNames = Split(GetExchangeServers(),",") 
Dim dicStores: Set dicStores = CreateObject("Scripting.Dictionary"): dicStores.CompareMode = 1 
CreateStoresDictionary 
Dim sSearchScope: sSearchScope = GetSearchScope()
CreateMailboxStatsReport 
WScript.Echo "Mailbox Statistics Report completed: " & sOutputFile 
WScript.Echo Now & " - " & WScript.ScriptName & " finished!" 


Function GetSearchScope()
	Dim sRet
	If Wscript.Arguments.Count > 0 Then
		sRet = Wscript.Arguments.Item(0)
	Else
		sRet = GetObject("LDAP://rootDSE").Get("defaultNamingContext") 
	End If
	WScript.Echo "Using " + sRet + " as the root search scope for user accounts"
	GetSearchScope = sRet
End Function

Function OutputFileName() 
    OutputFileName = Left(WScript.ScriptFullName, Len(WScript.ScriptFullName)-3) & _ 
        ReverseDate() & ".csv" 
End Function 
 
Function ReverseDate() 
    Dim dt: dt = date(): dt = Year(dt)*1e4 + Month(dt)*1e2 + Day(dt) 
    ReverseDate = dt 
End Function 
 
Sub AppendToLog(sData) 
    With CreateObject("Scripting.FileSystemObject")._ 
        OpenTextFile(sOutputFile, 8, True) 
        .Write sData & vbNewLine: .Close 
    End With  
End Sub 
 
Function GetExchangeServers()
	On Error Resume Next
    Dim oConn, oCmd, oRs 
    Dim sCNC, sFilter, sQuery, sOutput 
    Set oConn = Createobject("ADODB.Connection") 
    Set oCmd = Createobject("ADODB.Command") 
    Set oRs = Createobject("ADODB.Recordset") 
    sCNC = "CN=Microsoft Exchange,CN=Services," & _ 
                    GetObject("LDAP://RootDSE").Get("configurationNamingContext") 
    sFilter = "(&(objectCategory=msExchExchangeServer)(objectClass=msExchExchangeServer))" 
    sQuery = "<LDAP://" & sCNC & ">;" & sFilter & ";name;subtree" 
    oConn.Provider = "ADsDSOObject" 
    oConn.Open "ADs Provider" 
    Wscript.Echo "Querying ActiveDirectory for Exchange Servers..." 
    oCmd.ActiveConnection = oConn 
    oCmd.CommandText = sQuery 
    Set oRs = oCmd.Execute
	If Err.Number = 0 Then
		While Not oRs.EOF 
			sOutput = sOutput & oRs.Fields("name") & "," 
			oRs.MoveNext 
		Wend
	End If
    If Right(sOutput,1) = "," Then sOutput = Left(sOutput,(Len(sOutput))-1) 
    WScript.Echo "Exchange Servers found in ActiveDirectory: " & sOutput 
    oRs.Close(): Set oRs = Nothing 
    Set oCmd = Nothing 
    oConn.Close(): Set oConn = Nothing 
    GetExchangeServers = sOutput 
End Function 
 
Sub CreateStoresDictionary
	On Error Resume Next
    Dim sCNC, sQuery, sFilter 
    Dim sStoreNameDictEntry, sStorePolicyDictEntry, oPolicy, sPolicyDN 
    sCNC = "CN=Microsoft Exchange,CN=Services," & _ 
                GetObject("LDAP://RootDSE").Get("configurationNamingContext") 
    Dim oConn: Set oConn = CreateObject("ADODB.Connection") 
    oConn.Provider = "ADsDSOObject" 
    oConn.Open "Active Directory Provider" 
    Dim oCmd: Set oCmd = CreateObject("ADODB.Command") 
    oCmd.ActiveConnection = oConn 
    oCmd.Properties("page size") = 15000 
    sFilter = "(&(objectClass=msExchPrivateMDB)(!objectClass=msExchPrivateMDBPolicy))" 
    sQuery = "<LDAP://" & sCNC & ">;" & _ 
        sFilter & ";cn,mDBStorageQuota,mDBOverQuotaLimit,mDBOverHardQuotaLimit;subtree" 
    oCmd.CommandText = sQuery 
    oCmd.Properties("Page Size") = 15000 
    oCmd.Properties("Timeout") = 90 
    WScript.Echo "Querying Exchange Information Stores Quota Settings..." 
    Dim oRs: Set oRs = Createobject("ADODB.Recordset") 
    Set oRs = oCmd.Execute
	If Err.Number = 0 Then
		If oRs.RecordCount > 0 Then 
			oRs.MoveFirst 
			Do Until oRs.EOF 
				  sStoreNameDictEntry = oRs.Fields("cn") 

				If IsNull(oRs.Fields("mDBStorageQuota")) Then 
					sStorePolicyDictEntry = "Unlimited," 
				Else 
					sStorePolicyDictEntry = ReportSize(oRs.Fields("mDBStorageQuota")) & "," 
				End If 
					 
				If IsNull(oRs.Fields("mDBOverQuotaLimit")) Then 
					sStorePolicyDictEntry = sStorePolicyDictEntry & "Unlimited," 
				Else 
					sStorePolicyDictEntry = sStorePolicyDictEntry & ReportSize(oRs.Fields("mDBOverQuotaLimit")) & "," 
				End If 
				 
				If IsNull(oRs.Fields("mDBOverHardQuotaLimit")) Then 
					sStorePolicyDictEntry = sStorePolicyDictEntry & "Unlimited," 
				Else 
					sStorePolicyDictEntry = sStorePolicyDictEntry & ReportSize(oRs.Fields("mDBOverHardQuotaLimit")) & "," 
				End If 
				 
				sStorePolicyDictEntry = sStorePolicyDictEntry & "Mailbox Store" 
				If Not dicStores.Exists(sStoreNameDictEntry) Then _ 
					dicStores.Add sStoreNameDictEntry, sStorePolicyDictEntry 
				oRs.MoveNext 
			Loop 
		End If
	End If
    oRs.Close(): Set oRs = Nothing 
    Set oCmd = Nothing 
    oConn.Close(): Set oConn = Nothing 
End Sub 
 
 
Sub CreateMailboxStatsReport 
    On Error Resume Next 
    Dim sServer, oWMIExchange, oMailboxes, oMailbox, sOutLine 
    If UBound(arrServerNames) >= 0 Then 
        AppendToLog "Account Name,User Principal Name,Display Name,EMail,OU,Issue Warning,Prohibit Send,Prohibit Send and Receive,Quota Set Level,Limit Status,Mailbox Size,Total Items,Mailbox Location, Last LoggedOn User Account"
        WScript.Echo "Querying Exchange Servers For Mailboxes..." 
        For Each sServer in arrServerNames 
            Set oWMIExchange = GetObject("winmgmts:{impersonationLevel=impersonate}!//" & _ 
                                sServer & "/root/MicrosoftExchangeV2") 
            If Err.Number <> 0 Then 
                WScript.Echo "Unable to connect to the " & sServer & _ 
                    "/root/MicrosoftExchangeV2 namespace." 
            Else 
                Set oMailboxes = oWMIExchange.ExecQuery("SELECT * FROM Exchange_Mailbox WHERE NOT LegacyDN LIKE '%SYSTEMMAILBOX%' AND NOT LegacyDN LIKE '%CN=CONFIGURATION/%'") 
                If (oMailboxes.count > 0) Then 
                    For Each oMailbox in oMailboxes 
                        If oMailbox.DateDiscoveredAbsentInDS <> "" Then 
                            sOutLine = "[Disconnected Mailbox],N/A,N/A,N/A,N/A,N/A,N/A,N/A,N/A," & _ 
                                        LimitStatus(oMailbox.StorageLimitInfo) & "," & ReportSize(oMailbox.Size) & "," & oMailbox.TotalItems & "," & _ 
                                            oMailbox.ServerName & "\" & oMailbox.StorageGroupName &  "\" & oMailbox.StoreName & "\" & oMailbox.MailboxDisplayName & ",N/A"
                        Else 
                            sOutLine = GetMailboxStatsFromAD(oMailbox.LegacyDN) & "," & _ 
                                        LimitStatus(oMailbox.StorageLimitInfo) & "," & ReportSize(oMailbox.Size) & "," & oMailbox.TotalItems & "," & _ 
                                            oMailbox.ServerName & "\" & oMailbox.StorageGroupName &  "\" & oMailbox.StoreName & "\" & oMailbox.MailboxDisplayName & "," & oMailbox.LastLoggedOnUserAccount
                        End If 
                        AppendToLog sOutLine 
                      Next 
                End If 
                Set oMailbox = Nothing 
                Set oMailboxes = Nothing 
            End If 
        Next 
        Set oWMIExchange = Nothing 
    Else 
        WScript.Echo "No Exchange Servers found in ActiveDirectory" 
    End If 
End Sub 
 
 
Function GetMailboxStatsFromAD(legacyExchangeDN) 
    Dim sQuery, sFilter, sFields, sRet, sHomeMDBCn 
    Dim sSamAccountName, sUserPrincipalName, sDisplayName, sMail, sQuota, sOU
    Dim oConn: Set oConn = CreateObject("ADODB.Connection") 
    oConn.Provider = "ADsDSOObject" 
    oConn.Open "Active Directory Provider" 
    Dim oCmd: Set oCmd = CreateObject("ADODB.Command") 
    oCmd.ActiveConnection = oConn 
    oCmd.Properties("page size") = 15000 
    sFilter = "(&(ObjectClass=user)(ObjectCategory=person)(legacyExchangeDN=" & legacyExchangeDN & "))" 
    sFields = "samAccountName,userPrincipalName,displayName,mail,mDBUseDefaults,mDBStorageQuota,mDBOverQuotaLimit,mDBOverHardQuotaLimit,homeMDB,distinguishedName" 
    sQuery = "<LDAP://" & sSearchScope & ">;" & sFilter & ";" & sFields & ";subtree" 
    oCmd.CommandText = sQuery 
    oCmd.Properties("Page Size") = 15000 
    oCmd.Properties("Timeout") = 90 
    Dim oRs: Set oRs = Createobject("ADODB.Recordset") 
    Set oRs = oCmd.Execute 
    If oRs.RecordCount > 0 Then 
        oRs.MoveFirst 
        Do Until oRs.EOF 
                 
            If IsNull(oRs.Fields("samAccountName")) Then 
                sSamAccountName = "N/A" 
            Else 
                sSamAccountName = oRs.Fields("samAccountName") 
            End If 
             
            If IsNull(oRs.Fields("userPrincipalName")) Then 
                sUserPrincipalName = "N/A" 
            Else 
                sUserPrincipalName = oRs.Fields("userPrincipalName") 
            End If 
             
            If IsNull(oRs.Fields("displayName")) Then 
                sDisplayName = "N/A" 
            Else 
                sDisplayName = Trim(oRs.Fields("displayName")) 
            End If 
             
            If IsNull(oRs.Fields("mail")) Then 
                sMail = "N/A" 
            Else 
                sMail = oRs.Fields("mail") 
            End If 
			
            If IsNull(oRs.Fields("distinguishedName")) Then 
                sOU = "N/A" 
            Else 
                sOU = oRs.Fields("distinguishedName") 
				sOU = Mid(sOU, InStr(sOU, ",") + 1 )
            End If 
             
            sRet = sSamAccountName & "," & sUserPrincipalName & "," & _ 
                    sDisplayName & "," & sMail & "," & sOU
 
            If Not CBool(oRs.Fields("mDBUseDefaults")) Then 
                If IsNull(oRs.Fields("mDBStorageQuota")) Then 
                    sQuota = "Unlimited" 
                Else 
                    sQuota = ReportSize(oRs.Fields("mDBStorageQuota")) 
                End If 
                 
                If IsNull(oRs.Fields("mDBOverQuotaLimit")) Then 
                    sQuota = sQuota & "," & "Unlimited" 
                Else 
                    sQuota = sQuota & "," & ReportSize(oRs.Fields("mDBOverQuotaLimit")) 
                End If 
                 
                If IsNull(oRs.Fields("mDBOverHardQuotaLimit")) Then 
                    sQuota = sQuota & "," & "Unlimited" 
                Else 
                    sQuota = sQuota & "," & ReportSize(oRs.Fields("mDBOverHardQuotaLimit")) 
                End If 
                 
                sRet = sRet & "," & sQuota & ",User" 
            Else 
                sHomeMDBCn = GetObject("LDAP://" & oRs.Fields("homeMDB")).cn 
                If dicStores.Exists(sHomeMDBCn) Then 
                    sRet = sRet & "," & dicStores.Item(sHomeMDBCn) 
                Else 
                    sRet = sRet & ",UnKnown,UnKnown,UnKnown,UnKnown" 
                End If 
            End If 
            oRs.MoveNext 
        Loop 
    End If 
    oRs.Close(): Set oRs = Nothing 
    Set oCmd = Nothing 
    oConn.Close(): Set oConn = Nothing 
    GetMailboxStatsFromAD = sRet 
End Function 
 
 
Function ReportSize(iSize) 
    Dim sUnit, i: i = 0 
    While iSize > 1000 
        iSize = Round(((iSize)/1024),2) 
        i = i + 1 
    Wend 
    Select Case i 
        Case 0: sUnit = " KB" 
        Case 1: sUnit = " MB" 
        Case 2: sUnit = " GB" 
        Case 3: sUnit = " TB" 
        Case 4: sUnit = " PB" 
    End Select 
    ReportSize = iSize & sUnit 
End Function 
 
 
Function LimitStatus(iStatus) 
    Dim sRet: sRet = "UnKnown" 
    Select Case iStatus 
        Case 1: sRet = "Below Limit" 
        Case 2: sRet = "Issue Warning" 
        Case 4: sRet = "Prohibit Send" 
        Case 8: sRet = "No Checking" 
        Case 16: sRet = "Mailbox Disabled" 
        Case Else: sRet= "UnKnown" 
    End Select 
    LimitStatus = sRet 
End Function