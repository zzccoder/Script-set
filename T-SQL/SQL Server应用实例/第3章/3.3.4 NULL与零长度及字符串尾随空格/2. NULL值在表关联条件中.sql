-- бнЪОЪ§Он
DECLARE @ta TABLE(
	ida int, a int)
INSERT @ta(
	ida, a)
SELECT ida = 1, a = 1 UNION ALL
SELECT ida = 2, a = NULL UNION ALL
SELECT ida = 3, a = 3

DECLARE @tb TABLE(
	idb int, b int)
INSERT @tb(
	idb, b)
SELECT idb = 1, b = 1 UNION ALL
SELECT idb = 2, b = 2 UNION ALL
SELECT idb = 3, b = NULL

-- 1. JOIN
SELECT *
FROM @ta A
	INNER JOIN @tb B
		ON A.ida = B.idb
			AND A.a <> B.b

-- 2. IN
SELECT *
FROM @ta A
WHERE a IN (
		SELECT b FROM @tb B)

-- 3. NOT EXISTS
SELECT *
FROM @ta A
WHERE a NOT IN (
		SELECT b FROM @tb B)
