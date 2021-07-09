-- 建立演示环境
USE tempdb
GO

CREATE TABLE dbo.tb(
	c1 int NOT NULL,
	c2 int NOT NULL)
INSERT dbo.tb 
SELECT 1, 3 UNION ALL
SELECT 2, 2 UNION ALL
SELECT 3, 1
GO

-- 创建主键及索引
ALTER TABLE dbo.tb 
	ADD CONSTRAINT PK_tb
		PRIMARY KEY(
			c1)

CREATE UNIQUE INDEX IXU_tb_c2 
	ON dbo.tb(
		c2)
GO

-- 查询数据
SELECT * FROM dbo.tb 

SELECT * FROM dbo.tb 
WITH(INDEX(PK_tb))
GO

-- 删除演示环境
DROP TABLE dbo.tb