<#

    Script:   RemoveAllO365.ps1
    
    Purpose:  Removes Ofice 365
    
    Arguments:
              None.
              
    Version:
       1.0:   Initial version, September 2016, P. Zgraggen (Swisscom)
         
#>

# Default constants

# The Event Log Source Name used in the Application log
$Default_EventLogSourceName = "Addax.Remove.O365"

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

Function Init-EventLogSource {
	<#
		.SYNOPSIS
			Init-EventLogSource creates an event log source if necessary.

		.DESCRIPTION
			Write-Event function writes messages to the event log 
			after creating the logname and source if not already defined.

		.PARAMETER  $Message
			The message you want displayed in the event log body. 
			Required.
			
		.PARAMETER  $EventId
			The entryid number you wanted displayed in the event log. 
			Default is 0.
			
		.PARAMETER  $Source
			The source of the event log you wanted displayed in the event log. 
			Default is the PowerShell script name the function was invoked from.
			
		.PARAMETER  $LogName
			The log that you want the event loged in. Default is the Application log.
			If the Log and source pair do not exist on the machine this scirpt is 
			invoked on the pair will be created.

		.EXAMPLE
			PS C:\> Init-EventLogSource 

		.INPUTS

		.OUTPUTS
			None

		.NOTES
			Additional information about the function go here.

		.LINK
			http://jeffmurr.com/blog

	#>
	[CmdletBinding()]	
	param(
		[Parameter(Position=2, Mandatory=$false)]
		[System.String]
		$Source = $Default_EventLogSourceName,
		
		[Parameter(Position=3, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$LogName = "Application"
	)

	$ErrorActionPreference = "SilentlyContinue"
	if(!(Get-Eventlog -LogName $LogName -Source $Source)){
		$ErrorActionPreference = "Continue"
		try {New-Eventlog -LogName $LogName -Source $Source | Out-Null}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
}

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

Function Write-Event {
	<#
		.SYNOPSIS
			Write-Event function writes messages to the event log.

		.DESCRIPTION
			Write-Event function writes messages to the event log 
			after creating the logname and source if not already defined.

		.PARAMETER  $Message
			The message you want displayed in the event log body. 
			Required.
			
		.PARAMETER  $EventId
			The entryid number you wanted displayed in the event log. 
			Default is 0.
			
		.PARAMETER  $Source
			The source of the event log you wanted displayed in the event log. 
			Default is the PowerShell script name the function was invoked from.
			
		.PARAMETER  $LogName
			The log that you want the event loged in. Default is the Application log.
			If the Log and source pair do not exist on the machine this scirpt is 
			invoked on the pair will be created.

		.EXAMPLE
			PS C:\> Write-Event -Message "Process Started." -EntryId 0 -Information

		.EXAMPLE
			PS C:\> Write-Event "Process Started." -Information
			
		.EXAMPLE
			PS C:\> Write-Event "Process Failed." -EntryId 161 -Error
			
		.EXAMPLE
			PS C:\> Write-Event "Process Started."

		.INPUTS
			System.String,System.Int32,System.String,System.String,System.Switch,System.Switch

		.OUTPUTS
			None

		.NOTES
			Additional information about the function go here.

		.LINK
			http://jeffmurr.com/blog

	#>
	[CmdletBinding()]	
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$Message,
		
		[Parameter(Position=1, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.Int32]
		$EventId = 0,
		
		[Parameter(Position=2, Mandatory=$false)]
		[System.String]
		$Source = $Default_EventLogSourceName,
		
		[Parameter(Position=3, Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$LogName = "Application",
		
		[Switch]
		$Information,
		
		[Switch]
		$Warning,
		
		[Switch]
		$Error
	)

    <## See Init-EventLogSource
	$ErrorActionPreference = "SilentlyContinue"
	if(!(Get-Eventlog -LogName $LogName -Source $Source)){
		$ErrorActionPreference = "Continue"
		try {New-Eventlog -LogName $LogName -Source $Source | Out-Null}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
    ##>

	If ($Warning.IsPresent){	
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Warning" -EventId $EventId -Message $Message | Out-Null}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
	ElseIf ($Error.IsPresent) {
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Error" -EventId $EventId -Message $Message | Out-Null}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}	
	}
	Else {
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Information" -EventId $EventId -Message $Message | Out-Null}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
    
    Write-Host $Message
}

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

# This XML is the complete XML to remove all Office 365 products"
$XMLRemoveAllOffice365 = "<Configuration><Remove All=""true"" /><Display Level=""None"" /></Configuration>"

$ComputerSamAccountName = $env:COMPUTERNAME + "$"

$ScriptPath = Split-Path -Path $script:MyInvocation.MyCommand.Path -Parent

# Init Event Log - once
Init-EventLogSource

# Start
Write-Event -Information -Message "Starting Office 365 Remove All" -EventId 2000

    Write-Event -Information -Message "Older version of Office are installed, setup will uninstall older Office version(s)" -EventId 2001

    # This script uses the Microsoft Office Scrub Scripts, which must be located in the same folder as this script
    # Office 2007 script is called OffScrub07.vbs

    $OfficeScrubScripts = @( "OffScrub_O16msi.vbs", "OffScrubc2r.vbs" )

    foreach( $ScrubScript in $OfficeScrubScripts ) {
    
        $ScrubScriptFullPath = (Join-Path -Path $ScriptPath -ChildPath $ScrubScript)
        Write-Event -Information -Message "Searching for scrub script $($ScrubScriptFullPath)" -EventId 2002
        
        if( Test-Path -Path $ScrubScriptFullPath ) {
            Write-Event -Information -Message "Found Microsoft Scrub Script $($ScrubScriptFullPath)" -EventId 2003
                
            $ScriptName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path -Path $ScrubScript -Leaf))
            
            Write-Event -Information -Message "Running Microsoft Scrub Script $($ScrubScriptFullPath)" -EventId 2004
            Start-Process -FilePath "CScript.exe" -ArgumentList """$($ScrubScriptFullPath)"" ALL,OSE" -Wait
            }
        else {
            Write-Event -Information -Message "Can't find scrub script $($ScrubScriptFullPath)" -EventId 2005
            }
        }

        Write-Event -Information -Message "Remove OneDrive" -EventId 2006

        try {
            Get-Process -Name onedrive | Stop-Process -Force
            Write-Event -Information -Message "Killed all OneDrive processes" -EventId 2008
            }
        catch {
            Write-Event -Information -Message "Error killing OneDrive processes" -EventId 2008
            Write-Event -Information -Message $Error[0] -EventId 2008
            }

        $InstallOneDriveResult = (Start-Process -FilePath "\\addax\public\Software\Applications\Microsoft\Office365ProPlus\OneDriveSetup.exe" -ArgumentList @("/Uninstall") -Wait <#-WindowStyle hidden#> -PassThru )

        try {
            Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\OneDriveSetup" | Out-Null
            }
        catch {
            }

        Write-Event -Information -Message "OneDrive uninstall exit status: ($($InstallOneDriveResult.ExitCode))" -EventId 2007

    if( Test-PendingReboot ) {
        Write-Event -Information -Message $Message -EventId 2011
        Write-Event -Information -Message "Reboot Required, rebooting" -EventId 911
        Restart-Computer -Force
        }
        

Write-Event -Information -Message "Removal of Office 365 Completed" -EventId 2999

