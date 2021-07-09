WITH
A AS(
	SELECT id = 1 UNION ALL
	SELECT id = 2
),
B AS(
	SELECT id = 1, value = 1 UNION ALL
	SELECT id = 1, value = 3 UNION ALL
	SELECT id = 2, value = 2
)
SELECT
	A.id,
	B.value
FROM A, B
WHERE A.id = B.id
ORDER BY B.value
FOR XML RAW
