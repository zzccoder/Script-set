DECLARE 
	@a char(2), @a1 char(3), @b varchar(2)

-- 1. 比较运算符忽略尾部空格
SELECT
	@a = 'a',
	@a1 = 'a',
	@b = 'a'

SELECT 
	[a-b] = CASE WHEN @a = @b THEN '=' ELSE '<>' END,
	[a-a1] = CASE WHEN @a = @a1 THEN '=' ELSE '<>' END,
	[@a_Len] = LEN(@a),
	[@a1_Len] = LEN(@a1)
GO

-- 2. LIKE 
;WITH
TB AS(
	SELECT 
		a = CONVERT(varchar(2), 'a'),
		b = CONVERT(char(2), 'a')
)
SELECT
	[LIKE] = CASE WHEN a LIKE b THEN '=' ELSE '<>' END,
	[=] = CASE WHEN a = b THEN '=' ELSE '<>' END
FROM TB
