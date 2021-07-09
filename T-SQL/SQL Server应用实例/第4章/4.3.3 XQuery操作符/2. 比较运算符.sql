DECLARE @x xml
SET @x='<root>
  <a />
  <b />
</root>'

-- 1. is 比较
SELECT @x.query('
if ((/root/a)[1] is (/root/*)[1])
	then 1
else
	0
')

-- 2. << 比较
SELECT @x.query('
if ((/root/a)[1] << (/root/b)[1])
	then 1
else
	0
')