-- 1. 累加赋值
DECLARE @re varchar(max)
SET @re = ''

SELECT 
	@re = @re 
		+ ',' + CONVERT(varchar(20), object_id)
FROM sys.objects
SET @re = STUFF(@re, 1, 1, '')
PRINT @re
GO

-- 2. 条件中引用变量, 引用的是初始值, 而不是累加过程中的值
DECLARE @re int
SET @re = 0

SELECT 
	@re = @re + object_id
FROM sys.objects
WHERE @re < 10000
GO

-- 3. 在UPDATE中实现赋值
-- 定义演示表
DECLARE @tb TABLE(
	id int)
INSERT @tb(
	id)
SELECT 1 UNION ALL
SELECT NULL UNION ALL
SELECT 9

-- 赋值处理
DECLARE 
	@id int, @re int
SELECT
	@id = 0,
	@re = 0
UPDATE @tb SET
	id = @id,
	@id = @id + 1,
	@re = @re + ISNULL(id, 0)

-- 显示最终的结果
SELECT re = @re, * FROM @tb
GO