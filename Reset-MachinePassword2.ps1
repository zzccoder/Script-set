<#
    .SYNOPSIS
        Reset Machine Password. Change Local Machine Password and Machine Password in AD. 
         
    .PARAMETER  Userd
        The username of the user with access to AD.
 
    .PARAMETER  Passwordd
        The password for the user with access to AD.
 
    .EXAMPLE
        PS C:\> Reset-MachinePassword `
                -Server sjc01-p01-adc01 `
				-Userd Domain\domain_user `
				-Passwordd DomainPass `
                
    .INPUTS
        None.
 
    .OUTPUTS
        None.
 
    .NOTES
        Revision History:
            2013-04-29 : Anton Vovchenko - Created.
            2013-05-14 : Anton Vovchenko - Changed to generate random Password, detect hostname, domain and generate ldap root.
			2013-05-24 : Anton Vovchenko - 2.0 . Deleted detection DC
    .LINK
        http://support.microsoft.com/kb/324737
         
    .LINK
        http://msdn.microsoft.com/en-us/library/aa378750
 
#>
[cmdletbinding()]
param (
	[Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string]$server,   
    [Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string]$userd,
	[Parameter(Mandatory=$true)] [ValidateNotNullOrEmpty()] [string]$passwordd
   
    )
begin {

        function Convert-DNStoDN ([string]$DNSName) 
        { 
        #  Create an array of each item in the string separated by "." 
           $DNSArray = $DNSName.Split(".") 
         # Let's go through our new array and do something with each item 
           for ($x = 0; $x -lt $DNSArray.Length ; $x++) 
              { 
                # Remember that we need to go to Length-1 because arrays are "0 based indexes" 
                 if ($x -eq ($DNSArray.Length - 1)){$Separator = ""}else{$Separator =","} 
                 [string]$DN += "DC=" + $DNSArray[$x] + $Separator 
              } 
           return $DN 
        }

    #region C# Code to P-invoke LSA LsaStorePrivateData function.
    Add-Type @"
        using System;
        using System.Collections.Generic;
        using System.Text;
        using System.Runtime.InteropServices;
 
        namespace ComputerSystem
        {
            public class LSAutil
            {
                [StructLayout(LayoutKind.Sequential)]
                private struct LSA_UNICODE_STRING
                {
                    public UInt16 Length;
                    public UInt16 MaximumLength;
                    public IntPtr Buffer;
                }
 
                [StructLayout(LayoutKind.Sequential)]
                private struct LSA_OBJECT_ATTRIBUTES
                {
                    public int Length;
                    public IntPtr RootDirectory;
                    public LSA_UNICODE_STRING ObjectName;
                    public uint Attributes;
                    public IntPtr SecurityDescriptor;
                    public IntPtr SecurityQualityOfService;
                }
 
                private enum LSA_AccessPolicy : long
                {
                    POLICY_VIEW_LOCAL_INFORMATION = 0x00000001L,
                    POLICY_VIEW_AUDIT_INFORMATION = 0x00000002L,
                    POLICY_GET_PRIVATE_INFORMATION = 0x00000004L,
                    POLICY_TRUST_ADMIN = 0x00000008L,
                    POLICY_CREATE_ACCOUNT = 0x00000010L,
                    POLICY_CREATE_SECRET = 0x00000020L,
                    POLICY_CREATE_PRIVILEGE = 0x00000040L,
                    POLICY_SET_DEFAULT_QUOTA_LIMITS = 0x00000080L,
                    POLICY_SET_AUDIT_REQUIREMENTS = 0x00000100L,
                    POLICY_AUDIT_LOG_ADMIN = 0x00000200L,
                    POLICY_SERVER_ADMIN = 0x00000400L,
                    POLICY_LOOKUP_NAMES = 0x00000800L,
                    POLICY_NOTIFICATION = 0x00001000L
                }
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaRetrievePrivateData(
                            IntPtr PolicyHandle,
                            ref LSA_UNICODE_STRING KeyName,
                            out IntPtr PrivateData
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaStorePrivateData(
                        IntPtr policyHandle,
                        ref LSA_UNICODE_STRING KeyName,
                        ref LSA_UNICODE_STRING PrivateData
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaOpenPolicy(
                    ref LSA_UNICODE_STRING SystemName,
                    ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
                    uint DesiredAccess,
                    out IntPtr PolicyHandle
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaNtStatusToWinError(
                    uint status
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaClose(
                    IntPtr policyHandle
                );
 
                [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
                private static extern uint LsaFreeMemory(
                    IntPtr buffer
                );
 
                private LSA_OBJECT_ATTRIBUTES objectAttributes;
                private LSA_UNICODE_STRING localsystem;
                private LSA_UNICODE_STRING secretName;
 
                public LSAutil(string key)
                {
                    if (key.Length == 0)
                    {
                        throw new Exception("Key lenght zero");
                    }
 
                    objectAttributes = new LSA_OBJECT_ATTRIBUTES();
                    objectAttributes.Length = 0;
                    objectAttributes.RootDirectory = IntPtr.Zero;
                    objectAttributes.Attributes = 0;
                    objectAttributes.SecurityDescriptor = IntPtr.Zero;
                    objectAttributes.SecurityQualityOfService = IntPtr.Zero;
 
                    localsystem = new LSA_UNICODE_STRING();
                    localsystem.Buffer = IntPtr.Zero;
                    localsystem.Length = 0;
                    localsystem.MaximumLength = 0;
 
                    secretName = new LSA_UNICODE_STRING();
                    secretName.Buffer = Marshal.StringToHGlobalUni(key);
                    secretName.Length = (UInt16)(key.Length * UnicodeEncoding.CharSize);
                    secretName.MaximumLength = (UInt16)((key.Length + 1) * UnicodeEncoding.CharSize);
                }
 
                private IntPtr GetLsaPolicy(LSA_AccessPolicy access)
                {
                    IntPtr LsaPolicyHandle;
 
                    uint ntsResult = LsaOpenPolicy(ref this.localsystem, ref this.objectAttributes, (uint)access, out LsaPolicyHandle);
 
                    uint winErrorCode = LsaNtStatusToWinError(ntsResult);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("LsaOpenPolicy failed: " + winErrorCode);
                    }
 
                    return LsaPolicyHandle;
                }
 
                private static void ReleaseLsaPolicy(IntPtr LsaPolicyHandle)
                {
                    uint ntsResult = LsaClose(LsaPolicyHandle);
                    uint winErrorCode = LsaNtStatusToWinError(ntsResult);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("LsaClose failed: " + winErrorCode);
                    }
                }
 
                public void SetSecret(string value)
                {
                    LSA_UNICODE_STRING lusSecretData = new LSA_UNICODE_STRING();
 
                    if (value.Length > 0)
                    {
                        //Create data and key
                        lusSecretData.Buffer = Marshal.StringToHGlobalUni(value);
                        lusSecretData.Length = (UInt16)(value.Length * UnicodeEncoding.CharSize);
                        lusSecretData.MaximumLength = (UInt16)((value.Length + 1) * UnicodeEncoding.CharSize);
                    }
                    else
                    {
                        //Delete data and key
                        lusSecretData.Buffer = IntPtr.Zero;
                        lusSecretData.Length = 0;
                        lusSecretData.MaximumLength = 0;
                    }
 
                    IntPtr LsaPolicyHandle = GetLsaPolicy(LSA_AccessPolicy.POLICY_CREATE_SECRET);
                    uint result = LsaStorePrivateData(LsaPolicyHandle, ref secretName, ref lusSecretData);
                    ReleaseLsaPolicy(LsaPolicyHandle);
 
                    uint winErrorCode = LsaNtStatusToWinError(result);
                    if (winErrorCode != 0)
                    {
                        throw new Exception("StorePrivateData failed: " + winErrorCode);
                    }
                }
            }
        }
"@
    #endregion
}
 
process {

# Get hosname and domain of host         
        $sysinfo = Get-WmiObject -Class Win32_ComputerSystem
        $domain = Convert-DNStoDN($sysinfo.Domain)
        $hostname=$sysinfo.Name
	    $serverstr="LDAP://$server/$domain"
		# GeneratePassword(int length, int numberOfNonAlphanumericCharacters) 

        #Load "System.Web" assembly in PowerShell console 
        [Reflection.Assembly]::LoadWithPartialName("System.Web") | out-null

        #Calling GeneratePassword Method 
        $Password=[System.Web.Security.Membership]::GeneratePassword(10,2) 
    try {
        $ErrorActionPreference = "Stop"
       # Store the password securely.
        $root2 = New-Object System.DirectoryServices.DirectoryEntry($serverstr,$userd, $passwordd, "Secure")
		$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
		$objSearcher.SearchRoot = $root2
		$objSearcher.Filter = ("(&(objectCategory=computer)(name=$hostname*))")
		$objSearcher.SearchScope = "Subtree"
		$colResults = $objSearcher.FindOne().path
		$root = New-Object System.DirectoryServices.DirectoryEntry($colResults,$userd, $passwordd, "Secure")
        $root.psbase.invoke("SetPassword",$Password)
        #if($?){Write-Host "Reset Password Successful!"}else{Write-Host "Reset Failed"}
        $root.psbase.CommitChanges() 
        #if($?){Write-Host "Commit Changes Successful!"}else{Write-Host "Commit Changes Failed"}

        $lsaUtil = New-Object ComputerSystem.LSAutil -ArgumentList '$MACHINE.ACC'
        $lsaUtil.SetSecret($Password)
 
            
    } catch {
        throw 'Failed to set machine Account password. The error was: "{0}".' -f $_
          }
 
}
