/* =================================================================
这个测试随机生成插入数据，数据长度的变化限制在指定的范围
测试变化范围从20到1000，步长为20字符，每个区间插入10000条数据
然后把列的定义加大50字符，每个区间测试10次
然后比较更新char与varchar数据之间的时间差异。
================================================================= */
USE master
GO

-- 创建测试数据库
IF DB_ID('db_test') IS NOT NULL
	DROP DATABASE db_test
GO

CREATE DATABASE db_test
GO

USE db_test
GO

-- 创建测试用的存储过程
CREATE PROC p_test
	@len int -- 字符长度变化范围
AS
SET NOCOUNT ON

DECLARE 
	@d11 datetime, @d12 datetime,
	@d21 datetime, @d22 datetime


-- 随机生成 10000 条记录, 每条记录的值代表要生成的字符的长度
DECLARE @ TABLE(DataLen int)
INSERT @
SELECT TOP 10000
	1000 - (ABS(CHECKSUM(NEWID())) % @len)
FROM syscolumns A, syscolumns B

-- 测试插入数据到 char 列
IF OBJECT_ID('dbo.tb_char') IS NOT NULL
	DROP TABLE dbo.tb_char
CREATE TABLE dbo.tb_char(c1 char(1000))

INSERT dbo.tb_char(c1)
SELECT
	CASE 
		WHEN datalen = 0 THEN '' 
		WHEN datalen < 0 THEN NULL
		ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
	END
FROM @
-- 测试增加列
SET @d11 = GETDATE()
	ALTER TABLE dbo.tb_char ALTER COLUMN
		c1 char(1050)
SET @d12 = GETDATE()

-- 测试插入数据到 varchar 列
IF OBJECT_ID('dbo.tb_varchar') IS NOT NULL
	DROP TABLE dbo.tb_varchar
CREATE TABLE dbo.tb_varchar(c1 varchar(1000))

INSERT dbo.tb_varchar(c1)
SELECT
	CASE 
		WHEN datalen = 0 THEN '' 
		WHEN datalen < 0 THEN NULL
		ELSE LEFT(REPLICATE(CONVERT(char(36), NEWID()), 30), datalen)
	END
FROM @
-- 测试增加列
SET @d21 = GETDATE()
	ALTER TABLE dbo.tb_varchar ALTER COLUMN
		c1 varchar(1050)
SET @d22 = GETDATE()
SELECT dlen = @len, d11 = @d11, d12 = @d12, d21 = @d21, d22 = @d22
GO


-- 测试速度
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
