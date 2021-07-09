-- бнЪОЪ§Он
DECLARE @tb TABLE(
	id int, a int, b int)
INSERT @tb(
	id, a, b)
SELECT id = 1, a = 1, b = NULL UNION ALL
SELECT id = 2, a = NULL, b = 2 UNION ALL
SELECT id = 3, a = NULL, b = NULL

SET ANSI_NULLS ON
SET ANSI_NULLS OFF
DECLARE @a int, @b int
DECLARE CUR_tb CURSOR LOCAL
FOR
SELECT a, b FROM @tb
OPEN CUR_tb 
FETCH CUR_tb INTO @a, @b
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @a <> @b
		PRINT '<>'
	ELSE IF @a = @b
		PRINT '='
	ELSE
		PRINT 'O'
	FETCH CUR_tb INTO @a, @b
END
CLOSE CUR_tb
DEALLOCATE CUR_tb