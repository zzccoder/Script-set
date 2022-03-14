$OSInfo = "*2008*",
          "*Windows 10*",
          "Windows Server 2019*",
          "Windows Server 2016*",
          "*Windows 7*",
          "*xp*",
          "*vista*",
          "*Windows NT*",
          "*2000*",
          "*2003*" 
#>
Used For Win 10 and Windows Server Semin-Annual Channel enumeration OS Lifecycle information can be found here: https://docs.microsoft.com/en-us/windows-server/get-started/windows-server-release-info
 ...and here: https://support.microsoft.com/en-us/help/13853/windows-lifecycle-fact-sheet
#>
$BuildInfo = "*(10586)","*(15063)" 
  
Foreach ($OS in $OSInfo) {
     $EOLMachines = @()
     $PossibleEOLmachines = Get-ADComputer -Filter {operatingsystem -like $OS} -Property Name,OperatingSystemVersion,OperatingSystem,OperatingSystemServicePack,lastlogontimestamp
#Filter Out Windows 10 / Server SAC channels still supported
If ( ($PossibleEOLmachines.OperatingSystem -like "Windows 10*") -or ($PossibleEOLmachines.OperatingSystem -like "Windows Server 2016*") -or ($PossibleEOLmachines.OperatingSystem -like "Windows Server 2019*")){
    foreach ($Build in $BuildInfo) {
        $EOLMachines += $PossibleEOLmachines | Where-Object {$_.operatingSystemVersion -like $Build}
    }
} else { $EOLMachines = $PossibleEOLmachines }
     
     foreach ($machine in $EOLmachines) {
[pscustomobject]@{
    Name = $machine.name
    OperatingSystem = $machine.OperatingSystem
    OperatingSystemServicePack = $machine.OperatingSystemServicePack
    OperatingSystemVersion = $machine.OperatingSystemVersion
    lastlogontimestamp = [datetime]::FromFileTime($machine.lastlogontimestamp)
}
     }
     Remove-Variable EOLMachines
 } 