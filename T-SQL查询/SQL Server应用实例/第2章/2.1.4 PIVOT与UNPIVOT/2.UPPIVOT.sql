WITH
OBJ AS(
	SELECT type FROM sys.objects
),
P AS(
	SELECT *
	FROM OBJ
	PIVOT(
		COUNT(type)
		FOR type 
		IN([U], [V], [P])
	)P
)
SELECT *
FROM P
UNPIVOT(
	[Count]
	FOR type
	IN([U], [V], [P])
)UP