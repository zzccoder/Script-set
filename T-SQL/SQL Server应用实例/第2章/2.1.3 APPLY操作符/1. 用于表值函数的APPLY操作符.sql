USE tempdb
GO

-- 用于分拆字符串的表值函数
CREATE FUNCTION dbo.f_Split(
	@str varchar(max)
)RETURNS @re TABLE(
		id int IDENTITY, val varchar(10))
AS
BEGIN
	DECLARE @pos int
	SET @pos = CHARINDEX(',', @str)
	WHILE @pos > 0
	BEGIN
		INSERT @re(val) VALUES(LEFT(@str, @pos - 1))
		SELECT
			@str = STUFF(@str, 1, @pos, ''),
			@pos = CHARINDEX(',', @str)
	END
	IF @str > ''
		INSERT @re(val) VALUES(@str)
	RETURN
END
GO

-- 用于分拆的示例数据
DECLARE @tb TABLE(
	col varchar(max))
INSERT @tb
SELECT col = '1,2,3' UNION ALL
SELECT col = NULL UNION ALL
SELECT col = '' UNION ALL
SELECT col = '1'

-- 使用 CROSS APPLY
SELECT *
FROM @tb A
	CROSS APPLY dbo.f_Split(A.col) B

-- 使用 OUTER APPLY
SELECT *
FROM @tb A
	OUTER APPLY dbo.f_Split(A.col) B
GO

-- 删除演示数据
DROP FUNCTION dbo.f_Split
