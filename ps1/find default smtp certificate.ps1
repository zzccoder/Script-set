$server=(Get-ExchangeServer |Where-Object {$_.Name -like "CHGVA3-211b"} )| Select-Object Name,DistinguishedName
$TransportCert = (Get-ADObject -Identity $Server.DistinguishedName -Properties *).msExchServerInternalTLSCert
$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$CertBlob = [System.Convert]::ToBase64String($TransportCert)
$Cert.Import([Convert]::FromBase64String($CertBlob))
$Cert.FriendlyName
$cert.thumbprint
