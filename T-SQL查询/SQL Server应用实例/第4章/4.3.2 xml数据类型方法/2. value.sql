-- һ�㲽���·�����ʽ
DECLARE @test xml
SET @test = '<info>
  <name age="20">����</name>
  <name age="21">����</name>
</info>'
SELECT
	name = @test.value('(/info/name)[1]', 'nvarchar(20)'),
	age = @test.value('(/info/name/@age)[1]', 'int')