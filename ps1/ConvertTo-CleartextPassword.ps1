function ConvertTo-CleartextPassword
{
<#
.SYNOPSIS
This function can be used to decrypt passwords that were stored encrypted by the function Invoke-PasswordRoll.

Function: ConvertTo-CleartextPassword
Author: Microsoft
Version: 1.0

.DESCRIPTION
This function can be used to decrypt passwords that were stored encrypted by the function Invoke-PasswordRoll.


.PARAMETER EncryptedPassword

The encrypted password that was stored in a TSV file.

.PARAMETER EncryptionKey

The password used to do the encryption.


.EXAMPLE

. .\Invoke-PasswordRoll.ps1 #Loads the functions in this script file
ConvertTo-CleartextPassword -EncryptionKey "Password1" -EncryptedPassword 76492d1116743f0423413b16050a5345MgB8AGcAZgBaAHUAaQBwADAAQgB2AGgAcABNADMASwBaAFoAQQBzADEAeABjAEEAPQA9AHwAZgBiAGYAMAA1ADYANgA2ADEANwBkADQAZgAwADMANABjAGUAZQAxAGIAMABiADkANgBiADkAMAA4ADcANwBhADMAYQA3AGYAOABkADcAMQA5ADQAMwBmAGYANQBhADEAYQBjADcANABkADIANgBhADUANwBlADgAMAAyADQANgA1ADIAOQA0AGMAZQA0ADEAMwAzADcANQAyADUANAAzADYAMAA1AGEANgAzADEAMQA5ADAAYwBmADQAZAA2AGQA"

Decrypts the encrypted password which was stored in the TSV file.

#>
Param(
[Parameter(Mandatory=$true)]
[String]
$EncryptedPassword,

[Parameter(Mandatory=$true)]
[String]
$EncryptionKey
)

$Sha256 = new-object System.Security.Cryptography.SHA256CryptoServiceProvider
$SecureStringKey = $Sha256.ComputeHash([System.Text.UnicodeEncoding]::Unicode.GetBytes($EncryptionKey))

[SecureString]$SecureStringPassword = ConvertTo-SecureString -String $EncryptedPassword -Key $SecureStringKey
Write-Output ([System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($SecureStringPassword)))
}