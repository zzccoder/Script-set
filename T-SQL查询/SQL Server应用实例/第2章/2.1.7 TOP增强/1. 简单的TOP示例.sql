-- ʾ�������
DECLARE @t TABLE(id int)

-- 1. INSERT�����Ʋ�������
INSERT TOP (5) @t(
	id)
SELECT object_id FROM sys.objects
ORDER BY object_id

-- 2. ɾ������, ֻ��������
DELETE TOP (@@ROWCOUNT - 2)
FROM @t

-- 3. ���ɾ��������Ϊ3��, �����2��, �������0��
UPDATE TOP (CASE @@ROWCOUNT WHEN 3 THEN 2 ELSE 0 END) A SET
	id = id + 1
FROM @t A

-- ��ʾ���յĴ�����
SELECT * FROM @t