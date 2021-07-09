CREATE FUNCTION dbo.f_CursorExists(
	@CursorName sysname
)RETURNS TABLE
AS
RETURN(
	WITH
	LOCAL AS(
		SELECT 
			Name = @CursorName,
			Type = CAST('LOCAL' as varchar(8)),
			IsExists = CONVERT(bit,
					CASE CURSOR_STATUS('LOCAL', @CursorName)
						WHEN -3 THEN 0 
						ELSE 1 END)
	),
	GLOBAL AS(
		SELECT 
			Name = @CursorName,
			Type = CAST('GLOBAL' as varchar(8)),
			IsExists = CONVERT(bit,
					CASE CURSOR_STATUS('GLOBAL', @CursorName)
						WHEN -3 THEN 0 
						ELSE 1 END)
	),
	VARIABLE AS(
		SELECT 
			Name = @CursorName,
			Type = CAST('VARIABLE' as varchar(8)),
			IsExists = CONVERT(bit,
					CASE CURSOR_STATUS('VARIABLE', @CursorName)
						WHEN -3 THEN 0
						ELSE 1 END)
	),
	CUR AS(
		SELECT * FROM LOCAL
		UNION ALL
		SELECT * FROM GLOBAL
		UNION ALL
		SELECT * FROM VARIABLE
	)
	SELECT * FROM CUR
	WHERE IsExists=1
)
GO

--DROP FUNCTION dbo.f_CursorExists