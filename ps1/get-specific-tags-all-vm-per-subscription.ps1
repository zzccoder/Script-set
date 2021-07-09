<#
.Synopsis: Scipt to export all VM's with input tags	
.Description: The script will take the Tags and subscription as input 
			parameter. Then it will look at each VM to pull the input 
			tags details each VM's with Name, resourcegroup, state,
			tag values and subscription. This will be written to an
			output file name export.csv on current folder
			Connect-azaccount will prompt to login to portal with your 
			credentials
			
.NOTES
    File Name      : get-specific-tags-all-VM-per-subscriptions.ps1
    Author         : Hari VS (harivs@ymail.com)
    Prerequisite   : PowerShell with Azure module (AZ module 1.7 , not RM)
    (C) Copyright 2019 - Hari VS
.RECOMMENDATION
	This script is recommended to use against small subscriptions
.EXAMPLE	
	get-specific-tags-all-VM-per-subscriptions.ps1 -Subscription DevSubcription -InTag1 LOB -InTag2 Owner -InTag3 BillingCode

#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
   [string]$Subscription,
   
  [Parameter(Mandatory=$False)]
   [string]$InTag1,
	
  [Parameter(Mandatory=$False)]
   [string]$InTag2,
   
  [Parameter(Mandatory=$False)]
   [string]$InTag3
	
)
Connect-azaccount 

#Create the array for storing data
$vmlistarray = @()

#set the subscriptionID based on input
$SubscriptionID = Get-AzSubscription -SubscriptionName $Subscription

(Set-AzContext $SubscriptionId) > 0	

$VMS = Get-AzVM
	
foreach ($VM in $VMS)
	
				{    
				$vmstatus = Get-AzVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName -Status 
			
				$vmlistarray += New-Object PSObject -Property @{`
					Name=$VM.Name;` 
					Tag1= $VM.Tags.$InTag1;`
					Tag2= $VM.Tags.$InTag2;`
					Tag3= $VM.Tags.$InTag3;`
					Subscription=$Subscription;`
					ResourceGroupName=$VM.ResourceGroupName;`
					PowerState=(get-culture).TextInfo.ToTitleCase(($vmstatus.statuses)[1].code.split("/")[1])
					}

				}

$vmlistarray | export-csv -path .\export1.csv -NoTypeInformation