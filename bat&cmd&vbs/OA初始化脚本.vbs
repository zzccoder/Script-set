On Error Resume Next
Dim WshShell
Set WshShell = CreateObject("WScript.Shell") 
if err.Number > 0 then 
		MsgBox "���ܴ���WScript.Shell����" 
end If
SystemInit()
Function SystemInit()	
	Dim SiteIP
	Dim SiteUrl
	SiteIP = "http://10.1.32.32"
	SiteUrl = "http://oa.hlic.cn"
	AddWebSite SiteUrl
	AddWebSite SiteIP
	 '������Activex������ʾ�Ի��򣬲�������վ����https�ĸ�ѡ��ѡ��ȥ��
    'IE�����ҳ���°汾
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\SyncMode5", 4,"REG_DWORD"
    '������ʱ�ļ��д�С
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\5.0\Cache\Content\CacheLimit", 204800,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\CurrentLevel", 0,"REG_DWORD"    
    '������ǩ���� ActiveX �ؼ�
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1001", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1004", 1,"REG_DWORD"
    '��û�б��Ϊ��ȫ�� ActiveX �ؼ����г�ʼ���ͽű�����
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1201", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1206", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1209", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1406", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1407", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1607", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1800", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1804", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1806", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1809", 3,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1A00", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1A04", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1A05", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1C00", 196608,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1E05", 196608,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\2101", 1,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\2102", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\2200", 0,"REG_DWORD"
    'ActiveX �ؼ��Զ���ʾ
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\2201", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\1209", 0,"REG_DWORD"
    WriteRegistry "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2\2301", 3,"REG_DWORD"
	MsgBox "���ۺϰ칫����ϵͳ����ʼ���ɹ�������������IE����ϵͳ��"	
	'WshShell.Run "explorer.exe http://localhost",1 
End Function

Function WriteRegistry(strName,anyValue,strType)
	WshShell.RegWrite strName, anyValue, strType	
End Function

Function AddWebSite(WebsiteString)
	On Error Resume Next 
	Dim regkey,subkey,retValue,keyvalue,lResult,hKey,headstring,websiteArry,i,IPFlag,firstString,sencedString
    
    IPFlag = True
    If InStr(WebsiteString, "://") > 0 Then
        headstring = LCase(Left(WebsiteString, InStr(WebsiteString, "://") - 1))
        WebsiteString = Right(WebsiteString, Len(WebsiteString) - InStr(WebsiteString, "://") - 2)		
    End If
    
    websiteArry = Split(WebsiteString, ".")
    
    firstString = ""
    sencedString = ""
    For i = 0 To UBound(websiteArry)
      If Not IsNumeric(websiteArry(i)) Then
        IPFlag = False
        If i = 3 Then
           If websiteArry(i) = "*" Then
             IPFlag = True
           End If
        End If
      End If
      
      If UBound(websiteArry) - i < 2 Then
         firstString = firstString + "." + websiteArry(i)
      Else
         sencedString = sencedString + "." + websiteArry(i)
      End If
    Next
    
    If Left(firstString, 1) = "." Then firstString = Right(firstString, Len(firstString) - 1)
    If Left(sencedString, 1) = "." Then sencedString = Right(sencedString, Len(sencedString) - 1)
    
    If IPFlag Then
        i = 0
        Do
			i = i + 1
            regkey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Ranges\Range" & CStr(i)
			lResult = WshShell.RegRead(regkey&"\:Range")
			if err.Number <> 0 Then				
                subkey = headstring               			
				keyvalue = &H2
                WriteRegistry regkey&"\"&subkey,keyvalue,"REG_DWORD"
				'WriteRegistry2 HKEY_CURRENT_USER, REG_DWORD, regkey, subkey, keyvalue
                subkey = ":Range"
                keyvalue = WebsiteString				
				WriteRegistry regkey&"\"&subkey,keyvalue,"REG_SZ"
                Exit Function
            else
                if lResult = WebsiteString then
                    Exit Function
                end if
            End If            
        Loop
    Else
           regkey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\" & firstString & "\" & sencedString
           subkey = headstring
           keyvalue = &H2
           WriteRegistry regkey&"\"&subkey,keyvalue,"REG_DWORD"
    End If
    
End Function