--  使用 WITH XMLNAMESPACES 同时声明默认命名空间和非默认命名空间
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
