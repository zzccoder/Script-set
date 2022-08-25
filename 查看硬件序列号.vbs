Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select SerialNumber From Win32_BIOS")
For Each objItem In colItems
msgbox "Your SerialNumber is:" & objItem.SerialNumber
Exit For
Next
Set colItems = Nothing
Set objWMIService = Nothing