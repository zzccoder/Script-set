-- ����Ԫ��info��name��Ԫ����,�Ƿ���age����>20�Ľڵ�
DECLARE @test xml
SET @test = '<info>
  <name age="20">����</name>
  <name age="21">����</name>
</info>'
SELECT 
	@test.exist('/info/name[@age>20]')
