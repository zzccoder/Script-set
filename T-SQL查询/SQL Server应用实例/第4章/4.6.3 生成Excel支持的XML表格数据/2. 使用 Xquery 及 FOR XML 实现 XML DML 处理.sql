-- 演示表, 此表的 col 列为 xml 类型
DECLARE @tb TABLE(
	id int PRIMARY KEY,
	col xml
)

-- 增加演示数据
INSERT @tb(
	id, col)
VALUES(1, '<rows>
	<row>aa</row>
</rows>')

-- 更新操作
DECLARE 
	@id int,
	@xmldata xml

-- 要更新的记录的 ID 及需要增加的 xml 数据
SELECT 
	@id = 1, 
	@xmldata = '<rows>
	<row id="1">new data1</row>
	<row id="2">new data</row>
</rows>'

-- 更新操作
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

-- 显示处理结果
SELECT * FROM @tb