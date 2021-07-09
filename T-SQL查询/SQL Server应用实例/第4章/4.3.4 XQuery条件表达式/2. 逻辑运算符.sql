DECLARE @test xml
SET @test = '<softwares>
  <software name="dict">
    <category>tools</category>
    <price>100.00</price>
    <environment>windows</environment>
  </software>
  <software name="debug">
    <category>tools</category>
    <price>50.00</price>
  </software>
  <software name="windows">
    <category>OS</category>
    <price>1000.00</price>
  </software>
</softwares>'

SELECT @test.query('<softwares>{
for $i in /softwares/software
where ($i/category="tools" and $i/price>=100)
	or ($i/category="OS")
	return $i
}</softwares>')