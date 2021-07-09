-- 1. 使用 declare 声明默认命名空间
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

-- 2. 使用 declare 声明非默认命名空间
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