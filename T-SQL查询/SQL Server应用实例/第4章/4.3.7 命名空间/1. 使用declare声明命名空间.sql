-- 1. ʹ�� declare ����Ĭ�������ռ�
DECLARE @test xml
SET @test = ''

SET @test.modify('
declare default element namespace "http://namespacetest";
insert(
  <root>
    <production>abc</production>
  </root>
)into /')
SELECT @test
GO

-- 2. ʹ�� declare ������Ĭ�������ռ�
DECLARE @test xml
SET @test = ''

SET @test.modify('
declare default element namespace "http://namespace_test";
declare namespace P="http://namespacetest";
insert(
  <root>
    <P:production>abc</P:production>
  </root>
)into /')
SELECT @test