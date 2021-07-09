-- 一般步骤的路径表达式
DECLARE @test xml
SET @test = '<info>
  <name age="20">张三</name>
  <name age="21">李四</name>
</info>'
SELECT
	name = @test.value('(/info/name)[1]', 'nvarchar(20)'),
	age = @test.value('(/info/name/@age)[1]', 'int')