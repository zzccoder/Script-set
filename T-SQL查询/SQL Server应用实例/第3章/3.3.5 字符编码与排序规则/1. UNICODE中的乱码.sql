USE master
GO

CREATE DATABASE DB_Test
	COLLATE Latin1_General_CI_AS
GO

USE DB_test
GO

-- ��ʾ�����
DECLARE @tb TABLE(
	id int,
	col nvarchar(10))
INSERT @tb(
	id, col)
SELECT id = 1, col = '��' UNION ALL
SELECT id = 2, col = N'��'

-- 1. ��ʾ����
SELECT * FROM @tb

-- 2. ��������
SELECT * FROM @tb 
WHERE col = '��'

SELECT * FROM @tb
WHERE col = N'��'
GO

-- ɾ����ʾ���ݿ�
USE master
DROP DATABASE DB_Test