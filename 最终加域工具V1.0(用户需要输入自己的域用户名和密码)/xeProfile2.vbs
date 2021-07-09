'ע�⣺ǿ�ҽ������ǰ���ݵ�ǰ�û���Profile

'���ܣ����򼰹���Profile
'�汾��1.0
'��̣���ʯ��ͳһ�ʼ���Ŀ��
'��˾��΢���й����޹�˾

'����˵����
'�ű�Ϊ�˿��ǵ�Windows 2000��������Щû��Ӧ�����µĽű�����
'�ű���ʱ�뿼����VB��ִ�г���������Щ����û��Ӧ��WScript����ķ���
'���ڿ���ʱ���൱�̣����������кܶ಻��֮������ӭ����ָ��

Option Explicit
Const XE_CONFIG_FILENAME = "xeConfig.ini"
Const LOG_FILENAME = "%SystemRoot%\join2dc.log"
'����û�������ȡRemoteSID����ͨ�����˺ż��ɣ�
Const CONST_DOMAIN_USER = "sinopec\joindomain"
Const CONST_DOMAIN_PASSWORD = "J398qyan"

'���������򣬵���һ����������Ϊ�˵���Exit Sub�˳�����
Call Main

'������
Sub Main()
  Dim msg
  msg = "��������ȷ��������ָ�����������ļ�"
  If wscript.Arguments.Count = 0 Then
    MyPrint (msg)
    Exit Sub
  End If
  If UCase(wscript.Arguments.Item(0)) = "/JOIN2DOMAIN" Then
    Join2Domain
  Else
    MyPrint (msg)
  End If
End Sub

Sub Join2Domain()
  '������Ϣ�������Ŵ�������Ǳ�������Ա�������޷��ռ�
  myShell ("cmd /c %SystemRoot%\system32\ipconfig /all >>" & LOG_FILENAME)
  myShell ("cmd /c set >>" & LOG_FILENAME)
  MyPrint ("(Start)")
  MyPrint ("")
    
  MyPrint ("�����ռ����ű��ļ���Ϣ...")
  Dim gScriptFullName
  gScriptFullName = wscript.ScriptFullName
  MyPrint ("���ű��ļ�����" & gScriptFullName)
  Dim gFileLastModified, gFileSize
  Call GetFileInfo(gScriptFullName, gFileLastModified, gFileSize)
  MyPrint ("���ű�����޸�ʱ�䣺" & gFileLastModified)
  MyPrint ("���ű��ļ���С��" & gFileSize)
  MyPrint ("OK")

  
  MyPrint ("���ڼ�������ļ�" & XE_CONFIG_FILENAME & "...")
  Dim gMSG, gINIDNS, gINIDomainDNSName, gINIDomainNetbiosName, gINIDCNetbiosName
  gMSG = GetConfig(XE_CONFIG_FILENAME, gINIDNS, gINIDCNetbiosName, gINIDomainDNSName, gINIDomainNetbiosName)
  If gMSG <> "OK" Then
    MyPrint (gMSG)
    Exit Sub
  End If
  MyPrint ("DNS��" & gINIDNS)
  MyPrint ("DCNetbiosName��" & gINIDCNetbiosName)
  MyPrint ("DomainDNSName��" & gINIDomainDNSName)
  MyPrint ("DomainNetbiosName��" & gINIDomainNetbiosName)
  MyPrint ("OK")

  
  MyPrint ("���ڼ��DNS����...")
  Dim gPosition, gDNS1, gDNS2
  gPosition = InStr(1, gINIDNS, ",", 1)
  If gPosition = 0 Then
    MyPrint ("�����ļ�DNS���ô���")
    Exit Sub
  End If
  gDNS1 = Mid(gINIDNS, 1, gPosition - 1)
  gDNS2 = Mid(gINIDNS, gPosition + 1)
  myShell ("cmd /c %SystemRoot%\system32\ipconfig /all > ipconfig.txt")
  If Not DNSConfigOK("ipconfig.txt", gDNS1, gDNS2) Then
    MyPrint ("�ͻ���DNS���ô���")
    MyPrint ("�ͻ�����DNSӦΪ��" & gDNS1 & "����DNSӦΪ��" & gDNS2)
    Exit Sub
  End If
  MyPrint ("OK")

  
  MyPrint ("���ڼ�����ϵͳ...")
  Dim gCSName, gVersion, gCSDVersion, gSerialNumber
  Call GetOS(gCSName, gVersion, gCSDVersion, gSerialNumber)
  MyPrint ("��������" & gCSName)
  MyPrint ("����ϵͳ�汾�ţ�" & gVersion)
  MyPrint ("Service Pack��" & gCSDVersion)
  MyPrint ("���кţ�" & gSerialNumber)
  If gVersion < "5.0.2195" Then
    MyPrint ("����ϵͳ����Windows 2000����")
    Exit Sub
  End If
  If gVersion = "5.1.2600" And IsXPHomeVersion Then
    MyPrint ("Windows XP Home�治�ܼ�����������Windows XP Professional")
    Exit Sub
  End If
  If gVersion = "5.0.2195" And gCSDVersion < "Service Pack 4" Then
    MyPrint ("Windows 2000����Service Pack 4����")
    Exit Sub
  ElseIf gVersion = "5.1.2600" And gCSDVersion < "Service Pack 1" Then
    MyPrint ("Windows XP����Service Pack 1����")
    Exit Sub
  ElseIf gVersion = "5.2.3790" And gCSDVersion < "Service Pack 1" Then
    MyPrint ("Windows 2003����Service Pack 1����")
    Exit Sub
  End If
  MyPrint ("OK")

  
  MyPrint ("���ڼ��������ɫ...")
  Dim gComputerRole
  gComputerRole = GetComputerRole
  Select Case gComputerRole
    Case 0: MyPrint ("�����ǹ�����ģʽ��רҵ�����ϵͳ")
    Case 1: MyPrint ("�������Ѽ������רҵ�����ϵͳ")
    Case 2: MyPrint ("�����ǹ�����ģʽ�ķ���������ϵͳ")
    Case 3: MyPrint ("�������Ѽ�����ķ���������ϵͳ")
    Case 4: MyPrint ("�������������")
    Case 5: MyPrint ("�������������")
  End Select
  If gComputerRole = 4 Or gComputerRole = 5 Then
    MyPrint ("�����߲������������������")
    Exit Sub
  ElseIf gComputerRole = 1 Or gComputerRole = 3 Then
    MyPrint ("�����Ѽ����򣬱����߲���ִ��")
    Exit Sub
  End If
  MyPrint ("OK")

    
  If gVersion >= "5.1.2600" Then
    MyPrint ("���ڼ������...")
    Dim gConnectionID
    If EnableWireless(gConnectionID) Then
      MyPrint ("��Ͽ����������������������" & gConnectionID)
      Exit Sub
    End If
    If GetLANNumber <> 1 Then
      MyPrint ("��ȷ��ֻ��һ������������������")
      Exit Sub
    End If
    MyPrint ("OK")
  End If

    
  MyPrint ("���ڼ��Ĭ���û�����Ĭ������...")
  Dim gDefaultUserName, gDefaultDomainName
  Call GetDefaultUserName(gDefaultUserName, gDefaultDomainName)
  If gDefaultUserName = "" Or gDefaultDomainName = "" Then
    MyPrint ("�޷�ȡ��Ĭ���û�����Ĭ������")
    Exit Sub
  End If
  MyPrint ("Ĭ���û�����" & gDefaultUserName)
  MyPrint ("Ĭ��������" & gDefaultDomainName)
  MyPrint ("OK")

     
  MyPrint ("���ڼ��" & gDefaultUserName & "�Ƿ��Ǳ�������Ա...")
  If Not IsAdmin(gDefaultUserName) Then
    MyPrint (gDefaultUserName & "���Ǳ�������Ա")
    Exit Sub
  End If
  MyPrint (gDefaultUserName & "�Ǳ�������Ա")
  MyPrint ("OK")

    
  MyPrint ("���ڼ��" & gDefaultUserName & "��SID...")
  Dim gSID
  gSID = GetSID(gDefaultUserName)
  If gSID = "" Then
    MyPrint ("�޷���ȡ" & gDefaultUserName & "��SID")
    Exit Sub
  End If
  MyPrint (gDefaultUserName & "��SID��" & gSID)
  MyPrint ("OK")

      
  MyPrint ("���ڼ��" & gDefaultUserName & "��Profileλ��...")
  Dim gProfileImagePath
  Call GetProfileImagePath(gSID, gProfileImagePath)
  If gProfileImagePath = "" Then
    MyPrint ("�޷���ȡ" & gDefaultUserName & "��Profileλ��")
    Exit Sub
  End If
  MyPrint (gDefaultUserName & "��Profileλ�ã�" & gProfileImagePath)
  MyPrint ("OK")

    
  Dim gDriver
  gDriver = Mid(gProfileImagePath, 1, 1)
  MyPrint ("���ڼ��" & gDriver & "���Ƿ���NTFS...")
  '��������Ժ�������ã�������
  Dim ProfileIsNTFS
  ProfileIsNTFS = IsNTFS(gDriver & ":")
  If ProfileIsNTFS Then
    MyPrint (gDriver & "����NTFS")
    MyPrint ("OK")
    MyPrint ("���ڼ��ProfileȨ��...")
    Dim gProfilePermission
    gProfilePermission = "cmd /c %SystemRoot%\system32\cscript XCACLS.vbs " & Chr(34) & gProfileImagePath & Chr(34) & " > xcacls.txt"
    MyPrint (gProfilePermission)
    myShell (gProfilePermission)
    If Not IsAdministratorsPermission Then
      MyPrint ("Profileû��Administrators��Full ControlȨ��")
      MyPrint ("�������Profile��Administrators��Full ControlȨ��...")
      gProfilePermission = "cmd /c %SystemRoot%\system32\cscript XCACLS.vbs " & Chr(34) & gProfileImagePath & Chr(34) & " /e /g administrators:f"
      MyPrint (gProfilePermission)
      myShell (gProfilePermission)
    End If
  Else
    MyPrint (gDriver & "�̲���NTFS")
  End If
  MyPrint ("OK")
      

  Dim gInputDomainUser1
  gInputDomainUser1 = Trim(InputBox("�������������û���", "�й�ʯ�ͻ����ɷ����޹�˾"))
  If gInputDomainUser1 = "" Then
    MyPrint ("�û�������Ϊ��")
    Exit Sub
  End If
  Dim gInputDomainPassword
  gInputDomainPassword = Trim(InputBox("�������������û�����", "�й�ʯ�ͻ����ɷ����޹�˾"))
  If gInputDomainPassword = "" Then
    MyPrint ("����Ҫ����һ���ǿյ�����")
    Exit Sub
  End If
  
  MyPrint ("����������û�����" & gInputDomainUser1)
  MyPrint ("����������룺" & gInputDomainPassword)
  MyPrint ("OK")
  
  
  '���ڲ�Ӱ��ű����У�������������Ȳ��ģ����ܿɶ��Ի��һ��
  '��������Ѿ��������ƣ����Ի��ǵ��û���
  Dim gDomainUserArray
  Dim gDomainUserStrSIDArray(), gDomainUserBinSIDArray()
  gDomainUserArray = Split(gInputDomainUser1, ",")
  ReDim gDomainUserStrSIDArray(UBound(gDomainUserArray))
  ReDim gDomainUserBinSIDArray(UBound(gDomainUserArray))
  Dim i, gRemoteStrSID, gRemoteBinSID
  For i = LBound(gDomainUserArray) To UBound(gDomainUserArray)
    MyPrint ("���ڲ������û�" & gDomainUserArray(i) & "��SID...")
    Call GetRemoteSID(gINIDCNetbiosName & "." & gINIDomainDNSName, gDomainUserArray(i), CONST_DOMAIN_USER, CONST_DOMAIN_PASSWORD, gRemoteStrSID, gRemoteBinSID)
    MyPrint ("���û�" & gDomainUserArray(i) & "��SID��" & gRemoteStrSID)
    gDomainUserStrSIDArray(i) = gRemoteStrSID
    gDomainUserBinSIDArray(i) = gRemoteBinSID
    '����ĳ���˼·������
    'If ProfileIsNTFS Then
    '  gProfilePermission = "cmd /c %SystemRoot%\system32\cscript XCACLS.vbs " & Chr(34) & gProfileImagePath & Chr(34) & " /e /g " & gINIDomainNetbiosName & "\" & gDomainUserArray(i) & ":f"
    '  MyPrint ("�������Profile��Administrators��Full ControlȨ��...")
    '  MyPrint (gProfilePermission)
    '  myShell (gProfilePermission)
    '  MyPrint ("OK")
    'End If
  Next
  MyPrint ("OK")

  
  MyPrint ("���ڼ���...")
'  Dim gOUPath
'  gOUPath = gINIOUPath & "," & Convert2DomainPath(gINIDomainDNSName)
  Dim strNetdom
  strNetdom = "cmd /c NETDOM JOIN " & gCSName & " /Domain:" & gINIDomainDNSName & " /UserD:" & gINIDomainNetbiosName & "\" & gDomainUserArray(0) & " /PasswordD:" & gInputDomainPassword
  MyPrint (strNetdom)
  myShell (strNetdom & " > netdom.txt")
  Dim gNetdomResult
  If Not IsNetdomOK(gNetdomResult) Then
    MyPrint ("����ʧ�ܣ�" & gNetdomResult)
    Exit Sub
  End If
  MyPrint ("OK")

    
  Dim gAddStr
  For i = LBound(gDomainUserArray) To UBound(gDomainUserArray)
    MyPrint ("��������" & gDomainUserArray(i) & "��Profile...")
    Call SetProfileImagePath(gDomainUserStrSIDArray(i), gProfileImagePath, gDomainUserBinSIDArray(i))
    MyPrint ("���ڽ�" & gDomainUserArray(i) & "��ӵ�����Administrators...")
    gAddStr = "cmd /c %SystemRoot%\system32\net localgroup administrators " & gINIDomainNetbiosName & "\" & gDomainUserArray(i) & " /add"
    MyPrint (gAddStr)
    myShell (gAddStr)
  Next
  MyPrint ("OK")

    
  MyPrint ("�����޸�ȱʡ��¼��...")
  Call SetDefaultUserName(gDomainUserArray(0), gINIDomainNetbiosName)
  MyPrint ("OK")
  
  MyPrint ("")
  MyPrint ("�����ڿ��԰�ȫ�����������ˣ�")
  MyPrint ("")
  MyPrint ("(End)")
End Sub

'------------------------------------
'�Զ������
Sub MyPrint(ByVal vStr)
  Dim myStr
  myStr = "[" & Now & "]" & Chr(9) & vStr
  wscript.Echo myStr
  myShell ("cmd /c echo " & myStr & " >> " & LOG_FILENAME)
End Sub

'myShell
Sub myShell(ByVal vCommand)
  Dim WshShell
  Set WshShell = CreateObject("WScript.Shell")
  WshShell.Run vCommand, 0, True
End Sub

'��ȡ�ļ���Ϣ
Sub GetFileInfo(vFullFileName, ByRef vFileLastModified, ByRef vFileSize)
  Dim objFSO
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Dim objFile
  Set objFile = objFSO.GetFile(vFullFileName)
  vFileLastModified = objFile.DateLastModified
  vFileSize = objFile.Size
End Sub

'��ȡ������Ϣ
Function GetConfig(ByVal vFileName, ByRef vINIDNS, ByRef vINIDCNetbiosName, ByRef vINIDomainDNSName, ByRef vINIDomainNetbiosName)
  GetConfig = "OK"
  Dim objFSO
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  If objFSO.FileExists(vFileName) Then
    Const ForReading = 1
    Dim objTextFile
    Set objTextFile = objFSO.OpenTextFile(XE_CONFIG_FILENAME, ForReading)
    Dim iniStr
    Do Until objTextFile.AtEndOfStream
      iniStr = objTextFile.Readline
      If InStr(1, iniStr, "[DNS]", 1) > 0 Then
        vINIDNS = Trim(Mid(iniStr, Len("[DNS]") + 1))
        If vINIDNS = "" Then
          GetConfig = "DNS����Ϊ��"
          Exit Do
        End If
      ElseIf InStr(1, iniStr, "[DCNetbiosName]", 1) > 0 Then
        vINIDCNetbiosName = Trim(Mid(iniStr, Len("[DCNetbiosName]") + 1))
        If vINIDCNetbiosName = "" Then
          GetConfig = "DCNetbiosName����Ϊ��"
          Exit Do
        End If
      ElseIf InStr(1, iniStr, "[DomainDNSName]", 1) > 0 Then
        vINIDomainDNSName = Trim(Mid(iniStr, Len("[DomainDNSName]") + 1))
        If vINIDomainDNSName = "" Then
          GetConfig = "DomainDNSName����Ϊ��"
          Exit Do
        End If
      ElseIf InStr(1, iniStr, "[DomainNetbiosName]", 1) > 0 Then
        vINIDomainNetbiosName = Trim(Mid(iniStr, Len("[DomainNetbiosName]") + 1))
        If vINIDomainNetbiosName = "" Then
          GetConfig = "DomainNetbiosName����Ϊ��"
          Exit Do
        End If
'      ElseIf InStr(1, iniStr, "[DomainUserName]", 1) > 0 Then
'        vINIOUPath = Trim(Mid(iniStr, Len("[DomainUserName]") + 1))
'        If vINIOUPath = "" Then
'          GetConfig = "DomainUserName����Ϊ��"
'          Exit Do
'        End If
'      ElseIf InStr(1, iniStr, "[DomainPassword]", 1) > 0 Then
'        vINIDomainPassword = Trim(Mid(iniStr, Len("[DomainPassword]") + 1))
'        If vINIDomainPassword = "" Then
'          GetConfig = "DomainPassword����Ϊ��"
'          Exit Do
'        End If
      End If
    Loop
    objTextFile.Close
  Else
    GetConfig = "�����ļ�" & vFileName & "������"
  End If
End Function

'�жϿͻ���DNS�����Ƿ���ȷ
'û�ҵ��÷����������жϷ����ܴ���
Function DNSConfigOK(ByVal vFileName, ByVal vDNS1, ByVal vDNS2)
  Dim vDNSFlag1, vDNSFlag2
  vDNSFlag1 = False
  vDNSFlag2 = False
  Dim objFSO
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Const ForReading = 1
  Dim objTextFile
  Set objTextFile = objFSO.OpenTextFile(vFileName, ForReading)
  Dim vStr
  Do Until objTextFile.AtEndOfStream
    vStr = objTextFile.Readline
    If Not vDNSFlag1 And InStr(1, vStr, vDNS1, 1) > 0 Then
      vDNSFlag1 = True
    End If
    'ǿ����DNS�͸�DNS˳���ܻ�
    If vDNSFlag1 Then
      If InStr(1, vStr, vDNS2, 1) > 0 Then
        vDNSFlag2 = True
      End If
    End If
  Loop
  objTextFile.Close
  If vDNSFlag1 And vDNSFlag2 Then
    DNSConfigOK = True
  Else
    DNSConfigOK = False
  End If
End Function

'����ϵͳ��Ϣ
Sub GetOS(ByRef vCSName, ByRef vVersion, ByRef vCSDVersion, ByRef vSerialNumber)
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colOperatingSystems
  Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
  Dim objOperatingSystem
  For Each objOperatingSystem In colOperatingSystems
    vCSName = objOperatingSystem.CSName
    vVersion = objOperatingSystem.Version
    vCSDVersion = objOperatingSystem.CSDVersion
    vSerialNumber = objOperatingSystem.SerialNumber
  Next
End Sub

'�ж�Windows XP�Ƿ���Home��
Function IsXPHomeVersion()
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colOperatingSystems
  Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
  Dim objOperatingSystem
  For Each objOperatingSystem In colOperatingSystems
    If InStr(1, UCase(objOperatingSystem.Caption), "HOME", 1) > 0 Then
      IsXPHomeVersion = True
    Else
      IsXPHomeVersion = False
    End If
  Next
End Function

'�������ɫ
Function GetComputerRole()
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colComputers
  Set colComputers = objWMIService.ExecQuery("Select DomainRole from Win32_ComputerSystem")
  Dim objComputer
  For Each objComputer In colComputers
    GetComputerRole = objComputer.DomainRole
  Next
End Function

'���������Ƿ�������
Function EnableWireless(ByRef vWirelessConnectionID)
  EnableWireless = False
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colNics
  Set colNics = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter")
  Dim objNic
  For Each objNic In colNics
    If objNic.NetConnectionStatus = 2 And InStr(1, UCase(objNic.Name), "WIRELESS", 1) > 0 Then
      EnableWireless = True
      vWirelessConnectionID = objNic.NetConnectionID
    End If
  Next
End Function

'��ȡ�����ӵ�������������
Function GetLANNumber()
  GetLANNumber = 0
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colNics
  Set colNics = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter")
  Dim objNic
  For Each objNic In colNics
    If objNic.NetConnectionStatus = 2 Then
      If InStr(1, UCase(objNic.Name), "VMWARE VIRTUAL ETHERNET ADAPTER FOR VMNET", 1) > 0 Then
      Else
        GetLANNumber = GetLANNumber + 1
      End If
    End If
  Next
End Function

'��¼��(��������ͨ��WMI�޷�ȡ��UserName������ͨ����ע���ʵ��)
Sub GetDefaultUserName(ByRef vDefaultUserName, ByRef vDefaultDomainName)
  Const HKEY_LOCAL_MACHINE = &H80000002
  Dim oReg
  Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Dim strKeyPath
  strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
  oReg.GetStringValue HKEY_LOCAL_MACHINE, strKeyPath, "DefaultUserName", vDefaultUserName
  oReg.GetStringValue HKEY_LOCAL_MACHINE, strKeyPath, "DefaultDomainName", vDefaultDomainName
End Sub

'�޸�ȱʡ��¼��
Sub SetDefaultUserName(ByRef vDefaultUserName, vDefaultDomainName)
  Const HKEY_LOCAL_MACHINE = &H80000002
  Dim oReg
  Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Dim strKeyPath
  strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
  oReg.SetStringValue HKEY_LOCAL_MACHINE, strKeyPath, "DefaultUserName", vDefaultUserName
  oReg.SetStringValue HKEY_LOCAL_MACHINE, strKeyPath, "DefaultDomainName", vDefaultDomainName
End Sub

'�Ƿ��Ǳ�������Ա
Function IsAdmin(ByVal vUserName)
  IsAdmin = False
  Dim colGroups
  Set colGroups = GetObject("WinNT://.")
  colGroups.Filter = Array("Group")
  Dim objUser, objGroup
  For Each objGroup In colGroups
    If UCase(objGroup.Name) = "ADMINISTRATORS" Then
      For Each objUser In objGroup.Members
        If UCase(objUser.Name) = UCase(vUserName) Then
          IsAdmin = True
          Exit For
        End If
      Next
    End If
  Next
End Function

'��ȡ�����û���SID
Function GetSID(ByVal vUserName)
  GetSID = ""
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colItems
  Set colItems = objWMIService.ExecQuery("Select * from Win32_UserAccount")
  Dim objItem
  For Each objItem In colItems
    If UCase(objItem.Name) = UCase(vUserName) Then
      GetSID = objItem.SID
      Exit For
    End If
  Next
End Function

'��ȡ�û���Profileλ��
Sub GetProfileImagePath(ByVal vSID, ByRef vProfileImagePath)
  vProfileImagePath = ""
  Const HKEY_LOCAL_MACHINE = &H80000002
  Dim oReg
  Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Dim strKeyPath
  strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" & vSID
  oReg.GetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, "ProfileImagePath", vProfileImagePath
End Sub

'������û���Profileλ��
Sub SetProfileImagePath(ByVal vRemoteSID, ByVal vProfileImagePath, ByVal vBinSID)
  Const HKEY_LOCAL_MACHINE = &H80000002
  Dim oReg
  Set oReg = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Dim strKeyPath
  strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" & vRemoteSID
  oReg.CreateKey HKEY_LOCAL_MACHINE, strKeyPath
  oReg.SetStringValue HKEY_LOCAL_MACHINE, strKeyPath, "CentralProfile", ""
  oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath, "Flags", 0
  oReg.SetExpandedStringValue HKEY_LOCAL_MACHINE, strKeyPath, "ProfileImagePath", vProfileImagePath
  oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath, "ProfileLoadTimeHigh", 0
  oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath, "ProfileLoadTimeLow", 0
  oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath, "RefCount", 0
  oReg.SetBinaryValue HKEY_LOCAL_MACHINE, strKeyPath, "Sid", vBinSID
  oReg.SetDWORDValue HKEY_LOCAL_MACHINE, strKeyPath, "State", 0
End Sub

'�ж��Ƿ���NTFS����
Function IsNTFS(ByVal vDeviceID)
  IsNTFS = False
  Dim objWMIService
  Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\.\root\cimv2")
  Dim colDisks
  Set colDisks = objWMIService.ExecQuery("Select * from Win32_LogicalDisk")
  Dim objDisk
  For Each objDisk In colDisks
    If UCase(objDisk.DeviceID) = UCase(vDeviceID) And UCase(objDisk.FileSystem) = "NTFS" Then
      IsNTFS = True
      Exit Function
    End If
  Next
End Function

'�ж��Ƿ���administraotors���Ȩ��
'ע�⣺����ж�ֻ�Ǵ��Եģ�������ȫ��ȷ
Function IsAdministratorsPermission()
  IsAdministratorsPermission = False
  Dim objFSO
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Const ForReading = 1
  Dim objTextFile
  Set objTextFile = objFSO.OpenTextFile("xcacls.txt", ForReading)
  Dim okStr
  okStr = "Allowed  BUILTIN\Administrators  Full Control"
  Do Until objTextFile.AtEndOfStream
    If Mid(objTextFile.Readline, 1, Len(okStr)) = okStr Then
      IsAdministratorsPermission = True
      Exit Do
    End If
  Loop
  objTextFile.Close
End Function

'����DomainPath
Function Convert2DomainPath(ByVal vDomainDNSName)
  Dim vArray
  vArray = Split(vDomainDNSName, ".")
  Dim i
  For i = LBound(vArray) To UBound(vArray) - 1
    Convert2DomainPath = Convert2DomainPath & "DC=" & vArray(i) & ","
  Next
  Convert2DomainPath = Convert2DomainPath & "DC=" & vArray(i)
End Function

'�ж�netdom�����Ƿ�ɹ�
Function IsNetdomOK(ByRef vNetdomResult)
  Dim objFSO
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  Const ForReading = 1
  Dim objTextFile
  Set objTextFile = objFSO.OpenTextFile("netdom.txt", ForReading)
  vNetdomResult = objTextFile.Readline
  Dim okStr
  okStr = "THE COMMAND COMPLETED SUCCESSFULLY."
  If UCase(Mid(vNetdomResult, 1, Len(okStr))) = okStr Then
    IsNetdomOK = True
  Else
    IsNetdomOK = False
  End If
  objTextFile.Close
End Function














'�ڱ����û���ȡ���û�SID���㷨��MyGu�ṩ
Sub GetRemoteSID(ByVal vDCFQDN, ByVal vDestUser, ByVal vUserName, ByVal vPassword, ByRef vStrSID, ByRef vBinSID)
    
    Const ADS_SECURE_AUTHENTICATION = 1
    Const ADS_SERVER_BIND = 512
    
    Dim strComputer
    Dim strDS
    Dim strUser
    Dim strPassword
    Dim objDSO
    Dim objUser
    Dim objSid
    Dim strSid
    
    strComputer = vDCFQDN
    strDS = vDestUser
    strUser = vUserName
    strPassword = vPassword

    Set objDSO = GetObject("WinNT:")
    Set objUser = objDSO.OpenDSObject( _
                                "WinNT://" & strComputer & "/" & strDS, _
                                strUser, strPassword, _
                                ADS_SECURE_AUTHENTICATION + ADS_SERVER_BIND)

    objSid = objUser.objectSid
    
    vStrSID = Convert_RawSid_To_StrSid(objSid)
    vBinSID = Convert_Byte_To_Decimal_In_Array(objSid)
        
End Sub

'-----------------------------------------------------------------------------------------------
' Convert a Byte to Hex
'-----------------------------------------------------------------------------------------------

Function Convert_Byte_To_Hex(objValue)

    Dim intCharCode
    Dim intHexTmp
    
    Dim i
    
    For i = 1 To LenB(objValue)
        
        ' ��ȡ�ֽ�ת����character code
        intCharCode = AscB(MidB(objValue, i))
        ' ת����ʮ������
        intHexTmp = Hex(intCharCode)
        If (Len(intHexTmp) = 1) Then
            intHexTmp = "0" & intHexTmp
        End If
        Convert_Byte_To_Hex = Convert_Byte_To_Hex & intHexTmp
    Next
        
End Function



'-----------------------------------------------------------------------------------------------
'- This method convert raw sid to string sid
'-
'-
'- 00000001(01) 00000101(02) 00000000(03) 00000000(04) 00000000(05)
'- 00000000(06) 00000000(07) 00000101(08) 00010101(09) 00000000(10)
'- 00000000(11) 00000000(12) 11110000(13) 01011101(14) 10010111(15)
'- 01100101(16) 10011001(17) 00101010(18) 10101010(19) 11101101(20)
'- 01101001(21) 01101010(22) 11110001(23) 01010010(24) 11011001(25)
'- 00001000(26) 00000000(27) 00000000(28)
'-
'- S-   1   -5  -21 -1704418800 -3987352217 -1391553129 -2265
'-  1   2   9   16|15|14|13 20|19|18|17 24|23|22|21 28|27|26|25
'-
'- A revision level of "1".
'- An identifier-authority value of "5" (SECURITY_NT_AUTHORITY).
'- A first subauthority value of "21" (SECURITY_NOT_BUILTIN_DOMAIN_RID).
'- A second subauthority value of "544" (DOMAIN_ALIAS_RID_ADMINS).
'-
'- http://support.microsoft.com/kb/286182/en-us
'-----------------------------------------------------------------------------------------------

Function Convert_RawSid_To_StrSid(objSid)

    Const SID_Length = 28
    
    Const SID_RLV_START_POINT = 1                   'SID: revision level value start point
    Const SID_RLV_LENGTH = 1                            'SID: revision level value length
    
    Const SID_IAV_START_POINT = 2                   'SID: identifier-authority value start point
    Const SID_IAV_LENGTH = 1                            'SID: identifier-authority value length
    
    Const SID_FSV_START_POINT = 9                   'SID: first subauthority value start point
    Const SID_FSV_LENGTH = 1                            'SID: first subauthority value length
        
    Const SID_SSV_START_POINT = 13              'SID: second subauthority value start point
    Const SID_SSV_LENGTH = 4                            'SID: second subauthority value length
    
    ' Check objValue whether is Valid for ObjectSid
    ' if the objValue length is not equal 28, then it's invalid
    If (UBound(objSid) + 1) <> SID_Length Then
        MsgBox "Sid Length incorrect. This program will quit."
        wscript.quit
    End If
    
    Convert_RawSid_To_StrSid = "S-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_RLV_START_POINT, SID_RLV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_IAV_START_POINT, SID_IAV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                 SID_FSV_START_POINT, SID_FSV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_SSV_START_POINT, SID_SSV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_SSV_START_POINT + SID_SSV_LENGTH, SID_SSV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_SSV_START_POINT + SID_SSV_LENGTH * 2, SID_SSV_LENGTH) & "-" & _
                        Convert_Byte_To_Decimal(objSid, _
                                SID_SSV_START_POINT + SID_SSV_LENGTH * 3, SID_SSV_LENGTH)

End Function


'-----------------------------------------------------------------------------------------------
' Convert a Byte to String (Decimal)
'-----------------------------------------------------------------------------------------------

Function Convert_Byte_To_Decimal(objValue, intStart, intLength)

    Dim intCharCode
    Dim intTmp
    Dim intTmpBinary
    Dim i
    
    For i = intStart To (intStart + intLength - 1)
        
        ' ��ȡ�ֽ�ת����character code
        intCharCode = AscB(MidB(objValue, i))
        ' ת���ɶ����Ʋ�����8λ
        intTmp = Convert_Decimal_To_Binary(intCharCode, 8)
        ' �Ѷ�����������������
        intTmpBinary = intTmp & intTmpBinary
            
    Next
    
    ' �Ѷ�����ת����10����
    Convert_Byte_To_Decimal = Convert_Binary_To_Decimal(intTmpBinary)
    
End Function



'-----------------------------------------------------------------------------------------------
' Convert a number from binary to decimal
'-----------------------------------------------------------------------------------------------

Function Convert_Binary_To_Decimal(intBinary)

    ' Returns the decimal equivalent of a binary number.
    Dim digits
    Dim i
        
    digits = Len(intBinary)

    For i = digits To 1 Step -1

        If Mid(intBinary, i, 1) = "1" Then
            Convert_Binary_To_Decimal = Convert_Binary_To_Decimal + 2 ^ (digits - i)
        End If

    Next

End Function


'-----------------------------------------------------------------------------------------------
' Convert a number from decimal to binary
'-----------------------------------------------------------------------------------------------

Function Convert_Decimal_To_Binary(intDecimalValue, intMinimumDigits)

    ' Returns a string containing the binary
    ' representation of a positive integer.

    Dim intExtraDigitsNeeded

    ' Make sure value is not negative.
    intDecimalValue = Abs(intDecimalValue)

    ' Construct the binary value.
    Do
        Convert_Decimal_To_Binary = CStr(intDecimalValue Mod 2) & Convert_Decimal_To_Binary
        intDecimalValue = intDecimalValue \ 2
    Loop While intDecimalValue > 0

    ' Add leading zeros if needed.
    intExtraDigitsNeeded = intMinimumDigits - Len(Convert_Decimal_To_Binary)
    If intExtraDigitsNeeded > 0 Then
        Convert_Decimal_To_Binary = String(intExtraDigitsNeeded, "0") & Convert_Decimal_To_Binary
    End If

End Function


'-----------------------------------------------------------------------------------------------
' Convert a Byte to decimal in array
'-----------------------------------------------------------------------------------------------

Function Convert_Byte_To_Decimal_In_Array(objValue)

    Dim intCharCode
    Dim intHexTmp
    
    Dim i
    
    For i = 1 To LenB(objValue)
        
        ' ��ȡ�ֽ�ת����character code
        intCharCode = AscB(MidB(objValue, i))
        If (i = 1) Then
            intHexTmp = intCharCode
        Else
            intHexTmp = intHexTmp & "|" & intCharCode
        End If
    Next
    
    Convert_Byte_To_Decimal_In_Array = Split(intHexTmp, "|", -1, 1)
    
End Function
