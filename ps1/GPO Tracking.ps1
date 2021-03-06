#Start-Transcript -Path ([System.IO.Path]::GetTempFileName()) -Append

Function Get-OfficeVersion {
<#
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
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true, Position=0)]
    [string[]]$ComputerName = ".", #$env:COMPUTERNAME,
    [switch]$ShowAllInstalledProducts,
    [System.Management.Automation.PSCredential]$Credentials
)

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

    $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet("DefaultDisplayPropertySet",[string[]]$defaultDisplaySet)
    $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
}

process {

 $results = new-object PSObject[] 0;

 foreach ($computer in $ComputerName) {
 <##--
    if ($Credentials) {
       $os=Get-WMIObject win32_operatingsystem -Credential $Credentials #-computername $computer 
    } else {
       $os=Get-WMIObject win32_operatingsystem #-computername $computer
    }
##>
    $os=Get-WMIObject win32_operatingsystem
    
    $osArchitecture = $os.OSArchitecture
<##
    if ($Credentials) {
       $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default -computername $computer -Credential $Credentials
    } else {
       $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default -computername $computer
    }
##>
    $regProv = Get-Wmiobject -list "StdRegProv" -namespace root\default 

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
                try {
                  if ($officeInstallPath -match $installReg) { $officeProduct = $true }
                } catch { }
             }
           }

           if (!$officeProduct) { continue };
           
           $name = $regProv.GetStringValue($HKLM, $path, "DisplayName").sValue          

           if ($ConfigItemList.Contains($key.ToUpper()) -and $name.ToUpper().Contains("MICROSOFT OFFICE")) {
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
           $InstallDate  = $regProv.GetStringValue($HKLM, $path, "InstallDate").sValue
           
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
                     ClientCulture=$clientCulture;RegKey=$key;InstallDate=$InstallDate }
           $object | Add-Member MemberSet PSStandardMembers $PSStandardMembers
           $results += $object

        }
    }

  }

  $results = Get-Unique -InputObject $results 

  return $results;
}

}

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
    $Object | add-member Noteproperty ClickToRunInstalled $false

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

        $configurationPath = join-path $officeKeyPath "Configuration"

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
        } else {
            $platform = "64"
        }

        $CDNBaseUrl = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration -Name CDNBaseUrl -ErrorAction SilentlyContinue).CDNBaseUrl
        if (!($CDNBaseUrl)) {
           $CDNBaseUrl = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Office\15.0\ClickToRun\Configuration -Name CDNBaseUrl -ErrorAction SilentlyContinue).CDNBaseUrl
        }
        
        $Object | add-member Noteproperty Platform $platform
        $Object | add-member Noteproperty ClientCulture $clientCulture
        $Object | add-member Noteproperty ProductReleaseIds $productIds
        $Object | add-member Noteproperty Version $versionToReport
        $Object | add-member Noteproperty UpdatesEnabled $updatesEnabled
        $Object | add-member Noteproperty UpdateUrl $updateUrl
        $Object | add-member Noteproperty UpdateDeadline $updateDeadline
        $Object | add-member Noteproperty OfficeKeyPath $officeKeyPath
        $Object | add-member Noteproperty AppsExcluded $AppsExcluded
        $Object | add-member Noteproperty CDNBaseUrl $CDNBaseUrl
        
    } 

    return $Object 

}

function Execute-SQLCommand( $SqlText ) {
    $SqlServer = "chgva4-440.upstream.apc.grp"
    $SqlDatabase = "TrackingDB"
    
    Write-Host "Execute Query" $sqltext
    $Connection = New-Object System.Data.SQLClient.SQLConnection
    $Connection.ConnectionString = "server='$SqlServer';database='$SqlDatabase';trusted_connection=true;"
    $Connection.Open()
    $Command = New-Object System.Data.SQLClient.SQLCommand
    $Command.Connection = $Connection
    $Command.CommandText = $SqlText

    $Result = $Command.ExecuteReader()
    if( $Result.Read() ) {
        $ReturnValue = $Result.GetValue(0)    
        }
    $Connection.Close()
    
    return $ReturnValue            
    }

# Gather information

$ComputerName = $env:COMPUTERNAME
$Win32_BIOS = (Get-WmiObject -Class Win32_BIOS -ComputerName . | Select-Object -Property [a-z]*)
$Win32_Processor = (Get-WmiObject -Class Win32_Processor -ComputerName . | Select-Object -Property [a-z]*)
$Win32_ComputerSystem = (Get-WmiObject -Class Win32_ComputerSystem -ComputerName . | Select-Object -Property [a-z]*)
$Win32_ComputerSystemProduct = (Get-WmiObject -Class Win32_ComputerSystemProduct -ComputerName . | Select-Object -Property [a-z]*)
$Win32_OperatingSystem = (Get-WmiObject -Class Win32_OperatingSystem -ComputerName . -Property BuildNumber,SerialNumber,Version,OSArchitecture,Caption,CSDVersion,CSName,CurrentTimeZone,Description,InstallDate,OperatingSystemSKU,OSLanguage,ProductType | Select-Object -Property [a-z]*)
$Win32_LogicalDisk = (Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" -ComputerName . -Property DeviceID,DriveType,FreeSpace,Size,VolumeName,VolumeSerialNumber,Caption,Description,Name)

try {
    $ADSiteName = [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Name
    }
catch {
    $ADSiteName = "N/A"
    }

$OSInstallDate = [System.Management.ManagementDateTimeConverter]::ToDateTime($Win32_OperatingSystem.InstallDate).ToString("yyyy-MM-dd HH:mm:ss")
$GPOHistoryDCName = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name DCName).DCName.Replace('\\','')
$ComputerModel = $Win32_ComputerSystemProduct.Name
if($Win32_ComputerSystemProduct.Vendor -like "*LENOVO*") {
    $ComputerModel = $Win32_ComputerSystemProduct.Version
    }

[int]$capacity = $Win32_ComputerSystem.TotalPhysicalMemory / 1GB
$IP = Test-Connection -ComputerName $env:COMPUTERNAME -TimeToLive 2 -Count 1
$IPAddress = $IP.IPV4Address.ToString()

$ComputerID = Execute-SQLCommand "exec UpdateInventory @ComputerName = '$($ENV:ComputerName)',
                @Manufacturer='$($Win32_ComputerSystem.Manufacturer)',
                @HardwareModel='$ComputerModel',
                @BIOSVersion='$($Win32_BIOS.Version)',
                @HardwareSerialNumber= '$($Win32_BIOS.SerialNumber)',
                @OSArchitecture='$($Win32_OperatingSystem.OSArchitecture)',
                @OperatingSystemSKU=$($Win32_OperatingSystem.OperatingSystemSKU),
                @OperatingSystem='$($Win32_OperatingSystem.Caption)',
                @ServicePack='$($Win32_OperatingSystem.CSDVersion)',
                @OSVersion='$($Win32_OperatingSystem.Version)',
                @OSInstallDate='$OSInstallDate',
                @ADSiteName='$ADSiteName',
                @GPOHistoryDCName='$GPOHistoryDCName',
                @PhysicalMemoryGB=$capacity,
                @IPAddress='$IPAddress',
                @ProductType=$($Win32_OperatingSystem.ProductType)"

$ComputerID = Execute-SQLCommand "exec ClearInstalledOfficeProducts @ComputerName = '$($ENV:ComputerName)'"

    
$InstalledOfficeVersions = (Get-OfficeVersion -ShowAllInstalledProducts $true)

$OfficeInstalled = $false
        
foreach( $OfficeVersion in $InstalledOfficeVersions ) {
    if( $OfficeVersion.ClickToRun -eq "true" ) {
        # Click to run version
        $OfficeCtr = getCTRConfig

        $bitness = "32"
        if( $OfficeVersion.Bitness -ne "32-Bit" ) {
            $bitness = "64"
            }

        $UpdatesEnabled = 0
        if( $OfficeCtr.UpdatesEnabled ) {
            $UpdatesEnabled = 1
            }
        
        foreach( $o365ProductId in $OfficeCtr.ProductReleaseIds.Split(",") ) {
            switch ($o365ProductId) { 
                "O365ProPlusRetail" {$DisplayName = 'Microsoft Office 365 ProPlus'} 
                "O365BusinessRetail" {$DisplayName = 'Microsoft Office 365 Business'} 
                "ProjectProXVolume"    {$DisplayName = 'Microsoft Project Professional 2016'} 
                "ProjectProRetail"     {$DisplayName = 'Microsoft Project Professional 2016'} 
                "ProjectStdXVolume"    {$DisplayName = 'Microsoft Project Standard 2016'} 
                "ProjectStdRetail"     {$DisplayName = 'Microsoft Project Standard 2016'} 
                "VisioProXVolume"    {$DisplayName = 'Microsoft Visio Professional 2016'} 
                "VisioProRetail"     {$DisplayName = 'Microsoft Visio Professional 2016'} 
                "VisioStdXVolume"    {$DisplayName = 'Microsoft Visio Standard 2016'} 
                "VisioStdRetail"     {$DisplayName = 'Microsoft Visio Standard 2016'} 
                "SPDRetail"   {$DisplayName = 'Microsoft SharePoint Designer 2013'} 
                "grooveRetail"   {
                                    if( $($OfficeCtr.Version).StartsWith("15") ) {$DisplayName = 'Microsoft OneDrive for Business 2013'} else {$DisplayName = 'Microsoft OneDrive for Business 2016'}
                                    }

                default {$DisplayName = "Unknown O365 ProductID $o365ProductId <$($OfficeCtr.DisplayName)>"}
                }

            $OfficeInstalled = $true
            
            $ComputerID = Execute-SQLCommand "exec AddOfficeProduct @ComputerName = '$($ENV:ComputerName)', 
                            	@ProductID = '$o365ProductId',
                            	@Bitness = $($OfficeCtr.Platform),
                            	@DisplayName = '$DisplayName',
                            	@Version = '$($OfficeCtr.Version)',
                            	@CtrVersion = 1,
                            	@CtrClientCulture = '$($OfficeCtr.ClientCulture)',
                            	@CtrUpdateUrl = '$($OfficeCtr.UpdateUrl)',
                            	@CtrUpdatesEnabled = $UpdatesEnabled,
                            	@CtrProductReleaseIds = '$($OfficeCtr.ProductReleaseIds)',
                            	@CtrAppsExcluded = '$($OfficeCtr.AppsExcluded)',
                            	@CtrCDNBaseUrl = '$($OfficeCtr.CDNBaseUrl)'"
    
            }
            
        }
    elseif( $OfficeVersion.DisplayName -like "*Microsoft*" ) {
        # Standard Office MSI version
        
        $bitness = "32"
        if( $OfficeVersion.Bitness -ne "32-Bit" ) {
            $bitness = "64"
            }

        # Only look at RegKeys that are GUIDs
        if( $OfficeVersion.Regkey -match("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$") ) {
        
            $OfficeInstalled = $True
        
            $GuidParts = $OfficeVersion.Regkey.TrimStart('{').TrimEnd('}').Split('-')

            $ProductID = $GuidParts[1]
            
            $InstallDate = "NULL"
            if( $OfficeVersion.InstallDate.Length -eq 8 ) {
                $InstallDate = "'" + $OfficeVersion.InstallDate.Substring(0,4) + "/" +  $OfficeVersion.InstallDate.Substring(4,2) + "/" + $OfficeVersion.InstallDate.Substring(6,2) + "'"
                $InstallDate = "'" + $OfficeVersion.InstallDate + "'"
                }
                $ComputerID = Execute-SQLCommand "exec AddOfficeProduct @ComputerName = '$($ENV:ComputerName)',
                                	@ProductID = '$ProductID',
                                    @InstallPath = '$($OfficeVersion.InstallPath)',
                                	@Bitness = $bitness,
                                	@DisplayName = '$($OfficeVersion.DisplayName)',
                                	@Version = '$($OfficeVersion.Version)',
                                    @Publisher = 'Microsoft',
                                    @InstallDate = $InstallDate "
                }
            elseif( $GuidParts[4] -eq "0050048383C9" ) { # Office XP
                }
            elseif( $GuidParts[4] -eq "00C04F990354" ) { # Office XP Visio
                }
            }
        }

if( -not $OfficeInstalled ) {
    $ComputerID = Execute-SQLCommand "exec AddOfficeProduct @ComputerName = '$($ENV:ComputerName)',
                                	@ProductID = 'NO_OFFICE',
                                	@DisplayName = 'Workstation without Office' "
    }    

$ComputerID = Execute-SQLCommand "exec ClearLogicalDisks @ComputerName = '$($ENV:ComputerName)'"
    
foreach( $logicalDisk in $Win32_LogicalDisk ) {
    [int]$FreeSpaceMB = $logicalDisk.FreeSpace / 1MB
    [int]$SizeMB = $logicalDisk.Size / 1MB
    
    $ComputerID = Execute-SQLCommand "exec UpdateLogicalDisk @ComputerName = '$($ENV:ComputerName)', 
                        @DriveLetter = '$($logicalDisk.DeviceID)',
                        @VolumeLabel = '$($logicalDisk.VolumeName)',
                        @VolumeSizeMB = $SizeMB, 
                        @FreeSpaceMB = $FreeSpaceMB,
                        @VolumeSerialNumber = '$($logicalDisk.VolumeSerialNumber)' "
    }

$ComputerID = Execute-SQLCommand "exec ClearServices @ComputerName = '$($ENV:ComputerName)'"

foreach( $service in (Get-WmiObject -Class WIN32_Service) ) {
    $ComputerID = Execute-SQLCommand "exec UpdateService @ComputerName = '$($ENV:ComputerName)', 
                        @ServiceName = '$($service.Name)',
                        @DisplayName = '$($service.DisplayName)',
                        @ServiceAccount = '$($service.StartName)', 
                        @StartMode = '$($service.StartMode)' "
    }
    

$FiltertaskAccounts = @("SYSTEM","LocalSystem","NETWORK SERVICE","LOCAL SERVICE","Users","Authenticated Users","INTERACTIVE","Administrators","Everyone","Utilisateurs")
    
$TaskList = (ConvertFrom-Csv -InputObject (schtasks /query /FO CSV /V | Out-String)) | Where-Object { ($_.Hostname -ne 'HostName') }

foreach( $task in $TaskList ) {
    $TaskName = $task.TaskName
    $p = 'Run As User'
    $RunAsUser = $task.$p
    $p = "Scheduled Task State"
    $ScheduledTaskState = $task.$p
    
    if( ($TaskName.Length -ne 0) -and ($RunAsUser.Length -ne 0) -and ($ScheduledTaskState.Length -ne 0) ) {
        $ComputerID = Execute-SQLCommand "exec UpdateTask @ComputerName = '$($ENV:ComputerName)', 
                            @TaskName = '$($TaskName)',
                            @DisplayName = '$($TaskName)',
                            @ServiceAccount = '$($RunAsUser)', 
                            @StartMode = '$($ScheduledTaskState)' "
        }
    }


try {
    $Result = (Start-Process -FilePath "cmd.exe" -ArgumentList @("/C netsh winhttp reset proxy") -Wait -WindowStyle hidden -PassThru )
    Write-Host "exit status: ($($Result.ExitCode))"
    
    $ComputerID = Execute-SQLCommand "exec ProxyResetPreformed @ComputerName = '$($ENV:ComputerName)'"
    }
catch {}

