Clear-content C:\Scripts\CertReport.htm
$results=Invoke-Command -ComputerName (get-content C:\Scripts\DCs.txt) -ScriptBlock {Get-ChildItem Cert:\LocalMachine\My -Recurse  |
Where {$_.NotAfter -lt  (Get-Date).AddDays(60)}} | ForEach {
[pscustomobject]@{
  Computername =  $_.PSComputername
  Thumbprint =  $_.Thumbprint
  Template = ($_.Extensions | ?{$_.oid.Friendlyname -match "Certificate Template Information"}).Format(0) -replace "(.+)?=(.+)\((.+)?", '$2'
  Issuer = $_.Issuer
  ExpiresOn =  $_.NotAfter
  DaysUntilExpired = Switch ((New-TimeSpan -End $_.NotAfter).Days) {
  {$_  -gt 0} {$_}
  Default  {'Expired'}
    }
      }
          }
$a = "<style>"
$a = $a + "BODY{background-color:#d6eaf8;font-family:verdana;font-size:8pt;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:palegoldenrod}"
$a = $a + "</style>"
$results | ConvertTo-HTML -Head $a | Out-File C:\Scripts\CertReport.htm
if
 ($results –eq $Null)
{
$bodym = "Certificate Report-No Expiration"
Send-MailMessage -To bshwjt@contoso.com -from PKI@Contoso.com -Subject "Certificate Report-No Expiration" -Body $bodym -SmtpServer mail.contoso.com
}
else
{
$body = Get-Content C:\Scripts\CertReport.htm -Raw
Send-MailMessage -To bshwjt@contoso.com -from PKI@Contoso.com -Subject "PKI Report" -Body $body -BodyAsHtml -SmtpServer mail.contoso.com

}