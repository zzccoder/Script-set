DECLARE @x xml
SET @x='<root>
  <a />
  <b />
</root>'

-- 1. is �Ƚ�
SELECT @x.query('
if ((/root/a)[1] is (/root/*)[1])
	then 1
else
	0
')

-- 2. << �Ƚ�
SELECT @x.query('
if ((/root/a)[1] << (/root/b)[1])
	then 1
else
	0
')