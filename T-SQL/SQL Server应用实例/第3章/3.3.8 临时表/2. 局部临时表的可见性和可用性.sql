-- �ֲ���ʱ��Ŀɼ��ԺͿ�����
USE tempdb
GO

-- ������ʾ����
CREATE PROC dbo.p_Child
AS
	SET NOCOUNT ON
	IF OBJECT_ID(N'tempdb..#tb') IS NULL
		RAISERROR('#tb not exists', 10, 1) WITH NOWAIT
	ELSE
		SELECT * FROM #tb

	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Child')
	SELECT * FROM #tb
GO

CREATE PROC dbo.p_Test1
AS
	SET NOCOUNT ON
	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Test1')
	SELECT * FROM #tb
	
	EXEC dbo.p_Child

	SELECT * FROM #tb
GO

CREATE PROC dbo.p_Test2
AS
	SET NOCOUNT ON
	CREATE TABLE #tb(
		Description varchar(20))
	INSERT #tb(
		Description)
	VALUES(
		'#tb in dbo.p_Test2')
	SELECT * FROM #tb
GO

-- ��ʾ1. �ӹ���
PRINT '-- ��ʾ1. �ӹ���'
EXEC dbo.p_Test1
GO

-- ��ʾ2. ���й���
PRINT '-- ��ʾ2. ���й���'
EXEC dbo.p_Test2
EXEC dbo.p_Child
GO

-- ��ʾ3, ��ǰ������, �����������ʱ��
PRINT '-- ��ʾ3, ��ǰ������, �����������ʱ��'
CREATE TABLE #tb(
	Description varchar(20))
INSERT #tb(
	Description)
VALUES(
	'#tb in current link')
EXEC dbo.p_Child
DROP TABLE #tb
GO

-- ɾ����ʾ����
DROP PROC dbo.p_Child, dbo.p_Test1, dbo.p_Test2