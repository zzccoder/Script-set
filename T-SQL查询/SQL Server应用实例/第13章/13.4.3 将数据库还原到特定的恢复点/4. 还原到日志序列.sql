USE master
GO
-- ��������ȫ���ݲ������ݿ�
CREATE DATABASE db_test
BACKUP DATABASE db_test
TO DISK = 'c:\db_test.bak'
WITH FORMAT
GO

-- ��¼���кŵ���ʱ��
IF OBJECT_ID(N'tempdb..#lsn') IS NOT NULL
	DROP TABLE #lsn
CREATE TABLE #lsn(
	ID int IDENTITY,
	Flag int,
	CurrentLSN char(22),
	Operation sysname,
	Context sysname,
	TransactionID char(13)
)
-- ��ʼ�������Ա�֮ǰ��¼��ǰ�� lsn�� ����� last_lsn
INSERT #lsn(
	CurrentLSN, Operation, Context, TransactionID)
EXEC(N'DBCC LOG(N''db_test'')')
UPDATE #lsn SET
	Flag = 1
WHERE IDENTITYCOL = SCOPE_IDENTITY()

-- �������Ա�
CREATE TABLE db_test.dbo.tb(
	id int)

-- ��ʼ�������Ա�֮���¼��ǰ�� lsn�� ����� last_lsn
INSERT #lsn(
	CurrentLSN, Operation, Context, TransactionID)
EXEC(N'DBCC LOG(N''db_test'')')
UPDATE #lsn SET
	Flag = 2
WHERE IDENTITYCOL = SCOPE_IDENTITY()

-- ������Լ�¼
INSERT db_test.dbo.tb(
	id)
VALUES(1)

-- ����������־���Ա���Դ���־�����лָ���ָ������־���к�
BACKUP LOG db_test
TO DISK = 'c:\db_test_log.bak'
WITH FORMAT
GO


-- ��ԭ��ȫ����
RESTORE DATABASE db_test
FROM DISK = 'c:\db_test.bak'
WITH NORECOVERY,
	REPLACE

-- ͨ����־���кŻ�ԭ���ݿ⵽�������Ա�֮ǰ
-- �õ���־���к�
DECLARE
	@lsn varchar(50),
	@sql nvarchar(1000)
SELECT
	@sql = N'
DECLARE 
	@a binary(4), @b binary(4), @c binary(2)
SELECT
	@a = 0x' + SUBSTRING(CurrentLSN, 1, 8) + N',
	@b = 0x' + SUBSTRING(CurrentLSN, 10, 8) + N',
	@c = 0x' + SUBSTRING(CurrentLSN, 19, 4) + N'
SELECT
	@lsn = ''lsn:'' + 
			LEFT(RTRIM(CONVERT(int, @a)) + ''000000'', 6) + 
			RIGHT(CONVERT(int, @b) + 1000000, 6) + 
			RIGHT(CONVERT(int, @c) + 1000000, 5)
'
FROM #lsn
WHERE Flag = 1
EXEC sp_executesql @sql, N'@lsn varchar(50) OUTPUT', @lsn OUTPUT

-- ��ԭ��־��ָ������־���к�
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPATMARK = @lsn,
	STANDBY = 'C:\db_test_redo.bak'

-- ͨ�����ñ��Ƿ���ڣ�����֤�ĵ��Ƿ���ȷ
SELECT OBJECT_ID(N'db_test.dbo.tb')
/* -- ���:
-----------
NULL

(1 ����Ӱ��)
--*/
GO

-- ͨ����־���кŻ�ԭ���ݿ⵽�������Ա�֮ǰ
-- �õ���־���к�
DECLARE
	@lsn varchar(50),
	@sql nvarchar(1000)
SELECT
	@sql = N'
DECLARE 
	@a binary(4), @b binary(4), @c binary(2)
SELECT
	@a = 0x' + SUBSTRING(CurrentLSN, 1, 8) + N',
	@b = 0x' + SUBSTRING(CurrentLSN, 10, 8) + N',
	@c = 0x' + SUBSTRING(CurrentLSN, 19, 4) + N'
SELECT
	@lsn = ''lsn:'' + 
			LEFT(RTRIM(CONVERT(int, @a)) + ''000000'', 6) + 
			RIGHT(CONVERT(int, @b) + 1000000, 6) + 
			RIGHT(CONVERT(int, @c) + 1000000, 5)
'
FROM #lsn
WHERE Flag = 2
EXEC sp_executesql @sql, N'@lsn varchar(50) OUTPUT', @lsn OUTPUT

-- ��ԭ��־��ָ������־���к�
RESTORE LOG db_test
FROM DISK='c:\db_test_log.bak'
WITH STOPATMARK = @lsn,
	STANDBY = 'C:\db_test_redo.bak'

-- �����Ա��Ƿ���ڣ�����֤�ĵ��Ƿ���ȷ
SELECT 
	OBJECT_ID(N'db_test.dbo.tb'), COUNT(*)
FROM db_test.dbo.tb
/*-- ���
----------- -----------
2073058421  0

(1 ����Ӱ��)
--*/
GO

-- ɾ������
DROP DATABASE db_test
DROP TABLE #lsn
