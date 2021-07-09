DECLARE @test xml
SET @test = '<root>
  <proc>test111</proc>
  <function />
  <tb name="test" />
</root>'

-- 1. 更新子节点 proc 的文本节点值
SET @test.modify('
	replace value of (/root/proc/text())[1]
	with "newvalue"')

-- 2. 更新子节点的 name 属性值
SET @test.modify('
	replace value of (/root/tb/@name)[1]
	with "new attribute value"')

-- 显示所有操作的最终结果
SELECT @test