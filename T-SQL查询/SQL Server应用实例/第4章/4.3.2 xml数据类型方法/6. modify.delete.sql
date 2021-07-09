DECLARE @test xml
SET @test = '<?xml-stylesheet type="text/xsl" href="BlockInfo.xsl"?>
<root>
  <!-- ע��1 -->
  <proc>test111</proc>
  <function />
  <tb name="test">value</tb>
  <!-- ע��2 -->
</root>'

-- 1. ɾ���ӽڵ� tb �� name ����
SET @test.modify('
	delete /root/tb/@name')

-- 2. ɾ���ӽ�� proc �� function
SET @test.modify('
	delete (
		/root/proc,
		/root/function)')

-- 3. ɾ��ָ��
SET @test.modify('
	delete /processing-instruction()')

-- 4. ɾ�� root �ڵ��еĵ�1��ע�ͽ��
SET @test.modify('
	delete (/root/comment())[1]')

-- 5. ɾ���ӽ�� tb ���ı��ڵ�
SET @test.modify('
	delete (/root/tb/text())[1]')

-- ��ʾ���в��������ս��
SELECT @test