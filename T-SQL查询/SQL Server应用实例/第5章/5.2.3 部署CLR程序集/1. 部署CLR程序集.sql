-- ������ʾ���ݿ�
USE master
GO
CREATE DATABASE CLRSample
GO

USE CLRSample
GO

-- ���� CLR ����(��D:\CLRRelease\CLRSample.dll�м���)
CREATE ASSEMBLY CLRSample
FROM N'D:\CLRRelease\CLRSample.dll'
GO

-- ���� CLR ����
CREATE FUNCTION dbo.F_Format(
	@date datetime,
	@format nvarchar(4000)
)RETURNS nvarchar(4000)
AS
EXTERNAL NAME CLRSample.[CLRSample.UserDefinedFunctions].F_Format
GO

-- ���� CLR ����
SELECT dbo.F_Format(GETDATE(), N'yyyyMMdd_HHmmss')
