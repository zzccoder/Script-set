USE tempdb
GO

-- 建立演示环境
CREATE TABLE Dept(
	id int PRIMARY KEY, 
	parent_id int,
	name nvarchar(20))
INSERT Dept
SELECT 0, 0, N'<全部>' UNION ALL
SELECT 1, 0, N'财务部' UNION ALL
SELECT 2, 0, N'行政部' UNION ALL
SELECT 3, 0, N'业务部' UNION ALL
SELECT 4, 0, N'业务部' UNION ALL
SELECT 5, 4, N'销售部' UNION ALL
SELECT 6, 4, N'MIS' UNION ALL
SELECT 7, 6, N'UI' UNION ALL
SELECT 8, 6, N'软件开发' UNION ALL
SELECT 9, 8, N'内部开发'
GO

-- 查询指定部门下面的所有部门
DECLARE @Dept_name nvarchar(20)
SET @Dept_name = N'MIS'
;WITH
DEPTS AS(
	-- 定位点成员
	SELECT * FROM Dept
	WHERE name = @Dept_name
	UNION ALL
	-- 递归成员, 通过引用CTE自身与Dept基表JOIN实现递归
	SELECT A.*
	FROM Dept A, DEPTS B
	WHERE A.parent_id = B.id
)
SELECT * FROM DEPTS
GO

-- 删除演示环境
DROP TABLE Dept
