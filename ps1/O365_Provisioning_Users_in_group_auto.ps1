    ##########################################################################################################################
    # Script Name:	.ps1
    # Description:		This script populate an AD group based on a LDAP Filter
    # Argument:     LogfilePath & Verbose mode
    # Auteur:		Blaise Kientsch / Swisscom
    # Creatio Date:		02.09.2016
    # 
    # Version:			1.0
    #                  
    ############################################################################################################################
    # $LogFilePath: Path of the logfile
    #$ScriptVerbose: enable verbose log. Default=False
    param(
    [parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][String]$LogfilePath,
    [Switch]$ScriptVerbose
    )
    ############################################################################################################################
    # Variable global
    ############################################################################################################################
    $EnabledUsersFilter="(!userAccountControl:1.2.840.113556.1.4.803:=2)"
    $LDAPFilter="((adxGlobalEmployeeNum=*)(!userAccountControl:1.2.840.113556.1.4.803:=2))" #Ldap filter to select users to synchronize
    $GroupNameADXO365Auto="G_ADX_O365_Tenant_Auto_Users"            #Group to provision
    $GroupNameADXO365Exception="G_ADX_O365_Tenant_Exception_Users" #group of exception users
    $LogFile = $LogfilePath + "\AD_Group_O365_Provisionning_" + (((Get-Date -Format G).replace(" ","")).replace(":","")).replace(".","") + ".log" #Logfile full path name
    $ScriptWithErrors=$false                                        #Initialisation of the variable in case of error in the script
    $DormantDate = (get-date).AddDays(-90)
    $oldSuffix = "upstream.apc.grp"
    $newSuffix = "addaxpetroleum.com"
    ############################################################################################################################
    # Functions
    ############################################################################################################################
    # Fuction: LOG
    # Parameter: $message
    # Appen text to the logfile
    Function Log($message){
	    $message | Out-File $Logfile -Append 
    }

    ############################################################################################################################
    # Main
    ############################################################################################################################
    Import-Module ActiveDirectory #Import module ActiveDirectory
    $UsersToSynchronize=Get-ADUser -LDAPFilter $LDAPFilter -Properties LastLogonDate,passwordlastset | Where-Object{($_.LastLogonDate -gt $DormantDate) -or ($_.passwordlastset -gt $DormantDate)}#Select the users based on the LDAP filter defined earlier
    $ChangesToApply = diff ($UsersToSynchronize) (Get-ADGroupMember $GroupNameADXO365Auto) -Property 'SamAccountName' -IncludeEqual #Provides the action to apply to the user
    

    Foreach($UserChanges in $ChangesToApply)
    {
        Switch($UserChanges.SideIndicator)
        {
            "=="{if ($ScriptVerbose){
                    $TextToWrite = "INFORMATION: == User " + $UserChanges.SAMAccountName + " is already member of the group"
                    Log -message $TextToWrite}}
            "<="{try {Add-ADGroupMember $GroupNameADXO365Auto $UserChanges.SAMAccountName -Confirm:$false | Out-Null
                 if ($ScriptVerbose){ 
                    $TextToWrite= "INFORMATION: <= User " + $UserChanges.SAMAccountName + " has been successfully added"
                    Log -message $TextToWrite}}
                 Catch{
                 if ($ScriptVerbose){ 
                    $TextToWrite = "ERROR: <= User " + $UserChanges.SAMAccountName + " has not been successfully added"
                    Log -message $TextToWrite
                    $ScriptWithErrors=$true}}}
            "=>"{try {Remove-ADGroupMember $GroupNameADXO365Auto -members $UserChanges.SAMAccountName  -Confirm:$false | Out-Null
                 if ($ScriptVerbose){
                    $TextToWrite = "INFORMATION: => User " + $UserChanges.SAMAccountName + " has been successfully removed"
                    Log -message $TextToWrite }}
                 Catch{
                 if ($ScriptVerbose){
                    $TextToWrite = "ERROR: => User " + $UserChanges.SAMAccountName + " has not been successfully removed"
                    Log -message $TextToWrite
                    $ScriptWithErrors=$true}}}
            default{$TextToWrite= "INFORMATION: <= User " + $UserChanges.SAMAccountName + " has been successfully added"
                    Log -message $TextToWrite}
        }
    }

    If($ScriptWithErrors)
    {
        $ErrorMessage= "The Script " + $MyInvocation.MyCommand.Name + " has failed during the provisionning of the group " + $GroupNameADXO365Auto + ". Enable the verbose log to have more information"

        Write-EventLog -LogName "Application" -Source "O365Scripts" -EventID 3001 -EntryType Error -Message $ErrorMessage -Category 1 -RawData 10,20
    }
    else
    {
        $ErrorMessage= "The Script " + $MyInvocation.MyCommand.Name + " has successfully run during the provisionning of the group " + $GroupNameADXO365Auto + "."
        Write-EventLog -LogName "Application" -Source "O365Scripts" -EventID 3000 -EntryType Information -Message $ErrorMessage -Category 1 -RawData 10,20
    }


    ############################################################################################################################
    # Remove disabed users from the exception group
    ############################################################################################################################
   $UsersToRemoveFromGroup=Get-ADGroupMember $GroupNameADXO365Exception -PipelineVariable SamAccountName | Get-ADUser -Properties LastLogonDate,enabled | Where-Object{(($_.LastLogonDate -gt $DormantDate) -and ($_.enabled -eq $false))}
   Foreach($UserToRemove in $UsersToRemoveFromGroup)
    {
        try 
        {
            Remove-ADGroupMember $GroupNameADXO365Exception -members $UserToRemove.SAMAccountName  -Confirm:$false | Out-Null
            if ($ScriptVerbose)
            {
                    $TextToWrite = "INFORMATION: Disabled User " + $UserToRemove.SAMAccountName + " has been successfully removed"
                    Log -message $TextToWrite 
            }
        }
                 
        Catch
        {
            if ($ScriptVerbose)
            {
                    $TextToWrite = "ERROR: Disabled User " + $UserToRemove.SAMAccountName + " has not been successfully removed"
                    Log -message $TextToWrite
                    $ScriptWithErrors=$true
             }
         }
     }

############################################################################################################################
# Add a SIP address & check the upn
############################################################################################################################

$AddaxexceptionUsers = Get-ADGroupMember $GroupNameADXO365Exception

$AddaxUsersAuto = Get-ADGroupMember $GroupNameADXO365Auto

$AddaxUsersToCheck = $AddaxexceptionUsers + $AddaxUsersAuto

Foreach($AddaxUser in $AddaxUsersToCheck)
{
    if((Get-ADUser $AddaxUser -Properties UserPrincipalName).UserPrincipalName -notlike "*addaxpetroleum.com")
    {
        $newUpn = (Get-ADUser $AddaxUser -Properties UserPrincipalName).UserPrincipalName.Replace($oldSuffix,$newSuffix)

        if($newUpn -like "*addaxpetroleum.com")
        {
            try 
            {
                Set-ADUser $AddaxUser -UserPrincipalName $newUpn
            
                if ($ScriptVerbose)
                {
                    $TextToWrite = "INFORMATION: The UserPrincipalName of the user " + $newUpn + " has been successfully modified"
                    Log -message $TextToWrite 
                    
                }
            }
                 
            Catch
            {
                if ($ScriptVerbose)
                {
                    $TextToWrite = "ERROR: The UserPrincipalName of the user " + $newUpn + " has a wrong UPN and it has not been succesfully modified"
                    Log -message $TextToWrite
                    $ScriptWithErrors=$true
                }
            }
        }
        else
        {
            $TextToWrite = "ERROR: The UserPrincipalName of the user " + $newUpn + " has a wrong UPN and it has not been succesfully modified"
            Log -message $TextToWrite
            $ScriptWithErrors=$true
        }
    }

}