-- 1. ���������ֵ
DECLARE 
	@RandMin int, @RandMax int

--�������ֵ����С�����ֵ
SELECT
	@RandMin = -100,
	@RandMax = 100

-- ���������
SELECT TOP 100
	RandValue = ABS(CHECKSUM(NEWID())) % (1 + @RandMax - @RandMin) + @RandMin
FROM sys.objects O1, sys.objects O2
GO


-- 2. �����������
DECLARE 
	@RandMin datetime, @RandMax datetime

--�������ֵ����С�����ֵ
SELECT
	@RandMin = '20070101',
	@RandMax = '20071231'

-- ���������
SELECT TOP 100
	RandValue = DATEADD(Hour,
			ABS(CHECKSUM(NEWID())) % (1 + DATEDIFF(Hour, @RandMax, @RandMin)),
			@RandMin)
FROM sys.objects O1, sys.objects O2
GO



-- 3. ��������ַ���
--    a. ����һ��ʹ��NEWID�ĺ������Ա�������û�����������
CREATE VIEW dbo.v_NEWID
AS
SELECT re = CONVERT(char(36), NEWID())
GO

--    b. ��������ַ����ĺ���
CREATE FUNCTION dbo.f_RandStr(
	@StrLen int   -- �ַ����ĳ���
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

--    C. ���ú�����������ַ���
SELECT TOP 100
	RandValue = dbo.f_RandStr(50)
FROM sys.objects O1, sys.objects O2
GO

-- ɾ����ʾ����
DROP VIEW dbo.v_NEWID
DROP FUNCTION dbo.f_RandStr
