DECLARE @test xml
SET @test = '<?xml-stylesheet type="text/xsl" href="BlockInfo.xsl"?>
<root>
  <!-- 注释1 -->
  <proc>test111</proc>
  <function />
  <tb name="test">value</tb>
  <!-- 注释2 -->
</root>'

-- 1. 删除子节点 tb 的 name 属性
SET @test.modify('
	delete /root/tb/@name')

-- 2. 删除子结点 proc 和 function
SET @test.modify('
	delete (
		/root/proc,
		/root/function)')

-- 3. 删除指令
SET @test.modify('
	delete /processing-instruction()')

-- 4. 删除 root 节点中的第1个注释结点
SET @test.modify('
	delete (/root/comment())[1]')

-- 5. 删除子结点 tb 的文本节点
SET @test.modify('
	delete (/root/tb/text())[1]')

-- 显示所有操作的最终结果
SELECT @test