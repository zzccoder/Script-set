﻿#--------------------------------------------------------------------------------- 
#The sample scripts are not supported under any Microsoft standard support 
#program or service. The sample scripts are provided AS IS without warranty  
#of any kind. Microsoft further disclaims all implied warranties including,  
#without limitation, any implied warranties of merchantability or of fitness for 
#a particular purpose. The entire risk arising out of the use or performance of  
#the sample scripts and documentation remains with you. In no event shall 
#Microsoft, its authors, or anyone else involved in the creation, production, or 
#delivery of the scripts be liable for any damages whatsoever (including, 
#without limitation, damages for loss of business profits, business interruption, 
#loss of business information, or other pecuniary loss) arising out of the use 
#of or inability to use the sample scripts or documentation, even if Microsoft 
#has been advised of the possibility of such damages 
#--------------------------------------------------------------------------------- 

#requires -Version 2.0

#Check if ActiveDirectory module is imported.
If(-not(Get-Module -Name ActiveDirectory))
{
    Import-Module -Name ActiveDirectory
}

Function Get-OSCADUserPasswordExpiration
{
<#
 	.SYNOPSIS
        Get-OSCADUserPasswordExpiration is an advanced function which can be used to check if user account has expired within a specified period.
    .DESCRIPTION
        Get-OSCADUserPasswordExpiration is an advanced function which can be used to check if user account has expired within a specified period.
    .PARAMETER  SamAccountName
        Specifies the SamAccountName
    .PARAMETER  CsvFilePath
		Specifies the path you want to import csv files.
    .PARAMETER  DayofWeek
		Specifies the day of the week.
    .PARAMETER  NextDay
		Specifies a day that incidates you want to check if user account has expired within your specified day time.
    .EXAMPLE
        C:\PS> Get-OSCADUserPasswordExpiration -SamAccountName doris,katrina -NextDay 10
        
        SamAccountName                               ExpiredOnNext(41)Day PasswordLastSet                                  PasswordExpired
        --------------                               -------------------- ---------------                                  ---------------
        doris                                                        True 10/18/2013 4:25:37 PM                                      False
        katrina                                                     False 8/15/2013 10:16:23 AM                                       True

		This command will check if account password has expired within next 10 days.
    .EXAMPLE
        C:\PS> Get-OSCADUserPasswordExpiration -CsvFilePath C:\Script\SamAccountName.csv -NextDay 10

        SamAccountName                               ExpiredOnNext(41)Day PasswordLastSet                                  PasswordExpired
        --------------                               -------------------- ---------------                                  ---------------
        doris                                                        True 10/18/2013 4:25:37 PM                                      False
        katrina                                                     False 8/15/2013 10:16:23 AM                                       True  

		This command will check if a batch of accounts password have expired within next 10 days.
#>
    [CmdletBinding(DefaultParameterSetName='Sam')]
    Param
    (
        [Parameter(Mandatory=$true,Position=0,ParameterSetName='Sam')]
        [Alias('sam')][String[]]$SamAccountName,

        [Parameter(Mandatory=$true,Position=0,ParameterSetName='Csv')]
        [Alias('path')][String]$CsvFilePath,

        [Parameter(Mandatory=$true,Position=1)]
        [Alias('day')][ValidateScript({$($_ -ge 1) -and `
        $($_ -le $((Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.TotalDays))})]
        [Int]$NextDay
    )

    If($SamAccountName)
    {
        Foreach($User in $SamAccountName)
        {
            ADPasswordExpiration -SamAccountName $User -NextDay $NextDay
        }
    }

    If($CsvFilePath)
    {
        If(Test-Path -Path $CsvFilePath)
        {
            #import the csv file and store in a variable
            $Names = (Import-Csv -Path $CsvFilePath).SamAccountName

            Foreach($Name in $Names)
            {
                ADPasswordExpiration -SamAccountName $Name -NextDay $NextDay
            }
        }
        Else
        {
            Write-Warning "Cannot find path '$CsvFilePath', because it does not exist."
        } 
    }
}

Function ADPasswordExpiration([String]$SamAccountName,[Int]$NextDay)
{
    $MaxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.TotalDays
    $PasswordBeginDate = (Get-Date).AddDays(-$MaxPasswordAge)
    $PasswordExpriyDate = (Get-date).AddDays(-($MaxPasswordAge-$NextDay))

    $ADPasswordInfo = Get-ADUser -Filter {Enabled -eq $true -and SamAccountName -eq $SamAccountName}`
     -Properties PasswordNeverExpires,PasswordLastSet,PasswordExpired `
    | Select-Object SamAccountName,@{Expression={$($_.PasswordNeverExpires -eq $false) `
     -and $($_.PasswordLastSet -ge $PasswordBeginDate.Date) -and `
     $($_.PasswordLastSet -le $PasswordExpriyDate.Date)};Label="ExpiredOnNext($NextDay)Day"},`
     PasswordLastSet,PasswordExpired
    
    $ADPasswordInfo

}