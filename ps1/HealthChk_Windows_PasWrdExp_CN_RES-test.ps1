#Create output
if(!(test-path c:\computercheck\healthstatus)){
new-item -itemtype directory -path c:\computercheck\healthstatus
}
$filepath="c:\computercheck\healthstatus\PasWrdExp.txt"




#The vaild time
$username = "administrator"
$userinformation = net user $username|out-string -Stream
$lastsettime = [system.Convert]::ToDateTime($userinformation[8].Substring(19))
if ($userinformation[9].contains("never"))
{#Write-Host "Days  nolimited"
 "Days"  > $filepath
 "no limit" >> $filepath
}
else
{$expirytime = [system.Convert]::ToDateTime($userinformation[10].Substring(19)) 
$useTime = New-TimeSpan -Start $lastsettime -End $expirytime
$usedays = $useTime.Days
$usehours = $useTime.Hours
$usemin = $useTime.Minutes
#$userinformation[0]
#$userinformation[8]
#$userinformation[9]
#$userinformation[10]
#$userinformation[18]
#Write-Host "Days           $usedays Day $usehours Hours $usemin Minutes"}

#output to txt file
$array = @()
$info = @{
     ($userinformation[0] -split " ")[0] = $userinformation[0].Substring(20);
     ($userinformation[8] -split " ")[0] = $userinformation[8].Substring(17);
     ($userinformation[9] -split " ")[0] = $userinformation[9].Substring(19);
     ($userinformation[10] -split " ")[0] = $userinformation[10].Substring(18);
     ($userinformation[18] -split " ")[0] = $userinformation[18].Substring(19);
     "Days" = "$usedays Days $usehours Hours $usemin Minutes";
}
$Newobject = New-Object PSobject -Property $info
$Array +=$Newobject
$Array | Select-Object 用户名,上次设置密码,密码到期,密码可更改,上次登录,密码使用天数 | Export-CSV $filepath -UseCulture -NoTypeInformation -Encoding UTF8
}

#notepad $filepath