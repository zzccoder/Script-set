$Mailboxes = Import-csv c:\1.csv
$report = @()
foreach ($Mailbox in $Mailboxes)
{
    $mbxtotal=Get-ADUser $Mailbox.identity|Select-Object @{n="DisplayName";e={$_.displayname}},`@{n="SamAccountName";e={$_.samaccountname}}, `@{n="SurName";e={$_.SurName}}, `
    $report += $mbxtotal
}
# $report
$report|Export-Csv -Path c:\alluser.csv -NoTypeInformation -Encoding utf8