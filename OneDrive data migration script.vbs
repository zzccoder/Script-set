'---------------------------------------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------------------------------------
'Date : May 14 2019
'Author : Babatunde Olugbesan
'---------------------------------------------------------------------------------------------------------------------------------
'---------------------------------------------------------------------------------------------------------------------------------
'Option Explicit

Const scriptname = "M Drive > OneDrive Folder Migration"
Const mdrives = "\\nglag2-01\users$\"
Const C_I_FORREADING = 1, C_I_FORWRITING = 2
Const copylimit = 53687091200   '53687091200=50GB   107374182400=100GB      1073741824=1GB
dim folderpath
dim logfile
dim targetpath
dim actionmsg
dim foldersize
dim targetsize
Dim mobjFso
Dim mobjWsNetwork
Dim mobjWsShell
Dim msUserName
Dim machName

Main

'---------------------------------------------------------------------------------------------------------------------------------
'MAIN PROCEDURE : launch all the actions of the script
'---------------------------------------------------------------------------------------------------------------------------------
Sub Main

	'-------------------------------------------------------------------------------------------------------------------------
	'On Error Resume Next
    WScript.echo "... ONEDRIVE FILE MIGRATION CHECK STARTING! DO NOT CLOSE THIS WINDOW! ..."

	Err.Number = 0	
	Set mobjFso = CreateObject("Scripting.FileSystemObject")
	Set mobjWsNetwork = WScript.CreateObject("WScript.Network")
	Set mobjWsShell = Wscript.CreateObject("Wscript.Shell")
    machName = mobjWsNetwork.ComputerName
    msUserName = mobjWsNetwork.UserName
    folderpath = mdrives & msUserName & "\"
    logfile = "\\nglag2-01\shared$\MISC\OneDrive_customisation\od_migration_report.log"
    targetpath = "c:\Users\" & msUserName & "\OneDrive - Addax Petroleum\"
    foldersize = mobjFso.GetFolder(folderpath).Size
    targetsize = mobjFso.GetDrive("c:").FreeSpace

    'check variables set properly
	If Err.Number <> 0 Then
		mobjWsShell.LogEvent 2, "ERROR-Declarations - " & Err.Description
		WScript.Quit(Err.Number)
    Else
        mobjWsShell.LogEvent 0, scriptname & " NOTE-Declarations successful! Continuing script execution..."
	End If
    

    'set log entry timestamp
    actionmsg = Now() & "  " & machName & vbCrLf

    'Check m drive folder for user and confirm if under 50GB
    if foldersize < copylimit then
        WScript.echo "... M Drive size - " & foldersize/1073741824 & " GB : Okay to copy!"
        
        'create one drive folder if not there
        if mobjFso.FolderExists(targetpath) then	
            'ensure sufficient space exists at target
            if targetsize > foldersize then
                WScript.echo "... Folder copy procedure starting! Please be patient - this may take a few minutes! ..."

                'go ahead and copy
                mobjFso.CopyFolder folderpath & "*.*", targetpath, true     'parent folder & all sub-folders
                mobjFso.CopyFile folderpath & "*.*", targetpath, true       'files within parent folder
                WScript.echo "... Folder copy procedure ended! ..."

                'log action
                actionmsg = actionmsg & "Migration status (Success) - M-drive folder contents copied to local OneDrive for user (" & msusername & ") on machine (" & machName & ") " & vbCrLf
                actionmsg = actionmsg & foldersize/1073741824 & " GB copied" 
                updateLog logfile, actionmsg
                mobjWsShell.LogEvent 0, scriptname & actionmsg
            else
                'insufficient space detected
                WScript.echo "Migration status (Failed) - Insufficient disk space detected on local C Drive of machine (" & machName & ") - " & targetsize/1073741824 & " GB free space only" 
                actionmsg = actionmsg & "Migration status (Failed) - Insufficient disk space detected on local C Drive of machine (" & machName & ") - " & targetsize/1073741824 & " GB free space only"
                updateLog logfile, actionmsg
                mobjWsShell.LogEvent 2, scriptname & actionmsg 
                WScript.Quit()
            end if

		    
        else
            'folder not found
            WScript.echo "Migration status (Failed) - One Drive folder not detected on target machine!"	
            actionmsg = actionmsg & "Migration status (Failed) - One Drive folder not detected on target machine!" 
            updateLog logfile, actionmsg
            mobjWsShell.LogEvent 2, scriptname & actionmsg
            WScript.Quit()
	    End If
            
    else
        'source drive too large - over limit specified       
        actionmsg = actionmsg & "Migration status (Failed) - Source M-drive folder too large (" & msusername & ")..."
        actionmsg = actionmsg & foldersize/1073741824 & " GB" 
        updateLog logfile, actionmsg
        mobjWsShell.LogEvent 2, scriptname & actionmsg
        WScript.Quit()
    end if

    Set mobjFso = nothing
    Set mobjWsNetwork = nothing
	Set mobjWsShell = nothing

   'Pause
End Sub


Sub updateLog(psNewFile, psToAdd)

	Dim logfile
	Dim logcontent
	
	Set logfile = mobjFso.OpenTextFile(psNewFile, C_I_FORREADING, False)

	' Read in the whole file
	if not logfile.atEndOFStream then 
        logcontent = logfile.ReadAll	    
    end if
    logfile.Close

 	' make the changes
	logcontent = logcontent & psToAdd & vbCrLf
    logcontent = logcontent & "~" & vbCrLf

 	' Overwrite the existing File with the changes
	Set logfile = mobjFso.OpenTextFile(psNewFile, C_I_FORWRITING, True)
	logfile.Write(logcontent)
	logfile.Close	

End Sub

Sub Pause
    WScript.Echo ("Press Enter to continue")
    z = WScript.StdIn.ReadLine()
End Sub
