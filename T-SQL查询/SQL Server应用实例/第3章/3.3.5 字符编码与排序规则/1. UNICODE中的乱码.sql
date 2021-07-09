USE master
GO

CREATE DATABASE DB_Test
	COLLATE Latin1_General_CI_AS
GO

USE DB_test
GO

-- 演示表变量
DECLARE @tb TABLE(
	id int,
	col nvarchar(10))
INSERT @tb(
	id, col)
SELECT id = 1, col = '中' UNION ALL
SELECT id = 2, col = N'中'

-- 1. 显示数据
SELECT * FROM @tb

-- 2. 条件检索
SELECT * FROM @tb 
WHERE col = '中'

SELECT * FROM @tb
WHERE col = N'中'
GO

-- 删除演示数据库
USE master
DROP DATABASE DB_Test