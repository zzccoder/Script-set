-- 1. 同一连接中的存储过程中,如果使用同名的游标实现不同的功能,应该使用LOCAL游标
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
