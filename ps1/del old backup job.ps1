$Days =600 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-422/DBUsers/DAILY*.'+$backuptype}
$filelist |ft name


foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddDays(-$Days))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     #Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
}
if ($flag -eq 0 -or $flag -eq $null) { Write-Host "No files found which are older than:",(Get-Date).AddDays(-$Days)}





$Days =28 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzureStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-425/DBUsers/DAILY*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddDays(-$Days))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
}
if ($flag -eq 0 -or $flag -eq $null) { Write-Host "No files found which are older than:",(Get-Date).AddDays(-$Days)}


Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestrited;
$Days =28 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzureStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-428/DBUsers/DAILY*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddDays(-$Days))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
}
if ($flag -eq 0 -or $flag -eq $null) { Write-Host "No files found which are older than:",(Get-Date).AddDays(-$Days)}


$Months =1 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzureStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-428/DBUsers/WEEKLY*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddMonths(-$Months))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Write-host Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
	 
	 
	 
	 
$Days =28 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzureStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like 'chgva4-422/DBUsers/DAILY*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddDays(-$Days))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }
}
if ($flag -eq 0 -or $flag -eq $null) { Write-Host "No files found which are older than:",(Get-Date).AddDays(-$Days)}




$Months =1 # for file older than xx days
$backuptype = "bak"
#$backuptype = "trn" # for file extension .trn
$container="sqlbackups"
$StorageAccountName="adxprdsqlbackupesta010cf"
$StorageAccountKey="S7vRbs1byegde+cNcKH7+nZnnXzJuWYVpD9e2Zptwy0SVKr3OKVt5dz2pte/Cjl6eX+Ae9d8dYCOf4MSHtwemg=="
$context = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey
$filelist = Get-AzureStorageBlob -Container $container -Context $context
$filelist = $filelist  | Where-Object {$_.Name -like chgva4-422/DBUsers/WEEKLY*.'+$backuptype}
$filelist |ft name
foreach ($file in $filelist | Where-Object {$_.LastModified.DateTime -lt ((Get-Date).AddMonths(-$Months))})
{
     if ($file.Name -ne $null)
     {
     Write-host "Removing file: $file.Name"
     Write-host Remove-AzureStorageBlob -Blob $file.Name -Container $container -Context $context
     $flag=1
     }	 
	 
	 
	 
-- FULL BACKUP - USER DBs
use master
go

create table #dblist(dbname nvarchar(max))
insert into #dblist
select name from sys.databases where database_id > 4 and state !=6

DECLARE @storageAccount VARCHAR(255);
DECLARE @container VARCHAR(50);
DECLARE @credential VARCHAR(100);    
DECLARE @filename VARCHAR(255);

-- SET AZURE INFO HERE
SET @storageAccount = 'adxprdsqlbackupesta010cf';
SET @container = 'sqlbackups/chgva4-422/DBUsers';
SET @credential = 'gva.svc_sqlbackup'

declare c_dbname cursor
for
select dbname from #dblist
declare @dbname	sysname;
declare @cmd	nvarchar(max);


open c_dbname
fetch next from c_dbname into @dbname
while @@FETCH_STATUS = 0
begin
SET @filename = 'https://' + @storageAccount + '.blob.core.windows.net/' + @container + '/' + @dbname + '_'+ REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(), 20),'-',''),':',''),' ','') + '.bak';
set @cmd= 'BACKUP DATABASE ['+@dbname+'] TO URL = ''' + @filename + ''' WITH CREDENTIAL = '''+ @credential +''', COMPRESSION, STATS = 5';
--select @cmd;
execute (@cmd);
fetch next from c_dbname into @dbname;
end;
close c_dbname
deallocate c_dbname
drop table #dblist


use master
go

create table #dblist(dbname nvarchar(max))
insert into #dblist
select name from sys.databases where database_id <> 2 and recovery_model = 1 and state !=6

DECLARE @storageAccount VARCHAR(255);
DECLARE @container VARCHAR(50);
DECLARE @credential VARCHAR(100);    
DECLARE @filename VARCHAR(255);

-- SET AZURE INFO HERE
SET @storageAccount = 'adxprdsqlbackupesta010cf';
SET @container = 'sqlbackups/chgva4-422/BackupLogs';
SET @credential = 'gva.svc_sqlbackup'

declare c_dbname cursor
for
select dbname from #dblist
declare @dbname	sysname;
declare @cmd	nvarchar(max);


open c_dbname
fetch next from c_dbname into @dbname
while @@FETCH_STATUS = 0
begin
SET @filename = 'https://' + @storageAccount + '.blob.core.windows.net/' + @container + '/' + @dbname + '_'+ REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(), 20),'-',''),':',''),' ','') +'.trn';
set @cmd= 'BACKUP LOG ['+@dbname+'] TO URL = ''' + @filename + ''' WITH CREDENTIAL = '''+ @credential +''', COMPRESSION, STATS = 5';
--select @cmd;
execute (@cmd);
fetch next from c_dbname into @dbname;
end;
close c_dbname
deallocate c_dbname
drop table #dblist



-- FULL BACKUP - SYSTEM DBs
use master
go

create table #dblist(dbname nvarchar(max))
insert into #dblist
select name from sys.databases where database_id in (1,3,4)

DECLARE @storageAccount VARCHAR(255);
DECLARE @container VARCHAR(50);
DECLARE @credential VARCHAR(100);    
DECLARE @filename VARCHAR(255);

-- SET AZURE INFO HERE
SET @storageAccount = 'adxprdsqlbackupesta010cf';
SET @container = 'sqlbackups/chgva4-422/DBSystem';
SET @credential = 'gva.svc_sqlbackup'

declare c_dbname cursor
for
select dbname from #dblist
declare @dbname	sysname;
declare @cmd	nvarchar(max);


open c_dbname
fetch next from c_dbname into @dbname
while @@FETCH_STATUS = 0
begin
SET @filename = 'https://' + @storageAccount + '.blob.core.windows.net/' + @container + '/' + @dbname + '_'+ REPLACE(REPLACE(REPLACE(CONVERT(varchar,GETDATE(), 20),'-',''),':',''),' ','') + '.bak';
set @cmd= 'BACKUP DATABASE ['+@dbname+'] TO URL = ''' + @filename + ''' WITH CREDENTIAL = '''+ @credential +''', COMPRESSION, STATS = 5';
--select @cmd;
execute (@cmd);
fetch next from c_dbname into @dbname;
end;
close c_dbname
deallocate c_dbname
drop table #dblist





