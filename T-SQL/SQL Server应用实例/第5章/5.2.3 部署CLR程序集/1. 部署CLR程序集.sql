-- 建立演示数据库
USE master
GO
CREATE DATABASE CLRSample
GO

USE CLRSample
GO

-- 建立 CLR 程序集(从D:\CLRRelease\CLRSample.dll中加载)
CREATE ASSEMBLY CLRSample
FROM N'D:\CLRRelease\CLRSample.dll'
GO

-- 建立 CLR 对象
CREATE FUNCTION dbo.F_Format(
	@date datetime,
	@format nvarchar(4000)
)RETURNS nvarchar(4000)
AS
EXTERNAL NAME CLRSample.[CLRSample.UserDefinedFunctions].F_Format
GO

-- 调用 CLR 函数
SELECT dbo.F_Format(GETDATE(), N'yyyyMMdd_HHmmss')
