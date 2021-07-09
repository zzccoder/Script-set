SET NOCOUNT ON

-- 建立演示环境
DECLARE @tb TABLE(
	id int PRIMARY KEY)
INSERT @tb
SELECT 1 UNION ALL
SELECT 3 UNION ALL
SELECT 4 UNION ALL
SELECT 5

-- 循环插入10条数据
BEGIN TRY
	DECLARE 
		@id int,
		@ids varchar(100)	
	
	-- 初始化参数
	SELECT
		@id = 0,
		@ids = ''

	-- 循环插入10次数据到表变量中@tb
	WHILE @id < 10
	BEGIN
		SET @id = @id + 1
		BEGIN TRY
			BEGIN TRAN
				INSERT @tb VALUES(@id)
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			-- 如果插入失败, 则回滚事务
			IF XACT_STATE() <> 0
				ROLLBACK TRAN
			-- 记录插入失败的id
			SET @ids = @ids + ',' + RTRIM(@id)
		END CATCH
	END
	
	-- 如果包含有插入失败的记录, 则抛出错误
	IF @ids > ''
	BEGIN
		SET @ids = STUFF(@ids, 1, 1, '')
		RAISERROR('these id could''t insert: %s', 16, 1, @ids)
	END
END TRY
BEGIN CATCH
	IF XACT_STATE() <> 0
		ROLLBACK TRAN

	DECLARE
		@ErrorStr nvarchar(1000),
		@ErrorSeverity int,
		@ErrorState int,
		@ErrorNumber int,
		@ErrorProcedure sysname,
		@ErrorLine int,
		@ErrorMessage nvarchar(4000)

	SELECT
		@ErrorStr = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: %s',
		@ErrorSeverity = ERROR_SEVERITY(),
		@ErrorState = ERROR_STATE(),
		@ErrorNumber = ERROR_NUMBER(),
		@ErrorProcedure = ERROR_PROCEDURE(),
		@ErrorLine = ERROR_LINE(),
		@ErrorMessage = ERROR_MESSAGE()

	RAISERROR(
		@ErrorStr,
		@ErrorSeverity, 
		1,               
		@ErrorNumber,
		@ErrorSeverity, 
		@ErrorState,               
		@ErrorProcedure,
		@ErrorLine,
		@ErrorMessage)
END CATCH
-- 显示处理结果, 确认可以插入表变量中的值已经正确插入
SELECT * FROM @tb
SET NOCOUNT OFF