-- 测试元素info的name子元素中,是否有age属性>20的节点
DECLARE @test xml
SET @test = '<info>
  <name age="20">张三</name>
  <name age="21">李四</name>
</info>'
SELECT 
	@test.exist('/info/name[@age>20]')
