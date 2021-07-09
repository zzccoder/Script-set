-- 创建测试数据库
USE master
CREATE DATABASE test
GO
-- 关闭自动创建与更新统计功能
ALTER DATABASE test
SET 
	AUTO_CREATE_STATISTICS OFF,
	AUTO_UPDATE_STATISTICS OFF
GO

USE test
GO

-- 建立一个包含10000条记录, 仅有1条记录为女,其他记录为男的测试表
CREATE TABLE dbo.tb(
	id int IDENTITY(1, 1) PRIMARY KEY, col1 char(8000), sex nchar(1))
INSERT dbo.tb(
	col1, sex)
SELECT TOP 10000 
	N'男', N'男'
FROM sys.columns C1, sys.columns C2

UPDATE dbo.tb SET 
	sex = N'女'
WHERE id = 10000
GO

-- 创建索引
CREATE INDEX IX_tb_sex ON dbo.tb(sex)
-- 显示统计信息
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- 查询 sex = N'女' 的记录
SELECT * FROM dbo.tb
WHERE sex = N'女'
GO

-- test1. 将测试数据调整为包含1条记录为男,其他记录为女
UPDATE dbo.tb SET
	sex = CASE id WHEN 10000 THEN N'男' ELSE N'女' END
-- 显示统计信息
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- 查询 sex = N'女' 的记录
SELECT * FROM dbo.tb
WHERE sex = N'女'
GO

-- test2. 更新统计
UPDATE STATISTICS dbo.tb
-- 显示统计信息
DBCC SHOW_STATISTICS(N'dbo.tb', N'IX_tb_sex')
GO

-- 查询 sex = N'女' 的记录
SELECT * FROM dbo.tb
WHERE sex = N'女'
GO

-- 删除演示环境
USE master
DROP DATABASE test