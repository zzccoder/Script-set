-- 1. 事务回滚导致标识值不连续
-- 建立演示环境
CREATE TABLE #(
	id int IDENTITY(0,1), b int UNIQUE)
INSERT #(
	b)
VALUES(
	1)

-- a. 手工事务回滚
BEGIN TRAN
	INSERT #(
		b)
	VALUES(
		2)
ROLLBACK TRAN

INSERT #(
	b)
VALUES(
	2)
SELECT * FROM #
GO

-- b. 因操作失败自动回滚事务
INSERT #(
	b)
VALUES(
	2)
INSERT #(
	b)
VALUES(
	3)
SELECT * FROM #
GO

-- 删除演示表
DROP TABLE #
GO



-- 2. 删除记录导致标识值不连续
-- 建立演示环境
CREATE TABLE #(
	id int IDENTITY(0,1), b int)
INSERT #(
	b)
SELECT 1 UNION ALL
SELECT 2
GO

-- 删除一条记录
DELETE # WHERE b = 2
INSERT #(
	b)
VALUES(
	2)
SELECT * FROM #
GO

-- 删除演示环境
DROP TABLE #
GO


-- 3. 重置标识值导致标识值不连续
-- 建立演示环境
CREATE TABLE #(
	id int IDENTITY(0,1), b int)
INSERT #(
	b)
VALUES(
	1)

--重置当前标识值
DBCC CHECKIDENT(#, RESEED, 1)
INSERT #(
	b)
VALUES(
	1)
SELECT * FROM #
GO

-- 删除演示环境
DROP TABLE #
GO
