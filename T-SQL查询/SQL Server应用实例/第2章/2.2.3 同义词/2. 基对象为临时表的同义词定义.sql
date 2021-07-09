-- ����һ��������ʱ���ͬ���
CREATE SYNONYM dbo.tb_Common
FOR #
GO

-- ����һ���û����庯��, ����������ͬ���
CREATE FUNCTION dbo.f_sum()
RETURNS int
AS
BEGIN
	RETURN((SELECT SUM(col) FROM dbo.tb_Common))
END
GO

-- �������Դ洢����1
CREATE PROC dbo.p_test1
AS
SELECT col = 1 
INTO #

SELECT test1 = dbo.f_sum()
GO

-- �������Դ洢����2
CREATE PROC dbo.p_test2
AS
SELECT col = 10
INTO #

EXEC dbo.p_test1
SELECT test2 = dbo.f_sum()
GO

-- ���ô洢���̽��в���
SET NOCOUNT ON

CREATE TABLE #(col int)
EXEC dbo.p_test2
DROP TABLE #

SET NOCOUNT OFF
GO

-- ɾ����ʾ����
DROP PROC dbo.p_test1, dbo.p_test2
DROP FUNCTION dbo.f_sum
DROP SYNONYM dbo.tb_Common
