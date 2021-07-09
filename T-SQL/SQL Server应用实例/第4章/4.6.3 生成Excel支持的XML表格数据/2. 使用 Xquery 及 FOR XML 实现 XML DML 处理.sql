-- ��ʾ��, �˱�� col ��Ϊ xml ����
DECLARE @tb TABLE(
	id int PRIMARY KEY,
	col xml
)

-- ������ʾ����
INSERT @tb(
	id, col)
VALUES(1, '<rows>
	<row>aa</row>
</rows>')

-- ���²���
DECLARE 
	@id int,
	@xmldata xml

-- Ҫ���µļ�¼�� ID ����Ҫ���ӵ� xml ����
SELECT 
	@id = 1, 
	@xmldata = '<rows>
	<row id="1">new data1</row>
	<row id="2">new data</row>
</rows>'

-- ���²���
UPDATE A SET
	col = B.col
FROM @tb A
	OUTER APPLY(
		SELECT col = (
			SELECT
				T.c.query('row'),
				@xmldata.query('/rows/row')
			FROM A.col.nodes('/rows')T(c)
			FOR XML PATH(''), ROOT('rows'), TYPE
			)
	)B

-- ��ʾ������
SELECT * FROM @tb