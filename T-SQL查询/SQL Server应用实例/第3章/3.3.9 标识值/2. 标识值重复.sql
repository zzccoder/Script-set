-- 1. 强制插入标识值导致标识值重复
-- 建立演示环境
CREATE TABLE #(
	id int IDENTITY(1, 1), b int)
INSERT #(
	b)
VALUES(
	1)

-- 插入重复的标识值
SET IDENTITY_INSERT # ON
INSERT #(
	id, b)
VALUES(
	SCOPE_IDENTITY(), 2)
SET IDENTITY_INSERT # OFF

SELECT * FROM #
GO

-- 删除演示环境
DROP TABLE #
GO


-- 2. DBCC CHECKIDENT导致标识值重复
-- 建立演示环境
CREATE TABLE #(
	id int IDENTITY(1, 1), b int)
INSERT #(
	b)
VALUES(
	1)

--重置标识值
DBCC CHECKIDENT(#, RESEED, 0)
INSERT #(
	b)
VALUES(
	2)

SELECT * FROM #
GO

-- 删除演示环境
DROP TABLE #
GO
