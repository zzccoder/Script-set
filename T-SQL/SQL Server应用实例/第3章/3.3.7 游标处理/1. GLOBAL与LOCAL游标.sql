-- 1. ͬһ�����еĴ洢������,���ʹ��ͬ�����α�ʵ�ֲ�ͬ�Ĺ���,Ӧ��ʹ��LOCAL�α�
CREATE PROC dbo.p_test1
AS
	DECLARE CUR_tb CURSOR
	LOCAL
--	GLOBAL 
	FOR
	SELECT 1
GO

CREATE PROC dbo.p_test2
AS
	DECLARE CUR_tb CURSOR 
	LOCAL
--	GLOBAL 
	FOR
	SELECT 2
GO

EXEC dbo.p_test1
EXEC dbo.p_test2
GO

DROP PROC dbo.p_test1, dbo.p_test2
--DEALLOCATE CUR_tb
