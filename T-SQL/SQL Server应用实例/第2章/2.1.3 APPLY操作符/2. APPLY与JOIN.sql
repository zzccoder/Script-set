-- ��ʾ����
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

-- 1. ������Ϊ��ʱ, APPLY��������CROSS JOIN�Ľ��һ��
SELECT *
FROM @A
	CROSS APPLY @B

-- 2. ������Ϊ������ʱ, ������APPLY������ģ��JOIN
-- 2.a ģ�� INNER JOIN
SELECT *
FROM @A A
	CROSS APPLY(
		SELECT * FROM @B
		WHERE id = A.id
	)B

-- 2.b ģ�� LEFT JOIN
SELECT *
FROM @A A
	OUTER APPLY(
		SELECT * FROM @B
		WHERE id = A.id
	)B
