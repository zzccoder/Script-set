DECLARE @test xml
SET @test = '<root>
  <proc>test111</proc>
  <function />
  <tb name="test" />
</root>'

-- 1. �����ӽڵ� proc ���ı��ڵ�ֵ
SET @test.modify('
	replace value of (/root/proc/text())[1]
	with "newvalue"')

-- 2. �����ӽڵ�� name ����ֵ
SET @test.modify('
	replace value of (/root/tb/@name)[1]
	with "new attribute value"')

-- ��ʾ���в��������ս��
SELECT @test