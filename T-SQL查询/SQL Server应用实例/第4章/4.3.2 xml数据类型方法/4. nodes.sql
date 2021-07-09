DECLARE @test xml
SET @test = '<info>
  <name age="20">张三</name>
  <name age="21">李四</name>
</info>'
SELECT
	name = T.c.value('.[1]', 'nvarchar(20)'),
	age = T.c.value('@age[1]', 'int')
FROM @test.nodes('/info/name') T(c)
