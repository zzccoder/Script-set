#################################################################################
# Microsoft Windows Server 2012 and 2016 audit script                           #
# Copyright (c) PricewaterhouseCoopers 2019                                     #
#                                                                               #
# Operational instructions to the client:                                       #
#                                                                               #
# a) Scrutinize the contents of the script to ensure that it does not contain   #
#    any statements, commands or any other code that might negatively influence #
#    the client's environment(s) in either a security or operational way.       #
#                                                                               #
# b) Test the script on the test environment to ensure that it does not contain #
#    any statements, commands or any other code that might negatively influence #
#    the client's environment(s) in either a security or operational way.       #
#                                                                               #
# c) It is advised to execute the script during off-peak hours.                 #
#                                                                               #
# d) The client must remove all copies of the script as it is the property of   #
#    PricewaterhouseCoopers. The client may retain the script results.          #
#                                                                               #
# e) Do not email the script results to PricewaterhouseCoopers. Upon completion #
#    of the execution of the script, please notify us and we will have          #
#    representative come and collect it.                                        #
#                                                                               #
# f) The final responsibility for executing this script lies with the client.   #
#################################################################################

# default command line parameters
param (
    [string]$ExecutionMode = "normal",      # 'normal' performs the following actions. 'failsafe' bypasses them.
                                            #     - SID->SAM name redundant lookup error removal in getPrincipalName()
    [string]$Encoding = "UTF8"              # CSV output file encoding
)

function doErrorLog() {
	if ($Error.count -ne 0) {
		$num = 1
		foreach ($e in $error) {
			"Error ${num}:"																		| Out-File -Append $oError
			"========="																			| Out-File -Append $oError
			$e																					| Out-File -Append $oError
			Out-File -Append $oError
			$num++
		}
	}
}

function getPrincipalName([string]$SIDstr) {
    $mysid = New-Object System.Security.Principal.SecurityIdentifier($SIDstr)
    try {
        $rv = $mysid.Translate([System.Security.Principal.NTAccount])
    } catch {
        $rv = $SIDstr
    }
    # Remove error item if SAM account could not be located (cannot avoid the error in Powershell)
    if ($ExecutionMode -ne "failsafe") {
        if ($error.Count -ne 0) {
            for ($i=0; $i -le $error.Count; $i++) {
                if ($error[$i].invocationinfo -ne $null) {
                    if ($error[$i].invocationinfo.line.contains("Translate([System.Security.Principal.NTAccount])")) {
                        $error.Remove($error[$i])
                        break
                    }
                }
            }
        }
    }
    return $rv
}

function isAdmin() {
    $ut = [Security.Principal.WindowsIdentity]::GetCurrent()
    $u = New-Object Security.Principal.WindowsPrincipal $ut
    if ($u.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $true) {
        return "Yes"
    }
    return "No"
}

function doSystemInfo() {
# Startup information
	"PwC Windows Server 2012 and 2016 audit script version: $scriptVersion"						| Out-File -Append $oLog
	"Script execution started: " + (Get-Date -format "yyyy-MM-dd HH:mm:ss")						| Out-File -Append $oLog
	"Script run as user: $env:UserName (domain: $env:UserDomain)"								| Out-File -Append $oLog
	"Timezone offset: " + $w32cs.CurrentTimeZone/60												| Out-File -Append $oLog

# Extract machine info before performing script compatibility check
	"Win32_OperatingSystem:"																	| Out-File -Append $oSystemInfo
	"======================"																	| Out-File -Append $oSystemInfo
	$w32os | Format-List -Property *															| Out-File -Append $oSystemInfo
	""																							| Out-File -Append $oSystemInfo
	"Win32_ComputerSystem:"																		| Out-File -Append $oSystemInfo
	"====================="																		| Out-File -Append $oSystemInfo
	$w32cs | Format-List -Property *															| Out-File -Append $oSystemInfo
	""																							| Out-File -Append $oSystemInfo
	"Active network adaptors:"																	| Out-File -Append $oSystemInfo
	"========================"																	| Out-File -Append $oSystemInfo
	Get-WmiObject -Class "Win32_networkadapterconfiguration" | where {$_.ipaddress -ne $null}	| Out-File -Append $oSystemInfo

    "Powershell version:"																		| Out-File -Append $oSystemInfo
	"==================="																		| Out-File -Append $oSystemInfo
    $PSVersionTable   																			| Out-File -Append $oSystemInfo

# Script compatibility with Windows version
	$version = [double]($w32os.version.split(".")[0] + "." + $w32os.version.split(".")[1])
	"Windows version (name): " + $w32os.Caption													| Out-File -Append $oLog
	"Windows version (value): " + $w32os.Version												| Out-File -Append $oLog
	"Windows version (calculated): " + $version													| Out-File -Append $oLog
	If ($version -lt $minimumVersion) {
		"WARNING: Script incompatible with this Windows Server version"							| Out-File -Append $oLog
		write-host
        write-host "Windows version detected:" $w32os.Version
		write-host "Windows name detected:" $w32os.Caption
		write-host "WARNING! This script requires Windows Server 2012 (version 6.2) or newer.`r`n"
		write-host "Are you sure you want to continue?"
        $choice = Read-Host -Prompt "Press <Enter> to continue, or <Ctrl-C> to abort"
        write-host
	}

# Running as admin
	$asAdmin = isAdmin
	"Running as admin: " + $asAdmin             												| Out-File -Append $oLog
	If ($asAdmin -ne "Yes") {
		"WARNING: Powershell is not running with administrator rights"							| Out-File -Append $oLog
		write-host
		write-host "WARNING: Powershell is not running with administrator rights"
		write-host "Are you sure you want to continue?"
        $choice = Read-Host -Prompt "Press <Enter> to continue, or <Ctrl-C> to abort"
        write-host
	}

# Server role
	$domainRoleMap = @{0 = "Standalone Workstation"; 
                       1 = "Member Workstation";
                       2 = "Standalone Server"; 
                       3 = "Member Server"; 
                       4 = "Backup Domain Controller"; 
	                   5 = "Primary Domain Controller"}
	If ($w32cs.DomainRole -eq 0 -or $w32cs.DomainRole -eq 2) {
		"Domain Role (text): Server not on a domain"											| Out-File -Append $oLog
	} Else {
		"Domain Role (text): " + $domainRoleMap[[int]$w32cs.DomainRole]							| Out-File -Append $oLog
	}
}

function doPatches() {
	Get-HotFix | select HotFixID, @{Name="InstalledOn"; `
              Expression={[DateTime]::Parse($_.psbase.properties["installedon"].value, `
                          $([System.Globalization.CultureInfo]::GetCultureInfo("en-US"))).ToString("yyyy-MM-dd HH:mm")}}, `
			            InstalledBy, CSName, Name, FixComments, Description, ServicePackInEffect, Status, Caption `
	| Where {$_.HotFixID -ne "File 1"} `
    | Sort-Object -descending "InstalledOn" `
    | Select -first 500 `
	| Export-Csv -NoTypeInformation -encoding $Encoding $oPatches
	"${oPatches}: " + (Get-HotFix | Where {$_.HotFixID -ne "File 1"}).count                     | Out-File -Append $oCount # completeness
}

function doJEA() {
	"<BEGIN COMMAND: `$env:path>"																| Out-File -Append $oJEA
	$env:path.split(";")																		| Out-File -Append $oJEA
	"<END COMMAND: `$env:path>`r`n"																| Out-File -Append $oJEA

	"<BEGIN COMMAND: Get-PSSessionConfiguration>"												| Out-File -Append $oJEA
	Get-PSSessionConfiguration																	| Out-File -Append $oJEA
	"<END COMMAND: Get-PSSessionConfiguration>`r`n"												| Out-File -Append $oJEA

	"<BEGIN COMMAND: (Get-PSSessionConfiguration).ConfigFilePath>"								| Out-File -Append $oJEA
	(Get-PSSessionConfiguration).ConfigFilePath													| Out-File -Append $oJEA
	"<END COMMAND: (Get-PSSessionConfiguration).ConfigFilePath>`r`n"							| Out-File -Append $oJEA

	# Get the files identified above (.pssc)
    $numPSSC = 0
	if ((Get-PSSessionConfiguration).ConfigFilePath.count -eq 0) {
		"<BEGIN PSSC FILE: no session configuration files found.>"								| Out-File -Append $oJEA
		"<END PSSC FILE: no session configuration files found.>`r`n"							| Out-File -Append $oJEA
	} else {
		$A = foreach ($f in (Get-PSSessionConfiguration).ConfigFilePath) {
            $numPSSC++
			"<BEGIN PSSC FILE: $f>"																| Out-File -Append $oJEA
			foreach ($r in Get-Content $f) {
				$r																				| Out-File -Append $oJEA
			}
			"<END PSSC FILE: $f>`r`n"															| Out-File -Append $oJEA
		}
	}
	"${oJEA} (pssc): " + $numPSSC                                                               | Out-File -Append $oCount # completeness

	# Locate and extract role capabilities files (.psrc)
	$A = foreach ($i in $env:path.split(";")) {
		Get-ChildItem -Path $i -Filter *.psrc -Recurse -ErrorAction SilentlyContinue -Force
	}
    if ($A -eq $null) {
        $B = $null
    } else {
    	$B = $A.fullname.tolower() | sort | get-unique | sls rolecapabilities
    }
	if ($B.count -eq 0) {
		"<BEGIN PSRC FILE: no role capabilities files found.>"									| Out-File -Append $oJEA
		"<END PSRC FILE: no role capabilities files found.>"									| Out-File -Append $oJEA
	} else {
		foreach ($f in $B) {
			"<BEGIN PSRC FILE: $f>"																| Out-File -Append $oJEA
			foreach ($r in Get-Content $f) {
				$r																				| Out-File -Append $oJEA
			}
			"<END PSRC FILE: $f>`r`n"															| Out-File -Append $oJEA
		}
	}
	"${oJEA} (psrc): " + $B.count                                                               | Out-File -Append $oCount # completeness
}

function doReg() {
	$regkeys = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon",
		   "HKLM:\Software\Policies\Microsoft\Windows\Installer",
		   "HKCU:\Software\Policies\Microsoft\Windows\Installer",
		   "HKLM:\System\CurrentControlSet\services",
           "HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" # Script block logging (JEA events to event log for central collection)
    $regPermCount = 0
    $svcPermCount = 0
    $regValCount  = 0
	foreach ($k in $regkeys) {
		if (Test-Path $k) {							# if registry key exists, get value and permissions
			# Values
            $regValCount++
			Get-Item "$k"																		| Out-File -Append $oRegValues
			# Permissions
            $thisACL = (get-acl $k).Access
            $regPermCount += $thisACL.count
			$thisACL | select @{Name="Key"; Expression={$k}}, `
				              @{Name="Owner"; Expression={(Get-Acl $k).Owner}}, `
				              @{Name="Group"; Expression={(Get-Acl $k).Group}}, `
				              RegistryRights, AccessControlType, IdentityReference, `
                              IsInherited, InheritanceFlags, PropagationFlags `
			         | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oRegPerms
		}
	}

# Enumerate "services" key, as sensitive ImagePath parameter appears in sub-keys.
	$svcpath = "HKLM:\System\CurrentControlSet\services"					  # sub-keys for services
	if (Test-Path $svcpath) {								                  # if registry key exists
		$services = Get-ChildItem $svcpath | select PSChildName
		foreach ($k in $services) {
			$tmp = $svcpath + "\" + $k.PSChildName
            $prop = Get-ItemProperty $tmp
			if ($prop.ImagePath -and $prop.Start -and ($prop.ObjectName -contains "LocalSystem") -and ($prop.Start -ne 4)) {
	            $regValCount++
                Get-Item "$tmp" | Out-File -Append $oRegValues			      # Values
				$imgpaths.Add($(Get-ItemProperty $tmp).ImagePath) | out-null  # ImagePaths to inspect file permissions
												# Permissions
                $thisACL = (get-acl $tmp).Access
                $regPermCount += $thisACL.count
				$thisACL | select @{Name="Key"; Expression={$tmp}}, `
							      @{Name="Owner"; Expression={(Get-Acl $tmp).Owner}}, `
							      @{Name="Group"; Expression={(Get-Acl $tmp).Group}}, `
					              RegistryRights, AccessControlType, IdentityReference, `
							      IsInherited, InheritanceFlags, PropagationFlags `
						 | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oRegPerms
			}
		}
	}

# Get services' ImagePath ACLs
	foreach ($f in $imgpaths) {
		if (Test-Path $f) {							                          # if file exists, get permissions


# new code
            $thisACL = get-acl $f
            $thisPerms = ($thisACL.AccessToString -replace "268435456",   "FullControl" `
							                      -replace "-1610612736", "ReadAndExecute, Synchronize" `
							                      -replace "-536805376",  "Write, ReadAndExecute, Synchronize" `
                                                  -split '[\r\n]') | where {$_}
            $svcPermCount += $thisPerms.count
            foreach ($p in $thisPerms) {
			    $thisACL | select @{Name="PSPath"; Expression={$_.PSPath -replace "Microsoft.PowerShell.Core\\FileSystem::", ""}}, `
					                   Owner, Group, `
					                   @{Name="AccessToString"; Expression={$p}}, `
                			           CentralAccessPolicyName, AuditToString `
				         | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oSvcFilePerms
            }

# old code
#            $svcPermCount++
#            Get-Acl $f | select @{Name="PSPath"; Expression={$_.PSPath -replace "Microsoft.PowerShell.Core\\FileSystem::", ""}}, `
#					            Owner, Group, AccessToString, CentralAccessPolicyName, AuditToString `
#				   | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oSvcFilePerms

		}
	}
	"${oRegPerms}: "     + $regPermCount                                                        | Out-File -Append $oCount # completeness
	"${oRegValues}: "    + $regValCount                                                         | Out-File -Append $oCount # completeness
	"${oSvcFilePerms}: " + $svcPermCount                                                        | Out-File -Append $oCount # completeness
}

function doADInfo() {
	$d = [ADSI]"LDAP://RootDSE"
	"Name: " + (Get-ADDomain).Name																| Out-File -Append $oInfoAD
	"NetBiosName: " + (Get-ADDomain).NetBIOSName												| Out-File -Append $oInfoAD
	"DistinguishedName: " + (Get-ADDomain).DistinguishedName									| Out-File -Append $oInfoAD
	"DNSRoot: " + (Get-ADDomain).DNSRoot														| Out-File -Append $oInfoAD
	"Domain Functional Level (name): " + (Get-ADDomain).DomainMode								| Out-File -Append $oInfoAD
	"Domain Functional Level (value): " + $d.domainFunctionality 								| Out-File -Append $oInfoAD
	""																							| Out-File -Append $oInfoAD
	"ChildDomains: " + (Get-ADDomain).ChildDomains												| Out-File -Append $oInfoAD
	"Forest Functional Level (name): " + (Get-ADForest).ForestMode								| Out-File -Append $oInfoAD
	"Forest Functional Level (value): " + $d.forestFunctionality								| Out-File -Append $oInfoAD
	""																							| Out-File -Append $oInfoAD
	"LastLogonReplicationInterval: " + (Get-ADDomain).LastLogonReplicationInterval				| Out-File -Append $oInfoAD
	""																							| Out-File -Append $oInfoAD
	"AD Forest information:"																	| Out-File -Append $oInfoAD
	"========================="																	| Out-File -Append $oInfoAD
    (Get-ADForest) | select * 																	| Out-File -Append $oInfoAD
	""																							| Out-File -Append $oInfoAD
	"AD Domain information:"																	| Out-File -Append $oInfoAD
	"========================="																	| Out-File -Append $oInfoAD
    (Get-ADDomain) | select * 																	| Out-File -Append $oInfoAD
	""																							| Out-File -Append $oInfoAD
	"AD Forest DC information:"																	| Out-File -Append $oInfoAD
	"========================="																	| Out-File -Append $oInfoAD
    foreach ($d in (Get-ADForest).Domains) {
        Get-ADDomainController -Filter * -Server $d												| Out-File -Append $oInfoAD
    }

    # Inventory of DCs, per domain, for the forest
    $dcCount = 0
    $forest = Get-ADForest
    foreach ($d in $forest.Domains) {
        foreach ($dc in (Get-ADDomainController -Filter * -Server $d)) {
            $dcCount++
            $dc | select @{Name="ForestName";       Expression={$forest.name}}, `
                         @{Name="DomainName";       Expression={$d}}, `
                         @{Name="DomainController"; Expression={$_.hostname}}, `
                         Enabled, IsGlobalCatalog, IsReadOnly `
                | export-csv -NoTypeInformation -encoding $Encoding -Append $oForestDCsAD
        }
    }
	"${oForestDCsAD}: " + $dcCount                                                              | Out-File -Append $oCount # completeness
}

function doADGPOs() {
	# get list of GPOs, and statuses
	$allGPO = Get-GPO -All | select DomainName, DisplayName, GpoStatus, Description, `
		                  @{Name="CreationTime";     Expression={$_.CreationTime.ToString("yyyy-MM-dd HH:mm")}}, `
		                  @{Name="ModificationTime"; Expression={$_.ModificationTime.ToString("yyyy-MM-dd HH:mm")}}, `
		                  Owner, WmiFilter, Id, Path
    $allGPO | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oGPO
	"${oGPO}: " + $allGPO.count                                                                 | Out-File -Append $oCount # completeness

    # get GPO links
    $gpoLinkCount = 0
    $gptarget = @()
    $gptarget += Get-ADObject -Identity (Get-ADDomain).distinguishedName `
                              -Properties Name, DistinguishedName, gpLink, gpOptions                        # domain root
    $gptarget += Get-ADOrganizationalUnit -Filter * -Properties Name, DistinguishedName, gpLink, gpOptions  # OUs
    $gptarget += Get-ADObject -LDAPFilter '(objectClass=site)' `
                              -SearchBase "CN=Sites,$((Get-ADRootDSE).configurationNamingContext)" `
                              -SearchScope OneLevel `
                              -Properties Name, DistinguishedName, gpLink, gpOptions                        # sites
    foreach ($g in $gptarget) {
        if ($g.gpLink -eq $null -or $g.gpLink.trim() -eq "") {                                              # no links exist
            $gpoLinkCount++
            $g | select Name, DistinguishedName, ObjectClass, `
                        @{Name="LinkedGPOName";    Expression={"No GPO links"}}, `
                        @{Name="LinkedGPOguid";    Expression={"No GPO links"}}, `
                        @{Name="LinkedGPOStatus";  Expression={"No GPO links"}}, `
                        @{Name="LinkEnabled";      Expression={"No GPO links"}}, `
                        @{Name="LinkOrder";        Expression={"No GPO links"}}, `
                        @{Name="LinkEnforced";     Expression={"No GPO links"}}, `
                        @{Name="BlockInheritance"; Expression={if (($g.gpOptions -bAnd 1) -eq 1) {"Yes"} else {"No"}}}, `
                        @{Name="StreetAddress";    Expression={$_.streetaddress -join ";"}}, `
                        @{Name="City";             Expression={$_.city -join ";"}}, `
                        @{Name="State";            Expression={$_.state -join ";"}}, `
                        @{Name="Country";          Expression={$_.country -join ";"}} `
               | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oGPOlinks
        } else {                                                                                            # links exist
            $gplinks   = $g.gpLink.split("][") -replace "ldap://cn={","" | where {$_}
            # output example: 24BC02D4-8AFE-45BC-94AF-A938D8B10875},cn=policies,cn=system,DC=corp,DC=dystopia,DC=com;0
            $linkOrder = $gplinks.count
            foreach ($gpl in $gplinks) {
                $flags = [int]($gpl.split(";")[1].trim())
                $guid  = $gpl.split("}")[0].trim()
                $gpo   = Get-GPO -id $guid
                $gpoLinkCount++
                $g | select Name, DistinguishedName, ObjectClass, `
                            @{Name="LinkedGPOName";    Expression={$gpo.DisplayName}}, `
                            @{Name="LinkedGPOguid";    Expression={$guid}}, `
                            @{Name="LinkedGPOStatus";  Expression={$gpo.gpoStatus}}, `
                            @{Name="LinkEnabled";      Expression={if (($flags -bAnd 1) -eq 0) {"Yes"} else {"No"}}}, `
                            @{Name="LinkOrder";        Expression={$linkOrder}}, `
                            @{Name="LinkEnforced";     Expression={if (($flags -bAnd 2) -eq 2) {"Yes"} else {"No"}}}, `
                            @{Name="BlockInheritance"; Expression={if (($g.gpOptions -bAnd 1) -eq 1) {"Yes"} else {"No"}}}, `
                            @{Name="StreetAddress";    Expression={$_.streetaddress -join ";"}}, `
                            @{Name="City";             Expression={$_.city -join ";"}}, `
                            @{Name="State";            Expression={$_.state -join ";"}}, `
                            @{Name="Country";          Expression={$_.country -join ";"}} `
                   | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oGPOlinks
                $linkOrder--
            }
        }
    }
 	"${oGPOlinks}: " + $gpoLinkCount                                                                   | Out-File -Append $oCount # completeness

	# get GPO definitions (HTML, XML)
	New-Item -Path "$outdir\GPO" -ItemType directory | out-null
	foreach ($g in (Get-GPO -All)) {
        $dn2 = $g.displayName | foreach {$_ -replace "[:\\/""?<>|]", ""}                                    # avoid characters unsupported by filenames
#        $dn2 = $g.displayName.replace(":", "")                                                              # avoid GPO-with-colon error
		$d = $outpath + "\GPO\$($dn2)_$($g.id).html"
		Get-GPOReport -GUID $g.id -ReportType HTML -Path "$d"		                                        # html format
		$d = $outpath + "\GPO\$($dn2)_$($g.id).xml"
		Get-GPOReport -GUID $g.id -ReportType XML -Path "$d"		                                        # xml format
	}
}

function doADFineGrainedPwdPolicies() {
	# Get-ADFineGrainedPasswordPolicy -Filter {name -like "*"} | Export-Csv -NoTypeInformation -Append $oFGPP
	$fgpp = Get-ADFineGrainedPasswordPolicy -Filter {name -like "*"}
    $fgppCount = 0
	foreach ($f in $fgpp) {
		if ($f.AppliesTo.count -eq 0) {
            $fgppCount++
			$f	| select Name, Precedence, @{Name="AppliesTo"; Expression={"<no users>"}}, ComplexityEnabled, LockoutDuration, `
						 LockoutObservationWindow, LockoutThreshold, MaxPasswordAge, MinPasswordAge, MinPasswordLength, `
						 PasswordHistoryCount, ReversibleEncryptionEnabled, DistinguishedName, ObjectClass, ObjectGUID `
				| Export-Csv -NoTypeInformation -encoding $Encoding -Append $oFGPP
		} else {
			foreach ($u in $f.AppliesTo) {
                $fgppCount++
				$f	| select Name, Precedence, @{Name="AppliesTo"; Expression={$u}}, ComplexityEnabled, LockoutDuration, `
						     LockoutObservationWindow, LockoutThreshold, MaxPasswordAge, MinPasswordAge, MinPasswordLength, `
						     PasswordHistoryCount, ReversibleEncryptionEnabled, DistinguishedName, ObjectClass, ObjectGUID `
					| Export-Csv -NoTypeInformation -encoding $Encoding -Append $oFGPP
			}
		}
	}
 	"${oFGPP}: " + $fgppCount                                                                         | Out-File -Append $oCount # completeness
}

function doADUsers() {
# primary identity fields
	$users = Get-ADUser -Filter * -Properties UserPrincipalName, Name, GivenName, Initials, Surname, DisplayName, Description, `
                    Division, Enabled, LockedOut, AccountExpirationDate, AccountLockoutTime, lastLogonTimestamp, `
                    PasswordNeverExpires, AllowReversiblePasswordEncryption, CannotChangePassword, PasswordExpired, PasswordNotRequired, `
                    PasswordLastSet, DistinguishedName, SamAccountName, SID, SmartcardLogonRequired, createTimeStamp, modifyTimeStamp, `
                    "msds-principalname" `
		| select @{Name="UserPrincipalName (Login name)"; Expression={$_.UserPrincipalName}}, `
			     @{Name="msDS-PrincipalName (Login name pre-Win2k)"; Expression={$_.("msDS-PrincipalName")}}, `
			     Name, GivenName, Initials, Surname, DisplayName, Description, Division, `

# login related fields
	@{Name="PwC_Active"; Expression={if ($_.Enabled -eq $false -or $_.LockedOut -eq $true -or `
		($_.AccountExpirationDate -ne $null -and (Get-Date) -gt $_.AccountExpirationDate)) {"Inactive"} else {"Active"}}}, `
	Enabled, AccountExpirationDate, LockedOut, `
	@{Name="AccountLockoutTime"; Expression={if ($_.AccountLockoutTime -ne $null) {$_.AccountLockoutTime.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
	@{Name="PwC_ScriptExecDate"; Expression={(Get-Date).toString("yyyy-MM-dd HH:mm")}}, `

# lastlogon: inactive / dormant active users
	@{Name="lastLogonTimestamp"; Expression={if ($_.lastLogonTimestamp -ne $null) { `
		([DateTime]::FromFileTime($_.lastLogonTimestamp)).toString("yyyy-MM-dd HH:mm")} else {"Never logged in"}}}, `
	@{Name="PwC_DormancyDays"; Expression={if ($_.lastLogonTimestamp -ne $null) { `
		((Get-Date) - [DateTime]::FromFileTime($_.lastLogonTimestamp)).days} else {"Never logged in"}}}, `

# password fields
	PasswordNeverExpires, AllowReversiblePasswordEncryption, CannotChangePassword, PasswordExpired, PasswordNotRequired, `
	@{Name="PasswordLastSet"; Expression={if ($_.PasswordLastSet -ne $null) {$_.PasswordLastSet.ToString("yyyy-MM-dd HH:mm")} else {"Never changed"}}}, `
	@{Name="PwC_PasswordAge"; Expression={if ($_.PasswordLastSet -ne $null) {((Get-Date) - $_.PasswordLastSet).days} else {"Never changed"}}}, `

# secondary identity fields
    DistinguishedName, SamAccountName, SID, `

# other fields
	SmartcardLogonRequired, `
	@{Name="createTimeStamp"; Expression={if ($_.createTimeStamp -ne $null) {$_.createTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
	@{Name="modifyTimeStamp"; Expression={if ($_.modifyTimeStamp -ne $null) {$_.modifyTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}

    $users | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oUsersAD
 	"${oUsersAD}: " + $users.count                                                                   | Out-File -Append $oCount # completeness
}

function doADMSA() {
    $msa = Get-ADServiceAccount -filter * -properties *, "msds-principalname"
    $groups = Get-ADGroup -filter *
    $msaCount = 0
    foreach ($a in $msa) {
        if ($a.memberof.count -eq 0) {
            $msaCount++
    	    $a  | select Name, msds-principalname, Description, DisplayName, DistinguishedName, `
	                    @{Name="createTimeStamp"; Expression={if ($_.createTimeStamp -ne $null) {$_.createTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
	                    @{Name="modifyTimeStamp"; Expression={if ($_.modifyTimeStamp -ne $null) {$_.modifyTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
                        @{Name="Group"; Expression={"No group memberships"}}, `
                        @{Name="GroupDN"; Expression={"No group memberships"}} `
        	    | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oMSAUsersAD
        } else {
            foreach ($m in $a.memberof) {
                $msaCount++
        	    $a  | select Name, msds-principalname, Description, DisplayName, DistinguishedName, `
	                    @{Name="createTimeStamp"; Expression={if ($_.createTimeStamp -ne $null) {$_.createTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
	                    @{Name="modifyTimeStamp"; Expression={if ($_.modifyTimeStamp -ne $null) {$_.modifyTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
                        @{Name="Group"; Expression={($groups | where {$_.DistinguishedName -eq $m}).Name}}, `
                        @{Name="GroupDN"; Expression={($groups | where {$_.DistinguishedName -eq $m}).DistinguishedName}} `
        	        | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oMSAUsersAD
            }
        }
    }
 	"${oMSAUsersAD}: " + $msaCount                                                                        | Out-File -Append $oCount # completeness
}

function doADGroups() {
	$adGroups = Get-ADGroup -filter * -properties * `
        | select Name, DisplayName, Description, GroupCategory, GroupScope, DistinguishedName, SamAccountName, SID, `
        	    @{Name="createTimeStamp"; Expression={if ($_.createTimeStamp -ne $null) {$_.createTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}}, `
                @{Name="modifyTimeStamp"; Expression={if ($_.modifyTimeStamp -ne $null) {$_.modifyTimeStamp.ToString("yyyy-MM-dd HH:mm")} else {""}}} 
    $adGroups  | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oGroupsAD
 	"${oGroupsAD}: " + $adGroups.count                                                                    | Out-File -Append $oCount # completeness
}

function doADUserGroupMemberships() {
	$result = @()
    $memberCount = 0
	foreach ($g in (Get-ADGroup -filter *)) {						                             # iterate through all groups
        $grpmembers = dsget.exe group "$g" -members -expand | where {$_}
        if ($grpmembers -ne $null) {
            $grpmembers = $grpmembers -replace """", ""
    		foreach ($i2 in $grpmembers) {		                                                 # get effective (hierarchy expanded) group memberships
                $i = $i2.replace("'", "''")                                                      # avoid dn-containing-apostrophe error
                $thatuser = Get-ADUser -Filter "DistinguishedName -eq '$i'" -Properties *, "msds-principalname" `
						    | select distinguishedName, UserPrincipalName, msDS-PrincipalName, Name, GivenName, Initials, Surname, DisplayName, `
                   				     SamAccountName, SID, Description, MemberOf, PrimaryGroup, `
								    @{Name="PwC_Active"; Expression={if ($_.Enabled -eq $false -or $_.LockedOut -eq $true -or `
								    ($_.AccountExpirationDate -ne $null -and (Get-Date) -gt $_.AccountExpirationDate)) {"Inactive"} else {"Active"}}}, `
								    @{Name="PwC_DormancyDays"; Expression={if ($_.lastLogonTimestamp -ne $null) { `
								    ((Get-Date) - [DateTime]::FromFileTime($_.lastLogonTimestamp)).days} else {"Never logged in"}}}
                foreach ($u in $thatuser) {$u.MemberOf += $u.PrimaryGroup}                       # Add primary group to MemberOf
			    $item = "" | select @{Name="UserPrincipalName (Login name)"; Expression={$thatuser.UserPrincipalName}}, `
				        @{Name="msDS-PrincipalName (Login name pre-Win2k)"; Expression={$thatuser.("msDS-PrincipalName")}}, `
				        @{Name="PwC_Active";       Expression={$thatuser.PwC_Active}}, `
				        @{Name="PwC_DormancyDays"; Expression={$thatuser.PwC_DormancyDays}}, `
				        @{Name="Name";             Expression={$thatuser.Name}}, `
				        @{Name="GivenName";        Expression={$thatuser.GivenName}}, `
				        @{Name="Initials";         Expression={$thatuser.Initials}}, `
				        @{Name="Surname";          Expression={$thatuser.Surname}}, `
				        @{Name="DisplayName";      Expression={$thatuser.DisplayName}}, `
				        @{Name="Description";      Expression={$thatuser.Description}}, `
				        @{Name="UserDN";           Expression={$thatuser.DistinguishedName}}, `
				        @{Name="SamAccountName";   Expression={$thatuser.SamAccountName}}, `
				        @{Name="SID";              Expression={$thatuser.SID}}, `
				        @{Name="Group";            Expression={$g.Name}}, `
				        @{Name="GroupDN";          Expression={$g.DistinguishedName}}, `
				        @{Name="GroupInheritance"; Expression={if ($g.DistinguishedName -in ($thatuser.MemberOf)) {"Direct"} else {"Inherited"}}} `
                   | where {$_.UserDN -ne $null} 
                if ($item -ne $null) { $memberCount++ }
                $item | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oUGMembersAD
		    }
        }
	}
 	"${oUGMembersAD}: " + $memberCount                                                                   | Out-File -Append $oCount # completeness
}

function doADGroupGroupMemberships() {
    $groups = Get-ADGroup -filter * -properties Name, DisplayName, Description, DistinguishedName, MemberOf
    $groupCount = 0
	$result = @()
	foreach ($g in $groups) {
    	foreach ($m in $g.MemberOf) {
            $groupCount++
            $result += $g | select Name, DisplayName, Description, DistinguishedName, @{Name="MemberOf"; Expression={$m}}
       	}
    }
	$result | sort-object "Name" `
            | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oGGMembersAD
 	"${oGGMembersAD}: " + $groupCount                                                                    | Out-File -Append $oCount # completeness
}

function doADOUDelegations() {
    $OUs =  Get-ADOrganizationalUnit -filter * -properties *
    $delegationCount = 0
    foreach ($ou in $OUs) {
        $ntsd = $ou.ntsecuritydescriptor.access
        foreach ($s in $ntsd) {
            $delegationCount++
            $s | select @{Name="OUname"; Expression={$ou.name}}, `
                        @{Name="OUdistinguishedName"; Expression={$ou.distinguishedname}}, `
                        @{Name="OUdescription"; Expression={$ou.description}}, `
                        identityreference, AccessControlType, InheritanceType, activeDirectoryRights, isInhereted `
               | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oOUdelegations
        }
    }
 	"${oOUdelegations}: " + $delegationCount                                                             | Out-File -Append $oCount # completeness
}

function doADTrusts() {
# Inventory of trusts, per domain, for the forest
    $forest = Get-ADForest
    $trustCount = 0
    foreach ($d in $forest.Domains) {
        foreach ($t in (Get-ADTrust -Filter * -Properties * -Server $d)) {
            $trustCount++
            $t | select @{Name="ForestName"; Expression={$forest.name}}, `
                        @{Name="DomainName"; Expression={$d}}, `
                        @{Name="TrustName";  Expression={$_.Name}}, `
                        DistinguishedName, Source, Target, Direction, DisallowTransivity, ForestTransitive, `
                        IntraForest, IsTreeParent, IsTreeRoot, TrustType, TrustAttributes `
               | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oTrustAD
        }
    }
 	"${oTrustAD}: " + $trustCount                                                                        | Out-File -Append $oCount # completeness
}

function doLGPO() {
    SecEdit.exe /export /cfg "$outdir\Local_LGPO.txt" /quiet

# User rights assignment
    $privs = @{SeAssignPrimaryTokenPrivilege             = ""; `
               SeAuditPrivilege                          = ""; `
               SeBackupPrivilege                         = ""; `
               SeBatchLogonRight                         = "Log on as a batch job"; `
               SeChangeNotifyPrivilege                   = ""; `
               SeCreateGlobalPrivilege                   = "Create global objects"; `
               SeCreatePagefilePrivilege                 = ""; `
               SeCreatePermanentPrivilege                = ""; `
               SeCreateSymbolicLinkPrivilege             = ""; `
               SeCreateTokenPrivilege                    = "Create a token object"; `
               SeDebugPrivilege                          = "Debug programs"; `
               SeDelegateSessionUserImpersonatePrivilege = ""; `
               SeDenyBatchLogonRight                     = "Deny log on as a batch job"; `
               SeDenyInteractiveLogonRight               = "Deny log on locally"; `
               SeDenyNetworkLogonRight                   = "Deny access this computer from the network"; `
               SeDenyRemoteInteractiveLogonRight         = "Deny log on through Remote Desktop Services"; `
               SeDenyServiceLogonRight                   = "Deny log on as a service"; `
               SeEnableDelegationPrivilege               = ""; `
               SeImpersonatePrivilege                    = ""; `
               SeIncreaseBasePriorityPrivilege           = ""; `
               SeIncreaseQuotaPrivilege                  = ""; `
               SeIncreaseWorkingSetPrivilege             = ""; `
               SeInteractiveLogonRight                   = "Log on locally"; `
               SeLoadDriverPrivilege                     = "Load and unload device drivers"; `
               SeLockMemoryPrivilege                     = ""; `
               SeMachineAccountPrivilege                 = ""; `
               SeManageVolumePrivilege                   = ""; `
               SeNetworkLogonRight                       = "Access this computer from the network"; `
               SeProfileSingleProcessPrivilege           = ""; `
               SeRelabelPrivilege                        = ""; `
               SeRemoteInteractiveLogonRight             = "Log on through Remote Desktop Services"; `
               SeRemoteShutdownPrivilege                 = ""; `
               SeRestorePrivilege                        = "Restore files and directories"; `
               SeSecurityPrivilege                       = "Manage auditing and security log"; `
               SeServiceLogonRight                       = "Log on as a service"; `
               SeShutdownPrivilege                       = ""; `
               SeSyncAgentPrivilege                      = ""; `
               SeSystemEnvironmentPrivilege              = ""; `
               SeSystemProfilePrivilege                  = ""; `
               SeSystemtimePrivilege                     = ""; `
               SeTakeOwnershipPrivilege                  = "Take ownership of files or other objects"; `
               SeTcbPrivilege                            = "Act as part of the operating system"; `
               SeTimeZonePrivilege                       = ""; `
               SeTrustedCredManAccessPrivilege           = ""; `
               SeUndockPrivilege                         = ""
              }
    $privCount = 0
    foreach ($p in $privs.Keys) {
        $val = ([string](cat "$outdir\Local_LGPO.txt" | Select-String $p))
        if ($val -ne $null) {
            $val = $val.split("=")[1].Trim()
            $val = $val.split(",")
            foreach ($v in $val) {        # look up human-readable name for the SIDs
                $privCount++
                if ($v.startswith("*")) {
                    New-Object -Type PSObject -Property @{"RightName"=$p; "RightDescription"=$privs.$p; "Username"=(getPrincipalName($v.substring(1))); "SID"=$v.substring(1)} `
                            | Select RightName, RightDescription, Username, SID `
                            | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oUserRights
                } else {
                    New-Object -Type PSObject -Property @{"RightName"=$p; "RightDescription"=$privs.$p; "Username"=$v; "SID"=""} `
                            | Select RightName, RightDescription, Username, SID `
                            | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oUserRights
                }
            }
        }
    }
 	"${oUserRights}: " + $privCount                                                                    | Out-File -Append $oCount # completeness

# Security options
    # key: last part of registry key; value: list of human readable name, then default value if undefined
    $secCount = 0
    $opts = @{ `
        "Policies\System\InactivityTimeoutSecs="          = @("Interactive logon: Machine inactivity limit",                                   "0"); `
        "Policies\System\LegalNoticeText="                = @("Interactive logon: Message text for users attempting to log on",                ""); `
        "Policies\System\LegalNoticeCaption="             = @("Interactive logon: Message title for users attempting to log on",               ""); `
        "Control\Lsa\RestrictAnonymousSAM="               = @("Network access: Do not allow anonymous enumeration of SAM accounts",            "1"); `
        "Control\Lsa\RestrictAnonymous="                  = @("Network access: Do not allow anonymous enumeration of SAM accounts and shares", "0"); `
        "Control\Lsa\EveryoneIncludesAnonymous="          = @("Network access: Let Everyone permissions apply to anonymous users",             "0"); `
        "Control\Lsa\SCENoApplyLegacyAuditPolicy="        = @("Audit: Force audit policy subcategory settings to override audit policy category settings", "1"); `
        "LanManServer\Parameters\RestrictNullSessAccess=" = @("Network access: Restrict anonymous access to Named Pipes and Shares",           "0"); `
        "LanManServer\Parameters\NullSessionShares="      = @("Network access: Shares that can be accessed anonymously",                       "")
       }
    foreach ($p in $opts.Keys) {
        $secCount++
        $val = ([string](cat "$outdir\Local_LGPO.txt" | Select-String $p.replace("\","\\")))
        if ($val -ne $null) {                                                                  # defined
            New-Object -Type PSObject -Property @{"Tag"=$p; "OptionName"=$opts.$p[0]; "Defined"="Yes"; "Value"=$val.split("=")[1].Trim().Substring(2)} `
                    | Select Tag, OptionName, Defined, Value `
                    | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oSecurityOptions
        } else {                                                                               # undefined - use default value
            New-Object -Type PSObject -Property @{"Tag"=$p; "OptionName"=$opts.$p[0]; "Defined"="No, so default value applies"; "Value"=$opts.$p[1]} `
                    | Select Tag, OptionName, Defined, Value `
                    | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oSecurityOptions
        }
    }
 	"${oSecurityOptions}: " + $secCount                                                                 | Out-File -Append $oCount # completeness

# Basic auditing policies
    $map = @{"0" = "No auditing"; 
             "1" = "Success"; `
             "2" = "Failure"; `
             "3" = "Success and Failure"}
    $aud = @{"AuditSystemEvents ="    = "Audit system events"; `
             "AuditLogonEvents ="     = "Audit logon events"; `
             "AuditObjectAccess ="    = "Audit object access"; `
             "AuditPrivilegeUse ="    = "Audit privilege use"; `
             "AuditPolicyChange ="    = "Audit policy change"; `
             "AuditAccountManage ="   = "Audit account management"; `
             "AuditProcessTracking =" = "Audit process tracking"; `
             "AuditDSAccess ="        = "Audit directory service access"; `
             "AuditAccountLogon ="    = "Audit account logon events"}
    $audCount = 0
    foreach ($p in $aud.Keys) {
        $audCount++
        $val = ([string](cat "$outdir\Local_LGPO.txt" | Select-String $p)).split("=")[1].Trim()
        if ($val -ne $null) {                                               # defined
           New-Object -Type PSObject -Property @{"Tag"=$p; "BasicAuditPolicyDesc"=$aud.$p; "ValueDigit"=$val; "ValueText"=$map.$val} `
                             | Select Tag, BasicAuditPolicyDesc, ValueDigit, ValueText `
                             | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oBasicAudit
        } else {                                                            # undefined (no fallback default values for basic audit policies)
           New-Object -Type PSObject -Property @{"Tag"=$p; "BasicAuditPolicyDesc"=$aud.$p; "ValueDigit"=""; "ValueText"="Undefined"} `
                             | Select Tag, BasicAuditPolicyDesc, ValueDigit, ValueText `
                             | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oBasicAudit
        }
    }
 	"${oBasicAudit}: " + $audCount                                                                     | Out-File -Append $oCount # completeness

# Advanced audit policies
    auditpol.exe /get /category:* | Where {$_}               | Set-Content $oAdvancedAudit
    auditpol.exe /resourceSACL /type:Key /view  | Where {$_} | Set-Content $oRegGOAA        # Global Object Access Auditing: Registry SACLs
    auditpol.exe /resourceSACL /type:File /view | Where {$_} | Set-Content $oFileGOAA       # Global Object Access Auditing: File SACLs
}

function doUsers() {
    $now   = Get-Date
	$d     = [ADSI]("WinNT://" + $env:computername)
	$users = $d.children | where {$_.SchemaClassName -eq 'user'} | select *
    $first = 1
	foreach ($u in $users) {
# LGPO password and user account lockout controls
        if ($first -eq 1) {
            $first = 0
            $pwdComplexity = ([string](cat "$outdir\Local_LGPO.txt" | Select-String "PasswordComplexity")).split("=")[1].Trim()
            if ($pwdComplexity -eq "0") {$pwdComplexity = "Disabled"} else {$pwdComplexity = "Enabled"}
            $pwdReversible = ([string](cat "$outdir\Local_LGPO.txt" | Select-String "ClearTextPassword")).split("=")[1].Trim()
            if ($pwdReversible -eq "0") {$pwdReversible = "Disabled"} else {$pwdReversible = "Enabled"}
            $u | select @{Name="Enforce pwd history";    Expression={$_.PasswordHistoryLength}}, `
                        @{Name="Max pwd age (days)";     Expression={$_.MaxPasswordAge[0] / 86400}}, `
                        @{Name="Min pwd age (days)";     Expression={$_.MinPasswordAge[0] / 86400}}, `
                        @{Name="Min pwd length";         Expression={$_.MinPasswordLength}}, `
                        @{Name="Pwd must meet complexity requirements"; Expression={$pwdComplexity}}, `
                        @{Name="Store pwd using reversible encryption"; Expression={$pwdReversible}}, `
		    	        @{Name="Account lockout duration (minutes)"; Expression={if ($_.AutoUnlockInterval[0] -eq -1) {"Until administrator unlocks it"} else {$_.AutoUnlockInterval[0] / 60}}}, `
                        @{Name="Account lockout threshold";          Expression={if ([int]$_.MaxBadPasswordsAllowed[0] -eq 0) {"Account will not lock out"} else {$_.MaxBadPasswordsAllowed}}}, `
                        @{Name="Reset account lockout counter after (minutes)"; Expression={$_.LockoutObservationInterval[0] / 60}} `
		       | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oLGPO
        }

# Local users
        $tmpuser = New-Object System.Security.Principal.NTAccount($u.name)
        $u | select @{Name="Name";               Expression={$_.Name}}, `
                    @{Name="Fullname";           Expression={$_.Fullname}}, `
                    @{Name="Description";        Expression={$_.Description}}, `
			        @{Name="LastLogin";          Expression={if ($_.LastLogin -ne $null) {$_.LastLogin.ToString("yyyy-MM-dd HH:mm")} else {"Never logged in"}}}, `
			        @{Name="PwC_ScriptExecDate"; Expression={$now.toString("yyyy-MM-dd HH:mm")}}, `
			        @{Name="PwC_DormancyDays";   Expression={if ($_.LastLogin -ne $null) {($now - $_.LastLogin[0]).days} else {"Never logged in"}}}, `
                	@{Name="PwC_Active";         Expression={if ((($_.UserFlags[0] -bAnd 0x00002) -ne 0) -or `
                                                                 (($_.UserFlags[0] -bAnd 0x00010) -ne 0)) {"Inactive"} else {"Active"}}}, `
                    @{Name="Disabled";           Expression={if (($_.UserFlags[0] -bAnd 0x00002) -ne 0) {"Yes"} else {"No"}}}, `
			        @{Name="Locked";             Expression={if (($_.UserFlags[0] -bAnd 0x00010) -ne 0) {"Yes"} else {"No"}}}, `
			        @{Name="PwdNotRequired";     Expression={if (($_.UserFlags[0] -bAnd 0x00020) -ne 0) {"Yes"} else {"No"}}}, `
			        @{Name="PwdCantChange";      Expression={if (($_.UserFlags[0] -bAnd 0x00040) -ne 0) {"Yes"} else {"No"}}}, `
			        @{Name="PwdDoesntExpire";    Expression={if (($_.UserFlags[0] -bAnd 0x10000) -ne 0) {"Yes"} else {"No"}}}, `
			        @{Name="SmartcardRequired";  Expression={if (($_.UserFlags[0] -bAnd 0x40000) -ne 0) {"Yes"} else {"No"}}}, `
                    @{Name="UserFlags";          Expression={$_.UserFlags}}, `
                    @{Name="SID";                Expression={($tmpuser.Translate([System.Security.Principal.SecurityIdentifier])).value}} `
		   | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oUsers
	}
	"${oUsers}: " + $users.count                                                                       | Out-File -Append $oCount # completeness
}

function doShares() {
    $shares = Get-SmbShare 
    $shares | Select Name, Description, Path, ShareType, Special, ShareState | Export-Csv -NoTypeInformation -encoding $Encoding $oShares
    $sharePermsCount    = 0
    $shareDirPermsCount = 0
	foreach ($s in $shares) {
# Share permissions
        $thisShare = Get-SmbShareAccess -Name $s.name
            if ($thisShare.count -eq $null) {
                $sharePermsCount++                   # if only one permission, the count is null. This forces 1
            } else {
                $sharePermsCount += $thisShare.count
            }
        $thisShare | select @{Name="ShareName"; Expression={$_.name}}, `
                            AccountName, AccessControlType, AccessRight, ScopeName, PSComputerName `
                   | Export-Csv -NoTypeInformation -encoding $Encoding -Append $oSharePerms
# Share directory permissions
		if ($s.Path -ne "") {							# if share directory exists, get permissions
            $thisShareACL = Get-Acl $s.Path
            $thisSharePerms = ($thisShareACL.AccessToString -replace "268435456",   "FullControl" `
							                                -replace "-1610612736", "ReadAndExecute, Synchronize" `
							                                -replace "-536805376",  "Write, ReadAndExecute, Synchronize" `
                                                            -split '[\r\n]') | where {$_}
#            $shareDirPermsCount += $thisShareACL.count
            $shareDirPermsCount += $thisSharePerms.count
            foreach ($p in $thisSharePerms) {
			    $thisShareACL | select @{Name="ShareName"; Expression={$s.Name}}, `
                                       @{Name="PSPath"; Expression={$_.PSPath -replace "Microsoft.PowerShell.Core\\FileSystem::", ""}}, `
					                   Owner, Group, `
					                   @{Name="AccessToString"; Expression={$p}}, `
                			           CentralAccessPolicyName, AuditToString `
				              | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oShareDirPerms
            }
        }
    }
	"${oShares}: "        + $shares.count                                                              | Out-File -Append $oCount # completeness
	"${oSharePerms}: "    + $sharePermsCount                                                           | Out-File -Append $oCount # completeness
	"${oShareDirPerms}: " + $shareDirPermsCount                                                        | Out-File -Append $oCount # completeness
}

function doGroups() {
# powershell method
#    if ($cmdExist["Get-LocalGroup"] -eq "Y") {
#        $lg = Get-LocalGroup | select Name, Description, SID 
#        $lg | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oGroups
#	    "${oGroups}: " + $lg.count                                                                     | Out-File -Append $oCount # completeness
#    } else {
#        "Command Get-LocalGroup not found. Inspect $oGroupsL instead."                                 | Out-File -Append $oGroups
#    }

# legacy method
    net.exe localgroup | Out-File -Append $oGroupsL
}

function doGroupMemberships () {
# powershell method
#    if ($cmdExist["Get-LocalGroup"] -eq "Y" -and $cmdExist["Get-LocalGroupMember"] -eq "Y") {
#        $lgmCount = 0
#	    foreach ($g in (Get-LocalGroup)) {
#            $lgmCount += (Get-LocalGroupMember -group $g).count
#            Get-LocalGroupMember -group $g `
#                | select @{Name="GroupName";         Expression={$g.Name}}, `
#				         @{Name="MemberName";        Expression={$_.Name}}, `
#				         @{Name="MemberObjectClass"; Expression={$_.ObjectClass}}, `
#				         @{Name="MemberSource";      Expression={$_.PrincipalSource}}, `
#                         @{Name="MemberSID";         Expression={$_.Sid}} `
#                | Export-Csv -NoTypeInformation -Encoding $Encoding -Append $oGroupMembers
#	    }
#	    "${oGroupMembers}: " + $lgmCount                                                               | Out-File -Append $oCount # completeness
#    } else {
#        "Command Get-LocalGroup and/or Get-LocalGroupMember not found. Inspect $oGroupMembersL instead." | Out-File -Append $oGroupMembers
#    }

# legacy method
    $groups = net.exe localgroup | where {$_[0] -eq "*"} | select @{Name="group"; Expression={$_.Substring(1)}}
    foreach ($g in $groups) {
        "GROUP: " + $g.group                                                                           | Out-File -Append $oGroupMembersL  
        "=============================="                                                               | Out-File -Append $oGroupMembersL
        net.exe localgroup ""$g.group""                                                                | Out-File -Append $oGroupMembersL
    }
}

###################################### MAIN FUNCTIONS ##############################################

function Foundation() {
	write-host "Foundation extracts"
	write-host "==================="

	write-host "(FND) Get registry settings and permissions..."
    $sw = [Diagnostics.Stopwatch]::StartNew()
   	doReg
    "Execution time of doReg(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(FND) Get applied patch information..."
    $sw.Restart()
	doPatches
    "Execution time of doPatches(): " + $sw.Elapsed.TotalSeconds								| Out-File -Append $oLog

	write-host "(FND) Get share permissions..."
    $sw.Restart()
    doShares
    "Execution time of doShares(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(FND) Get drives..."
    $sw.Restart()
	Get-WmiObject -Class Win32_Volume `
            | select Name, Label, Caption, Description, DriveLetter, `
                     FileSystem, BootVolume, Capacity, FreeSpace `
            | Export-Csv -NoTypeInformation -Encoding $Encoding $oDrives
    "Execution time of doDrives(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(FND) Get Just-Enough-Administration (JEA) configuration..."
    $sw.Restart()
	doJEA
    "Execution time of doJEA(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

    write-host "(FND) Get Local Group Policy Objects (LGPO)..."
    $sw.Restart()
    doLGPO
    "Execution time of doLGPO(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(FND) Get resultant set of policy (RSoP) for local machine..."
    $sw.Restart()
    gpresult.exe /h "$outpath\FND_AppliedGPOs.html" /SCOPE COMPUTER | out-null
    gpresult.exe /x "$outpath\FND_AppliedGPOs.xml"  /SCOPE COMPUTER | out-null
    "Execution time of doRSoP(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog
    $sw.Stop()

	write-host
}

function DomainController() {
#   Check if AD commands are installed
    if ($cmdExist["Get-ADUser"] -eq "N") {
        "WARNING: Required AD Powershell cmdlets could not be found"         					| Out-File -Append $oLog
		write-host
		write-host "WARNING: Some required AD Powershell cmdlets could not be found."
		write-host "         The Active Directory Powershell module might not be installed."
		write-host "Are you sure you want to continue?"
        $choice = Read-Host -Prompt "Press <Enter> to continue, or <Ctrl-C> to abort"
        write-host
    }

	write-host "(DC) Get AD information..."
    $sw = [Diagnostics.Stopwatch]::StartNew()
	doADInfo
    "Execution time of doADInfo(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(DC) Get AD Group Policy Objects (GPO)..."
    $sw.Restart()
	doADGPOs
    "Execution time of doADGPOs(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(DC) Get AD fine-grained password policies (FGPP)..."
    $sw.Restart()
	doADFineGrainedPwdPolicies
    "Execution time of doADFineGrainedPwdPolicies(): " + $sw.Elapsed.TotalSeconds				| Out-File -Append $oLog

	write-host "(DC) Get AD users..."
    $sw.Restart()
	doADUsers
    "Execution time of doADUsers(): " + $sw.Elapsed.TotalSeconds								| Out-File -Append $oLog

	write-host "(DC) Get AD Managed Service Accounts (MSA)..."
    $sw.Restart()
    doADMSA
    "Execution time of doADMSA(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(DC) Get AD groups..."
    $sw.Restart()
	doADGroups
    "Execution time of doADGroups(): " + $sw.Elapsed.TotalSeconds								| Out-File -Append $oLog

	write-host "(DC) Get AD direct and inherited user-group memberships (This might take a few minutes)..."
    $sw.Restart()
	doADUserGroupMemberships
    "Execution time of doADUserGroupMemberships(): " + $sw.Elapsed.TotalSeconds					| Out-File -Append $oLog

	write-host "(DC) Get AD direct group-group memberships..."
    $sw.Restart()
	doADGroupGroupMemberships
    "Execution time of doADGroupGroupMemberships(): " + $sw.Elapsed.TotalSeconds				| Out-File -Append $oLog

    write-host "(DC) Get OU delegations..."
    $sw.Restart()
    doADOUDelegations
    "Execution time of doADOUDelegations(): " + $sw.Elapsed.TotalSeconds						| Out-File -Append $oLog

	write-host "(DC) Get AD trusts..."
    $sw.Restart()
	doADTrusts
    "Execution time of doADTrusts(): " + $sw.Elapsed.TotalSeconds								| Out-File -Append $oLog
    $sw.Stop()
}

function NonDomainController() {
	write-host "(Local) Get local users..."
    $sw = [Diagnostics.Stopwatch]::StartNew()
    doUsers
    "Execution time of doUsers(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(Local) Get local groups..."
    $sw.Restart()
	doGroups
    "Execution time of doGroups(): " + $sw.Elapsed.TotalSeconds									| Out-File -Append $oLog

	write-host "(Local) Get local group memberships..."
    $sw.Restart()
	doGroupMemberships
    "Execution time of doGroupMemberships(): " + $sw.Elapsed.TotalSeconds						| Out-File -Append $oLog
    $sw.Stop()
}

#################################### MAIN #######################################
$ErrorActionPreference = "Continue"		         # Continue if errors occur, and log them
# $MaximumErrorCount = 512                       # Increase error log capacity
$scriptVersion = "2019-08-13"
Write-Host "Script version: $scriptVersion"
Write-Host "Copyright 2019 PricewaterhouseCoopers. All rights reserved.`r`n"
Write-Host "Operational instructions:"
Write-Host "========================="
Write-Host "It is the client's responsibility to perform the following steps prior to execution "
Write-Host "of the script in the production environment:"
Write-Host "a) Scrutinize the contents of these scripts to ensure that they do not contain "
Write-Host "   statements, commands or other code that might negatively influence the "
Write-Host "   environment(s) in either a security or operational way."
Write-Host "b) Test the scripts on the test environment to ensure that they do not contain "
Write-Host "   statements, commands or other code that might negatively influence the "
Write-Host "   environment(s) in either a security or operational way."
Write-Host "c) The final responsibility for executing this script lies with the client."
Write-Host "d) It is advised to execute the script during off-peak hours."
Write-Host "e) The client must remove all copies of the script as it is the property of "
Write-Host "   PricewaterhouseCoopers.  The client may retain the script results.`r`n"
$choice = Read-Host -Prompt "Press <Enter> to continue, or <Ctrl-C> to abort"
Write-Host

$cmdExist = @{"Get-PSSessionConfiguration"      = "";
              "Get-Date"                        = "";
              "Get-WmiObject"                   = "";
              "Get-HotFix"                      = "";
              "Get-Content"                     = "";
              "Get-Item"                        = "";
              "Get-ACL"                         = "";
              "Get-ChildItem"                   = "";
              "Get-ItemProperty"                = "";
              "Get-ADDomain"                    = "";
              "Get-ADForest"                    = "";
              "Get-ADDomainController"          = "";
              "Get-GPO"                         = "";
              "Get-ADObject"                    = "";
              "Get-ADOrganizationalUnit"        = "";
              "Get-ADRootDSE"                   = "";
              "Get-GPOReport"                   = "";
              "Get-ADFineGrainedPasswordPolicy" = "";
              "Get-ADUser"                      = "";
              "Get-ADServiceAccount"            = "";
              "Get-ADGroup"                     = "";
              "Get-ADTrust"                     = "";
              "Get-SmbShare"                    = "";
              "Get-SmbShareAccess"              = "";
              "Get-LocalGroup"                  = "";
              "Get-LocalGroupMember"            = "";
              "dsget.exe"                       = "";
              "secedit.exe"                     = "";
              "auditpol.exe"                    = "";
              "net.exe"                         = "";
              "gpresult.exe"                    = ""}

# Check which commands are available
foreach ($c in $($cmdExist.keys)) {
    $cmdExist[$c] = "N"
    if (Get-Command $c -errorAction SilentlyContinue) {
        $cmdExist[$c] = "Y"
    }
}
$Error.Clear()					                                        # Clears errors logged by the check above

$minimumVersion  = 6.2									                # Warn if the Windows version is below 2012
$w32os = Get-WmiObject -Class "Win32_OperatingSystem"
$w32cs = Get-WmiObject -Class "Win32_ComputerSystem"

$outdir           = $w32os.CSName + "_" + (Get-Date).toString("yyyy-MM-dd_HH\hmmss")
$outpath          = $pwd.path + "\" + $outdir
$oError           = $outdir + "\ERR_Errors.txt"                         # Errors during script execution
$oCount           = $outdir + "\FND_rowcounts.txt"                      # System row counts, for completeness testing
$oSystemInfo      = $outdir + "\FND_SystemInfo.txt"                     # System information
$oLog             = $outdir + "\FND_Log.txt"                            # Script execution information
$oDrives          = $outdir + "\FND_Drives.csv"
$oPatches         = $outdir + "\FND_Patches.csv"
$oShares          = $outdir + "\FND_Shares.csv"
$oSharePerms      = $outdir + "\FND_SharePerms.csv"                     # Share permissions
$oShareDirPerms   = $outdir + "\FND_ShareDirPerms.csv"                  # Share directory permissions
$oFilePerms       = $outdir + "\FND_FilePerms.csv"                      # File permissions
$oSvcFilePerms    = $outdir + "\FND_SvcFilePerms.csv"                   # File permissions of services identified in the registry
$oDirPerms        = $outdir + "\FND_DirPerms.csv"                       # Directory permissions
$oJEA             = $outdir + "\FND_JEA.txt"                            # Just-Enough-Administration
$oRegValues       = $outdir + "\FND_RegValues.txt"                      # Registry values
$oRegPerms        = $outdir + "\FND_RegPerms.csv"                       # Registry permissions
New-Item -Path $outdir -ItemType directory | out-null
$imgpaths         = New-Object System.Collections.ArrayList				# To inspect service ImagePaths' file permissions

# Non-AD output files
$oLGPO            = $outdir + "\Local_UserPwdPolicies.csv"              # Local Password and user control components of Local GPO
$oUsers           = $outdir + "\Local_Users.csv"                        # Local User listing
#$oGroups          = $outdir + "\Local_Groups.csv"                      # Local Group listing (PS method using Get-LocalGroup)
$oGroupsL         = $outdir + "\Local_Groups.txt"                       # Local Group listing (legacy method using net.exe)
#$oGroupMembers    = $outdir + "\Local_GroupMembers.csv"                # Local User-Group listing (hierarchies don't exist)
$oGroupMembersL   = $outdir + "\Local_GroupMembers.txt"                 # Local User-Group listing using legacy net.exe method
$oUserRights      = $outdir + "\Local_UserRights.csv"                   # Local User rights
$oSecurityOptions = $outdir + "\Local_SecurityOptions.csv"              # Local Security options
$oBasicAudit      = $outdir + "\Local_BasicAudit.csv"                   # Local Basic audit policy
$oAdvancedAudit   = $outdir + "\Local_AdvancedAudit.txt"                # Local Advanced audit policy
$oRegGOAA         = $outdir + "\Local_GOAAregistrySACL.txt"             # Global Object Access Auditing: Registry SACLs
$oFileGOAA        = $outdir + "\Local_GOAAfileSACL.txt"                 # Global Object Access Auditing: File SACLs

# AD output files
$oGPO             = $outdir + "\AD_GPOlist.csv"                         # Group Policy Objects
$oGPOlinks        = $outdir + "\AD_GPOlinks.csv"                        # Group Policy Object links
$oFGPP            = $outdir + "\AD_FineGrainedPwdPolicies.csv"          # Fine-grained password policies
$oUsersAD         = $outdir + "\AD_Users.csv"                           # User listing
$oMSAUsersAD      = $outdir + "\AD_MSAUsers.csv"                        # Managed service account listing
$oGroupsAD        = $outdir + "\AD_Groups.csv"                          # Group listing
$oUGMembersAD     = $outdir + "\AD_UserGroupMembers.csv"                # Users-to-Groups, hierarchy expanded
$oGGMembersAD     = $outdir + "\AD_GroupGroupMembers.csv"               # Group-to-Group,  hierarchy collapsed
$oInfoAD          = $outdir + "\AD_Info.txt"                            # Active Directory information
$oForestDCsAD     = $outdir + "\AD_ForestDCs.csv"                       # List of domain controllers, per domain, in the forest
$oTrustAD         = $outdir + "\AD_Trusts.csv"                          # Domain trusts in the forest
$oOUdelegations   = $outdir + "\AD_OUDelegations.csv"                   # OU delegated administration

# Log which commands are available
"Command existence check:"															    		| Out-File -Append $oSystemInfo
"========================"														    			| Out-File -Append $oSystemInfo
foreach ($c in $($cmdExist.keys)) {
	"$c : " + $cmdExist[$c]																		| Out-File -Append $oSystemInfo
}
""                      																		| Out-File -Append $oSystemInfo

doSystemInfo                                                            # System information and version check
Foundation                                                              # Items common to DC and non-DC server roles
If ($w32cs.DomainRole -eq 4 -or $w32cs.DomainRole -eq 5) {
	write-host "Domain Controller detected. Running Active Directory queries"
	write-host "============================================================"
	DomainController
} Else {
	write-host "Domain Controller NOT detected. Running local queries"
	write-host "====================================================="
	NonDomainController
}

doErrorLog
"Script execution ended: " + (Get-Date -format "yyyy-MM-dd HH:mm:ss")							| Out-File -Append $oLog

write-host
write-host "Zipping output..."
Add-Type -Assembly System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($outpath, $outpath + ".zip", [System.IO.Compression.CompressionLevel]::Optimal, $false)
write-host "Please copy ${outdir}.zip to a PwC consultant's encrypted USB storage."
write-host "Please do not email this file!"
write-host