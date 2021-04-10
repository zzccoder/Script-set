$menucolor = [System.ConsoleColor]::gray
write-host "¨X¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨["-ForegroundColor $menucolor
write-host "¨U                              Identify missing patches                                     ¨U"-ForegroundColor $menucolor
write-host "¨U                              Jan K?re Lokna - lokna.no                                    ¨U"-ForegroundColor $menucolor
write-host "¨U                                       v 1.2                                               ¨U"-ForegroundColor $menucolor
write-host "¨U                                  Requires elevation: No                                   ¨U"-ForegroundColor $menucolor
write-host "¨^¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨T¨a"-ForegroundColor $menucolor
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