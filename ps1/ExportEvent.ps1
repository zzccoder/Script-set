<#
The sample scripts are not supported under any Microsoft standard support 
program or service. The sample scripts are provided AS IS without warranty  
of any kind. Microsoft further disclaims all implied warranties including,  
without limitation, any implied warranties of merchantability or of fitness for 
a particular purpose. The entire risk arising out of the use or performance of  
the sample scripts and documentation remains with you. In no event shall 
Microsoft, its authors, or anyone else involved in the creation, production, or 
delivery of the scripts be liable for any damages whatsoever (including, 
without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) arising out of the use 
of or inability to use the sample scripts or documentation, even if Microsoft 
has been advised of the possibility of such damages.
#> 

#requires -Version 2
function Export-OSCEvent
{
	<#
		.SYNOPSIS
			The Export-OSCEvent command will export eventlog with specified event ID to a CSV file, 
			and then send it to administrators.

		.DESCRIPTION
			The Export-OSCEvent command will export eventlog with specified event ID to a CSV file, 
			and then send it to administrators.
 			Only log created in last 24 hours, will be exported. 
			
		.PARAMETER Path
			Specifies the path to the CSV output file. The parameter is required.	
		.PARAMETER EventID
			Indicates which event to monitor or collect.	
		.PARAMETER SmtpServer
			Specifies the name or IP of the SMTP server that sends the e-mail message.
		.PARAMETER To
			Specifies the addresses to which the mail is sent. Enter names (optional) and the e-mail address, such as "Name
 			<someone@example.com>". This parameter is required.
		.PARAMETER From
			Specifies the address from which the mail is sent. Enter a name (optional) and e-mail address, such as "Name 
			<someone@example.com>". This parameter is required.
		.PARAMETER Subject
			Specifies the subject of the e-mail message. This parameter is required.
		.PARAMETER Body
			 Specifies the body (content) of the e-mail message.
		.EXAMPLE
			PS C:\> Export-OSCEvent -Path "C:\Eventlog.csv" -LogName "Application","Security","System" -EventID 4634 -SmtpServer "Ex01"`
					-From "administrator@test2012.com" -To "administrator@test2012.com" -Body "Daily Check"
			
			Description
			-----------
			This command collect event log with event id 4634, and export to "C:\Eventlog.csv".
			Then send it to "administrator@test2012.com" via smtp server "Ex01"
			
		.EXAMPLE
			PS C:\> Export-OSCEvent -Path "C:\Eventlog.csv" -LogName "Application","Security","System" -EventID 4634,4624 -SmtpServer "Ex01"`
					-Subject "Eventlog daily check" -From "administrator@test2012.com" `
					-To "administrator@test2012.com","david@test2012.com"
			
			Description
			-----------
			This command collect event log with event id 4634 or 4624, and export to "C:\Eventlog.csv".
			Then send it to David and administrator via smtp server "Ex01"
		.LINK
			Windows PowerShell Advanced Function
			http://technet.microsoft.com/en-us/library/dd315326.aspx
		.LINK
			Send-MailMessage
			http://technet.microsoft.com/en-us/library/hh849925
		.LINK
			Export-Csv
			http://technet.microsoft.com/library/hh849932.aspx
		.LINK
			Get-WinEvent
			http://technet.microsoft.com/en-us/library/hh849682.aspx	
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true,Position=0)]
		[String]$Path,
        [Parameter(Mandatory=$True,Position=1)]
		[String[]]$LogName,
		[Parameter(Mandatory=$True,Position=2)]
		[String[]]$EventID,
		[Parameter(Mandatory=$True,Position=3)]
		[String]$SmtpServer,
		[Parameter(Mandatory=$True,Position=4)]
		[String[]]$To,
		[Parameter(Mandatory=$True,Position=5)]
		[String]$From,
		[Parameter(Mandatory=$False,Position=6)]
		[String]$Subject="Eventlog daily check",
		[Parameter(Mandatory=$False,Position=7)]
		[String]$Body="Eventlog daily check, detail report is attached."
	)
	process
	{
		#check whether path is correct
		try
		{
			$TempPath=Split-Path $Path
			if (-not (Test-Path $TempPath))
			{
				New-Item -ItemType directory -Path $TempPath -ErrorAction Stop  |Out-Null
			}
		}
		catch
		{
			Write-Error -Message "Could not create path '$Path'. Please make sure you have enough permission and the format is correct."
			return
		}
		#export a certain eventlog with specified log name and event ID for last 24 hours. 
        Get-WinEvent -LogName $LogName -MaxEvents 1000 -EA SilentlyContinue | Where-Object {$_.id -in $EventID -and $_.Timecreated -gt (Get-date).AddHours(-24)} | Sort TimeCreated -Descending | Export-Csv $Path -NoTypeInformation
		
		Send-MailMessage -From $From -To $To -SmtpServer $SmtpServer -Subject $Subject -Body $Body -Attachments $Path
	} 
}
