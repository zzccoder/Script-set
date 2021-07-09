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
	return <software name="{$i/@name}" remark="{
			if ($i/category!="OS") then
				if ($i/environment) then
					"has environment request"
				else
					"no  environment request"
			else()
		}"  />
}</softwares>')