-- 1. �򵥵�·�����ʽ
DECLARE @test xml
SET @test = '<lva >
  <lv2 id="1">
    <lv3 id="11"/>
  </lv2>
</lva>
<lvb>
  <lv2 id="2"/>
</lvb>'

SELECT @test.query('/lva/lv2')
SELECT @test.query('//lv2')
GO

-- 2. ������ѡν�ʵ�·�����ʽ
DECLARE @test xml
SET @test = '<lva >
  <lv2 id="1">
    <lv3 id="11"/>
  </lv2>
</lva>
<lvb>
  <lv2 id="2"/>
</lvb>'

SELECT @test.query('/*[.//lv2/@id="2"]')