Param (
    [string]$VMName,
    [string]$MachineName,
    [string]$OSName,
    [string]$OSVersion,
    [string]$IsServer2008R2,
    [string]$FolderPath,
    [string]$Logfile,
    [string]$TargetPortalAddress,
    [string]$TargetPortalPortNumber,
    [string]$TargetUserName,
    [string]$TargetPassword,
    [string]$InitiatorChapPassword,
    [string]$ScriptId,
    [string]$SequenceNumber,
    [string]$IsMultiTarget = "0"
)

Function LogWrite
{
   Param ([string]$logstring)
   $Timestamp=Get-Date
   $logdata="[$Timestamp] :" + $logstring
   Add-content  $Logfile -value $logdata
}
Function WaitForExit
{
    Echo "`nPress 'Q/q' key to exit ..."
    while($true)
    {
        $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if(($($x.Character) -eq "q") -or ($($x.Character) -eq "Q"))
        {
            exit
        }
    }
}

Function ConnectToTarget2008R2
{
   Param (
    [string]$TargetNodeAddress,
    [string]$TargetUserName,
    [string]$UserEnteredTargetPassword,
    [int]$NumRetriesLeft)


    if ($NumRetriesLeft -gt 0)
    {
      Try
      {
        $output = ISCSICli.exe QLoginTarget "$TargetNodeAddress" "$TargetUserName" "$UserEnteredTargetPassword"
        if( $($output.count) -gt 3 )
        {
          $success=$output[4]
        }
        else
        {
          $success=$output[2]
        }
        LogWrite "Success Status $success."
        if($success -eq "The target has already been logged in via an iSCSI session. ")
        {
            throw [System.Exception] $success
        }
        elseif($success -ne "The operation completed successfully. ")
        {
            throw [System.Exception] $success
        }
      }
      Catch
      {
        $NumRetriesLeft = $NumRetriesLeft - 1
        Write-Host "Retrying the connection to ILR after 2 mins - the target preparation is expected to take some time."
        Start-Sleep -Seconds 120
        $success = ConnectToTarget2008R2 "$TargetNodeAddress" "$TargetUserName" "$UserEnteredTargetPassword" $NumRetriesLeft
      }
    }
    else
    {
       LogWrite "Exceeded number of retries in Large Disk flow - please wait for sometime and retry running the script"
       throw [System.Exception] "Exceeded number of retries in Large Disk flow - please wait for sometime and retry running the script"
    }
    return $success
}


Function ConnectToTarget
{
   Param (
    [string]$TargetNodeAddress,
    [string]$LocalPortalAddress,
    [int]$LocalPortalPortNumber,
    [string]$TargetUserName,
    [string]$UserEnteredTargetPassword,
    [int]$NumRetriesLeft)


    if ($NumRetriesLeft -gt 0)
    {
      Try
      {
        $IscsiConnection=Connect-IscsiTarget -NodeAddress $TargetNodeAddress -TargetPortalAddress $LocalPortalAddress -TargetPortalPortNumber $LocalPortalPortNumber -AuthenticationType MUTUALCHAP -ChapUsername $TargetUserName -ChapSecret $UserEnteredTargetPassword -ErrorAction Stop
      }
      Catch
      {
        $NumRetriesLeft = $NumRetriesLeft - 1
        Write-Host "Retrying the connection to ILR after 2 mins - the target preparation is expected to take some time."
        Start-Sleep -Seconds 120
        $success = ConnectToTarget "$TargetNodeAddress" "$LocalPortalAddress" $LocalPortalPortNumber "$TargetUserName" "$UserEnteredTargetPassword" $NumRetriesLeft
      }
    }
    else
    {
       LogWrite "Exceeded number of retries in Large Disk flow - please wait for sometime and retry running the script"
       throw [System.Exception] "Exceeded number of retries in Large Disk flow - please wait for sometime and retry running the script"
    }
    return $IscsiConnection
}

Function Get-Available-Driveletter()
{
  $DriveList = Get-PSDrive -PSProvider filesystem | foreach({($_.Root).Replace(":\","")})
  $AllDrives = [char[]]([int][char]'E'..[int][char]'Z')
  $NextDriveLetter = ($AllDrives | Where-Object { $DriveList -notcontains $_ } | Select-Object -First 1) + ":"
  Return $NextDriveLetter
}

Function Mount-ILR-Volumes()
{
  $disks = Get-Disk | Where-Object {($_.FriendlyName -like '*MABILR*' -and $_.PartitionStyle -ne 'RAW')}
  $offlineDisks = $disks | Where-Object {($_.OperationalStatus -ne 'Online')}
  $offlineDisks | Set-Disk -IsOffline $False

  ForEach($disk in $disks)
  {
    $partitions = Get-Partition -DiskNumber $disk.number | Where-Object {(!$_.DriveLetter)}
    ForEach($partition in $partitions)
    {
      $DriveLetter = Get-Available-Driveletter
      $DrivePath = $DriveLetter
      Write-Host "Mounting ILR Disk to path" $DrivePath
        Try
        {
             Add-PartitionAccessPath -DiskNumber $disk.number -PartitionNumber $partition.PartitionNumber -AccessPath $DrivePath -ErrorAction SilentlyContinue
        }
        Catch
        {
              Write-Host "Ran out of Drive letters - please go to disk management and assign drive letters manually for the disks"
              $ErrorMessage = $_.Exception.Message
              $FailedItem = $_.Exception.ItemName
              LogWrite "Exception Details: $ErrorMessage, $FailedItem"
        }
      }
  }

}


LogWrite $VMName
LogWrite $MachineName
LogWrite $OSName
LogWrite $OSVersion
LogWrite $IsServer2008R2
LogWrite $FolderPath
LogWrite $Logfile
$result=[bool]::TryParse($IsServer2008R2,[ref]$isServer2008R2)
LogWrite $isServer2008R2
LogWrite $TargetPortalAddress
LogWrite $TargetPortalPortNumber
LogWrite $TargetUserName
LogWrite $SequenceNumber
LogWrite $ScriptId

if($TargetPassword -eq "UserInput123456")
{
    Echo "`n"
    $UserEnteredTargetPassword=Read-Host 'Please enter the 15 character password, shown on the portal, to securely connect to the recovery point'
    if($UserEnteredTargetPassword.Length -ne 15)
    {
         Write-Host "You need to enter the complete 15 character password as shown on the portal screen."   -foreground "red"
         Write-Host "You can use the copy button beside the generated password on the portal to copy and paste here."  -foreground "red"
         WaitForExit
    }
}
else
{
    $UserEnteredTargetPassword=$TargetPassword
}

$MyComputerName=(Get-ChildItem -path env:computername).Value
if(($isServer2008R2 -eq $false) -and (($MyComputerName.ToLower() -eq $VMName.ToLower()) -or ($MyComputerName.ToLower() -eq $MachineName.ToLower())))
{
    LogWrite "Running from Same Machine MyComputerName: $MyComputerName"
    $StoragePools=Get-StoragePool | Where-Object  FriendlyName -NE "Primordial"
    $StoragePoolCount=$StoragePools.Count
    if($StoragePoolCount -ne 0)
    {
        LogWrite "Has Storage Pools Configured: $StoragePoolCount"
        Echo "`nPlease find below the Storage space entities present in this machine."
        Echo "`nStorage Pool Friendly Name."
        Echo "-------------------------------"
        Foreach($StorageSpace in $StoragePools)
           {
               Echo "$($StorageSpace.FriendlyName)"
           }
        Write-Host "`nMount the recovery point only if you are SURE THAT THESE ARE NOT BACKED UP/ PRESENT IN THE RECOVERY POINT." -foreground "red"
        Write-Host "If they are already present, it might corrupt the data irrevocably on this machine." -foreground "red"
        Write-Host "It is recommended to run this script on any other machine with similar OS to recover files." -foreground "red"
        Write-Host "`nShould the recovery point be mounted on this machine? (Y/N) " -foreground "red"
        while($true)
        {
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if(($($x.Character) -eq "n") -or ($($x.Character) -eq "N"))
            {
                Echo "`nPlease run this script on any other machine with similar OS to recover files."
                WaitForExit
            }
            elseif(($($x.Character) -eq "y") -or ($($x.Character) -eq "Y"))
            {
                break;
            }
        }
    }
}

#Echo "For More details please check log file: $Logfile"
$LocalPortalAddress ="127.0.0.1"
$LocalPortalPortNumber =5365
$MinPort = 5365
$MaxPort = 5396
$IsProcessRunning=$false
$MABILRRegKey="hkcu:\SOFTWARE\Microsoft\Microsoft Azure Backup ILR"
$IsLargeDisk = $false
Try
{
    $ProcessId=Get-ItemProperty -Name "ProcessId" -Path "$MABILRRegKey" -ErrorAction Stop
    $PortNumber=Get-ItemProperty -Name "PortNumber" -Path "$MABILRRegKey" -ErrorAction Stop
    $LastVMName=Get-ItemProperty -Name "VMName" -Path "$MABILRRegKey" -ErrorAction Stop
    $LastTargetNodeAddress=Get-ItemProperty -Name "TargetNodeAddress" -Path "$MABILRRegKey" -ErrorAction SilentlyContinue
    $LastTargetUserName=Get-ItemProperty -Name "TargetUserName" -Path "$MABILRRegKey" -ErrorAction Stop
    LogWrite "Registry Process Id : $($ProcessId.ProcessId)"
    LogWrite "Registry PortNumber : $($PortNumber.PortNumber)"
    if($($LastTargetUserName.TargetUserName) -ne $TargetUserName)
    {
        Echo "`nWe detected a session already connected to a recovery point of the VM $($LastVMName.VMName) ."
        Echo "We need to unmount the volumes before connecting to the new recovery point of VM $VMName,"
        Echo "`nPlease enter 'Y' to proceed or 'N' to abort..."
        while($true)
        {
            $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            if(($($x.Character) -eq "n") -or ($($x.Character) -eq "N"))
            {
                Echo "It is recommended to close the earlier session before starting new connection to another RP."
                WaitForExit
            }
            elseif(($($x.Character) -eq "y") -or ($($x.Character) -eq "Y"))
            {
                break;
            }
        }
        Echo "`nPlease wait while we disconnect old session..."
        $lastline=""
        $MinPort=($($PortNumber.PortNumber)+1)
        if($MinPort -ge $MaxPort)
        {
            $MinPort=5365
        }
        $LastTargetNodeAddresses = $LastTargetNodeAddress.TargetNodeAddress.Split(";")
        if($isServer2008R2 -eq $true)
        {
          foreach ($LastTargetNodeAddress in $LastTargetNodeAddresses)
          {
  	          LogWrite "Disconnected last target : $($LastTargetNodeAddress)"
              $output=ISCSICli.exe SessionList $($LastTargetNodeAddress)
              LogWrite "Success Status $output."
              foreach ($outputline in $output)
              {
                  if($outputline.Contains($($LastTargetNodeAddress)))
                  {
                      $sessionid=$lastline.Substring(25,33)
                      LogWrite "Disconnecting Session. ID:+.$sessionid"
                      $output=ISCSICli.exe LogoutTarget $sessionid
                  }
                  $lastline=$outputline
              }
            }
        }
        else
        {
          foreach ($LastTargetNodeAddress in $LastTargetNodeAddresses)
          {
            Disconnect-IscsiTarget -NodeAddress $($LastTargetNodeAddress) -ErrorAction SilentlyContinue -Confirm:$false
          }
        }

        $Process = Get-Process -Id $($ProcessId.ProcessId) -ErrorAction SilentlyContinue
        LogWrite "Current Process Name : $($Process.Name)"
        if( $($Process.Name) -eq "SecureTCPTunnel")
        {
            LogWrite "Process is already running on Port $($PortNumber.PortNumber)"
            Stop-Process -Id $($ProcessId.ProcessId) -ErrorAction SilentlyContinue -Confirm:$false
        }
        $IsProcessRunning=$false
        if($isServer2008R2 -eq $false)
        {
            foreach ($LastTargetNodeAddress in $LastTargetNodeAddresses)
            {
              Disconnect-IscsiTarget -NodeAddress $($LastTargetNodeAddress) -ErrorAction SilentlyContinue -Confirm:$false
            }
            Remove-IscsiTargetPortal -TargetPortalAddress $LocalPortalAddress -ErrorAction SilentlyContinue -Confirm:$false
        }
        Echo "`nOlder session disconnected. Establishing a new session for the new recovery point...."
    }
    else
    {
        $Process = Get-Process -Id $($ProcessId.ProcessId) -ErrorAction SilentlyContinue
        LogWrite "Current Process Name : $($Process.Name)"
        LogWrite "Same Script was ran earlier."
        $MinPort = $($PortNumber.PortNumber)
        $MaxPort = $($PortNumber.PortNumber)
        if( $($Process.Name) -eq "SecureTCPTunnel")
        {
            LogWrite "Process is already running on Port $($PortNumber.PortNumber)"
            $IsProcessRunning=$false
            Stop-Process -Id $($ProcessId.ProcessId) -ErrorAction SilentlyContinue -Confirm:$false
        }
    }
}
Catch
{
    LogWrite "Process is not running."
    $IsProcessRunning=$false
    $PortNumber=$null
    LogWrite "Exception Details: $ErrorMessage, $FailedItem"
}
if(!$IsProcessRunning)
{
    $ActivationId=Get-Random -Maximum 10000
    $SecureTCPTunnel = "$FolderPath\SecureTCPTunnel.exe"
    $SecureTCPTunnelLogfile = $FolderPath + "\SecureTCPTunnelLogFile.log"

    $Process=Start-Process -FilePath $SecureTCPTunnel -ArgumentList "$MinPort $MaxPort $TargetPortalAddress $TargetPortalPortNumber $TargetUserName $VMName $ActivationId $SecureTCPTunnelLogfile"  -PassThru -WindowStyle Hidden
    $MaxProcessWaitRetry = 20
    $CurrentProcessWaitRetryCount = 0
    while($CurrentProcessWaitRetryCount -lt $MaxProcessWaitRetry)
    {
        $ActivationIdReg=Get-ItemProperty -Name "ActivationId" -Path "$MABILRRegKey" -ErrorAction SilentlyContinue

        if($($Process.HasExited))
        {
            LogWrite "SecureTCPTunnel is exited with exception."
            LogWrite "Exit Code: $($Process.ExitCode)"
            Echo "Failed to create Secure TCP Tunnel for ISCSI. Please retry after sometime."
            break;
        }
        if($($ActivationIdReg.ActivationId) -eq $ActivationId)
        {
            LogWrite "Process started and activation id is successfully set."
            $PortNumber=Get-ItemProperty -Name "PortNumber" -Path "hkcu:\SOFTWARE\Microsoft\Microsoft Azure Backup ILR" -ErrorAction Stop
            $LocalPortalPortNumber=$($PortNumber.PortNumber)
            LogWrite "SecureTCPTunnel is listening on Port=$LocalPortalPortNumber"
            try
            {
                # Remove inheritance
                $acl = Get-Acl $MABILRRegKey
                $acl.SetAccessRuleProtection($true,$true)
                Set-Acl $MABILRRegKey $acl
                # Remove ACL
                $acl = Get-Acl $MABILRRegKey
                $acl.Access | %{$acl.RemoveAccessRule($_)} | Out-Null
                # Add local admin
                $permission  = "BUILTIN\Administrators","FullControl", "ContainerInherit,ObjectInherit","None","Allow"
                $rule = New-Object System.Security.AccessControl.RegistryAccessRule $permission
                $acl.SetAccessRule($rule)
                Set-Acl $MABILRRegKey $acl
            }
            catch
            {
                LogWrite "Exception Details: $ErrorMessage, $FailedItem"
                LogWrite "Failed to ACL Registry"
            }
            break;
        }
        $CurrentProcessWaitRetryCount = $CurrentProcessWaitRetryCount + 1
        Start-Sleep -Milliseconds 100
    }
    if($MaxProcessWaitRetry -eq $CurrentProcessWaitRetryCount)
    {
        LogWrite "Activation ID is not updated by process. SecureTCPTunnel process failed to connect."
        Echo "`Unable to access the recovery point. Please make sure that you have enabled access to Azure public IP addresses on the outbound port 3260 and 'https://download.microsoft.com/'"
        WaitForExit
    }
}
Try
{
    Echo "`nConnecting to recovery point using ISCSI service...."

    $job=Start-Job -ScriptBlock {Get-WmiObject -Class Win32_LogicalDisk}
$dpscript = @"
list disk
"@
[array]$Temp = $dpscript | diskpart
    ForEach ($Line in $Temp)
    {
       If ($Line.StartsWith("  Disk"))
       {
               [array]$DisksBefore += $Line
       }
    }
    $DiskCountBeforeConnection = $DisksBefore.Count
}
Catch
{
    LogWrite "Warning: Failed to get Disk Count from DiskPart."
}
$ConnectionSucceeded=$false
Try
{
    LogWrite "Starting MSiSCSI Service..."
    Start-Service MSiSCSI
    LogWrite "MSiSCSI Service Started Successfully."
    if($isServer2008R2 -eq $true)
    {
	    LogWrite "Discovering Targets from Portal: $TargetPortalAddress, $TargetPortalPortNumber"
        $output=ISCSICli.exe AddTargetPortal $LocalPortalAddress $LocalPortalPortNumber * * * * * * * * * $TargetUserName $UserEnteredTargetPassword 1
        $success=$output[2]
        Logwrite $output
        LogWrite "Success Status $success."
        if($success -ne "The operation completed successfully. ")
        {
            throw [System.Exception] $success
        }
        LogWrite "Fetching target list"
        $output=ISCSICli.exe ListTargets
        $success=$output[$output.Count-1]
        Logwrite $output
        LogWrite "Success Status $success."
        if($success -ne "The operation completed successfully. ")
        {
            throw [System.Exception] $success
        }
        LogWrite "Total Targets Found : $($output.Count)"
        $UserNameFields=$TargetUserName.Split(';')
        $UserName=$UserNameFields[2].Split('-')
        LogWrite "Resource ID: $($UserName[0])"
        foreach($node in $output)
        {
            LogWrite "Target Name: $node"
            if( $node.contains($UserName[0]) -and $node.contains($SequenceNumber))
            {
                 $TargetNodeAddress=$node.trim()
        	    LogWrite "Fetch Target Succeeded."
        	    LogWrite ("Target Found $TargetNodeAddress")
                $output=ISCSICli.exe QLoginTarget "$TargetNodeAddress" "$TargetUserName" "$UserEnteredTargetPassword"
                if( $($output.count) -gt 3 )
                {
                    $success=$output[4]
                }
                else
                {
                    $success=$output[2]
                }
                LogWrite "Success Status $success."
                if($success -eq "The target has already been logged in via an iSCSI session. ")
                {
                    throw [System.Exception] $success
                }
                elseif($success -ne "The operation completed successfully. ")
                {
                    throw [System.Exception] $success
                }
	              
            }
        }
     }
      else
    	{
	      LogWrite "Setting up initiators Chap Secret..."
        Set-IscsiChapSecret -ChapSecret $InitiatorChapPassword -ErrorAction Stop
        LogWrite "Discovering Targets from Portal: $TargetPortalAddress, $TargetPortalPortNumber"
        LogWrite "Discovery params: $LocalPortalAddress, $LocalPortalPortNumber, $TargetUserName"
        $IscsiTargetPortal=New-IscsiTargetPortal -TargetPortalAddress $LocalPortalAddress -TargetPortalPortNumber $LocalPortalPortNumber -AuthenticationType MUTUALCHAP -ChapUsername $TargetUserName -ChapSecret $UserEnteredTargetPassword -ErrorAction Stop
        LogWrite "Discovery Succeeded."
        $TargetNodes=Get-IscsiTarget
        LogWrite "Total Targets Found : $($TargetNodes.Count)"
        $MaxRetryCount = 10
        $UserNameFields=$TargetUserName.Split(';')
        $UserName=$UserNameFields[2].Split('-')
        LogWrite "Resource ID: $($UserName[0])"
        $NotReadyCount = 0
        $TargetNodeArray = [System.Collections.ArrayList]@()
        $ReadyTargetMap = @{}
        $ReadyTargets = [System.Collections.ArrayList]@()
        
        # get the list of notready targets
        foreach($TargetNode in $TargetNodes)
        {
          $TargetAddress = $TargetNode.NodeAddress.ToString()
          if($TargetAddress.ToString().contains($UserName[0]) -and $TargetAddress.ToString().contains($SequenceNumber))
          {
              $TargetNodeArray.Add($TargetAddress.ToLower())
              if ($TargetAddress.ToLower().contains("notready"))
              {
                $readyTargetKey = $TargetAddress.ToLower() -replace "-notready"
                $ReadyTargetMap[$readyTargetKey] = $false
                $IsLargeDisk =$true
              }
          }
        }

        foreach($TargetNode in $TargetNodes)
        {
            $TargetAddress = $TargetNode.NodeAddress.ToString()
            if($TargetAddress.ToString().contains($UserName[0]) -and $TargetAddress.ToString().contains($SequenceNumber))
            {
                if (!$TargetAddress.ToLower().contains("notready"))
                {
                    $readyTargetKey = $TargetAddress.ToLower()
                    $ReadyTargetMap[$readyTargetKey] = $true
                }
            }
        }

        $ReadyTargets = $ReadyTargetMap.Keys
        foreach($ReadyTarget in $ReadyTargets)
        {
            if(!$ReadyTargetMap[$ReadyTarget])
            {
                $NotReadyCount = $NotReadyCount + 1
            }
        }

        while($MaxRetryCount -gt 0 -and $NotReadyCount -gt 0)
        {
          Write-Host "Preparing the iSCSI target in Azure Backup service..."
          LogWrite "Retrying the connection to ILR after 2 mins - the target preparation is expected to take some time for large disks."
          Start-Sleep -Seconds 120
          LogWrite "Removing Not ready Target"
          Get-IscsiTarget | Where-Object NodeAddress -Like '*notready*' | ForEach-Object { Disconnect-IscsiTarget -NodeAddress $_.NodeAddress -ErrorAction SilentlyContinue -Confirm:$false }
          LogWrite "Removing older session"
          Remove-IscsiTargetPortal -TargetPortalAddress $LocalPortalAddress -ErrorAction SilentlyContinue -Confirm:$false
          LogWrite "Discovering Targets from Portal: $TargetPortalAddress, $TargetPortalPortNumber"
          LogWrite "Discovery params: $LocalPortalAddress, $LocalPortalPortNumber, $TargetUserName"
          $IscsiTargetPortal=New-IscsiTargetPortal -TargetPortalAddress $LocalPortalAddress -TargetPortalPortNumber $LocalPortalPortNumber -AuthenticationType MUTUALCHAP -ChapUsername $TargetUserName -ChapSecret $UserEnteredTargetPassword -ErrorAction Stop
          LogWrite "Discovery Succeeded."
          $TargetNodes=Get-IscsiTarget
          LogWrite "Total Targets Found : $($TargetNodes.Count)"

          #populate the ReadyTargetMap
          foreach($TargetNode in $TargetNodes)
          {
            $TargetAddress = $TargetNode.NodeAddress.ToString()
            if($TargetAddress.ToString().contains($UserName[0]) -and $TargetAddress.ToString().contains($SequenceNumber))
            {
                $CurrentTargetName = $TargetAddress.ToLower()
                if (!$CurrentTargetName.contains("notready"))
                {
                    $ReadyTargetMap[$CurrentTargetName] = $true
                }
            }
          }
          $NotReadyCount = 0
          $ReadyTargets = $ReadyTargetMap.Keys
          foreach($ReadyTarget in $ReadyTargets)
          {
              if(!$ReadyTargetMap[$ReadyTarget])
              {
                  $NotReadyCount = $NotReadyCount + 1
              }
          }
          $MaxRetryCount = $MaxRetryCount - 1
        }

        $NotReadyCount = 0
        foreach($ReadyTarget in $ReadyTargets)
        {
            if(!$ReadyTargetMap[$ReadyTarget])
            {
                $NotReadyCount = $NotReadyCount + 1
            }
        }

        if($NotReadyCount -gt 0)
        {
          Write-Host "Try running the script after few minutes. The Target preparation for large disk is expected to take time."
          LogWrite "Try running the script after few minutes. The Target preparation for large disk is expected to take time."
          WaitForExit
        }

        $TargetNodeAddresses = [System.Collections.ArrayList]@()
        LogWrite "Targets are Ready, trying to connect"
        Write-Host "iSCSI target prepared"
        foreach($TargetNode in $ReadyTargets)
        {
            LogWrite "Target Name: $($TargetNode.ToString()), SequenceNumber: $SequenceNumber"
            $TargetAddress = $TargetNode
            if(!$TargetAddress.ToLower().contains("notready") -and $TargetAddress.contains($UserName[0]) -and $TargetAddress.contains($SequenceNumber) )
            {
                 $TargetNodeAddress=$TargetAddress
        	       LogWrite ("Target Found, $TargetNodeAddress")
		           LogWrite ("Username, $UserName[0]")
        	       LogWrite "Connecting to target $TargetNodeAddress..."
	            Try
	            {
	              LogWrite "Connecting to Target: Connect-IscsiTarget -NodeAddress $TargetNodeAddress -TargetPortalAddress $LocalPortalAddress -TargetPortalPortNumber $LocalPortalPortNumber"
	              $IscsiConnection=Connect-IscsiTarget -NodeAddress $TargetNodeAddress -TargetPortalAddress $LocalPortalAddress -TargetPortalPortNumber $LocalPortalPortNumber -AuthenticationType MUTUALCHAP -ChapUsername $TargetUserName -ChapSecret $UserEnteredTargetPassword -ErrorAction Stop
	            }
	            Catch
	            {
	                $ErrorMessage = $_.Exception.Message
	                $FailedItem = $_.Exception.ItemName
	                if(!($ErrorMessage -cmatch "The target has already been logged in via an iSCSI session. "))
	                {
	                   throw
	                }
	            }

                  $TargetNodeAddresses.Add($TargetNodeAddress)
            }
      	}
        $TargetNodeAddressRegValue = $TargetNodeAddresses -join ";"
        LogWrite "Connection succeeded!"
        LogWrite "Operating System will load your Disks and Volumes."
        LogWrite "Wait few minutes and your volumes will appear in Explorer."
        Write-Host "`nConnection succeeded!"  -foreground "green"
        Echo "`nPlease wait while we attach volumes of the recovery point."
        if ($IsLargeDisk -eq $true)
        {
            Echo "`n For recovery points of virtual machines with > 4TB data disks, attaching will take time and is dependent on iSCSI service and the number of disks..."
        }
        else
        {
            Echo "`n*************  Open Explorer to browse for files  *************"
            Echo "`nAfter recovery, to remove the disks and close the connection to the recovery point, please click 'Unmount Disks' in step 3 of the portal."
        }
        #Echo "Operating System will load your Disks and Volumes."
        #Echo "Please Wait for few seconds and your volumes will appear in Explorer."
        Set-ItemProperty  -Name "TargetNodeAddress" -Value "$TargetNodeAddressRegValue" -Path "hkcu:\SOFTWARE\Microsoft\Microsoft Azure Backup ILR" -ErrorAction Stop
        $ConnectionSucceeded=$true
    }
}
Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    if($ErrorMessage -eq "The target has already been logged in via an iSCSI session. ")
    {
        Echo "`n$ErrorMessage"
        $NewVolumesReg=Get-ItemProperty -Name "NewVolumesList" -Path "$MABILRRegKey" -ErrorAction SilentlyContinue
        if($NewVolumesReg)
        {
           $RegVolumesList = $NewVolumesReg.NewVolumesList.Split(';')
           Echo "`n$($RegVolumesList.Count-1) recovery volumes attached"
           Foreach($RegVolume in $RegVolumesList)
           {
               if($RegVolume)
               {
                   Write-Host "`n$RegVolume" -foreground "green"
               }
           }
        }
        Echo "`n*************  Open Explorer to browse for files  *************"
    }
    elseif($ErrorMessage -eq "Authentication Failure. ")
    {
    Write-Host "`nThis script cannot connect to the recovery point. Either the password entered is invalid or the disks have been unmounted. Please enter the correct password or download a new script from the portal."  -foreground "red"
    }
    else
    {
        Write-Host "`nException caught while connecting to Target. Please retry after some time."  -foreground "red"
    }
    LogWrite "Exception Details: $ErrorMessage, $FailedItem"
    LogWrite "Exception caught while connecting to Target. Please retry after some time."
    Write-Host "If this vm contains disks greater than 4TB and if you have tried connecting to the recovery point immediately. Please wait for some more time and rerun the script - the disk initialization might not be complete in our service."
}

Try
{
if( $ConnectionSucceeded -eq $true )
  {
      Start-Sleep -Seconds 10
      $MaxRetryCount=12
      $RetryCount=0
      LogWrite "Current Disk Count = $DiskCountBeforeConnection"
      while($RetryCount -le $MaxRetryCount)
      {
          remove-variable Temp -ErrorAction SilentlyContinue
          remove-variable Disks -ErrorAction SilentlyContinue
          [array]$Temp = $dpscript | diskpart
          $newDiskFound=$false
          ForEach ($Line in $Temp)
          {
                If ($Line.StartsWith("  Disk"))
                {
                  $isOld=$false
                  ForEach ($OldLine in $DisksBefore)
                  {
                      if($Line -eq $OldLine)
                      {
                          $isOld=$true
                      }
                  }
                  if($isOld -eq $false)
                  {
                      [array]$Disks += $Line
                      $newDiskFound=$true
                  }
                }
          }
          $DiskCountAfterConnection = $Disks.Count
          LogWrite "New Disk Count = $DiskCountAfterConnection"
          if($newDiskFound)
          {
              LogWrite "New disks are added to System."
              break;
          }
          $RetryCount=$RetryCount+1;
          Start-Sleep -Seconds 5
      }
      For ($i=0;$i -le ($Disks.count-1);$i++)
      {
         $currLine = $Disks[$i]
         $currLine -Match "  Disk (?<disknum>...) +(?<sts>.............) +(?<sz>.......) +(?<fr>.......) +(?<dyn>...) +(?<gpt>...)" | Out-Null
         $DiskObj =  New-Object PSObject
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DiskNumber" -Value $Matches['disknum'].Trim()
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Status" -Value $Matches['sts'].Trim()
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Size" -Value $Matches['sz'].Trim()
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Free" -Value $Matches['fr'].Trim()
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Dyn" -Value $Matches['dyn'].Trim()
         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Gpt" -Value $Matches['gpt'].Trim()
        $isDyn=$Matches['dyn'].Trim()
        LogWrite "Disk:$($DiskObj.DiskNumber), DiskStatus:$($DiskObj.Status) , isDynamic:$isDyn"
          If (($isDyn -eq "*") -or ($DiskObj.Status -eq "Offline"))
       {
  $dpscript = @"
select disk $($DiskObj.DiskNumber)
detail disk
"@
         [array]$Temp = $dpscript | diskpart
         ForEach ($Line in $Temp)
         {
                 If ($Line -cmatch "Disk ID" -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DiskID" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Type") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DetailType" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Status") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "DetailStatus" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Path") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Path" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Target") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "Target" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("LUN ID") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "LUNID" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Location Path") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "LocationPath" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Current Read-only State") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "CurrentReadOnlyState" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Read-only") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "ReadOnly" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Boot Disk") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "BootDisk" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Pagefile Disk") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "PagefileDisk" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Hibernation File Disk") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "HibernationFileDisk" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Crashdump Disk") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "CrashdumpDisk" -Value $Line.Split(":")[1].Trim()
                 }
                 ElseIf ($Line.StartsWith("Clustered Disk") -and $Line -match ":")
                 {
                         Add-Member -InputObject $DiskObj -MemberType NoteProperty -Name "ClusteredDisk" -Value $Line.Split(":")[1].Trim()
                 }
         }
  }
     [array]$DiskResults += $DiskObj
  }
  if($isServer2008R2 -eq $true)
  {
  	$UnhealthyDisksCount=0
  }
  else
  {
  	$UnhealthyDisks=Get-PhysicalDisk | Where-Object {($_.OperationalStatus -ne "OK" -or $_.HealthStatus -ne "Healthy") -and $_.Manufacturer -eq "MABILR I"}
  	$UnhealthyDisksCount=$UnhealthyDisks.Count
  }
  if($UnhealthyDisksCount -gt 0)
  {
  LogWrite "Detected Unhealthy Disks in ILR. Total Unhealthy Disk Count =$UnhealthyDisksCount"
  Write-Host "`nWindows detected identical disk/storage pool configuration and prevented import. Please run this script from another machine with similar OS." -foreground "red"
  }
  else
  {
  $dpscript="";
  ForEach ($Disk in $DiskResults)
  {
     If ($Disk.DetailType -eq "iSCSI")
     {
          LogWrite "Detected ISCSI Disk. Disk Number= $($Disk.DiskNumber)"
          if($Disk.Status -eq "Offline")
          {
          LogWrite "Disk is in Offline State. Disk Number= $($Disk.DiskNumber) "
  $dpscript += @"
""
select disk $($Disk.DiskNumber)
online disk
"@
          }
             If ($Disk.DetailStatus -eq "Foreign")
         {
          LogWrite "Detected Dynamic disk. Disk Number= $($Disk.DiskNumber)"
             [array]$iSCSIForeignDisks += $Disk
  $dpscript += @"
""
select disk $($Disk.DiskNumber)
import NoErr
"@
             }
     }
  }
  LogWrite $DiskResults
  LogWrite $dpscript
  $Temp = $dpscript | diskpart
  LogWrite $Temp
  Start-Sleep -Seconds 5
  $MaxJobRetryCount=300
  $CurrentJobRetryCount=0
  while($CurrentJobRetryCount -lt $MaxJobRetryCount)
  {
      $jobstate=$job.JobStateInfo.State
      LogWrite "Status $jobstate"
      if(($job.JobStateInfo.State -ne "Running") -and ($job.JobStateInfo.State -ne "NotStarted"))
      {
         break;
      }
      $CurrentJobRetryCount=$CurrentJobRetryCount+1
      Start-Sleep -Milliseconds 1000
  }
  if($job.JobStateInfo.State -ne "Completed")
  {
      LogWrite "Failed to fetch Volume List. Status $($job.State) , Error : $($job.Error)"
  }
  else
  {
      $VolumesBeforeConnection=Receive-Job -Job $job
      $job=Start-Job -ScriptBlock {Get-WmiObject -Class Win32_LogicalDisk}
      $CurrentJobRetryCount=0
      while($CurrentJobRetryCount -lt $MaxJobRetryCount)
      {
  	$jobstate=$job.JobStateInfo.State
  	LogWrite "Status $jobstate"
          if(($job.JobStateInfo.State -ne "Running") -and ($job.JobStateInfo.State -ne "NotStarted"))
          {
             break;
          }
          $CurrentJobRetryCount=$CurrentJobRetryCount+1
          Start-Sleep -Milliseconds 1000
      }
      if($job.JobStateInfo.State -ne "Completed")
      {
          LogWrite "Failed to fetch Volume List. Status $($job.State) , Error : $($job.Error)"
      }
      else
      {
          $VolumesAfterConnection=Receive-Job -Job $job
          $NewVolumes=""
          ForEach($Volume in $VolumesAfterConnection)
          {
              $isnew=$true
              ForEach($VolumeOld in $VolumesBeforeConnection)
              {
                  if($($Volume.Name) -eq $($VolumeOld.Name))
                  {
                      $isnew=$false
                  }
              }
              if($isnew)
              {
                  if($($Volume.VolumeName))
                  {
                     $VolumeLabel=$($Volume.VolumeName)
                  }
                  else
                  {
                     $VolumeLabel="Local Disk"
                  }
                  [array]$NewVolumesList += "$($Volume.Name)\$VolumeLabel"
                  $NewVolumesString += "$($Volume.Name)\$VolumeLabel;"
              }
          }
          Echo "`n$($NewVolumesList.Count) recovery volumes attached"
          ForEach($VolumeName in $NewVolumesList)
          {
              Write-Host "`n$VolumeName"  -foreground "green"
          }
          Set-ItemProperty -Name "NewVolumesList" -Path "$MABILRRegKey" -Value "$NewVolumesString" -ErrorAction SilentlyContinue
      }
  }
    Mount-ILR-Volumes
    if ($IsLargeDisk -eq $true)
    {
        Echo "`n You are using large disks - disk size greater than 4tb. Please wait for sometime until all disks come up."
    }
    else
    {
        Echo "`n*************  Open Explorer to browse for files  *************"
        Echo "`nAfter recovery, to remove the disks and close the connection to the recovery point, please click 'Unmount Disks' in step 3 of the portal."
    }
  }
}
}
Catch
{
$ErrorMessage = $_.Exception.Message
$FailedItem = $_.Exception.ItemName
LogWrite "Exception Details: $ErrorMessage, $FailedItem"
LogWrite "Exception caught while importing Dynamic Disks. Please retry after some time."
Write-Host "Exception caught while loading the Disks. Please retry after some time."  -foreground "red"
}
WaitForExit

# SIG # Begin signature block
# MIIdkgYJKoZIhvcNAQcCoIIdgzCCHX8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGJJo204iU8+dv2QjtqqZ2rHL
# o6+gghhuMIIE3jCCA8agAwIBAgITMwAAASowv4XFDrHijAAAAAABKjANBgkqhkiG
# 9w0BAQUFADB3MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEw
# HwYDVQQDExhNaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EwHhcNMTkwOTA2MjA0MDAx
# WhcNMjAxMjA0MjA0MDAxWjCBzjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEpMCcGA1UECxMgTWljcm9zb2Z0IE9wZXJhdGlvbnMgUHVlcnRvIFJp
# Y28xJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjdEMkUtMzc4Mi1CMEY3MSUwIwYD
# VQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEAwf897kPTp3rbi0IXPL5mIk8+sxQXOySrxq6u0dcS
# DM/j0UPJ44b1+NHiKMjg/rEljKeQv3Gv1+DReO5/l5WVIUG30aRshd+lhMTbloXt
# pdpE0pvbxYYTsoR7mTjq9895SRDNoBN0BPpRHgsXKSDlIG4x+FiZHGuDHj4QTnw9
# 5gDscz7Jx7ay2VUTf6VojlQru1Zn5WikxW2XL/C6FPL27+UNNz0xvR8/ZAPPorin
# PM/Tt3tDaZgpNV0833cpY8jR2/ASMlnMQ8lm+KxaSQ3GPv3l3cxzByqtW3zhHC0I
# r5Li5M1kcW4YCLYUGAwAz7F1p648jeLfzJZlKsNE8+tbUwIDAQABo4IBCTCCAQUw
# HQYDVR0OBBYEFGh44LoptAA0a6kNmt0IAGmQFJOxMB8GA1UdIwQYMBaAFCM0+NlS
# RnAK7UD7dvuzK7DDNbMPMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly9jcmwubWlj
# cm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY3Jvc29mdFRpbWVTdGFtcFBD
# QS5jcmwwWAYIKwYBBQUHAQEETDBKMEgGCCsGAQUFBzAChjxodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY3Jvc29mdFRpbWVTdGFtcFBDQS5jcnQw
# EwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQEFBQADggEBAJiZBBAy3E41
# jbTxZjTkjaAKGfCni80OIPE5eJm4NpHbdkLaEdmFoN2/Ii4kohXydn23JtoiHy62
# ByvMAprROcqK0DIBx5IoXgA9B5nyd5h9Um3bZxYNvXKSI9tbFKcMdYI/OS7mj2PL
# RM33lGHUDGPpFNCilw3lVMzEdfYW22Va/caVeNT1o+MfmdFv22umoZNyDOyxKCLY
# +6Qp+hd8hMVNUxuVJ34i0RA7SJSjcPLrbNlOXay2h4z0iI4szcFFJDCqJPg8hOiG
# cBn5FPDopfdX62QZRDicLtsannm60AN5vJwElmxRihxigHMdWRRw57arqlWpFLAI
# mlhJkCFxeJswggX/MIID56ADAgECAhMzAAABUZ6Nj0Bxow5BAAAAAAFRMA0GCSqG
# SIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# KDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwHhcNMTkw
# NTAyMjEzNzQ2WhcNMjAwNTAyMjEzNzQ2WjB0MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNyb3NvZnQgQ29ycG9yYXRpb24w
# ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCVWsaGaUcdNB7xVcNmdfZi
# VBhYFGcn8KMqxgNIvOZWNH9JYQLuhHhmJ5RWISy1oey3zTuxqLbkHAdmbeU8NFMo
# 49Pv71MgIS9IG/EtqwOH7upan+lIq6NOcw5fO6Os+12R0Q28MzGn+3y7F2mKDnop
# Vu0sEufy453gxz16M8bAw4+QXuv7+fR9WzRJ2CpU62wQKYiFQMfew6Vh5fuPoXlo
# N3k6+Qlz7zgcT4YRmxzx7jMVpP/uvK6sZcBxQ3WgB/WkyXHgxaY19IAzLq2QiPiX
# 2YryiR5EsYBq35BP7U15DlZtpSs2wIYTkkDBxhPJIDJgowZu5GyhHdqrst3OjkSR
# AgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEEAYI3TAgBBggrBgEFBQcDAzAd
# BgNVHQ4EFgQUV4Iarkq57esagu6FUBb270Zijc8wUAYDVR0RBEkwR6RFMEMxKTAn
# BgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMRYwFAYDVQQF
# Ew0yMzAwMTIrNDU0MTM1MB8GA1UdIwQYMBaAFEhuZOVQBdOCqhc3NyK1bajKdQKV
# MFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lv
# cHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0wNy0wOC5jcmwwYQYIKwYBBQUH
# AQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtp
# b3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0wNy0wOC5jcnQwDAYDVR0T
# AQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAWg+ArS4Anq7KrogslIQnoMHSXUPr
# /RqOIhJX+32ObuY3MFvdlRElbSsSJxrRy/OCCZdSse+f2AqQ+F/2aYwBDmUQbeMB
# 8n0pYLZnOPifqe78RBH2fVZsvXxyfizbHubWWoUfNW/FJlZlLXwJmF3BoL8E2p09
# K3hagwz/otcKtQ1+Q4+DaOYXWleqJrJUsnHs9UiLcrVF0leL/Q1V5bshob2OTlZq
# 0qzSdrMDLWdhyrUOxnZ+ojZ7UdTY4VnCuogbZ9Zs9syJbg7ZUS9SVgYkowRsWv5j
# V4lbqTD+tG4FzhOwcRQwdb6A8zp2Nnd+s7VdCuYFsGgI41ucD8oxVfcAMjF9YX5N
# 2s4mltkqnUe3/htVrnxKKDAwSYliaux2L7gKw+bD1kEZ/5ozLRnJ3jjDkomTrPct
# okY/KaZ1qub0NUnmOKH+3xUK/plWJK8BOQYuU7gKYH7Yy9WSKNlP7pKj6i417+3N
# a/frInjnBkKRCJ/eYTvBH+s5guezpfQWtU4bNo/j8Qw2vpTQ9w7flhH78Rmwd319
# +YTmhv7TcxDbWlyteaj4RK2wk3pY1oSz2JPE5PNuNmd9Gmf6oePZgy7Ii9JLLq8S
# nULV7b+IP0UXRY9q+GdRjM2AEX6msZvvPCIoG0aYHQu9wZsKEK2jqvWi8/xdeeeS
# I9FN6K1w4oVQM4MwggYHMIID76ADAgECAgphFmg0AAAAAAAcMA0GCSqGSIb3DQEB
# BQUAMF8xEzARBgoJkiaJk/IsZAEZFgNjb20xGTAXBgoJkiaJk/IsZAEZFgltaWNy
# b3NvZnQxLTArBgNVBAMTJE1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhv
# cml0eTAeFw0wNzA0MDMxMjUzMDlaFw0yMTA0MDMxMzAzMDlaMHcxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xITAfBgNVBAMTGE1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ+h
# bLHf20iSKnxrLhnhveLjxZlRI1Ctzt0YTiQP7tGn0UytdDAgEesH1VSVFUmUG0KS
# rphcMCbaAGvoe73siQcP9w4EmPCJzB/LMySHnfL0Zxws/HvniB3q506jocEjU8qN
# +kXPCdBer9CwQgSi+aZsk2fXKNxGU7CG0OUoRi4nrIZPVVIM5AMs+2qQkDBuh/NZ
# MJ36ftaXs+ghl3740hPzCLdTbVK0RZCfSABKR2YRJylmqJfk0waBSqL5hKcRRxQJ
# gp+E7VV4/gGaHVAIhQAQMEbtt94jRrvELVSfrx54QTF3zJvfO4OToWECtR0Nsfz3
# m7IBziJLVP/5BcPCIAsCAwEAAaOCAaswggGnMA8GA1UdEwEB/wQFMAMBAf8wHQYD
# VR0OBBYEFCM0+NlSRnAK7UD7dvuzK7DDNbMPMAsGA1UdDwQEAwIBhjAQBgkrBgEE
# AYI3FQEEAwIBADCBmAYDVR0jBIGQMIGNgBQOrIJgQFYnl+UlE/wq4QpTlVnkpKFj
# pGEwXzETMBEGCgmSJomT8ixkARkWA2NvbTEZMBcGCgmSJomT8ixkARkWCW1pY3Jv
# c29mdDEtMCsGA1UEAxMkTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9y
# aXR5ghB5rRahSqClrUxzWPQHEy5lMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9j
# cmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL21pY3Jvc29mdHJvb3Rj
# ZXJ0LmNybDBUBggrBgEFBQcBAQRIMEYwRAYIKwYBBQUHMAKGOGh0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljcm9zb2Z0Um9vdENlcnQuY3J0MBMG
# A1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBBQUAA4ICAQAQl4rDXANENt3p
# tK132855UU0BsS50cVttDBOrzr57j7gu1BKijG1iuFcCy04gE1CZ3XpA4le7r1ia
# HOEdAYasu3jyi9DsOwHu4r6PCgXIjUji8FMV3U+rkuTnjWrVgMHmlPIGL4UD6ZEq
# JCJw+/b85HiZLg33B+JwvBhOnY5rCnKVuKE5nGctxVEO6mJcPxaYiyA/4gcaMvnM
# MUp2MT0rcgvI6nA9/4UKE9/CCmGO8Ne4F+tOi3/FNSteo7/rvH0LQnvUU3Ih7jDK
# u3hlXFsBFwoUDtLaFJj1PLlmWLMtL+f5hYbMUVbonXCUbKw5TNT2eb+qGHpiKe+i
# myk0BncaYsk9Hm0fgvALxyy7z0Oz5fnsfbXjpKh0NbhOxXEjEiZ2CzxSjHFaRkMU
# vLOzsE1nyJ9C/4B5IYCeFTBm6EISXhrIniIh0EPpK+m79EjMLNTYMoBMJipIJF9a
# 6lbvpt6Znco6b72BJ3QGEe52Ib+bgsEnVLaxaj2JoXZhtG6hE6a/qkfwEm/9ijJs
# sv7fUciMI8lmvZ0dhxJkAj0tr1mPuOQh5bWwymO0eFQF1EEuUKyUsKV4q7OglnUa
# 2ZKHE3UiLzKoCG6gW4wlv6DvhMoh1useT8ma7kng9wFlb4kLfchpyOZu6qeXzjEp
# /w7FW1zYTRuh2Povnj8uVRZryROj/TCCB3owggVioAMCAQICCmEOkNIAAAAAAAMw
# DQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhv
# cml0eSAyMDExMB4XDTExMDcwODIwNTkwOVoXDTI2MDcwODIxMDkwOVowfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAKvw+nIQHC6t2G6qghBNNLrytlghn0IbKmvpWlCquAY4GgRJun/D
# DB7dN2vGEtgL8DjCmQawyDnVARQxQtOJDXlkh36UYCRsr55JnOloXtLfm1OyCizD
# r9mpK656Ca/XllnKYBoF6WZ26DJSJhIv56sIUM+zRLdd2MQuA3WraPPLbfM6XKEW
# 9Ea64DhkrG5kNXimoGMPLdNAk/jj3gcN1Vx5pUkp5w2+oBN3vpQ97/vjK1oQH01W
# KKJ6cuASOrdJXtjt7UORg9l7snuGG9k+sYxd6IlPhBryoS9Z5JA7La4zWMW3Pv4y
# 07MDPbGyr5I4ftKdgCz1TlaRITUlwzluZH9TupwPrRkjhMv0ugOGjfdf8NBSv4yU
# h7zAIXQlXxgotswnKDglmDlKNs98sZKuHCOnqWbsYR9q4ShJnV+I4iVd0yFLPlLE
# tVc/JAPw0XpbL9Uj43BdD1FGd7P4AOG8rAKCX9vAFbO9G9RVS+c5oQ/pI0m8GLhE
# fEXkwcNyeuBy5yTfv0aZxe/CHFfbg43sTUkwp6uO3+xbn6/83bBm4sGXgXvt1u1L
# 50kppxMopqd9Z4DmimJ4X7IvhNdXnFy/dygo8e1twyiPLI9AN0/B4YVEicQJTMXU
# pUMvdJX3bvh4IFgsE11glZo+TzOE2rCIF96eTvSWsLxGoGyY0uDWiIwLAgMBAAGj
# ggHtMIIB6TAQBgkrBgEEAYI3FQEEAwIBADAdBgNVHQ4EFgQUSG5k5VAF04KqFzc3
# IrVtqMp1ApUwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGG
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUci06AjGQQ7kUBU7h6qfHMdEj
# iTQwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3Br
# aS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAzXzIyLmNybDBe
# BggrBgEFBQcBAQRSMFAwTgYIKwYBBQUHMAKGQmh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0MjAxMV8yMDExXzAzXzIyLmNydDCB
# nwYDVR0gBIGXMIGUMIGRBgkrBgEEAYI3LgMwgYMwPwYIKwYBBQUHAgEWM2h0dHA6
# Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvZG9jcy9wcmltYXJ5Y3BzLmh0bTBA
# BggrBgEFBQcCAjA0HjIgHQBMAGUAZwBhAGwAXwBwAG8AbABpAGMAeQBfAHMAdABh
# AHQAZQBtAGUAbgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAZ/KGpZjgVHkaLtPY
# dGcimwuWEeFjkplCln3SeQyQwWVfLiw++MNy0W2D/r4/6ArKO79HqaPzadtjvyI1
# pZddZYSQfYtGUFXYDJJ80hpLHPM8QotS0LD9a+M+By4pm+Y9G6XUtR13lDni6WTJ
# RD14eiPzE32mkHSDjfTLJgJGKsKKELukqQUMm+1o+mgulaAqPyprWEljHwlpblqY
# luSD9MCP80Yr3vw70L01724lruWvJ+3Q3fMOr5kol5hNDj0L8giJ1h/DMhji8MUt
# zluetEk5CsYKwsatruWy2dsViFFFWDgycScaf7H0J/jeLDogaZiyWYlobm+nt3TD
# QAUGpgEqKD6CPxNNZgvAs0314Y9/HG8VfUWnduVAKmWjw11SYobDHWM2l4bf2vP4
# 8hahmifhzaWX0O5dY0HjWwechz4GdwbRBrF1HxS+YWG18NzGGwS+30HHDiju3mUv
# 7Jf2oVyW2ADWoUa9WfOXpQlLSBCZgB/QACnFsZulP0V3HjXG0qKin3p6IvpIlR+r
# +0cjgPWe+L9rt0uX4ut1eBrs6jeZeRhL/9azI2h15q/6/IvrC4DqaTuv/DDtBEyO
# 3991bWORPdGdVk5Pv4BXIqF4ETIheu9BCrE/+6jMpF3BoYibV3FWTkhFwELJm3Zb
# CoBIa/15n8G9bW1qyVJzEw16UM0xggSOMIIEigIBATCBlTB+MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29k
# ZSBTaWduaW5nIFBDQSAyMDExAhMzAAABUZ6Nj0Bxow5BAAAAAAFRMAkGBSsOAwIa
# BQCggaIwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFAhYWAum/h3bslaUKNxZLV3j
# 3SBAMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBho
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEBBQAEggEAc62xC6/M
# fIEdNJsw4inqYk7A1gtGFAl6vZBFRHK9Jvmjt/t0B91M4HatdRu88i5rf8QReEio
# xQUCvnlWi2+YTSNO9u0uxoQXH+0MgBmeiMkIf1Tr2Ek5opNz6tj/6muZ35HsuaCN
# kNMp0Igv5ktXSw8v8tbcBVWAPjdrDLph/m8vkF5vV9nUa5doW1y/I0VGvAgubMTe
# q7va93cKJTUh9vm5MbFyIs5XJ8B5+LxtqALcTxXvXidJgS2AY0VNBpdh6MxU9Jbg
# ohGjP+DWpGMByzMQt+VejepUP/QMdVZn9zJJ7lUPizJbTF6b+pDUoipP6fzeLZhj
# XXtaO/LtSdh8faGCAigwggIkBgkqhkiG9w0BCQYxggIVMIICEQIBATCBjjB3MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSEwHwYDVQQDExhNaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0ECEzMAAAEqML+FxQ6x4owAAAAAASowCQYFKw4D
# AhoFAKBdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8X
# DTE5MTAxMzE3MjUxNlowIwYJKoZIhvcNAQkEMRYEFFiU1jdCxl6kpHC0rv4hmgEu
# SHzqMA0GCSqGSIb3DQEBBQUABIIBABCI9Jex7NylIPfUvOYQ0l/MqLJla3WXiY81
# dlPzMYX7z169R9UG+oQQYVE6cfzXSjMcLPdwt+I8yljtECBEF0X/am4CXMARLrom
# yiuvaxMLIVF+S4DMpn8I2Vna3d8LxIktyF1MuufL/BRmjPNL1SByaEYe08u7MZp5
# Tx+irI17n9qsrOkuWCS8RpV0lvHGfzt1+VXq63c9RRXuWjNBeVUqjL0TNK02yAjv
# S7MuZxXPaP+8g03T5c6LiV4wOqUu97W8sHmGVa66kAKScVUpEwa7Q6CR3831FTeG
# i2YMn4GBdO1/nI6HZtHxVD3MpSC99gORU7jydFSvP4Pn/xhzRq0=
# SIG # End signature block
