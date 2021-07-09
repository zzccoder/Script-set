DECLARE @test xml
SET @test = ''

-- 1. 在modify方法中, 使用FLWOR表达式构造XML实例
SET @test.modify('
insert (
<values>
{
	for $i in(1,2), $j in (2,3)
	return <value a="{$i}" b="{$j}" />
}
  </values>
) into /')
SELECT @test

-- 2. 迭代 value 子结点的属性 a 和 b 
SELECT @test.query('<root>{
for $i in /values/value
where $i/@a != $i/@b
order by $i/@a descending, $i/@b
	return
		if($i/@a="1" and $i/@b="3") then
			concat(string($i/@a), string($i/@b))
		else
			concat(string($i/@a), string($i/@b), ",")
}</root>')
