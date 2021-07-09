-- 使用EXCEPT实现差集
SELECT object_id, name, type FROM master.sys.tables
EXCEPT
SELECT object_id, name, type FROM tempdb.sys.tables

-- 使用NOT IN实现差集
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE object_id NOT IN( -- 由于object_id是唯一的, 因此只需用此列判断是否存在
		SELECT object_id
		FROM(
			SELECT object_id, name, type FROM tempdb.sys.tables
		)OBJ)

-- 使用NOT EXISTS实现差集
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE NOT EXISTS( -- exists可以用多个列作为判断是否存在的依据
		SELECT object_id, name, type FROM tempdb.sys.tables
		WHERE object_id = TB.object_id
			AND name = TB.name
			AND type = TB.type)

-- 在NOT IN子句中,借助CHECKSUM用多个列作为判断是否存在的依据
SELECT DISTINCT
	object_id, name, type 
FROM master.sys.tables TB
WHERE CHECKSUM(object_id, name, type) NOT IN(
		SELECT CHECKSUM(object_id, name, type)
		FROM(
			SELECT object_id, name, type FROM tempdb.sys.tables
		)OBJ)
