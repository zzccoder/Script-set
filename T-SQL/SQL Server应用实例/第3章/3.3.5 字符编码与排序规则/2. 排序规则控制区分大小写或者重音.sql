-- ʹ�����������ƱȽ��Ƿ����ִ�Сд������
SELECT
	[���ִ�Сд] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CS_AS = 'A'
				THEN 1
			ELSE 0 END,
	[����ȫ������] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CI_AS = '��'
				THEN 1
			ELSE 0 END,
	[����ȫ������] = CASE
			WHEN 'a' COLLATE Chinese_PRC_90_CI_AS_WS = '��'
				THEN 1
			ELSE 0 END
GO

-- ��ѯ��Ч�������
SELECT *
FROM ::fn_helpcollations()
