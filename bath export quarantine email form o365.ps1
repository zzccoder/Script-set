
Install-Module exchangeonliemanage
Import-Module exchangeonliemanage


$output = @() 
$ExportCSV= Read-Host "Export the quarantine CSV file location (E.g c:\temp\QuarantineReport.CSV)"  
$StartDate = Get-Date (Read-Host -Prompt 'Enter the start date, Eg.  08/31/2019') 
$StartDate = $StartDate.tostring("MM/dd/yyyy")
$endDate =  Get-Date (Read-Host -Prompt 'Enter the end date, Eg.  09/30/2019')
$endDate = $endDate.tostring("MM/dd/yyyy")

if($ExportCSV -eq "")
{
    $ExportCSV = "c:\temp\QuarantineReport.CSV"
}

If(($StartDate -eq "") -or ($endDate -eq ""))
{
    $Reports = get-quarantinemessage -PageSize 1000

}else{

$page = 1

while (get-quarantinemessage -StartReceivedDate $StartDate -EndReceivedDate $endDate -PageSize 1000 -page $page) 
{
$reports = get-quarantinemessage -StartReceivedDate $StartDate -EndReceivedDate $endDate -PageSize 1000 -page $page
$page++

Foreach($report in $reports)
    {

        $userObj = New-Object PSObject  
        $userObj | Add-Member NoteProperty -Name "Received" -Value $report.ReceivedTime
        $userObj | Add-Member NoteProperty -Name "Sender" -Value $report.SenderAddress
        $userObj | Add-Member NoteProperty -Name "Subject" -Value $report.Subject
        $UserObj | Add-Member NoteProperty -Name "Recipient" -Value $report.RecipientAddress
        $userObj | Add-Member NoteProperty -Name "Quarantine reason" -Value $report.QuarantineTypes
        $userObj | Add-Member NoteProperty -Name "Released?" -Value $report.Released
        $userObj | Add-Member NoteProperty -Name "Policy Type" -Value $report.PolicyType
        $userObj | Add-Member NoteProperty -Name "Message ID" -Value $report.MessageId
        $userObj | Add-Member NoteProperty -Name "Expires" -Value $report.Expires

        $output += $UserObj  
    }

    $output | Export-csv $ExportCSV -Encoding UTF8 -NoTypeInformation -append
    Write-host ("CSV file page " + ($page-1) + " has been exported to " + $ExportCSV)  -fore Green 

}
}

Write-host ("================================================================================")
Write-host ("CSV file has been exported to " + $ExportCSV)  -fore Green 