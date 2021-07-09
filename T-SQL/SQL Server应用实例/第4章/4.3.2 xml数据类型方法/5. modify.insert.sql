DECLARE @test xml
SET @test = '<root/>'

-- 1. 插入子节点 tb
SET @test.modify('
	insert <tb/>
	into /root[1]')

-- 2. 在 tb 子结点前插入 proc 和 function 两个同级节点
SET @test.modify('
	insert (
		<proc />,
		<function />
	)
	before (/root/tb)[1]')

-- 3. 在 XML 实例的最前面插入指令
SET @test.modify('
	insert <?xml-stylesheet type="text/xsl" href="BlockInfo.xsl"?>
	as first into /')

-- 4. 在 root 子结点最后插入注释结点
SET @test.modify('
	insert <!-- 注释 -->
	as last into (/root)[1]')

-- 5. 为 tb 节点增加一个名为name的属性
SET @test.modify('
	insert attribute name{"test"}
	into (/root/tb)[1]')

-- 6. 在 proc 节点中插入文本节点序列
SET @test.modify('
	insert(
		text{"test"},
		text{"111"}
	)
	into (/root/proc)[1]')

-- 显示所有操作的最终结果
SELECT @test