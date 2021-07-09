-- ������ʾ����
USE tempdb
GO

SELECT TOP 10000
	pkid = IDENTITY(int, 1, 1), O.*
INTO dbo.tb
FROM sys.objects O, sys.columns C
GO

-- 1. ʹ�þۼ�����
CREATE UNIQUE CLUSTERED INDEX IXUC_pkid
	ON dbo.tb(
		pkid ASC)
GO
-- ��������
SELECT * FROM dbo.tb
ORDER BY pkid ASC  -- 1
GO

-- 2. ʹ����ͨ����
CREATE INDEX IX_object_id
	ON dbo.tb(
		object_id ASC)
GO
-- ��������
SELECT * FROM dbo.tb
ORDER BY object_id ASC  -- 2
GO

-- 3. ���н�������ͨ����
DROP INDEX dbo.tb.IXUC_pkid
GO
-- ��������
SELECT * FROM dbo.tb
ORDER BY object_id  ASC  -- 3
GO

-- ɾ����ʾ����
DROP TABLE dbo.tb