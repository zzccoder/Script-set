-- 使用UNION实现并集并去掉重复值
SELECT object_id, name, type FROM sys.tables
UNION
SELECT object_id, name, type FROM sys.objects

-- 使用UNION ALL实现并集
SELECT object_id, name, type FROM sys.tables
UNION ALL
SELECT object_id, name, type FROM sys.objects
