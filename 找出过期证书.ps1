$today = Get-Date
 
Get-ChildItem -Path cert:\ -Recurse |
  Where-Object { $_.NotAfter -ne $null  } |
  Where-Object { $_.NotAfter -lt $today } |
  Select-Object -Property FriendlyName, NotAfter, PSParentPath, Thumbprint |
  Out-GridView