####################################################################################################
#
# Unattend_DCPROMO.ps1
#
# v.01 The 26 November 2012 by K¨¦vin KISOKA - Personal Website : http://www.it-deployment.fr This link is external to TechNet Wiki. It will open in a new window. 
#  
# Usage : 
#          - Modules Work Only with Powershell 3.0 / .NET 4.0 is required
#     - Install silently ADDS Binaries
#          - Store DSRM Password in secure string in a text file for reusing like MSFT recommands
#          - Prompt Only for requireds PROMOTE parameters like sysvol/ntds/logs folder path  
#
#
#####################################################################################################

 

# Import ServerManager Module to install ADDS Binaries

Import-Module "Servermanager"

# Check If ADDS Binaries are already installed on the computer

$check = Get-WindowsFeature | ? {$_.Name -Like "AD-Domain-Services" -and $_.InstallState -eq "Installed"}

If ($check -eq "true") {write-host "******* Installation of Binaries is Ok, DC PROMOTE JOB Can now start *******" -ForegroundColor Yellow}

# Install Windows ADDS Binaries

ElseIf ($check -ne "true") {Add-WindowsFeature AD-Domain-Services -IncludeManagementTools}

# Confirm Binaries Installation is good

If ($_ -eq "Success") {write-host "******* Installation of Binaries is Ok, DC PROMOTE JOB Can now start *******" -ForegroundColor Yellow}

 
Elseif ($_ -ne "Success") {Add-WindowsFeature AD-Domain-Services -IncludeManagementTools}

# Input all parameters required to install Forest And Domain ADDS

$netbiosname = Read-Host 'What NETBIOSDOMAIN NAME you desire ? Limit length is 15 Characters'
$Domain = Read-Host 'What Full Qualified Domain Name you desire ?'
$NTDSPath = Read-host 'What NTDS.DIT Database Folder Path do you Desire ?'
$NTDSLogpath = Read-host 'What NTDS.DIT LogFolder Path do you Desire ?'
$SysvolPath = Read-host 'What SYSVOL Folder Path do you Desire ?'

# Store password Admin in a secure string

$file = "c:\pw.txt"
$pw = read-host -prompt "Password:" -assecurestring
$pw | ConvertFrom-SecureString | Set-Content $file

# Launch Promote Job
 
Install-ADDSForest -DomainName $Domain -DomainNetBIOSName $netbiosname -safemodeadministratorpassword (Get-Content $File | ConvertTo-SecureString) -SkipAutoConfigureDNS -SkipPreChecks -InstallDNS:$true -SYSVOLPath $SysvolPath -DatabasePath $NTDSPath -LogPath $NTDSLogpath -WhatIf

# Confirm Installation Completion and Debug Logs location

Write-Host "****** Installation In Progress ! You will find debug data of the installation process in %systemroot%\debug\dcpromo.log ******" -ForegroundColor Green -NoNewline