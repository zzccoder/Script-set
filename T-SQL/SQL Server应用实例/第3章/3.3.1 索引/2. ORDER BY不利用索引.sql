-- 建立演示环境
USE tempdb
GO

SELECT TOP 10000
	pkid = IDENTITY(int, 1, 1), O.*
INTO dbo.tb
FROM sys.objects O, sys.columns C
GO

-- 1. 使用聚集索引
CREATE UNIQUE CLUSTERED INDEX IXUC_pkid
	ON dbo.tb(
		pkid ASC)
GO
-- 检索数据
SELECT * FROM dbo.tb
ORDER BY pkid ASC  -- 1
GO

-- 2. 使用普通索引
CREATE INDEX IX_object_id
	ON dbo.tb(
		object_id ASC)
GO
-- 检索数据
SELECT * FROM dbo.tb
ORDER BY object_id ASC  -- 2
GO

-- 3. 表中仅包含普通索引
DROP INDEX dbo.tb.IXUC_pkid
GO
-- 检索数据
SELECT * FROM dbo.tb
ORDER BY object_id  ASC  -- 3
GO

-- 删除演示环境
DROP TABLE dbo.tb