--日期函数
--获得当前时间
select GETDATE()

--增加时间：dateadd（日期部分，加数，时间）
select dateadd(DAY,5,GETDATE())
select DATEADD(day,-5,getdate())

--datediff(日期部分，日期1，日期2):计算日期1和日期2之间的时间差
select DATEDIFF(MONTH,'1989-01-12','1994-11-27')
select DATEDIFF(SECOND,'2011-03-21',getdate())
select DATEDIFF(dd,'1992-02-12',GETDATE())
select DATEDIFF(dd,getdate(),DATEADD(yy,70,'1992-02-12'))

--datepart(日期部分，时间)：获得日期部分
select DATEPART(yy,getdate())-20



--数学函数
--abs（）：绝对值
select ABS(-25)
select ABS(0)

--rand():随机数
select RAND()

--round(数值，小数位数):四舍五入
select ROUND(-11.4,0)
select ROUND(-11.5,0)
select ROUND(-11.6,0)
select ROUND(11.25632,2)-- 11.26000

--floor():向下取整，获得小于或等于当前数的最大整数
select FLOOR(-11.2)  -- -12
select FLOOR(-11)  -- -11

select FLOOR(11.2)  -- 11
select FLOOR(11)  --11


--ceiling():向上取整
select CEILING(-11.2)  -- -11
select CEILING(-11)   --  -11
select CEILING(11.2)   --  12
select CEILING(11)   --  11


--字符串函数
--left() right() :从左（右）截取指定长度的字符
select LEFT('abcdefg',3)
select RIGHT('abcdefg',3)

--len()：字符长度
select LEN('中国')

--lower() upper() :转换成大写（小写）
select LOWER('ASDFsdaf')
select UPPER('SDAFSADFdasdfasdf')

--ltrim() rtrim() :去掉字符串左（右）端的空格
select 'c' + LTRIM('163 36   ')+'d'
--去掉两端空格
select 'c' + rtrim(ltrim (' 163 36  ')) + 'd'

--reverse() :反转字符串
select REVERSE('abcdefg')

--replace(字符串，旧，新) ：字符串替换
select REPLACE('0000abdfoasoodf0','0','o')

--substring(要截取的字符串，开始位置，长度)：字符串截取
select SUBSTRING('abcdefg',2,4)

use mytest
select * from employee
--查看每位员工的姓氏
select substring(empname,1,1) from employee

--将身份证中所有的1都替换成0
select replace(empid,'1','0') from employee

--查看每位员工名字的个数
select empname,LEN(empname) from employee


---类型转换函数

--cast(要转换的数值 as 目标类型)
select 'a'+CAST(1 as CHAR(2))

--想将员工编号和姓名合为一个字段
select cast(empNo as CHAR(2))+empname from employee

--convert(目标类型，要转换的数值)
select CONVERT(char(2),1)+'a'
select convert(char(2),empNo)+empname from employee

--截取每个员工的名字
select right(empname,len(empname)-1) from employee
select SUBSTRING(empname,2,len(empname)-1) from employee

select REVERSE(empname) from employee