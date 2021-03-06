<#

    Script:   installO365.ps1
    
    Purpose:  Generates the XML configuration file required by Office 365 ClickToRun setup. 
    
    Arguments:
         1:   An XML file describing the security groups that this script uses to determine the options to write to the O365 Setup XML File
              If no argument is present the script looks for InstallO365.xml is the same directory as this script

    Version:
       1.0:   Initial version, September 2016, P. Zgraggen (Swisscom)
         
#>

# Default constants

# The default controlling XML filename, this will be used if the script is started without arguments. 
#     It can be a full path or just a filename in which case the file must be co-located with this script 
$Default_ThisScriptXmlFilename = "\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\Scripts\InstallO365.xml"
#$Default_ThisScriptXmlFilename = "\\UPCHGVA2-468\Office2016_Test\Scripts\InstallO365-Test.xml"

# The default channel to install
$Default_Channel = "Deffered"

# The default bitness to use, either 32 or 64
$Default_Bitness = 32

# The Event Log Source Name used in the Application log
$Default_EventLogSourceName = "Addax.Install.O365"

#Start-Transcript -Path ([System.IO.Path]::GetTempFileName()) -Append

#region Functions
#region Init-EventLogSource
<# -----------------------------------------------------------------------------------------------------------------------------------------------------
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

Function Init-EventLogSource {
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
#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Write-Event
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

Function Write-Event {
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
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Warning" -EventId $EventId -Message $Message -Category 0 | Out-Null
              Write-Host "`r`n" (Get-Date -Format "yyyyMMdd HH:mm") "WARNING" $EventId $Message "`r`n"}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
	ElseIf ($Error.IsPresent) {
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Error" -EventId $EventId -Message $Message -Category 0 | Out-Null
              Write-Host "`r`n" (Get-Date -Format "yyyyMMdd HH:mm") "ERROR" $EventId $Message "`r`n"}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}	
	}
	Else {
		try { Write-EventLog -LogName $LogName -Source $Source -EntryType "Information" -EventId $EventId -Message $Message -Category 0 | Out-Null
              Write-Host "`r`n" (Get-Date -Format "yyyyMMdd HH:mm") "INFORMATION" $EventId $Message "`r`n"}
		catch [System.Security.SecurityException] {
			Write-Error "Error:  Run as elevated user.  Unable to write or read to event logs."
		}
	}
    
}

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Get-LoggedOnUsers

function Get-LoggedOnUsers($computername = ".") { 
 
#mjolinor 3/17/10 
 
$regexa = '.+Domain="(.+)",Name="(.+)"$' 
$regexd = '.+LogonId="(\d+)"$' 
 
$logontype = @{ 
        "0"="Local System" 
        "2"="Interactive" #(Local logon) 
        "3"="Network" # (Remote logon) 
        "4"="Batch" # (Scheduled task) 
        "5"="Service" # (Service account logon) 
        "7"="Unlock" #(Screen saver) 
        "8"="NetworkCleartext" # (Cleartext network logon) 
        "9"="NewCredentials" #(RunAs using alternate credentials) 
        "10"="RemoteInteractive" #(RDP\TS\RemoteAssistance) 
        "11"="CachedInteractive" #(Local w\cached credentials) 
    } 
 
$logon_sessions = @(gwmi win32_logonsession -ComputerName $computername) 
$logon_users = @(gwmi win32_loggedonuser -ComputerName $computername) 
 
$session_user = @{} 
 
$logon_users |% { 
    $_.antecedent -match $regexa > $nul 
    $username = $matches[1] + "\" + $matches[2] 
    $_.dependent -match $regexd > $nul 
    $session = $matches[1] 
    $session_user[$session] += $username 
    } 
  
$logon_sessions |%{ 
        $starttime = [management.managementdatetimeconverter]::todatetime($_.starttime) 
         
        $loggedonuser = New-Object -TypeName psobject 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid] 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.tostring()] 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "TypeID" -Value $_.logontype.tostring()
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $starttime 
         
        $loggedonuser 
        } 
 
    }

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Get-OfficeVersion
<#


    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [string[]]$ComputerName = $env:COMPUTERNAME,
        [switch]$ShowAllInstalledProducts,
        [System.Management.Automation.PSCredential]$Credentials
    )



    .Synopsis
    Gets the Office Version installed on the computer
    .DESCRIPTION
    This function will query the local or a remote computer and return the information about Office Products installed on the computer
    .NOTES   
    Name: Get-OfficeVersion
    Version: 1.0.5
    DateCreated: 2015-07-01
    DateUpdated: 2016-07-20
    .LINK
    https://github.com/OfficeDev/Office-IT-Pro-Deployment-Scripts
    .PARAMETER ComputerName
    The computer or list of computers from which to query 
    .PARAMETER ShowAllInstalledProducts
    Will expand the output to include all installed Office products
    .EXAMPLE
    Get-OfficeVersion
    Description:
    Will return the locally installed Office product
    .EXAMPLE
    Get-OfficeVersion -ComputerName client01,client02
    Description:
    Will return the installed Office product on the remote computers
    .EXAMPLE
    Get-OfficeVersion | select *
    Description:
    Will return the locally installed Office product with all of the available properties
#>

Function Get-OfficeVersion {
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true, Position=0)]
    [string[]]$ComputerName = $env:COMPUTERNAME,
    [switch]$ShowAllInstalledProducts,
    [System.Management.Automation.PSCredential]$Credentials )

begin {
    $HKLM = [UInt32] "0x80000002"
    $HKCR = [UInt32] "0x80000000"

    $excelKeyPath = "Excel\DefaultIcon"
    $wordKeyPath = "Word\DefaultIcon"
   
    $installKeys = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall',
                   'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'

    $officeKeys = 'SOFTWARE\Microsoft\Office',
                  'SOFTWARE\Wow6432Node\Microsoft\Office'

    $defaultDisplaySet = 'DisplayName','Version', 'ComputerName'

    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet',[string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
}

process {

 $results = new-object PSObject[] 0;

 foreach ($computer in $ComputerName) {
    if ($Credentials) {
       $os=Get-WMIObject win32_operatingsystem -computername $computer -Credential $Credentials
    } else {
       $os=Get-WMIObject win32_operatingsystem -computername $computer
    }

    $osArchitecture = $os.OSArchitecture

    if ($Credentials) {
       $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default -computername $computer -Credential $Credentials
    } else {
       $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default -computername $computer
    }

    [System.Collections.ArrayList]$VersionList = New-Object -TypeName System.Collections.ArrayList
    [System.Collections.ArrayList]$PathList = New-Object -TypeName System.Collections.ArrayList
    [System.Collections.ArrayList]$PackageList = New-Object -TypeName System.Collections.ArrayList
    [System.Collections.ArrayList]$ClickToRunPathList = New-Object -TypeName System.Collections.ArrayList
    [System.Collections.ArrayList]$ConfigItemList = New-Object -TypeName  System.Collections.ArrayList
    $ClickToRunList = new-object PSObject[] 0;

    foreach ($regKey in $officeKeys) {
       $officeVersion = $regProv.EnumKey($HKLM, $regKey)
       foreach ($key in $officeVersion.sNames) {
          if ($key -match "\d{2}\.\d") {
            if (!$VersionList.Contains($key)) {
              $AddItem = $VersionList.Add($key)
            }

            $path = join-path $regKey $key

            $configPath = join-path $path "Common\Config"
            $configItems = $regProv.EnumKey($HKLM, $configPath)
            if ($configItems) {
               foreach ($configId in $configItems.sNames) {
                 if ($configId) {
                    $Add = $ConfigItemList.Add($configId.ToUpper())
                 }
               }
            }

            $cltr = New-Object -TypeName PSObject
            $cltr | Add-Member -MemberType NoteProperty -Name InstallPath -Value ""
            $cltr | Add-Member -MemberType NoteProperty -Name UpdatesEnabled -Value $false
            $cltr | Add-Member -MemberType NoteProperty -Name UpdateUrl -Value ""
            $cltr | Add-Member -MemberType NoteProperty -Name StreamingFinished -Value $false
            $cltr | Add-Member -MemberType NoteProperty -Name Platform -Value ""
            $cltr | Add-Member -MemberType NoteProperty -Name ClientCulture -Value ""


            
            $packagePath = join-path $path "Common\InstalledPackages"
            $clickToRunPath = join-path $path "ClickToRun\Configuration"
            $virtualInstallPath = $regProv.GetStringValue($HKLM, $clickToRunPath, "InstallationPath").sValue

            [string]$officeLangResourcePath = join-path  $path "Common\LanguageResources"
            $mainLangId = $regProv.GetDWORDValue($HKLM, $officeLangResourcePath, "SKULanguage").uValue
            if ($mainLangId) {
                $mainlangCulture = [globalization.cultureinfo]::GetCultures("allCultures") | where {$_.LCID -eq $mainLangId}
                if ($mainlangCulture) {
                    $cltr.ClientCulture = $mainlangCulture.Name
                }
            }

            [string]$officeLangPath = join-path  $path "Common\LanguageResources\InstalledUIs"
            $langValues = $regProv.EnumValues($HKLM, $officeLangPath);
            if ($langValues) {
               foreach ($langValue in $langValues) {
                  $langCulture = [globalization.cultureinfo]::GetCultures("allCultures") | where {$_.LCID -eq $langValue}
               } 
            }

            if ($virtualInstallPath) {

            } else {
              $clickToRunPath = join-path $regKey "ClickToRun\Configuration"
              $virtualInstallPath = $regProv.GetStringValue($HKLM, $clickToRunPath, "InstallationPath").sValue
            }

            if ($virtualInstallPath) {
               if (!$ClickToRunPathList.Contains($virtualInstallPath.ToUpper())) {
                  $AddItem = $ClickToRunPathList.Add($virtualInstallPath.ToUpper())
               }

               $cltr.InstallPath = $virtualInstallPath
               $cltr.StreamingFinished = $regProv.GetStringValue($HKLM, $clickToRunPath, "StreamingFinished").sValue
               $cltr.UpdatesEnabled = $regProv.GetStringValue($HKLM, $clickToRunPath, "UpdatesEnabled").sValue
               $cltr.UpdateUrl = $regProv.GetStringValue($HKLM, $clickToRunPath, "UpdateUrl").sValue
               $cltr.Platform = $regProv.GetStringValue($HKLM, $clickToRunPath, "Platform").sValue
               $cltr.ClientCulture = $regProv.GetStringValue($HKLM, $clickToRunPath, "ClientCulture").sValue


               $ClickToRunList += $cltr
            }

            $packageItems = $regProv.EnumKey($HKLM, $packagePath)
            $officeItems = $regProv.EnumKey($HKLM, $path)

            foreach ($itemKey in $officeItems.sNames) {
              $itemPath = join-path $path $itemKey
              $installRootPath = join-path $itemPath "InstallRoot"

              $filePath = $regProv.GetStringValue($HKLM, $installRootPath, "Path").sValue
              if (!$PathList.Contains($filePath)) {
                  $AddItem = $PathList.Add($filePath)
              }
            }

            foreach ($packageGuid in $packageItems.sNames) {
              $packageItemPath = join-path $packagePath $packageGuid
              $packageName = $regProv.GetStringValue($HKLM, $packageItemPath, "").sValue
            
              if (!$PackageList.Contains($packageName)) {
                if ($packageName) {
                   $AddItem = $PackageList.Add($packageName.Replace(' ', '').ToLower())
                }
              }
            }

          }
       }
    }

    

    foreach ($regKey in $installKeys) {
        $keyList = new-object System.Collections.ArrayList
        $keys = $regProv.EnumKey($HKLM, $regKey)
        foreach ($key in $keys.sNames) {
           $path = join-path $regKey $key
           $installPath = $regProv.GetStringValue($HKLM, $path, "InstallLocation").sValue
           if (!($installPath)) { continue }
           if ($installPath.Length -eq 0) { continue }

           $buildType = "64-Bit"
           if ($osArchitecture -eq "32-bit") {
              $buildType = "32-Bit"
           }

           if ($regKey.ToUpper().Contains("Wow6432Node".ToUpper())) {
              $buildType = "32-Bit"
           }

           if ($key -match "{.{8}-.{4}-.{4}-1000-0000000FF1CE}") {
              $buildType = "64-Bit" 
           }

           if ($key -match "{.{8}-.{4}-.{4}-0000-0000000FF1CE}") {
              $buildType = "32-Bit" 
           }

           if ($modifyPath) {
               if ($modifyPath.ToLower().Contains("platform=x86")) {
                  $buildType = "32-Bit"
               }

               if ($modifyPath.ToLower().Contains("platform=x64")) {
                  $buildType = "64-Bit"
               }
           }

           $primaryOfficeProduct = $false
           $officeProduct = $false
           foreach ($officeInstallPath in $PathList) {
             if ($officeInstallPath) {
                $installReg = "^" + $installPath.Replace('\', '\\')
                $installReg = $installReg.Replace('(', '\(')
                $installReg = $installReg.Replace(')', '\)')
                if ($officeInstallPath -match $installReg) { $officeProduct = $true }
             }
           }

           if (!$officeProduct) { continue };
           
           $name = $regProv.GetStringValue($HKLM, $path, "DisplayName").sValue          

           if ($ConfigItemList.Contains($key.ToUpper()) -and $name.ToUpper().Contains("MICROSOFT OFFICE") -and $name.ToUpper() -notlike "*MUI*") {
              $primaryOfficeProduct = $true
           }

           $clickToRunComponent = $regProv.GetDWORDValue($HKLM, $path, "ClickToRunComponent").uValue
           $uninstallString = $regProv.GetStringValue($HKLM, $path, "UninstallString").sValue
           if (!($clickToRunComponent)) {
              if ($uninstallString) {
                 if ($uninstallString.Contains("OfficeClickToRun")) {
                     $clickToRunComponent = $true
                 }
              }
           }

           $modifyPath = $regProv.GetStringValue($HKLM, $path, "ModifyPath").sValue 
           $version = $regProv.GetStringValue($HKLM, $path, "DisplayVersion").sValue



           $cltrUpdatedEnabled = $NULL
           $cltrUpdateUrl = $NULL
           $clientCulture = $NULL;

           [string]$clickToRun = $false

           if ($clickToRunComponent) {
               $clickToRun = $true
               if ($name.ToUpper().Contains("MICROSOFT OFFICE")) {
                  $primaryOfficeProduct = $true
               }

               foreach ($cltr in $ClickToRunList) {
                 if ($cltr.InstallPath) {
                   if ($cltr.InstallPath.ToUpper() -eq $installPath.ToUpper()) {
                       $cltrUpdatedEnabled = $cltr.UpdatesEnabled
                       $cltrUpdateUrl = $cltr.UpdateUrl
                       if ($cltr.Platform -eq 'x64') {
                           $buildType = "64-Bit" 
                       }
                       if ($cltr.Platform -eq 'x86') {
                           $buildType = "32-Bit" 
                       }
                       $clientCulture = $cltr.ClientCulture
                   }
                 }
               }
           }
           
           if (!$primaryOfficeProduct) {
              if (!$ShowAllInstalledProducts) {
                  continue
              }
           }

           $object = New-Object PSObject -Property @{DisplayName = $name; Version = $version; InstallPath = $installPath; ClickToRun = $clickToRun; 
                     Bitness=$buildType; ComputerName=$computer; ClickToRunUpdatesEnabled=$cltrUpdatedEnabled; ClickToRunUpdateUrl=$cltrUpdateUrl;
                     ClientCulture=$clientCulture;RegKey=$path }
           $object | Add-Member MemberSet PSStandardMembers $PSStandardMembers
           $results += $object

        }
    }

  }

  $results = Get-Unique -InputObject $results 

  return $results;
}

}

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region getCTRConfig

<#

    Function: getCTRConfig
    
    Arguments: None
       
    Purpose:    Returns the current Click To Run configuration installed on the machine
                From Github see https://github.com/OfficeDev/Office-IT-Pro-Deployment-Scripts/tree/master/Office-ProPlus-Deployment
    
    Owner: Microsoft Office Product Team
    
    Returns an object
        ClickToRunInstalled : True/False
        Platform            : 32/64
        ClientCulture       : en-us
        ProductReleaseIds   : O365ProPlusRetail,VisioProXVolume
        Version             : 16.0.6741.2063
        UpdatesEnabled      : True
        UpdateUrl           : C:\Office365ProPlus\Channel.Deffered
        UpdateDeadline      : 
        OfficeKeyPath       : SOFTWARE\Microsoft\Office\ClickToRun
        AppsExcluded        : access,groove
        CDNBaseUrl          : http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114
        
#>

function getCTRConfig() {

    $HKLM = [UInt32] "0x80000002"
    $computerName = $env:COMPUTERNAME

    if (!($regProv)) {
        $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default -computername $computerName -ErrorAction Stop
        }
    
    $officeCTRKeys = 'SOFTWARE\Microsoft\Office\15.0\ClickToRun',
                     'SOFTWARE\Wow6432Node\Microsoft\Office\15.0\ClickToRun',
                     'SOFTWARE\Microsoft\Office\ClickToRun',
                     'SOFTWARE\Wow6432Node\Microsoft\Office\ClickToRun'

    $Object = New-Object PSObject
    $Object | Add-Member Noteproperty ClickToRunInstalled $false

    [string]$officeKeyPath = "";
    foreach ($regPath in $officeCTRKeys) {
       [string]$installPath = $regProv.GetStringValue($HKLM, $regPath, "InstallPath").sValue
       if ($installPath) {
          if ($installPath.Length -gt 0) {
              $officeKeyPath = $regPath;
              break;
              }
           }
        }

    if ($officeKeyPath.Length -gt 0) {
        $Object.ClickToRunInstalled = $true

        $configurationPath = Join-Path $officeKeyPath "Configuration"

        [string]$platform = $regProv.GetStringValue($HKLM, $configurationPath, "Platform").sValue
        [string]$clientCulture = $regProv.GetStringValue($HKLM, $configurationPath, "ClientCulture").sValue
        [string]$productIds = $regProv.GetStringValue($HKLM, $configurationPath, "ProductReleaseIds").sValue
        [string]$versionToReport = $regProv.GetStringValue($HKLM, $configurationPath, "VersionToReport").sValue
        [string]$updatesEnabled = $regProv.GetStringValue($HKLM, $configurationPath, "UpdatesEnabled").sValue
        [string]$updateUrl = $regProv.GetStringValue($HKLM, $configurationPath, "UpdateUrl").sValue
        [string]$updateDeadline = $regProv.GetStringValue($HKLM, $configurationPath, "UpdateDeadline").sValue
        [string]$AppsExcluded = $regProv.GetStringValue($HKLM, $configurationPath, "o365proplusretail.ExcludedApps").sValue

        if (!($productIds)) {
            $productIds = ""
            $officeActivePath = Join-Path $officeKeyPath "ProductReleaseIDs\Active"
            $officeProducts = $regProv.EnumKey($HKLM, $officeActivePath)

            foreach ($productName in $officeProducts.sNames) {
               if ($productName.ToLower() -eq "stream") { continue }
               if ($productName.ToLower() -eq "culture") { continue }
               if ($productIds.Length -gt 0) { $productIds += "," }
               $productIds += "$productName"
                }
            }

        $splitProducts = $productIds.Split(',');

        if ($platform.ToLower() -eq "x86") {
            $platform = "32"
            } 
        else {
            $platform = "64"
            }

        $CDNBaseUrl = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration -Name CDNBaseUrl -ErrorAction SilentlyContinue).CDNBaseUrl
        if (!($CDNBaseUrl)) {
           $CDNBaseUrl = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Office\15.0\ClickToRun\Configuration -Name CDNBaseUrl -ErrorAction SilentlyContinue).CDNBaseUrl
            }
        
        $Object | Add-Member Noteproperty Platform $platform
        $Object | Add-Member Noteproperty ClientCulture $clientCulture.Split(",")
        $Object | Add-Member Noteproperty ProductReleaseIds $productIds.Split(",")
        $Object | Add-Member Noteproperty Version $versionToReport
        $Object | Add-Member Noteproperty UpdatesEnabled $updatesEnabled
        $Object | Add-Member Noteproperty UpdateUrl $updateUrl
        $Object | Add-Member Noteproperty UpdateDeadline $updateDeadline
        $Object | Add-Member Noteproperty OfficeKeyPath $officeKeyPath
        $Object | Add-Member Noteproperty AppsExcluded $AppsExcluded.Split(",")
        $Object | Add-Member Noteproperty CDNBaseUrl $CDNBaseUrl
        } 

    return $Object 
    }

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region IsInGroup
<#

    Function: IsInGroup
    
    Arguments:
       samAccountName:   the samAccountName to search for, computer names must have the trailing dollar
       GroupName:        the distingish name of the group, nested groups are also searched
       
    Purpose:  Uses LDAP to search the Active Directory to see if the samAccountName is a member if the GroupName (including nested groups)
    
    Returns:
        $true    if the samAccountName is a member
        $false   under all other conditions, i.e. not a member, samAccountName doesn't exists, GroupName doesn't exist
        
#>

Function IsInGroup( $DomainController, $samAccountName, $GroupName ) {
    
    if( $samAccountName -eq $null -or $GroupName -eq $null ) {
        return $false
        }

    $IsInGroupResult = $false

    try {
        $Domain = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DomainController")
        $Searcher = New-Object System.DirectoryServices.DirectorySearcher($Domain)

        $Searcher.PageSize = 100
        $Searcher.SearchScope = "subtree"
        $Searcher.Filter = "(&(objectCategory=Group)(sAMAccountName=$GroupName))"
        $colProplist = "name","distinguishedName"
        foreach( $i in $colPropList ) {
            $Searcher.PropertiesToLoad.Add($i) | Out-Null
            }
        $GResult = $Searcher.FindOne()

        If($GResult -ne $null) {
            #Get the DN of the group
            $GroupDN = $GResult.Properties.distinguishedname
            $Searcher.Filter = "(&(sAMAccountName=$samAccountName)(memberof:1.2.840.113556.1.4.1941:=$GroupDN))"
            $Result = $Searcher.FindAll()
            if ($Result -ne $null) {
                $IsInGroupResult = $true
                } 
            }
        }
    catch {}
    
    return $IsInGroupResult
    }

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Test-XMLFile
<#

    Function: Test-XMLFile
    
    Arguments:
       xmlFilePath:   the file name to test
       
    Purpose:  Verifies that the file contains a valid XML document structure
    
    Returns:
        $null                if the structure is a valid XML
        StringErrorMessage   under all other conditions
        
#>

Function Test-XMLFile( $xmlFilePath ) {
    # Check for Load or Parse errors when loading the XML file
    $xml = New-Object System.Xml.XmlDocument
    try {
        $xml.Load((Get-ChildItem -Path $xmlFilePath).FullName)
        return $null
        }
    catch [System.Xml.XmlException] {
	    #this message may help user debug or at least see the detailed issue of the file. 
        return $_.toString()
        }
    }

#endregion

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Test-PendingReboot

function Test-PendingReboot {
#Adapted from https://gist.github.com/altrive/5329377
#Based on <http://gallery.technet.microsoft.com/scriptcenter/Get-PendingReboot-Query-bdb79542>

    $RebootPending = $false

    if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA SilentlyContinue) {
        Write-Event -Information -Message "Reboot pending, reason: Component Based Servicing" -EventId 902
        $RebootPending = $true
        }
    if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA SilentlyContinue) {
        Write-Event -Information -Message "Reboot pending, reason: WindowsUpdate" -EventId 902
        $RebootPending = $true
        }
    if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA SilentlyContinue) { 
        Write-Event -Information -Message "Reboot pending, reason: Pending File Rename Operations" -EventId 902
        $RebootPending = $true
        }
    try { 
       $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
       $status = $util.DetermineIfRebootPending()
       if(($status -ne $null) -and $status.RebootPending) {
            Write-Event -Information -Message "Reboot pending, reason: SCCM via WMI" -EventId 902
            $RebootPending = $true
            }
        }
    catch {
        }
 
    return $RebootPending
    }

#endregion    

<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#endregion    
<# ----------------------------------------------------------------------------------------------------------------------------------------------------- #>

#region Startup
# This XML is the complete XML to remove all Office 365 products"
$XMLRemoveAllOffice365 = "<Configuration><Remove All=""true"" /><Display Level=""None"" /></Configuration>"

$ComputerSamAccountName = $env:COMPUTERNAME + "$"
$ThisScriptXmlConfigFilename = ""
$ThisScriptExecuteSetup = $false                # if this is false then setup will not execute

$ScriptPath = Split-Path -Path $script:MyInvocation.MyCommand.Path -Parent

# Init Event Log - once
Init-EventLogSource

# Start
Write-Event -Information -Message "Starting Office 365 Installation" -EventId 1

# Fetching AD Domain Name
$MachineDomain = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name MachineDomain).MachineDomain
Write-Event -Information -Message "Active Directory Domain: $($MachineDomain)" -EventId 2

if( Test-Connection -ComputerName $MachineDomain -Quiet ) {
    Write-Event -Information -Message "Script has successfully PING a domain controller, it has network connectivity" -EventId 3
    }
else {
    Write-Event -Error -Message "Attempts to PING a domain controller failed" -EventId 4
    Write-Event -Error -Message "$($Message)Assuming no DFS network connectivity, quitting" -EventId 4
    return 1222       # ERROR_NO_NETWORK
    }

#endregion

#region GetActiveDirectory Info
# Fetch Domain Controller Name

try {
    $DomainController = "CHGVA5-001.upstream.apc.grp"
    $DomainControllerList = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Servers
    $CurrentDomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

    foreach( $DC in $DomainControllerList ) {
        if( (Test-Connection -ComputerName $DC.Name -Quiet -Count 1) -and ($DC.Domain.ToString() -eq $CurrentDomain) ) {
            $DomainController = $DC.Name
            break
            }
        }
    }
catch {
    Write-Event -Error -Message $Error[0] -EventId 5
    }

if( $DomainController -eq $null ) {
    Write-Event -Error -Message "Unable to fetch a domain controller`n$($Error[0])" -EventId 6
    Write-Event -Error -Message "Assuming no network connectivity, quitting" -EventId 6
    return 1222       # ERROR_NO_NETWORK
    }

Write-Event -Information -Message "Using Domain Controller $DomainController for LDAP" -EventId 5

# Fetch DFS Infomation
$ADSiteData = "No Information"
$DfsClientData = "No Information"
$DfsRootData = "No Information"

Write-Host "Fetching Win32_NetworkAdapterConfiguration From WMI"
$Ipv4AddressRegex = [regex] "\b(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}\b"
$LocalIPaddresses = @()
$NetworkAdapterCollection = gwmi Win32_NetworkAdapterConfiguration

foreach( $NetworkAdapter in $NetworkAdapterCollection ) {
    if( $NetworkAdapter.IPAddress -and $NetworkAdapter.DefaultIPGateway ) {
        foreach( $IPAddress in $NetworkAdapter.IPAddress ) {
            if( $IPAddress -match $Ipv4AddressRegex ) {
                $LocalIPaddresses += @($IPAddress)
                }
            }
        }
    }

if( $LocalIPaddresses.Count -eq 0 ) {
    $LocalIPaddressData = "No found"
    }
else {
    $LocalIPaddressData = ($LocalIPaddresses -join ", ")
    }

if( $env:PROCESSOR_ARCHITECTURE -eq 'AMD64' ) {
    try {
        Write-Host "Fetching DfsUtil Client SiteInfo using hostname"
        $DfsClientData = "Attempting to obtain DFS SiteInfo based on computer name $($env:COMPUTERNAME)"
        $DfsClientData += (\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\Tools\dfsutil.exe client siteinfo $env:COMPUTERNAME) | Select-String -Pattern "site" | Out-String -Width 300

        if( $LocalIPaddresses.Count -eq 0 ) {
            Write-Event -Information -Message "Unable to obtain the local IP Address" -EventId 601
            }
        else {
            Write-Host "Fetching DfsUtil Client SiteInfo using WMI IP Addresses"

            foreach( $IPAddress in $LocalIPaddresses ) {
                $DfsClientData += "Attempting to obtain DFS SiteInfo based on IP Address $($IPAddress)"
                $DfsClientData += (\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\Tools\dfsutil.exe client siteinfo $IPaddress) | Select-String -Pattern "site" | Out-String -Width 300
                }
            }

        Write-Host "Fetching DfsUtil pktinfo"
        $DfsRootData = (((\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\Tools\dfsutil.exe /pktinfo) | Select-String -Pattern "active","entry") | Out-String -Width 300)
        }
    catch {
        Write-Event -Error -Message "Unable to fetch DFS Information`n$($Error[0])" -EventId 601
        }
    }
else {
    Write-Event -Warning -Message "Unable to fetch DFS Information because it is a 32-bit Windows" -EventId 601
    }

Write-Host "Fetching NLTest DSGETSITE"
$ADSiteData = (nltest /dsgetsite) | Out-String -Width 300

Write-Event -Information -Message "AD Site DSGetSite:`n$($ADSiteData)`nDFS Client SiteInfo`n$($DfsClientData)`nDFS Root Infomation`n$($DfsRootData)`nLocal IP Address: $($LocalIPaddressData)`n" -EventId 603

#endregion


# Fetch the driving XML
$Message = "Powershell Script Argument Count: $($args.Count)`n"

if( $args.Count -ge 1 ) {
    $Message += "Script Argument: $($args[0])`n"
    
    if( Test-Path -Path $args[0] ) {
        $Message += "File Exists: $($args[0])`n"
        
        $ThisScriptXmlConfigFilename = $args[0]
        }
    else {
        # Couldn't find that path, that the filename and see if it is with the script
        $Message += "WARN`tFile Does Not Exists: $($args[0])`n"
        
        $FileName = Split-Path -Path $args[0] -Leaf
        $Message += "Searching for : $($FileName) in folder $($ScriptPath) `n"

        if( Test-Path -Path (Join-Path -Path $ScriptPath -ChildPath $FileName) ) {
            $ThisScriptXmlConfigFilename = (Join-Path -Path $ScriptPath -ChildPath $FileName)
            $Message += "File Exists: $($ThisScriptXmlConfigFilename)`n"
            }
        else {
            $Message += "ERROR`tCould not find that file`n"
            }
        }
    }
else {
    # No scripts arguments, use default XML filename
    $Message += "INFO`tNo script arguments, will attempt to use default file $($Default_ThisScriptXmlFilename)`n"
    
    if( (Test-Path -Path $Default_ThisScriptXmlFilename) ) {
        $Message += "File Exists: $($Default_ThisScriptXmlFilename)`n"
    
        $ThisScriptXmlConfigFilename = $Default_ThisScriptXmlFilename
        }
    else {
        $Message += "INFO`tFile Does Not Exists: $($Default_ThisScriptXmlFilename)`n"

        $Message += "Searching for : $($Default_ThisScriptXmlFilename) in folder $($ScriptPath) `n"

        if( Test-Path -Path (Join-Path -Path $ScriptPath -ChildPath $Default_ThisScriptXmlFilename) ) {
            $ThisScriptXmlConfigFilename = (Join-Path -Path $ScriptPath -ChildPath $Default_ThisScriptXmlFilename)
            $Message += "File Exists: $($ThisScriptXmlConfigFilename)`n"
            }
        else {
            $Message += "WARN`tCould not find that file`n"
            }
        }
    }

$Message += "Attempting to use file: $($ThisScriptXmlConfigFilename)`n"

if( $ThisScriptXmlConfigFilename.length -eq 0 ) {
    Write-Event -Error -Message "$($Message)FATAL`tCould not find any XML file to use, quitting" -EventId 7
    return 2      # ERROR_FILE_NOT_FOUND
    }

$Message += "Using XML File: $ThisScriptXmlConfigFilename`n"

# Test XML file
$Message += "Testing of XML file for parsing errors`n"
$XmlParseResult = Test-XMLFile $ThisScriptXmlConfigFilename
if( $XmlParseResult -eq $null ) {
    $DesiredConfig = [xml] (Get-Content -Path $ThisScriptXmlConfigFilename -ErrorAction:SilentlyContinue)
    }
else {
    $Message += "ERROR`t$($XmlParseResult)`n"
    Write-Event -Error -Message "$($Message)FATAL`tXML parsing errors, quitting" -EventId 7
    return 1465 # ERROR_XML_PARSE_ERROR
    }

Write-Event -Information -Message $Message -EventId 8

# Create a temp file for the XML install file
$O365XmlConfigFilename = [System.IO.Path]::GetTempFileName()
Write-Event -Information -Message "Created temp install XML File: $O365XmlConfigFilename" -EventId 9

# Check the XML for required values
if( $DesiredConfig.Configuration.Install.SetupPath -eq $null ) {
    Write-Event -Error -Message "XML error, missing setup path, quitting" -EventId 10
    return 1465 # ERROR_XML_PARSE_ERROR
    }

if( $DesiredConfig.Configuration.Install.ProductID -eq $null ) {
    Write-Event -Error -Message "XML error, missing Office 365 Product ID, quitting" -EventId 11
    return 1465 # ERROR_XML_PARSE_ERROR
    }

Write-Event -Information -Message "Setup Path: $($DesiredConfig.Configuration.Install.SetupPath)" -EventId 12

# Get the main install group
if( $DesiredConfig.Configuration.Install.InstallGroup -eq $null ) {
    Write-Event -Error -Message "Missing install group in XML file, quitting" -EventId 13
    return 1610 # ERROR_BAD_CONFIGURATION
    }

# Get the Current CTR Config
$Message = "Fetching the current Click To run configuration`n"
$CurrentCtrConfig = getCTRConfig

$Message += "Current Click To run configuration:"
$Message += "`n--------------------`n"
$Message += ($CurrentCtrConfig | Out-String -Width 300)
$Message += "`n--------------------`n"

Write-Event -Information -Message $Message -EventId 14

Write-Event -Information -Message "Primary Install Group: $($DesiredConfig.Configuration.Install.InstallGroup)" -EventId 15

if( -not (IsInGroup $DomainController $ComputerSamAccountName $DesiredConfig.Configuration.Install.InstallGroup) ) {
    $Message += "Computer is not a member of $($DesiredConfig.Configuration.Install.InstallGroup)`n"
    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        Write-Event -Warning -Message "Computer is not a member of $($DesiredConfig.Configuration.Install.InstallGroup) but has Office 365 Click To Run installed" -EventId 16
        }
    else {
        Write-Event -Warning -Message $Message -EventId 16
        }

    Write-Event -Information -Message ("Script Completed") -EventId 99
    return 0
    }
else {
    Write-Event -Information -Message "Computer is a member of $($DesiredConfig.Configuration.Install.InstallGroup)" -EventId 17

    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        Write-Event -Information -Message "Computer has Office 365 Click To Run installed" -EventId 16
        }
    else {
        # Remove Old Office versions?
        $OldVersionsExist = $false
        $OfficeScrubScripts = @()

        $Message = "Fetching the current Office inventory`n"

        $OfficeInventory = Get-OfficeVersion -ShowAllInstalledProducts 
        foreach( $OfficeVersion in $OfficeInventory ) {
            $WillTreat = $false

            if( ($OfficeVersion.ClickToRun -eq "False") -and ($OfficeVersion.DisplayName -like "*Microsoft*") -and -not ($OfficeVersion.RegKey -like '*90160000-001F-0804-0000-0000000FF1CE*') ) {             # Ignore C2R versions and ZN language tools

                if( $OfficeVersion.Version.StartsWith("12.") ) {    # Office 2007
                    if( -not ($OfficeScrubScripts -contains "OffScrub07.vbs" ) ) { 
                        $WillTreat = $true
                        $OldVersionsExist = $true
                        $OfficeScrubScripts += @("OffScrub07.vbs")
                        }
                    }
                elseif( $OfficeVersion.Version.StartsWith("14.") ) {    # Office 2010
                    if( -not ($OfficeScrubScripts -contains "OffScrub10.vbs" ) ) {
                        $WillTreat = $true
                        $OldVersionsExist = $true
                        $OfficeScrubScripts += @("OffScrub10.vbs")
                        }
                    }
                elseif( $OfficeVersion.Version.StartsWith("15.") ) {    # Office 2013
                    if( -not ($OfficeScrubScripts -contains "OffScrub_O15msi.vbs" ) ) {
                        $WillTreat = $true
                        $OldVersionsExist = $true
                        $OfficeScrubScripts += @("OffScrub_O15msi.vbs")
                        }
                    }
                elseif( $OfficeVersion.Version.StartsWith("16.") ) {    # Office 2016
                    if( -not ($OfficeScrubScripts -contains "OffScrub_O16msi.vbs" ) ) {
                        $WillTreat = $true
                        $OldVersionsExist = $true
                        $OfficeScrubScripts += @("OffScrub_O16msi.vbs")
                        }
                    }
                else {
                    Write-Host "Couldn't find version for <$($OfficeVersion.DisplayName)> Version <$($OfficeVersion.Version)>"
                    }
                }
            if( $WillTreat) {
                $Message += "Found <$($OfficeVersion.DisplayName)> Version <$($OfficeVersion.Version)>  `n"
                }
            else {
                $Message += "Ignoring <$($OfficeVersion.DisplayName)> Version <$($OfficeVersion.Version)> `n"
                }
            }
    
        Write-Event -Information -Message $Message -EventId 18
        $Message = ""

        if( $OldVersionsExist ) {
            Write-Event -Information -Message "Older version of Office are installed, setup will uninstall older Office version(s)" -EventId 19

            # This script uses the Microsoft Office Scrub Scripts, which must be located in the same folder as this script

            foreach( $ScrubScript in $OfficeScrubScripts ) {
                $ScrubScriptFullPath = (Join-Path -Path $ScriptPath -ChildPath $ScrubScript)
        
                if( Test-Path -Path $ScrubScriptFullPath ) {
                    $ArgList = "//B //H:CScript ""$($ScrubScriptFullPath)"" ALL,OSE"
                    Write-Event -Information -Message "Running Microsoft Scrub CScript $($ArgList)`n" -EventId 20

                    $ScrubScriptResult = (Start-Process -FilePath "CScript.exe" -ArgumentList $ArgList -Wait -PassThru)

                    Write-Event -Information -Message "Scrub CScript Exit Status $($ScrubScriptResult.ExitCode)`n" -EventId 20
                    }
                else {
                    Write-Event -WarningAction -Message "Can't find scrub script $ScrubScriptFullPath`n" -EventId 20
                    }
                }

            if( Test-PendingReboot ) {
                Write-Event -Information -Message "Reboot Required" -EventId 911
                }
        
            Restart-Computer -Force 
            return (350) # ERROR_FAIL_NOACTION_REBOOT 

            Write-Event -Information -Message "Completed uninstall of older version, no reboot required" -EventId 21
            }
        }

    Write-Event -Information -Message "Completed examination of the current Office inventory" -EventId 22

    # If restart pending, don't execute
    if( Test-PendingReboot ) {
        Write-Event -Information -Message "Reboot required before continuing" -EventId 911
        return (350) # ERROR_FAIL_NOACTION_REBOOT 
        }

    # Now we have to work out what has changed, if anything
    if( -not $CurrentCtrConfig.ClickToRunInstalled ) {
        Write-Event -Information -Message "Office Click To Run is not installed, setup will install Office 365" -EventId 23
        $ThisScriptExecuteSetup = $true
        }
    
    # Platform (bitness) Change?
    $DesiredBitness = $Default_Bitness

    if( $DesiredConfig.Configuration.Install.OfficeClientEdition.Default -ne $null ) {
        $DesiredBitness = $DesiredConfig.Configuration.Install.OfficeClientEdition.Default
        }
        
    if( $DesiredConfig.Configuration.Install.OfficeClientEdition.ExceptionGroup -ne $null ) {
        if( (IsInGroup $DomainController $ComputerSamAccountName $DesiredConfig.Configuration.Install.OfficeClientEdition.ExceptionGroup) ) {
            # if the computer is in the exception group then we want the opposite to the default
            if( $DesiredBitness -eq 32 ) {
                $DesiredBitness = 64
                }
            else {
                $DesiredBitness = 32
                }
            }
        }

    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        $CurrentBitness = $CurrentCtrConfig.Platform
        
        $Message = "Current Bitness is <$CurrentBitness> Desired bitness <$DesiredBitness>`n"
        if( $CurrentBitness -ne $DesiredBitness ) {
            $Message += "WARN`tBitness has changed`n"
            $ThisScriptExecuteSetup = $true
            }
        else {
            $Message += "INFO`tNo change in bitness`n"
            }
        Write-Event -Information -Message $Message -EventId 24
        }    

    # Channel Change?
    $DesiredBranch = $null
    $DesiredVersion = $null
    $DesiredVersionFromXml = $null
    $DesiredBranchSourcePath = $null
    $DesiredBranchUpdatePath = $null
    $BranchOnHoldGroup = $null
    $BranchOnHoldVersion = $null
    
    $Message = ""

    if( $DesiredConfig.Configuration.Install.Channels.DefaultChannel -ne $null ) {
        $DesiredBranch = $DesiredConfig.Configuration.Install.Channels.DefaultChannel
        $Message += "Default channel <$DesiredBranch> found in XML`n"
        }
    else {
        $DesiredBranch = $Default_Channel
        $Message += "No default channel found in XML using script default <$DesiredBranch> `n"        
        }
    
    $BranchGroupCount = 0
    if( $DesiredConfig.Configuration.Install.Channels.Channel -ne $null ) {
        foreach($branch in $DesiredConfig.Configuration.Install.Channels.Channel) {
            if( $branch.Name -eq $DesiredBranch ) {
                $DesiredVersion = $branch.Version
                $DesiredVersionFromXml = $branch.Version
                $DesiredBranchSourcePath = $branch.SourcePath
                $DesiredBranchUpdatePath = $branch.UpdatePath
                $BranchOnHoldGroup = $branch.OnHoldGroup
                $BranchOnHoldVersion = $branch.OnHoldVersion
                }
            if( (IsInGroup $DomainController $ComputerSamAccountName $branch.Group) ) {
                $BranchGroupCount += 1
                
                $DesiredBranch = $branch.Name
                $DesiredVersion = $branch.Version
                $DesiredVersionFromXml = $branch.Version
                $DesiredBranchSourcePath = $branch.SourcePath
                $DesiredBranchUpdatePath = $branch.UpdatePath
                $BranchOnHoldGroup = $branch.OnHoldGroup
                $BranchOnHoldVersion = $branch.OnHoldVersion
                }
            }
        }
    else {
        $message += "Error, Missing <CHANNELS><CHANNEL...\></CHANNELS> definition section in XML`n"
        }

    if( $BranchGroupCount -gt 1 ) {
        $message += "Warning, Computer is assigned to more than one branch group`n"
        }
        
    if( $DesiredBranchSourcePath -eq $null ) {
        Write-Event -Error -Message "$($Message)FATAL`tNo SourcePath defined in the XML, quitting" -EventId 25
        return 1610 # ERROR_BAD_CONFIGURATION
        }

    if( $DesiredBranchUpdatePath -eq $null ) {
        $Message += "No UpdatePath defined in the XML defaulting the UpdatePath to the SourcePath $DesiredBranchSourcePath`n"
        $DesiredBranchUpdatePath = $DesiredBranchSourcePath
        }

    $Message += "Channel Desired: <$($DesiredBranch)>`n"
    $Message += "Channel Desired Version: <$($DesiredVersion)>`n"
    $Message += "Channel Source Path: <$($DesiredBranchSourcePath)>`n"
    $Message += "Channel Update Path: <$($DesiredBranchUpdatePath)>`n"
    $Message += "Channel OnHold Group: <$($BranchOnHoldGroup)>`n"
    $Message += "Channel OnHold Version: <$($BranchOnHoldVersion)>`n"
            
    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        $CurrentBranch = ""
            
        if( $DesiredConfig.Configuration.BranchInformation.baseURL -ne $null ) {
            foreach( $branch in $DesiredConfig.Configuration.BranchInformation.baseURL ) {
                if( $CurrentCtrConfig.CDNBaseUrl -eq $branch.url ) {
                    $CurrentBranch = $branch.branch
                    }
                }
            }

        $Message += "Current Channel is <$CurrentBranch> Desired Channel is <$DesiredBranch>`n"
        if( $CurrentBranch -ne $DesiredBranch ) {
            $Message += "Warning, Channel has changed`n"
            $ThisScriptExecuteSetup = $true
            }
        else {
            $Message += "No change in Channel`n"
            }
        }

    Write-Event -Information -Message $Message -EventId 26
    $Message = ""

    # Version Change?
    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        $CurrentVersion = $CurrentCtrConfig.Version
        }
        
    # Is this machine in the OnHold exception group for the channel
    $IsComputerOnHold = $false
    if( $BranchOnHoldGroup -ne $null ) {
        $Message += "Branch OnHold group is defined, checking if the computer is a member of $($BranchOnHoldGroup)`n"
        if( (IsInGroup $DomainController $ComputerSamAccountName $BranchOnHoldGroup) ) {
            $Message += "Warning, Computer is a member of the OnHold group, will attempt to install version $($BranchOnHoldVersion)`n"
            $DesiredVersion = $BranchOnHoldVersion
            $IsComputerOnHold = $true
            }
        else {
            $Message += "Computer is not part of the OnHold group, continuing normally`n"
            }
        }
    
    if( $DesiredVersion -eq $null ) {
        $Message += "Desired version latest on server, checking server`n"
        
        # Find version in the CAB file
        $DefaultCABFilename = "v$($DesiredBitness).cab"   # e.g. v32.cab or v64.cab
        
        $DefaultCABPath = Join-Path -Path $DesiredBranchSourcePath -ChildPath "Office\Data\$($DefaultCABFilename)"
        
        $Message += "Looking for CAB file $($DefaultCABPath)`n"
        if( (Test-Path -Path $DefaultCABPath) ) {
            $Message += "CAB file found, extracting VersionDescriptor.xml to destination $($VersionDescriptorFullPath)`n"
            $VersionDescriptorFullPath = (Join-Path -Path $env:TEMP -ChildPath "VersionDescriptor.xml")

            $ExpandOutput = (C:\Windows\System32\Expand.exe $DefaultCABPath -f:VersionDescriptor.xml $env:TEMP | Out-String -Width 300)
            if( Test-Path -Path $VersionDescriptorFullPath ) {
                $Message += "Reading XML from: $($VersionDescriptorFullPath)`n"
                [xml]$cab = Get-Content -Path $VersionDescriptorFullPath
                }
            else {
                $Message += "ERROR, File not found: $($VersionDescriptorFullPath)`n"
                $Message += ($ExpandOutput + "`n")
                Write-Event -Error -Message "$($Message)FATAL`tCould not find VersionDescriptor.xml file: $VersionDescriptorFullPath, quitting" -EventId 26
                return 2 # ERROR_FILE_NOT_FOUND
                }
            
            $DesiredVersion = $cab.Version.Available.Build
            if( $DesiredVersion -eq $null ) {
                $Message += "CAB reports no version or XML file is invalid`n"
                }
            else {
                $Message += "CAB reports Version $($DesiredVersion)`n"
                }
            }
        else {
            $Message += "ERROR, CAB file was not found`n"
            Write-Event -Error -Message "$($Message)FATAL`tCould not find default CAB file: $DefaultCABPath, quitting" -EventId 27
            return 2 # ERROR_FILE_NOT_FOUND
            }
        }
    else {
        $Message += "Desired version from XML: <$DesiredVersion>`n"
        $DefaultCABFilename = "v$($DesiredBitness)_$($DesiredVersion).cab"    # e.g. v32_16.0.6741.2063.cab

        $DefaultCABPath = Join-Path -Path $DesiredBranchSourcePath -ChildPath "Office\Data\$($DefaultCABFilename)"
        if( -not (Test-Path -Path $DefaultCABPath) ) {
            Write-Event -Error -Message "$($Message)FATAL`tCould not find version CAB file: $DefaultCABPath, quitting" -EventId 28
            return 2 # ERROR_FILE_NOT_FOUND
            }
        }
    
    if( $CurrentCtrConfig.ClickToRunInstalled ) {
        if( $DesiredVersionFromXml -eq $null ) {
            $Message += "Current Version is <$CurrentVersion> Server Version <$DesiredVersion>`n"
            if( $IsComputerOnHold ) {
                if( $CurrentVersion -ne $DesiredVersion ) {
                    $Message += "Computer is a member of OnHold and versions are different, forcing setup"
                    $ThisScriptExecuteSetup = $true
                    }
                else {
                    $Message += "Computer is a member of OnHold group and at the correct version"
                    }
                }
            else {
                $Message += "Update will occur via update process, not this installation process, unless product option changes are shown below`n"
                }
            }
        else {
            $Message += "Current Version is <$CurrentVersion> Desired Version <$DesiredVersion>`n"

            if( $CurrentVersion -ne $DesiredVersion ) {
                $Message += "Warning, Version has changed`n"
                $ThisScriptExecuteSetup = $true
                }
            else {
                $Message += "No change in version`n"
                }
            }
        }

    Write-Event -Information -Message $Message -EventId 29
    $Message = ""

    # Products
    $Message += "`tChecking for desired products`n"
    $DesiredProducts = @($DesiredConfig.Configuration.Install.ProductID)

    if( $DesiredConfig.Configuration.Install.ProductID -ne $null ) {
        $DesiredProducts = @($DesiredConfig.Configuration.Install.ProductID)
        $Message += "Desired Product: $($DesiredConfig.Configuration.Install.ProductID)`n"
        }

    if( $DesiredConfig.Configuration.OptionalProducts.ProductID -ne $null ) {
        foreach($Product in $DesiredConfig.Configuration.OptionalProducts.ProductID) {
            if( (IsInGroup $DomainController $ComputerSamAccountName $Product.IncludeGroup) ) {
                $Message += "Desired Product: $($Product.Name) because computer is a member of $($Product.IncludeGroup)`n"
                $DesiredProducts += @($Product.Name)
                }
            }
        }
          
    Write-Event -Information -Message $Message -EventId 30 
    $Message = ""

    # Product Adds/Removes?
    $Message += "Checking differences for Products`n"
    $DifferenceFound = $false
    $ProductsToRemove = @()
    
    foreach( $Product in $CurrentCtrConfig.ProductReleaseIds ) {
        if( -not ($DesiredProducts -contains $Product) ) {
            $Message += "WARN`tRemove $Product from computer`n"
            $ThisScriptExecuteSetup = $true
            $DifferenceFound = $true

            $ProductsToRemove += @($Product)
            }
        }
        
    foreach( $Product in $DesiredProducts ) {
        if( -not ($CurrentCtrConfig.ProductReleaseIds -contains $Product) ) {
            $Message += "INFO`tAdd $Product to computer`n"
            $ThisScriptExecuteSetup = $true
            $DifferenceFound = $true
            }
        }

    if( $DifferenceFound ) {
        $Message += "WARN`tDifferences have been found`n"
        }
    else {
        $Message += "INFO`tNo differences have been found`n"
        }

    # Build list of Excluded Office Apps
    $InstallOneDrive = $true
    $Message += "Checking for desired Excluded Office Apps`n"
    $DesiredOfficeAppsExcluded = @()
    
    if( $DesiredConfig.Configuration.Install.ExcludeApps.ProductID -ne $null ) {
        foreach($Product in $DesiredConfig.Configuration.Install.ExcludeApps.ProductID) {
            if( $Product.Name -eq "onedrive" ) { $InstallOneDrive = $false }

            if( $Product.IncludeGroup -eq $null -and $Product.ExcludeGroup -eq $null ) {
                # Exclude for everyone $($Product.Name)
                $Message += "WARN`tExcluding App $($Product.Name) from all computers because no Include or Exclude group is defined`n"
                $DesiredOfficeAppsExcluded += @($Product.Name)
                }
            elseif( $Product.ExcludeGroup -ne $null ) {
                # If the computer is specfically excluded from this App
                if( (IsInGroup $DomainController $ComputerSamAccountName $Product.ExcludeGroup) ) {
                    $Message += "WARN`tExcluding App $($Product.Name) because computer is a member of $($Product.ExcludeGroup)`n"
                    $DesiredOfficeAppsExcluded += @($Product.Name)
                    }                
                }
            else { # ( $Product.IncludeGroup -eq $null ) 
                # If the computer is specfically included for this App
                if(-not (IsInGroup $DomainController $ComputerSamAccountName $Product.IncludeGroup) ) {
                    $Message += "WARN`tExcluding App $($Product.Name) because computer is NOT a member of $($Product.IncludeGroup)`n"
                    $DesiredOfficeAppsExcluded += @($Product.Name)
                    }
                else {
                    if( $Product.Name -eq "onedrive" ) { $InstallOneDrive = $true }
                    }
                }
            }
        }

    Write-Event -Information -Message $Message -EventId 31
    $Message = ""

    # Office Apps Add/Removes?
    $Message += "Checking differences for Excluded Office Apps`n"
    $DifferenceFound = $false

    foreach( $App in $CurrentCtrConfig.AppsExcluded ) {
        if( -not ($DesiredOfficeAppsExcluded -contains $App) ) {
            $Message += "INFO`tAdd $App to computer`n"
            $ThisScriptExecuteSetup = $true
            $DifferenceFound = $true
            }
        }
        
    foreach( $App in $DesiredOfficeAppsExcluded) {
        if( -not ($CurrentCtrConfig.AppsExcluded -contains $App) ) {
            $Message += "WARN`tRemove $App from computer`n" 
            $ThisScriptExecuteSetup = $true
            $DifferenceFound = $true
            }
        }

    if( $DifferenceFound ) {
        $Message += "WARN`tDifferences have been found`n"
        }
    else {
        $Message += "INFO`tNo differences have been found`n"
        }

    Write-Event -Information -Message $Message -EventId 32
    $Message = ""

    # XML Generation
    if( $ThisScriptExecuteSetup ) {
        Write-Event -Information -Message "Generating Setup.exe XML file $($O365XmlConfigFilename)" -EventId 33
        $Message += "WARN`tThe script has determined that setup should be run, generating setup.exe XML file`n"
        
        Add-Content -Path $O365XmlConfigFilename -Value "<Configuration>"

        $VersionString = ""
        if( $DesiredVersion -and $DesiredVersionFromXml ) {
            $VersionString = " Version=""$($DesiredVersion)"" "
            }

        if( $IsComputerOnHold ) {
            $VersionString = " Version=""$($DesiredVersion)"" ForceDowngrade=""TRUE"" "
            }

        Add-Content -Path $O365XmlConfigFilename -Value "    <Add SourcePath=""$($DesiredBranchSourcePath)"" DownloadPath=""$($DesiredBranchSourcePath)"" OfficeClientEdition=""$($DesiredBitness)"" Channel=""$($DesiredBranch)"" $VersionString >"
        foreach( $Product in $DesiredProducts ) {
            if( $product -eq $DesiredConfig.Configuration.Install.ProductID ) {
                Add-Content -Path $O365XmlConfigFilename -Value "        <Product ID=""$($Product)"">"
                Add-Content -Path $O365XmlConfigFilename -Value "            <Language ID=""en-us"" />"

                if( $DesiredOfficeAppsExcluded.Count -gt 0 ) {
                    foreach( $App in $DesiredOfficeAppsExcluded ) {
                        Add-Content -Path $O365XmlConfigFilename -Value "            <ExcludeApp ID=""$($App)"" />"
                        }
                    }
                    
                Add-Content -Path $O365XmlConfigFilename -Value "        </Product>"
                }
            else {
                Add-Content -Path $O365XmlConfigFilename -Value "        <Product ID=""$($Product)""><Language ID=""en-us"" /></Product>"
                }
            }

        Add-Content -Path $O365XmlConfigFilename -Value "    </Add>"
        
        if( $ProductsToRemove.Count -gt 0 ) {
            Add-Content -Path $O365XmlConfigFilename -Value "    <Remove>"
            foreach( $Product in $ProductsToRemove ) {
                Add-Content -Path $O365XmlConfigFilename -Value "        <Product ID=""$Product""><Language ID=""en-us"" /></Product>"
                }
            Add-Content -Path $O365XmlConfigFilename -Value "    </Remove>"
            }
            
        Add-Content -Path $O365XmlConfigFilename -Value "    <Updates Enabled=""TRUE"" UpdatePath=""$($DesiredBranchUpdatePath)"" /> "
        $DisplayLevel = "None"
        if( $DesiredConfig.Configuration.Install.DisplayLevel -ne $null ) {
            $DisplayLevel = $DesiredConfig.Configuration.Install.DisplayLevel
            }
            
        Add-Content -Path $O365XmlConfigFilename -Value "    <Display Level=""$DisplayLevel"" AcceptEULA=""TRUE"" /> "
        
        $LoggingLevel = "Standard"
        if( $DesiredConfig.Configuration.Install.Logging.Level -ne $null ) {
            $LoggingLevel = $DesiredConfig.Configuration.Install.Logging.Level
            }

        $LoggingPath = "%temp%"
        if( $DesiredConfig.Configuration.Install.Logging.Level -ne $null ) {
            $LoggingPath = $DesiredConfig.Configuration.Install.Logging.Path
            }

        Add-Content -Path $O365XmlConfigFilename -Value "    <Logging Level=""$LoggingLevel"" Path=""$LoggingPath"" /> "

        if( $DesiredConfig.Configuration.Properties.Property -ne $null ) {
            foreach( $Property in $DesiredConfig.Configuration.Properties.Property ) {
                if( $Property.EnableGroup -eq $null ) {
                    Add-Content -Path $O365XmlConfigFilename -Value "    <Property Name=""$($Property.Name)"" Value=""$($Property.Value)"" />"
                    }
                elseif( (IsInGroup $DomainController $ComputerSamAccountName $Property.EnableGroup)) {
                    Add-Content -Path $O365XmlConfigFilename -Value "    <Property Name=""$($Property.Name)"" Value=""$($Property.Value)"" />"
                    }
                }
            }
            
        Add-Content -Path $O365XmlConfigFilename -Value "</Configuration>"

        # Completed XML file generation
        $Message += "INFO`tCompleted XML Generation`n"
        }
    else {
        $Message += "INFO`tThe script has determined that setup should not be run`n"
        }
    }
        
Write-Event -Information -Message $Message -EventId 34
$Message = ""
$FinalMessage = ""

# To execute or not?
if( -not $ThisScriptExecuteSetup ) {
    Write-Event -Information -Message "INFO`tNo differences found, Setup.exe will not be executed`n" -EventId 35
    $FinalMessage = "No differences found in Office 365 configuration, Setup.exe was not executed"
    }
else {
    $Message += "Desired Config:`n" + (Get-Content -Path $O365XmlConfigFilename | Out-String -Width 300)
    $FinalMessage = "Office 365 configuration changed, Setup.exe was executed"

    if( Test-Path -Path $DesiredConfig.Configuration.Install.SetupPath ) {
        $Message += "Found setup.exe at $($DesiredConfig.Configuration.Install.SetupPath)`n"
        $Message += "Executing setup.exe with arguments <""/Configure $($O365XmlConfigFilename)"">`n"

        Write-Event -Information -Message "$($Message)Setup.exe will be run" -EventId 36
        $Message = ""
        #-NoNewWindow 
        $InstallOfficeResult = (Start-Process -FilePath $DesiredConfig.Configuration.Install.SetupPath -ArgumentList @("/Configure", $O365XmlConfigFilename) -Wait -WindowStyle hidden -PassThru )
        Write-Event -Information -Message "Setup exit status: ($($InstallOfficeResult.ExitCode))" -EventId 37

        if( $InstallOneDrive ) {
            Write-Event -Information -Message "Configuring Registry for OneDrive" -EventId 38

            #$InstallOneDriveResult = (Start-Process -FilePath "\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\OneDriveSetup.exe" -ArgumentList @("/Silent","/PerComputer") -Wait -WindowStyle hidden -PassThru )
            #Write-Event -Information -Message "OneDrive Setup exit status: ($($InstallOneDriveResult.ExitCode))" -EventId 39

            try {
                if( -not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\OneDriveSetup") ) {
                    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components" -Name "OneDriveSetup" | Out-Null
                    }

                New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\OneDriveSetup" -Name "Stubpath" -Value "${env:ProgramFiles(x86)}\Microsoft OneDrive\OneDriveSetup.exe” -PropertyType String -Force | Out-Null
                Write-Event -Information -Message "OneDrive Registry Setup Completed" -EventId 391
                }
            catch {
                Write-Event -Information -Message "OneDrive Registry Setup Failed" -EventId 391
                Write-Event -Error -Message $Error[0] -EventId 391
                }
            }
        else {
            Write-Event -Information -Message "Remove OneDrive" -EventId 40

            try {
                Get-Process -Name onedrive | Stop-Process -Force
                Write-Event -Information -Message "Killed all OneDrive processes" -EventId 41
                }
            catch {
                Write-Event -Information -Message "Error killing OneDrive processes" -EventId 43
                Write-Event -Error -Message $Error[0] -EventId 43
                }

            $InstallOneDriveResult = (Start-Process -FilePath "\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\OneDriveSetup.exe" -ArgumentList @("/Uninstall") -Wait -WindowStyle hidden -PassThru )

            try {
                Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\OneDriveSetup" | Out-Null
                }
            catch {
                }

            Write-Event -Information -Message "OneDrive uninstall exit status: ($($InstallOneDriveResult.ExitCode))" -EventId 44
            }

        }
    else {
        Write-Event -Error -EventId 98 -Message "$($Message)FATAL`tCan't find setup.exe: $($DesiredConfig.Configuration.Install.SetupPath)" 
        return 2     # ERROR_FILE_NOT_FOUND
        }
    }


# Proofing Tools
Write-Event -Information -Message "Installing Proofing Tools" -EventId 45

if( Test-Path -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{90160000-001F-0804-0000-0000000FF1CE}" -PathType Container) {
    Write-Event -Information -Message "Proofing Tools already installed" -EventId 49
    }
else {
    $InstallProofingResult = (Start-Process -FilePath "\\upstream.apc.grp\public\Software\Applications\Microsoft\Office365ProPlus\ProofingTools\proofingtools2016_zh-cn-x86.exe" -ArgumentList @("/quiet /norestart") -Wait -WindowStyle hidden -PassThru )
    Write-Event -Information -Message "Proofing Tools Setup exit status: ($($InstallProofingResult.ExitCode))" -EventId 46

    $FinalMessage += "`nProofing tools were installed"
    }


# Reboot or not
if( Test-PendingReboot ) {
    Write-Event -Information -Message "WARN`tReboot Required`n" -EventId 47
            
    if( @(Get-LoggedOnUsers | Where-Object { ($_.TypeId -eq 2) -or ($_.TypeId -eq 10) }).count -eq 0 ) {
        Write-Event -Information -Message "Reboot Required, rebooting" -EventId 48
        Restart-Computer -Force
        return (350) # ERROR_FAIL_NOACTION_REBOOT 
        }
    else {
        Write-Event -Information -Message "Reboot Required, please restart this computer" -EventId 911
        return (350) # ERROR_FAIL_NOACTION_REBOOT 
        }
    }
else {
    Write-Event -Information -Message ("Script Completed`n$($FinalMessage)") -EventId 99
    }

if( Test-Path -Path $O365XmlConfigFilename ) {
    #Remove-Item -Path $O365XmlConfigFilename
    }

return 0 # ERROR_SUCCESS

