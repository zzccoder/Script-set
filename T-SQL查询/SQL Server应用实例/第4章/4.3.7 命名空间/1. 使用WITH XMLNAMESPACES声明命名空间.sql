--  ʹ�� WITH XMLNAMESPACES ͬʱ����Ĭ�������ռ�ͷ�Ĭ�������ռ�
DECLARE @test xml
SET @test = '<root xmlns="http://namespace_test">
  <P:production xmlns:P="http://namespacetest">abc</P:production>
</root>'

;WITH 
XMLNAMESPACES(
	DEFAULT 'http://namespace_test',
	'http://namespacetest' as P
)
SELECT @test.query('/root/P:production')
