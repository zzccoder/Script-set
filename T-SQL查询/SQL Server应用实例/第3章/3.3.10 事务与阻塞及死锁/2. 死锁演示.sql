-- ������ʾ

-- 1. ����A
-- �������Ի���
USE tempdb
GO

CREATE TABLE dbo.tb(
	id int)
INSERT dbo.tb(
	id)
VALUES(
	1)
GO

-- ���ݴ���
SET DEADLOCK_PRIORITY LOW -- NORMAL
BEGIN TRAN
	SELECT * FROM dbo.tb WITH(HOLDLOCK)
	WAITFOR DELAY '00:00:05'
	UPDATE dbo.tb SET id = 2
COMMIT TRAN
GO


-- ����B
USE tempdb
GO

BEGIN TRAN
	SELECT * FROM dbo.tb WITH(HOLDLOCK)

	UPDATE dbo.tb SET id = 2
COMMIT TRAN
GO

-- ɾ����ʾ����
DROP TABLE dbo.tb
GO
