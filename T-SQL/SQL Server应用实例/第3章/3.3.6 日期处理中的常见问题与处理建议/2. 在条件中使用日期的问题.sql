--a. 忽略了日期转换为字符后的格式
SELECT * FROM tbname
WHERE DateField LIKE '2005-01-01%'

SELECT * FROM tbname 
WHERE LEFT(DateField, 10) = '2005-01-01'

SELECT * FROM tbname
WHERE CONVERT(CHAR(10), DateField, 120) = '2005-1-1'

SELECT * FROM tbname 
WHERE DateField LIKE '2005-01-01%'

--b.  错误的日期区间查询(查询2005年2月至2006年3月的数据)
SELECT * FROM tbname 
WHERE Year(DateField) = 2005 AND Month(DateField) >= 2
	AND Year(DateField) = 2006 AND Month(DateField) <= 3
