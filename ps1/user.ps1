$list=Get-Mailbox 

ForEach ($item in $list) 

{ 

$user=Get-User $item 

$sam=$user.SAMAccountName 

Set-Mailbox $item ¨CAlias "$sam" 

} 
