-- 1. �ۼӸ�ֵ
DECLARE @re varchar(max)
SET @re = ''

SELECT 
	@re = @re 
		+ ',' + CONVERT(varchar(20), object_id)
FROM sys.objects
SET @re = STUFF(@re, 1, 1, '')
PRINT @re
GO

-- 2. ���������ñ���, ���õ��ǳ�ʼֵ, �������ۼӹ����е�ֵ
DECLARE @re int
SET @re = 0

SELECT 
	@re = @re + object_id
FROM sys.objects
WHERE @re < 10000
GO

-- 3. ��UPDATE��ʵ�ָ�ֵ
-- ������ʾ��
DECLARE @tb TABLE(
	id int)
INSERT @tb(
	id)
SELECT 1 UNION ALL
SELECT NULL UNION ALL
SELECT 9

-- ��ֵ����
DECLARE 
	@id int, @re int
SELECT
	@id = 0,
	@re = 0
UPDATE @tb SET
	id = @id,
	@id = @id + 1,
	@re = @re + ISNULL(id, 0)

-- ��ʾ���յĽ��
SELECT re = @re, * FROM @tb
GO