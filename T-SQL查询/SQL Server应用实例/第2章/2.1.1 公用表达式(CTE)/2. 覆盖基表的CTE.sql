USE tempdb
GO

-- 建立演示环境
CREATE TABLE T1(
	id int)
INSERT T1 
SELECT 1 UNION ALL 
SELECT 2

CREATE TABLE T2(
	id int)
GO

-- CTE 
;WITH
T2 AS(
	SELECT * FROM T1
)
-- 显示结果
SELECT * FROM T2

-- 这里已经与CTE定义无关, 显示T1的内容, 以确定CTE定义的有效范围
SELECT * FROM T2
GO

-- 删除演示环境
DROP TABLE T1, T2