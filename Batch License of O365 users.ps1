function Connect-MSService(){
    Import-Module MsOnline
    $cred=Get-Credential -Credential xxx@xxxx.com
    Connect-MsolService -Credential $cred #-errorAction silentlyContinue -errorvariable er
    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://partner.outlook.cn/PowerShell-LiveID -Credential $cred -Authentication Basic -AllowRedirection
    Import-PSSession $Session
}
Connect-MSService
$msolUsers = Get-MsolUser -All -Synchronized
$mailboxUsers = Get-Mailbox -ResultSize unlimited|%{$_.UserPrincipalName}

## Define License Options
## There are five Services SHAREPOINTWAC,SHAREPOINTENTERPRISE,MCOSTANDARD,OFFICESUBSCRIPTION,EXCHANGE_S_ENTERPRISE in E3 Licence
## If you want to disable any of them in the licence options, just use -DisablePlans and follow the name of the services you want to disable
$O365E3 = New-MsolLicenseOptions -AccountSkuId syndication-account:ENTERPRISEPACK_NO_RMS
$O365E3_OnlyExchange = New-MsolLicenseOptions -AccountSkuId syndication-account:ENTERPRISEPACK_NO_RMS -DisabledPlans SHAREPOINTWAC,SHAREPOINTENTERPRISE,MCOSTANDARD,OFFICESUBSCRIPTION

## Process each user in the collection, if they have license already, change the license options, if not, add the License with options
foreach ($msolUser in $msolUsers) {
	$HasLicense = $msolUser.IsLicensed
	if ($HasLicense) {
		#Write-Host $msolUser.UserPrincipalName -ForegroundColor Green
        #$msolUser | Set-MsolUserLicense -LicenseOptions $O365E3_OnlyExchange
	}
	else {
        if($mailboxUsers -contains $msolUser.UserPrincipalName){
		    $msolUser | Set-MsolUser -UsageLocation "CN"
		    $msolUser | Set-MsolUserLicense -AddLicenses "syndication-account:ENTERPRISEPACK_NO_RMS" -LicenseOptions $O365E3_OnlyExchange -ErrorAction Continue
            if($?){
                $msolUser.IsLicensed=$true
            }else{
                Write-Host $msolUser.UserPrincipalName -ForegroundColor green
            }
        }
	}
}