option explicit

dim lsProxyFileName, lsServerPath, lsClientPath, lsServerFilePath, lsClientFilePath
dim lbNeedToCopy
dim lpServerProxyFile, lpClientProxyFile
dim lpFileSystemObject
'Pour la session
'Dim wshShell, objEnv, strSessionName

lsProxyFileName = "apdnl_accelerated_pac_base.pac"
lsServerPath = ""
lsClientPath = "C:\"

lsServerFilePath = lsServerPath & lsProxyFileName
lsClientFilePath = lsClientPath & lsProxyFileName

lbNeedToCopy = true

'Session
'Set wshShell = Wscript.CreateObject("Wscript.Shell")
'Set objEnv = wshShell.Environment("VOLATILE")
'strSessionName = objEnv("SESSIONNAME")

'msgbox " Session Name " & vbtab & " : " &strSessionName

Set lpFileSystemObject= CreateObject("Scripting.FileSystemObject")

'IF strSessionName <> "ICA" then
if lpFileSystemObject.FolderExists("C:\") then

	if lpFileSystemObject.FileExists(lsServerFilePath) then

		if lpFileSystemObject.FileExists(lsClientFilePath) then
	
			Set lpServerProxyFile = lpFileSystemObject.GetFile(lsServerFilePath)
			Set lpClientProxyFile = lpFileSystemObject.GetFile(lsClientFilePath)
		
			lbNeedToCopy = lpServerProxyFile.DateLastModified <> lpClientProxyFile.DateLastModified or lpServerProxyFile.Size <> lpClientProxyFile.Size
	
		end if

		if lbNeedToCopy then

			lpFileSystemObject.CopyFile lsServerFilePath, lsClientPath,TRUE
	
		end if


'		if lbNeedToCopy then
'			msgbox "File copied"
'		else
'			msgbox "No need to copy file"
'		end if

	else

'		msgbox "Could not find proxypac on server"

	end if

else

	'msgbox "pas de c:"

end if