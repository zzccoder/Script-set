USE tempdb
GO

-- 创建演示数据
CREATE TABLE dbo.tb_IndexTest(
	id int NOT NULL,
	col int,
	CONSTRAINT PK_id
		PRIMARY KEY CLUSTERED(
			id)
)
CREATE INDEX IX_col
	ON dbo.tb_IndexTest(
		col)
GO

-- 禁用索引
ALTER INDEX IX_col
	ON dbo.tb_IndexTest
	DISABLE
GO

-- 禁用所有索引(包括主键)
ALTER INDEX ALL
	ON dbo.tb_IndexTest
	DISABLE
GO

-- 禁用主键后, 访问基础表会失败
SELECT * FROM dbo.tb_IndexTest
GO

-- 启用索引
ALTER INDEX ALL
	ON dbo.tb_IndexTest
	REBUILD
GO

-- 重新组织索引 IX_col
ALTER INDEX IX_col
	ON dbo.tb_IndexTest
	REORGANIZE
GO

-- 删除演示
DROP TABLE dbo.tb_IndexTest
