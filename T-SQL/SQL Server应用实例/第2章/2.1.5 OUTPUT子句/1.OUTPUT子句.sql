-- 演示表变量
DECLARE @t TABLE(id int)

-- 1. 在INSERT语句中使用OUTPUT
--    OUTPUT结果直接返回给调用者
INSERT @t
OUTPUT INSERTED.*
SELECT object_id FROM sys.objects O


-- 2. 在UPDATE语句中使用OUTPUT
--    OUTPUT输出FROM子句中指定的表中的列, 这个列在被UPDATE的表中并不存在
UPDATE A SET
	id = O.object_id % 100
OUTPUT 
	O.name,
	DELETED.id AS id_BeforeUpdate, 
	INSERTED.id AS id_AfterUpdate
FROM @t A, sys.objects O
WHERE A.id = O.object_id


-- 3. 在DELETE语句中使用OUTPUT
--    输出的结果返回给指定的表变量

--    a. 用于保存输出结果的表变量
DECLARE @re TABLE(
	id int, name sysname)

--    b. 删除
DELETE A
OUTPUT 
	DELETED.id, O.name
INTO @re
FROM @t A, sys.objects O
WHERE A.id = O.object_id

--    c. 显示结果
SELECT * FROM @re
