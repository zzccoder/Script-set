USE tempdb
GO

-- 定义演示的父表和引用表
CREATE TABLE dbo.ta(
	id int PRIMARY KEY,
	col int)
INSERT dbo.ta(
	id, col)
SELECT 1, 1 UNION ALL
SELECT 2, 2 UNION ALL
SELECT 3, 3 UNION ALL
SELECT -1, 0 

CREATE TABLE dbo.tb(
	id int PRIMARY KEY,
	ta_id int
		DEFAULT - 1
		REFERENCES dbo.ta(
			id)
			ON UPDATE SET NULL
			ON DELETE SET DEFAULT)
INSERT dbo.tb(
	id, ta_id)
SELECT 1, 1 UNION ALL
SELECT 2, 2 UNION ALL
SELECT 3, 2 UNION ALL
SELECT 4, 3 UNION ALL
SELECT 5, 3
GO

-- 删除和修改dbo.ta表中的记录
DELETE dbo.ta
WHERE id = 1

UPDATE dbo.ta 
	SET id = 10
WHERE id = 2
GO

-- 显示dbo.tb表的结果
SELECT * FROM dbo.tb
GO

-- 删除演示环境
DROP TABLE dbo.tb, dbo.ta
