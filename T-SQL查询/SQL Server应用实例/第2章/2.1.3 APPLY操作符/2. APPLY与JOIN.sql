-- 演示数据
DECLARE @A TABLE(
	id int)
INSERT @A
SELECT id = 1 UNION ALL
SELECT id = 2

DECLARE @B TABLE(
	id int)
INSERT @B
SELECT id = 1 UNION ALL
SELECT id = 3

-- 1. 右输入为表时, APPLY操作符与CROSS JOIN的结果一样
SELECT *
FROM @A
	CROSS APPLY @B

-- 2. 右输入为派生表时, 可以用APPLY操作符模拟JOIN
-- 2.a 模拟 INNER JOIN
SELECT *
FROM @A A
	CROSS APPLY(
		SELECT * FROM @B
		WHERE id = A.id
	)B

-- 2.b 模拟 LEFT JOIN
SELECT *
FROM @A A
	OUTER APPLY(
		SELECT * FROM @B
		WHERE id = A.id
	)B
