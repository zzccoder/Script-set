SET NOCOUNT ON

-- ������ʾ����
DECLARE @tb TABLE(
	id int PRIMARY KEY)
INSERT @tb
SELECT 1 UNION ALL
SELECT 3 UNION ALL
SELECT 4 UNION ALL
SELECT 5

-- ѭ������10������
BEGIN TRY
	DECLARE 
		@id int,
		@ids varchar(100)	
	
	-- ��ʼ������
	SELECT
		@id = 0,
		@ids = ''

	-- ѭ������10�����ݵ��������@tb
	WHILE @id < 10
	BEGIN
		SET @id = @id + 1
		BEGIN TRY
			BEGIN TRAN
				INSERT @tb VALUES(@id)
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			-- �������ʧ��, ��ع�����
			IF XACT_STATE() <> 0
				ROLLBACK TRAN
			-- ��¼����ʧ�ܵ�id
			SET @ids = @ids + ',' + RTRIM(@id)
		END CATCH
	END
	
	-- ��������в���ʧ�ܵļ�¼, ���׳�����
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
-- ��ʾ������, ȷ�Ͽ��Բ��������е�ֵ�Ѿ���ȷ����
SELECT * FROM @tb
SET NOCOUNT OFF