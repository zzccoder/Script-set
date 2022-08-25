[reflection.assembly]::LoadWithPartialName("Microsoft.UpdateServices.Administration")
$WSUS = [Microsoft.UpdateServices.Administration.AdminProxy]::GetUpdateServer('SV-BJ-WSUS',$false,8530) 
#creating the update scope. Different parameters can be used each time for different reports needed
$updatescope = New-Object Microsoft.UpdateServices.Administration.UpdateScope
$updatescope.ApprovedStates = [Microsoft.UpdateServices.Administration.ApprovedStates]::LatestRevisionApproved
$updatescope.FromArrivalDAte = [datetime]"01/11/2018"
$wsusgroup = $wsus.GetComputerTargetGroups() | Where {$_.Name -eq "all computers"}
$updateScope.ApprovedComputerTargetGroups.add($wsusgroup)
$updatescope
#Get approved patch list
$updates = $wsus.GetUpdates($updatescope) 
#Get downloaded patch list
$Updatesready = $updates | ? {$_.State -eq "ready"}
$Updatesready | select Title,UpdateClassificationTitle,@{n="AdditionalInformationUrls";e={$_.AdditionalInformationUrls -join ";"}},state | Export-CSV D:\11WSUSReady.csv -encoding UTF8