-- ��ʾ����
DECLARE @A TABLE(
	A_id int,
	A_col int)
INSERT @A
SELECT 1, 1 UNION ALL
SELECT 2, NULL UNION ALL
SELECT 3, 1 UNION ALL
SELECT 3, 2 UNION ALL
SELECT 4, 1

DECLARE @B TABLE(
	B_id int,
	B_col int)
INSERT @B
SELECT 1, 1 UNION ALL
SELECT 2, NULL UNION ALL
SELECT NULL, 1

-- INNER JOIN
SELECT *
FROM @A A
	INNER JOIN @B B
		ON A.A_id = B.B_id

-- LEFT JOIN
SELECT *
FROM @A A
	LEFT JOIN @B B
		ON A.A_id = B.B_id

SELECT *
FROM @A A
	LEFT JOIN @B B
		ON A.A_col = 1

SELECT *
FROM @A A
	LEFT JOIN @B B
		ON A.A_col = 1
WHERE B.B_col = 1

-- RIGHT JOIN
SELECT *
FROM @A A
	RIGHT JOIN @B B
		ON A.A_id = B.B_id

SELECT *
FROM @A A
	RIGHT JOIN @B B
		ON A.A_id = B.B_id
			AND A.A_col = 1

SELECT *
FROM @A A
	RIGHT JOIN @B B
		ON A.A_id = B.B_id
			AND A.A_col = 1
WHERE B.B_col <> 1

SELECT *
FROM @A A
	RIGHT JOIN @B B
		ON A.A_col = 1

-- CROSS JOIN
SELECT *
FROM @A A
	CROSS JOIN @B B
