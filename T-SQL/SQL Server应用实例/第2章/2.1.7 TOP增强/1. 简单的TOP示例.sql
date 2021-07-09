-- 示例表变量
DECLARE @t TABLE(id int)

-- 1. INSERT中限制插入行数
INSERT TOP (5) @t(
	id)
SELECT object_id FROM sys.objects
ORDER BY object_id

-- 2. 删除数据, 只保留两行
DELETE TOP (@@ROWCOUNT - 2)
FROM @t

-- 3. 如果删除的行数为3行, 则更新2行, 否则更新0行
UPDATE TOP (CASE @@ROWCOUNT WHEN 3 THEN 2 ELSE 0 END) A SET
	id = id + 1
FROM @t A

-- 显示最终的处理结果
SELECT * FROM @t