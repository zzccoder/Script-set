DECLARE @test xml
SET @test = '<root/>'

-- 1. �����ӽڵ� tb
SET @test.modify('
	insert <tb/>
	into /root[1]')

-- 2. �� tb �ӽ��ǰ���� proc �� function ����ͬ���ڵ�
SET @test.modify('
	insert (
		<proc />,
		<function />
	)
	before (/root/tb)[1]')

-- 3. �� XML ʵ������ǰ�����ָ��
SET @test.modify('
	insert <?xml-stylesheet type="text/xsl" href="BlockInfo.xsl"?>
	as first into /')

-- 4. �� root �ӽ��������ע�ͽ��
SET @test.modify('
	insert <!-- ע�� -->
	as last into (/root)[1]')

-- 5. Ϊ tb �ڵ�����һ����Ϊname������
SET @test.modify('
	insert attribute name{"test"}
	into (/root/tb)[1]')

-- 6. �� proc �ڵ��в����ı��ڵ�����
SET @test.modify('
	insert(
		text{"test"},
		text{"111"}
	)
	into (/root/proc)[1]')

-- ��ʾ���в��������ս��
SELECT @test