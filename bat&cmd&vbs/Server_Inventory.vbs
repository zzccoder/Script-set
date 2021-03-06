'===================================================================================
'
' Author      : Syed Abdul Khader
' Description : VBScript to find the server Inventory
'
'===================================================================================

on Error Resume Next 
dtmDate = Date
strMonth = Month(Date)
strDay = Day(Date)
strYear = Right(Year(Date),2)
strFileName = "C:\Temp\ServerInventory_" & strMonth & "-" & strDay & "-" & strYear & ".xls"
'objExcel.Workbooks.Open("strFileName")
Set objExcel = CreateObject("Excel.Application") 
' Reading the Input File (Text File Containing Computer Names)
objExcel.Visible = True 
objExcel.Workbooks.Add 

Set fso1 = CreateObject("Scripting.FileSystemObject") 
Set pcfile = fso1.OpenTextFile("ServerList.txt",1) 
'Set objExcel = CreateObject("Excel.Application") 
'objExcel.Visible = True 
'objExcel.Workbooks.Add 

 wscript.echo "Please wait !!!"
objExcel.Cells(1, 1).Value = "  Computer Name  " 
objExcel.Cells(1, 1).Font.Colorindex = 2
objExcel.Cells(1, 1).Font.Bold = True 
objExcel.Cells(1, 1).Interior.ColorIndex = 23 
objExcel.Cells(1, 1).Alignment = "Center" 
Set objRange = objExcel.ActiveCell.EntireColumn 
objRange.AutoFit() 
 
objExcel.Cells(1, 2).Value = "  Manufacturer  " 
objExcel.Cells(1, 2).Font.Colorindex = 2
objExcel.Cells(1, 2).Font.Bold = True 
objExcel.Cells(1, 2).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("B1") 
objRange.Activate 
Set objRange = objExcel.ActiveCell.EntireColumn 
objRange.AutoFit() 
 
objExcel.Cells(1, 3).Value = "  Model  " 
objExcel.Cells(1, 3).Font.Colorindex = 2
objExcel.Cells(1, 3).Font.Bold = True 
objExcel.Cells(1, 3).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit() 
 
objExcel.Cells(1, 4).Value = "  RAM (GB) " 
objExcel.Cells(1, 4).Font.Colorindex = 2
objExcel.Cells(1, 4).Font.Bold = True 
objExcel.Cells(1, 4).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit() 

objExcel.Cells(1, 5).Value = " Operating System "
objExcel.Cells(1, 5).Font.Colorindex = 2
objExcel.Cells(1, 5).Font.Bold = True 
objExcel.Cells(1, 5).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 6).Value = " Installed Date "
objExcel.Cells(1, 6).Font.Colorindex = 2
objExcel.Cells(1, 6).Font.Bold = True 
objExcel.Cells(1, 6).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 7).Value = " Processor "
objExcel.Cells(1, 7).Font.Colorindex = 2
objExcel.Cells(1, 7).Font.Bold = True 
objExcel.Cells(1, 7).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 8).Value = " Drive "
objExcel.Cells(1, 8).Font.Colorindex = 2
objExcel.Cells(1, 8).Font.Bold = True 
objExcel.Cells(1, 8).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 9).Value = " Drive Size (GB)"
objExcel.Cells(1, 9).Font.Colorindex = 2
objExcel.Cells(1, 9).Font.Bold = True 
objExcel.Cells(1, 9).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 10).Value = " Free Space (GB) "
objExcel.Cells(1, 10).Font.Colorindex = 2
objExcel.Cells(1, 10).Font.Bold = True 
objExcel.Cells(1, 10).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()
 
objExcel.Cells(1, 11).Value = " Adapter Description "
objExcel.Cells(1, 11).Font.Colorindex = 2
objExcel.Cells(1, 11).Font.Bold = True 
objExcel.Cells(1, 11).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()
 
objExcel.Cells(1, 12).Value = " DHCP Enabled "
objExcel.Cells(1, 12).Font.Colorindex = 2
objExcel.Cells(1, 12).Font.Bold = True 
objExcel.Cells(1, 12).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()
 
objExcel.Cells(1, 13).Value = " IP Address"
objExcel.Cells(1, 13).Font.Colorindex = 2
objExcel.Cells(1, 13).Font.Bold = True 
objExcel.Cells(1, 13).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 14).Value = " Subnet "
objExcel.Cells(1, 14).Font.Colorindex = 2
objExcel.Cells(1, 14).Font.Bold = True 
objExcel.Cells(1, 14).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 15).Value = " Gateway"
objExcel.Cells(1, 15).Font.Colorindex = 2
objExcel.Cells(1, 15).Font.Bold = True 
objExcel.Cells(1, 15).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 16).Value = " Roles & Features"
objExcel.Cells(1, 16).Font.Colorindex = 2
objExcel.Cells(1, 16).Font.Bold = True 
objExcel.Cells(1, 16).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 17).Value = " Installed Software "
objExcel.Cells(1, 17).Font.Colorindex = 2
objExcel.Cells(1, 17).Font.Bold = True 
objExcel.Cells(1, 17).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 18).Value = " Installed Date "
objExcel.Cells(1, 18).Font.Colorindex = 2
objExcel.Cells(1, 18).Font.Bold = True 
objExcel.Cells(1, 18).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 19).Value = " Version "
objExcel.Cells(1, 19).Font.Colorindex = 2
objExcel.Cells(1, 19).Font.Bold = True 
objExcel.Cells(1, 19).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

objExcel.Cells(1, 20).Value = " Size "
objExcel.Cells(1, 20).Font.Colorindex = 2
objExcel.Cells(1, 20).Font.Bold = True 
objExcel.Cells(1, 20).Interior.ColorIndex = 23 
Set objRange = objExcel.Range("C1") 
objRange.Activate 
Set objRange = ObjExcel.ActiveCell.EntireColumn 
objRange.AutoFit()

n = 1
y = 2 

do while Not pcfile.AtEndOfStream 
    computerName = pcfile.readline 
	Err.Clear 
	Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & computerName & "\root\cimv2") 
	Set colSettings = objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem") 
	Set colOSSettings = objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem")
	Set colProcSettings = objWMIService.ExecQuery("SELECT * FROM Win32_Processor")
	Set colDiskSettings = objWMIService.ExecQuery("Select * from Win32_LogicalDisk Where DriveType=3")
	Set colAdapters = objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")
	Set colRoleFeatures = objWMIService.ExecQuery ("Select * from Win32_ServerFeature")

	If Err.Number = 0 Then 
		For Each objComputer In colSettings 
			strManufacturer = objComputer.Manufacturer 
			strModel = objComputer.Model 
			'FormatGB = FormatNumber(size / (1024 * 1024 * 1024), 2,0,0,0)
			strRAM = FormatNumber((objComputer.TotalPhysicalMemory / (1024 * 1024 *1024)), 2,0,0,0)
        
			For Each objOS In colOSSettings
				strOS = objOS.Caption
				OSinstDate = CDate(Mid(objOS.InstallDate,1,4)+"/" + Mid(objOS.InstallDate,5,2)+"/"+Mid(objOS.InstallDate,7,2))
        
				For Each objProc In colProcSettings
					strProc = objProc.Name
 
					If computerName <> oldName Then 
						objExcel.Cells(y, 1).Value = computerName 
						objExcel.Cells(y, 1).Alignment = "Center" 
						objExcel.Cells(y, 2).Value = strManufacturer 
						objExcel.Cells(y, 2).Alignment = "Center" 
						objExcel.Cells(y, 3).Value = strModel 
						objExcel.Cells(y, 3).Alignment = "Center"  
						objExcel.Cells(y, 4).Value = strRAM 
						objExcel.Cells(y, 4).Alignment = "Center" 
						objExcel.Cells(y, 5).Value = strOS 
						objExcel.Cells(y, 5).Alignment = "Center" 
						objExcel.Cells(y, 6).Value = OSinstDate
						objExcel.Cells(y, 6).Alignment = "Center" 
						objExcel.Cells(y, 7).Value = strProc 
						objExcel.Cells(y, 7).Alignment = "Center" 
						a=y
						For Each objDisk In colDiskSettings
							strDiskDeviceID = objDisk.DeviceID
							objExcel.Cells(a, 8).Value = strDiskDeviceID 
							objExcel.Cells(a, 8).Alignment = "Center" 
							'FormatNumber((objComputer.TotalPhysicalMemory / (1024 * 1024 *1024)), 2,0,0,0)
	          
							strDiskSize = FormatNumber((objDisk.Size / (1024 * 1024 * 1024)),2,0,0,0)
							objExcel.Cells(a, 9).Value = strDiskSize 
							objExcel.Cells(a, 9).Alignment = "Center"   
							strDiskFreeSpace = FormatNumber((objDisk.FreeSpace / (1024 * 1024 * 1024)),2,0,0,0)
							diskper = (strDiskSize / 100) *20
				
							if (strDiskFreeSpace <= diskper) then
								objExcel.Cells(a, 10).Value = strDiskFreeSpace 
								objExcel.Cells(a, 10).Alignment = "Center"
								objExcel.Cells(a, 10).Interior.ColorIndex = 3
							else
								objExcel.Cells(a, 10).Value = strDiskFreeSpace 
								objExcel.Cells(a, 10).Alignment = "Center" 
							end if
							a = a + 1
						Next  
						b=y
						For Each objAdapter in colAdapters
							Adapter = objAdapter.Description
							objExcel.Cells(b, 11).Value = Adapter 
							objExcel.Cells(b, 11).Alignment = "Center"
				
							If objAdapter.DHCPEnabled = True Then
								objExcel.Cells(b, 12).Value = "True"
								objExcel.Cells(b, 12).Alignment = "Center"	
							Else	
								objExcel.Cells(b, 12).Value = "False"
								objExcel.Cells(b, 12).Alignment = "Center"	
							End If
			
							If Not IsNull(objAdapter.IPAddress) Then
								For i = LBound(objAdapter.IPAddress) to UBound(objAdapter.IPAddress)
									If Not Instr(objAdapter.IPAddress(i), ":") > 0 Then
										IP = objAdapter.IPAddress(i)
									End If
									objExcel.Cells(b, 13).Value = IP
									objExcel.Cells(b, 13).Alignment = "Center"	
								Next
							End If
							If Not IsNull(objAdapter.IPSubnet) Then
								For i = 0 To UBound(objAdapter.IPSubnet)
									If Instr(objAdapter.IPSubnet(i), ".") > 0 Then
										Subnet = objAdapter.IPSubnet(i)
										objExcel.Cells(b, 14).Value = Subnet
										objExcel.Cells(b, 14).Alignment = "Center"
									End If
								Next
							End If
							If Not IsNull(objAdapter.DefaultIPGateway) Then
								For i = 0 To UBound(objAdapter.DefaultIPGateway)
									gateway = objAdapter.DefaultIPGateway(i)
								Next
								objExcel.Cells(b, 15).Value = gateway
								objExcel.Cells(b, 15).Alignment = "Center"
							End If
							b = b + 1
						Next
						x=y
						
						Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
						Set colRoleFeatures = objWMIService.ExecQuery ("Select * from Win32_ServerFeature")
						colrole=isnull(colRoleFeatures)
						If colrole=false then
							For Each objRoleFeatures in colRoleFeatures
								objExcel.Cells(x, 16).Value = objrolefeatures.name
								x=x+1
							Next
						Else
							objExcel.Cells(x, 16).Value = "No Roles & Features Found"
						End If
						
						b=y
						Const HKLM = &H80000002
						strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
							strEntry1a = "DisplayName"
							strEntry1b = "QuietDisplayName"
							strEntry2 = "InstallDate"
							strEntry3 = "VersionMajor"
							strEntry4 = "VersionMinor"
							strEntry5 = "EstimatedSize"
						Set objReg = GetObject("winmgmts://" & computerName & "/root/default:StdRegProv")
						objReg.EnumKey HKLM, strKey, arrSubkeys
						For Each strSubkey In arrSubkeys
							intRet1 = objReg.GetStringValue(HKLM, strKey & strSubkey, strEntry1a, strValue1)
							If strValue1 <> "" Then
								objReg.GetStringValue HKLM, strKey & strSubkey, strEntry2, strValue2
								If strValue2 <> "" Then
									d=CStr (strvalue2)
								End If
								objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry3, intValue3
								objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry4, intValue4
								objReg.GetDWORDValue HKLM, strKey & strSubkey, strEntry5, intValue5
								intvalue5 = intValue5/1024
								If intvalue5 <> "" Then
									If intvalue3 >=0 then 
										If intvalue4 >=0 then
											objExcel.Cells(b, 17).Value = strValue1
											If strvalue2 > 0 then
												strvalue2=Cstr(strvalue2)
												dd=Mid(strvalue2,7,2)
												mm=mid(strvalue2,5,2)
												yy=mid(strvalue2,1,4)
												objExcel.Cells(b, 18).Value = dd &"/" & mm & "/" & yy
											Else
												objExcel.Cells(b, 18).Value = " "
											End if
											objExcel.Cells(b, 19).Value = intValue3 & "." & intValue4
											objExcel.Cells(b, 20).Value = Round(intvalue5, 2) & " MB"
											objExcel.Cells(b, 22).Value = "1st If"
											b=b+1
										End If
									Else
										objExcel.Cells(b, 17).Value = strValue1
										If strvalue2 > 0 then
											strvalue2=Cstr(strvalue2)
											dd=Mid(strvalue2,7,2)
											mm=mid(strvalue2,5,2)
											yy=mid(strvalue2,1,4)
											objExcel.Cells(b, 18).Value = dd &"/" & mm & "/" & yy
										Else
											objExcel.Cells(b, 18).Value = " "
										End if
											
										objExcel.Cells(b, 19).Value = " "
										objExcel.Cells(b, 20).Value = Round(intvalue5, 2) & " MB"
										b=b+1
									End If
								Else
									objExcel.Cells(b, 17).Value = strValue1
									If strvalue2 > 0 then
										strvalue2=Cstr(strvalue2)
										dd=Mid(strvalue2,7,2)
										mm=mid(strvalue2,5,2)
										yy=mid(strvalue2,1,4)
										objExcel.Cells(b, 18).Value = dd &"/" & mm & "/" & yy
									Else
										objExcel.Cells(b, 18).Value = " "
									End if
									if intValue3 >= 0 then 
										objExcel.Cells(b, 19).Value = intValue3 & "." & intValue4
									else	
										objExcel.Cells(b, 19).Value = " "
									End If
									objExcel.Cells(b, 20).Value = Round(intvalue5, 2) & " MB"
									b=b+1
								End If
							End If
						Next
								
						if a > b then
							If a > x then 
								y = a + 1
							End If
						End If 
						if b > a then 
							if b > x then
								y = b + 1
							end if
						End If 
						If x > a then
							if x > b then
								y = x + 1
							end if
						End If
						computerName = "" 
						strManufacturer = "" 
						strModel = "" 
						strRAM = "" 
						Err.clear 
					End If
				Next
			Next
		Next
	Else 
		objExcel.Cells(y, 1).Value = computerName 
		objExcel.Cells(y, 1).Alignment = "Center" 
		objExcel.Cells(y, 2).Value = "Not on line" 
		objExcel.Cells(y, 2).Alignment = "Center" 
		y = y + 1 
		Err.clear  
	End If 
Loop 
y = y + 1 
objExcel.Cells(y, 1).Value = "Scan Complete" 
objExcel.Cells(y, 1).Font.Bold = True 

for column=1 to 20
	set objrange = objExcel.columns(column).autofit()
next
objExcel.ActiveWorkbook.SaveAs "c:\temp\ServerInventory_" & strMonth & "-" & strDay & "-" & strYear & ".xls"
wscript.echo "Script Completed !!!" & vbCrLf & "Excel is saved as " & strFileName
'objExcel.Workbooks.saveas ("ServerInventory_" & strMonth & "-" & strDay & "-" & strYear & ".xls")