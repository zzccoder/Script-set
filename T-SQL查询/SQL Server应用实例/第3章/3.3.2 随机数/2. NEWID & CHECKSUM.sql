-- 1. 生成随机数值
DECLARE 
	@RandMin int, @RandMax int

--设置随机值的最小和最大值
SELECT
	@RandMin = -100,
	@RandMax = 100

-- 生成随机数
SELECT TOP 100
	RandValue = ABS(CHECKSUM(NEWID())) % (1 + @RandMax - @RandMin) + @RandMin
FROM sys.objects O1, sys.objects O2
GO


-- 2. 生成随机日期
DECLARE 
	@RandMin datetime, @RandMax datetime

--设置随机值的最小和最大值
SELECT
	@RandMin = '20070101',
	@RandMax = '20071231'

-- 生成随机数
SELECT TOP 100
	RandValue = DATEADD(Hour,
			ABS(CHECKSUM(NEWID())) % (1 + DATEDIFF(Hour, @RandMax, @RandMin)),
			@RandMin)
FROM sys.objects O1, sys.objects O2
GO



-- 3. 生成随机字符串
--    a. 建立一个使用NEWID的函数，以便可以在用户定义中引用
CREATE VIEW dbo.v_NEWID
AS
SELECT re = CONVERT(char(36), NEWID())
GO

--    b. 生成随机字符串的函数
CREATE FUNCTION dbo.f_RandStr(
	@StrLen int   -- 字符串的长度
)RETURNS varchar(max)
AS
BEGIN
	IF @StrLen < 0
		RETURN(NULL)

	DECLARE 
		@re varchar(max), @len int
	SELECT
		@re = re,
		@len = 36
	FROM dbo.v_NEWID
	WHILE @len < @StrLen
		SELECT 
			@re = @re + re,
			@len = 36 + @len
		FROM dbo.v_NEWID
	SET @re = LEFT(@re, @StrLen)

	;WITH
	SN AS(
		SELECT TOP 11
			RowID = ROW_NUMBER() OVER(ORDER BY object_id) - 1
		FROM sys.objects
	),
	CH AS(
		SELECT
			ch = CASE RowID WHEN 10 THEN '-' ELSE CONVERT(char(1), RowID) END,
			chv = (
					SELECT chv = CHAR(ABS(CHECKSUM(re)) % 26 + 97)
					FROM dbo.v_NEWID)
		FROM SN
	)
	SELECT @re = REPLACE(@re, ch, chv)
	FROM CH

	RETURN(@re)
END
GO

--    C. 调用函数生成随机字符串
SELECT TOP 100
	RandValue = dbo.f_RandStr(50)
FROM sys.objects O1, sys.objects O2
GO

-- 删除演示环境
DROP VIEW dbo.v_NEWID
DROP FUNCTION dbo.f_RandStr
