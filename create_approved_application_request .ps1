## Copyright © 2022, Consultanting Services (Microsoft Corporation). All rights reserved.
## Powered by MG
## :: ======================================================= ::
##
##
##	DESCRIPTION
##	  create_approved_application_request.ps1 is tool to create applicaton request in SCCM.
##    reference: https://docs.microsoft.com/en-us/mem/configmgr/develop/apps/application-approval-process
##
##	ARGUMENTS
##    Please see param section
##
##	RETURNS
##	  result1: Exit Code:: -1=Parameter error; 0=Succeed; 4209=WMI query exception; 8240=None of object acquired; 1170=String null or empty; 1627=WMI execution failed; 512=completed, but no execution result; other=completed with error return code
##	  result2: Exit Message
##	  result3: exception object or execution result object
##
##  SAMPLES
##    .\create_approved_application_request.ps1 -server 'patac-cm01.patac.com.cn' -client 'patac-clt02' -clientDomain 'patac.com.cn' -user 'PATAC\user3' -appid '7465321' -app 'Green Hills IDE-V800 v6.1.4'
##    .\create_approved_application_request.ps1 -server 'patac-cm01.patac.com.cn' -client 'patac-clt01' -clientDomain 'patac.com.cn' -user 'PATAC\user1' -appid '3765021' -app 'Photoshop CS6'
##    .\create_approved_application_request.ps1 -server 'patac-cm01.patac.com.cn' -client 'patac-clt01' -clientDomain 'patac.com.cn' -user 'PATAC\user1' -appid '3765022' -app 'Speos 2022R1'
##    .\create_approved_application_request.ps1 -server 'SISHN01066.sgm.shanghaigm.com' -client 'PPSDW00027' -clientDomain 'PATAC.SHANGHAIGM.COM' -user 'PATAC\s4irsb' -appid '3765021' -app 'Photoshop CS6'
## :: ======================================================= ::

param
(
    [Parameter(Mandatory=$true,
               HelpMessage="Please enter FQDN of SCCM Site Server. Sample: patac-cm01.patac.com.cn")]
    [Alias('server')]
    [String]$CMSiteServerFQDN,

    [Parameter(Mandatory=$true,
               HelpMessage="Please enter NetBIOSName of client machine that will deploy application. Sample: patac-clt02")]
    [Alias('client')]
    [String]$ClientMachineNetBIOSName,

    [Parameter(Mandatory=$true,
               HelpMessage="Please enter Domain FQDN of client machine that will deploy application. Sample: patac.com.cn")]
    [Alias('clientDomain')]
    [String]$ClientMachineDoaminFQDN,

    [Parameter(Mandatory=$true,
               HelpMessage="Please enter User name with Domain Short name. Sample: PATAC\user3")]
    [Alias('user')]
    [String]$UsernameWithDomain,

    [Parameter(Mandatory=$true,
               HelpMessage="Please enter ID of ITSR application that will deploy. Sample: 7465321")]
    [Alias('appid')]
    [String]$ITSRappid,

    [Parameter(Mandatory=$true,
               HelpMessage="Please enter Name of ITSR application that will deploy (just for recording). Sample: Green Hills IDE-V800 v6.1.4")]
    [Alias('app')]
    [String]$ApplicationName,

    [Parameter(Mandatory=$false,
               HelpMessage="Please enter Whether to install application automatically")]
    [bool]$AutoInstall = $false

)

<##
# SCCM Server FQDN
$CMSiteServerFQDN = 'patac-cm01.patac.com.cn'

$ClientMachineNetBIOSName = 'patac-clt02'
$ClientMachineDoaminFQDN = 'patac.com.cn'
$UsernameWithDomain = 'PATAC\user3'
#$ITSRappid = '123456789'
$ITSRappid = '7465321'
$ITSRappidRemark = "#ITSRappid:$($ITSRappid)#"
$ApplicationName = 'Green Hills IDE-V800 v6.1.4'
$AutoInstall = 'false'
#$AutoInstall = 'true'
##>

##==========Start check parameter==================
#check server parameter
$CMSiteServerFQDN = $CMSiteServerFQDN.Trim()
if([String]::IsNullOrEmpty($CMSiteServerFQDN))
{
    $ExitCode = -1
    $ExitMessage = 'The server parameter is empty.'
    return $ExitCode, $ExitMessage, $null
} elseif(($CMSiteServerFQDN.split('.').Length - 1) -lt 2) {
    $ExitCode = -1
    $ExitMessage = 'The server parameter format is incorrect.'
    return $ExitCode, $ExitMessage, $null
}

#check client parameter
$ClientMachineNetBIOSName = $ClientMachineNetBIOSName.Trim()
if([String]::IsNullOrEmpty($ClientMachineNetBIOSName))
{
    $ExitCode = -1
    $ExitMessage = 'The client parameter is empty.'
    return $ExitCode, $ExitMessage, $null
} elseif(($ClientMachineNetBIOSName.split('.').Length -1) -ne 0) {
    $ExitCode = -1
    $ExitMessage = 'The client parameter format is incorrect.'
    return $ExitCode, $ExitMessage, $null
}

#check clientDomain parameter
$ClientMachineDoaminFQDN = $ClientMachineDoaminFQDN.Trim()
if([String]::IsNullOrEmpty($ClientMachineDoaminFQDN))
{
    $ExitCode = -1
    $ExitMessage = 'The clientDomain parameter is empty.'
    return $ExitCode, $ExitMessage, $null
} elseif(($ClientMachineDoaminFQDN.split('.').Length - 1) -lt 1) {
    $ExitCode = -1
    $ExitMessage = 'The clientDomain parameter format is incorrect.'
    return $ExitCode, $ExitMessage, $null
}

#check user parameter
$UsernameWithDomain = $UsernameWithDomain.Trim()
if([String]::IsNullOrEmpty($UsernameWithDomain))
{
    $ExitCode = -1
    $ExitMessage = 'The user parameter is empty.'
    return $ExitCode, $ExitMessage, $null
} elseif($UsernameWithDomain.split('\').Length - 1 -ne 1) {
    $ExitCode = -1
    $ExitMessage = 'The user parameter format is incorrect.'
    return $ExitCode, $ExitMessage, $null
}

##==========End check parameter==================

$ITSRappidRemark = "#ITSRappid:$($ITSRappid)#"

if ($AutoInstall) {
    $StrAutoInstall = 'true'
} else {
    $StrAutoInstall = 'false'
}

$Comments = "Request Application id '$ITSRappid' name '$ApplicationName' for $UsernameWithDomain on $ClientMachineNetBIOSName.$ClientMachineDoaminFQDN"

#### Get CM Site Code
try {
    $scObj=Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace root\sms -Query 'select SiteCode from sms_providerlocation' -ErrorAction Stop
} catch {
    $ExitCode = 4209
    $ExitMessage = 'An exception occurred while getting WMI object of SCCM SiteCode. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $_
}

if (!$scObj) {
    $ExitCode = 8240
    $ExitMessage = 'None of SCCM WMI object was fetched. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $null
}

if ([string]::IsNullOrEmpty($scObj.SiteCode)) {
    $ExitCode = 1170
    $ExitMessage = 'Can not get SiteCode of SCCM. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $null
} else {
    $sitecode = $scObj.SiteCode
    $namespace ="root\sms\site_" + $sitecode
}


#### Get CM Application Id
try {
    #$CmApplication = Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace $namespace -Class SMS_Application | Where-Object -FilterScript {$_.IsLatest -eq $True -and $_.LocaliZedDisplayName -eq $ApplicationName}
    $CmApplication = Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace $namespace -Class SMS_Application -ErrorAction Stop | `
                                   Where-Object -FilterScript {$_.IsLatest -eq $True -and $_.LocalizedDescription -like "*$ITSRappidRemark*"}
} catch {
    $ExitCode = 4209
    $ExitMessage = 'An exception occurred while getting WMI object of SCCM Application. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $_
}

if ($CmApplication -eq $null)
{
    $ExitCode = 8240
    $ExitMessage = "No application with ITSR`'s id was found in SCCM. Please check application in SCCM."
    return $ExitCode, $ExitMessage, $null
} elseif ($CmApplication -is [array] -and $CmApplication.count -gt 1) {
    $ExitCode = 1152
    $ExitMessage = "More than one application with ITSR`'s id was found in SCCM. It is not possible to decide which application should be deployed. Please check application in SCCM."
    return $ExitCode, $ExitMessage, $null
}

if ([string]::IsNullOrEmpty($CmApplication.ModelName)) {
    $ExitCode = 1170
    $ExitMessage = 'Can not get ModelName of SCCM application. Please check application in SCCM.'
    return $ExitCode, $ExitMessage, $null
} else {
    $CmApplicationId = $CmApplication.ModelName
}

#### Get Client Computer GUID in CM
try {
    #$machine = Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace $namespace -Query "SELECT * FROM SMS_R_SYSTEM WHERE NetbiosName = '$ClientMachineNetBIOSName'  ResourceNames = '$ClientMachineNetBIOSName'" -ErrorAction Stop
    $machine = Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace $namespace -Class SMS_R_SYSTEM -ErrorAction Stop | `
                             Where-Object -FilterScript {$_.NetbiosName -eq $ClientMachineNetBIOSName -and $_.FullDomainName -eq $ClientMachineDoaminFQDN}
} catch {
    $ExitCode = 4209
    $ExitMessage = 'An exception occurred while getting WMI object of SCCM Computer. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $_
}

if ($machine -eq $null)
{
    $ExitCode = 8240
    $ExitMessage = "No computer was found in SCCM. Please check computer in SCCM."
    return $ExitCode, $ExitMessage, $null
} elseif ($machine -is [array] -and $machine.count -gt 1) {
    $ExitCode = 1152
    $ExitMessage = "More than one computer was found in SCCM. It is not possible to decide which computer should be deployed. Please check computer in SCCM."
    return $ExitCode, $ExitMessage, $null
}

if ([string]::IsNullOrEmpty($machine.SMSUniqueIdentifier)) {
    $ExitCode = 1170
    $ExitMessage = 'Can not get SMSUniqueIdentifier of SCCM computer. Please check computer in SCCM.'
    return $ExitCode, $ExitMessage, $null
} else {
    $ClientGuid = $machine.SMSUniqueIdentifier
}

#### Check user account in CM
try {
    $user = Get-WmiObject -ComputerName $CMSiteServerFQDN -Namespace $namespace -Class SMS_R_USER -ErrorAction Stop | `
                             Where-Object -FilterScript {$_.UniqueUserName -eq $UsernameWithDomain}
} catch {
    $ExitCode = 4209
    $ExitMessage = 'An exception occurred while getting WMI object of SCCM user. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $_
}

if ($user -eq $null)
{
    $ExitCode = 8240
    $ExitMessage = "No user was found in SCCM. Please check user in SCCM."
    return $ExitCode, $ExitMessage, $null
} elseif ($user -is [array] -and $user.count -gt 1) {
    $ExitCode = 1152
    $ExitMessage = "More than one user was found in SCCM. It is not possible to decide which user should be deployed. Please check computer in SCCM."
    return $ExitCode, $ExitMessage, $null
}

#### Create Approved Applcation Request
try {
    $ObjResult = Invoke-WmiMethod -ComputerName $CMSiteServerFQDN -Path "SMS_UserApplicationRequest" -Namespace $namespace -Name CreateApprovedRequest `
                                  -ArgumentList @($CmApplicationId, $StrAutoInstall, $ClientGuid, $Comments, $UsernameWithDomain) -ErrorAction Stop
} catch {
    $ExitCode = 1627
    $ExitMessage = 'An exception occurred while creating application request in SCCM via WMI. Please contact Administrator.'
    return $ExitCode, $ExitMessage, $_
}

#### check execution result
if($ObjResult -eq $null) {
    $ExitCode = 512
    $ExitMessage = "Process completed, but no execution result was found. Please check it out."
    return $ExitCode, $ExitMessage, $null
} elseif ($ObjResult.ReturnValue -eq 0) {
    $ExitMessage = 'Succeed to create application request'
    return $ObjResult.ReturnValue, $ExitMessage, $ObjResult
} else {
    $ExitMessage = "Process completed with error return code `'$($ObjResult.ReturnValue)`'. Please check it out."
    return $ObjResult.ReturnValue, $ExitMessage, $ObjResult
}