-- 使用INTERSECT实现交集
SELECT object_id, name, type FROM sys.tables
INTERSECT
SELECT object_id, name, type FROM sys.objects

-- 使用IN实现交集
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE object_id IN( -- 由于object_id是唯一的, 因此只需用此列判断是否存在
		SELECT object_id
		FROM(
			SELECT object_id, name, type FROM sys.objects
		)OBJ)

-- 使用EXISTS实现交集
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE EXISTS( -- exists可以用多个列作为判断是否存在的依据
		SELECT object_id, name, type FROM sys.objects
		WHERE object_id = TB.object_id
			AND name = TB.name
			AND type = TB.type)

-- 在IN子句中,借助CHECKSUM用多个列作为判断是否存在的依据
SELECT DISTINCT
	object_id, name, type 
FROM sys.tables TB
WHERE CHECKSUM(object_id, name, type) IN(
		SELECT CHECKSUM(object_id, name, type)
		FROM(
			SELECT object_id, name, type FROM sys.objects
		)OBJ)
