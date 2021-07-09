/* =================================================================
�������������ɲ������ݣ����ݳ��ȵı仯������ָ���ķ�Χ
���Ա仯��Χ��10��1000������Ϊ20�ַ���ÿ���������10000������
Ȼ��������������2000�����ݣ�ÿ���������10��
Ȼ��Ƚϸ���char��varchar����֮���ʱ�����
================================================================= */
USE master
GO

-- �����������ݿ�
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test
GO

CREATE DATABASE db_test
GO

USE db_test
GO

-- ���������õĴ洢����
CREATE PROC p_test
	@len int -- �ַ����ȱ仯��Χ
AS
SET NOCOUNT ON

DECLARE 
	@d11 datetime, @d12 datetime,
	@d21 datetime, @d22 datetime


-- ������� 10000 ����¼, ÿ����¼��ֵ����Ҫ���ɵ��ַ��ĳ���
DECLARE @ TABLE(id int identity, DataLen int, flag bit)
INSERT @
SELECT TOP 10000
	1000 - (ABS(CHECKSUM(NEWID())) % @len), 0
FROM syscolumns A, syscolumns B

-- ����Ҫ���µ�����
DECLARE @u TABLE(id int, DataLen int)
INSERT @u SELECT TOP 2000
	id, 1000 - (ABS(CHECKSUM(NEWID())) % @len)
FROM @
ORDER BY NEWID()

-- ���Բ������ݵ� char ��
IF OBJECT_ID('dbo.tb_char') IS NOT NULL
	DROP TABLE dbo.tb_char
CREATE TABLE dbo.tb_char(id int PRIMARY KEY, c1 char(1000), c2 char(500))
CREATE INDEX IX_tb_char_c1 ON dbo.tb_char(c2)

INSERT dbo.tb_char(id, c1, c2)
SELECT id, LEFT(Data, datalen1), RIGHT(Data, datalen2)
FROM(
	SELECT
		id,
		datalen1 = CASE WHEN datalen > 0 THEN datalen / 2 ELSE 0 END,
		datalen2 = CASE WHEN datalen > 0 THEN datalen - datalen / 2 ELSE 0 END,
		Data = CASE 
			WHEN datalen = 0 THEN '' 
			WHEN datalen < 0 THEN NULL
			ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
		END
	FROM @
)A
-- ���Ը��µ��ٶ�
SET @d11 = GETDATE()
UPDATE A SET
	c1 = LEFT(Data, datalen1), 
	c2 = RIGHT(Data, datalen2)
FROM dbo.tb_char A, (
	SELECT
		id,
		datalen1 = CASE WHEN datalen > 0 THEN datalen / 2 ELSE 0 END,
		datalen2 = CASE WHEN datalen > 0 THEN datalen - datalen / 2 ELSE 0 END,
		Data = CASE 
			WHEN datalen = 0 THEN '' 
			WHEN datalen < 0 THEN NULL
			ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
		END
	FROM @u
)B
WHERE A.id = B.id
SET @d12 = GETDATE()

-- ���Բ������ݵ� varchar ��
IF OBJECT_ID('dbo.tb_varchar') IS NOT NULL
	DROP TABLE dbo.tb_varchar
CREATE TABLE dbo.tb_varchar(id int PRIMARY KEY, c1 varchar(1000), c2 varchar(500))
CREATE INDEX IX_tb_varchar_c1 ON dbo.tb_char(c2)

INSERT dbo.tb_varchar(id, c1, c2)
SELECT id, LEFT(Data, datalen1), RIGHT(Data, datalen2)
FROM(
	SELECT
		id,
		datalen1 = CASE WHEN datalen > 0 THEN datalen / 2 ELSE 0 END,
		datalen2 = CASE WHEN datalen > 0 THEN datalen - datalen / 2 ELSE 0 END,
		Data = CASE 
			WHEN datalen = 0 THEN '' 
			WHEN datalen < 0 THEN NULL
			ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
		END
	FROM @
)A
-- ���Ը��µ��ٶ�
SET @d21 = GETDATE()
UPDATE A SET
	c1 = LEFT(Data, datalen1), 
	c2 = RIGHT(Data, datalen2)
FROM dbo.tb_varchar A, (
	SELECT
		id,
		datalen1 = CASE WHEN datalen > 0 THEN datalen / 2 ELSE 0 END,
		datalen2 = CASE WHEN datalen > 0 THEN datalen - datalen / 2 ELSE 0 END,
		Data = CASE 
			WHEN datalen = 0 THEN '' 
			WHEN datalen < 0 THEN NULL
			ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
		END
	FROM @u
)B
WHERE A.id = B.id
SET @d22 = GETDATE()
SELECT dlen = @len, d11 = @d11, d12 = @d12, d21 = @d21, d22 = @d22
GO

-- �����ٶ�
IF OBJECT_ID('tempdb..#re') IS NOT NULL
	DROP TABLE #re
CREATE TABLE #re(
	id int IDENTITY,
	DataLenChange int,
	char_dt_Begin datetime,
	char_dt_end datetime,
	char_duration as DATEDIFF(ms, char_dt_Begin, char_dt_end),
	varchar_dt_Begin datetime,
	varchar_dt_end datetime,
	varchar_duration as DATEDIFF(ms, varchar_dt_Begin, varchar_dt_end))

DECLARE @len int, @duretion int
SET @len = 20
SET @duretion= 10
WHILE @len <= 1000
BEGIN
	DECLARE @i int
	SET @i = 0
	WHILE @i <  @duretion
	BEGIN
		SET @i = @i + 1
		RAISERROR('test %d. step %d', 10, 1, @len, @i) WITH NOWAIT
		INSERT #re(
			DataLenChange,
			char_dt_Begin, char_dt_end,
			varchar_dt_Begin, varchar_dt_end)
		EXEC p_test @len
	END
	SET @len = @len + 20
END

SELECT 
	id = (id -1) / @duretion + 1,
	DataLenChange,
	char_duration = AVG( char_duration),
	varchar_duration = AVG(varchar_duration)
FROM #re
GROUP BY (id -1) / @duretion + 1, DataLenChange
