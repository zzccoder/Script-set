$menucolor = [System.ConsoleColor]::gray
write-host "ĘXĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘ["-ForegroundColor $menucolor
write-host "ĘU                              Identify missing patches                                     ĘU"-ForegroundColor $menucolor
write-host "ĘU                              Jan K?re Lokna - lokna.no                                    ĘU"-ForegroundColor $menucolor
write-host "ĘU                                       v 1.2                                               ĘU"-ForegroundColor $menucolor
write-host "ĘU                                  Requires elevation: No                                   ĘU"-ForegroundColor $menucolor
write-host "Ę^ĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘTĘa"-ForegroundColor $menucolor
#List your patches here. Updated list of patches at http://support.microsoft.com/kb/2784261
$recommendedPatches = "KB2955164", "KB219355"
 
$missingPatches = @()
foreach($_ in $recommendedPatches){
    if (!(get-hotfix -id $_)) { 
        $missingPatches += $_ 
    }    
}
$intMissing = $missingPatches.Count
$intRecommended = $recommendedpatches.count
Write-Host "$env:COMPUTERNAME is missing $intMissing of $intRecommended patches:" 
$missingPatches