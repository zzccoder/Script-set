$Months =12 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-428/DBUsers/MONTHLY/*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddMonths(-$Months))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Write-host Remove-AzStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
	 
	 
#Set-ExecutionPolicy  -ExecutionPolicy RemoteSigned;
$Days =90 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-428/DBUsers/NewDAILY/*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddDays(-$Days))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Remove-AzStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
}
if ($flag -eq 0 -or $flag -eq $null) { Write-Host "No files found which are older than:",(Get-Date).AddDays(-$Days)}