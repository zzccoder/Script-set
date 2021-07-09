create database function1 
----------------------------字符串函数--------------------------

--字符串函数charindex 用来寻找一个指定的字符串在另一个字符串中的起始位置。
select charindex('accp','myaccpcoures',1)
--字符串函数len返回字符串的长度
select len('123')
--字符串函数Lower字符串转换为小写
select Lower('ABC')
--字符串函数Upper把字符串转换为大写
select Upper('abc')
--字符串函数Ltrim清除左边的空格
select Ltrim(' adb')
--字符串函数Rtrim清楚右边的空格
select Rtrim(' ads ')
--字符串函数right从字符串右边返回指定数目的字符串
select Right('1234',3)
--字符串函数replace替换一个字符串中的字符
select replace('123123123','1','abc')
--字符串函数stuff在字符串中删除指定长度的字符并在该位置播入一个
--新的字符串
select stuff('123456789',2,3,'a')

------------------------------日期函数-----------------------------

--获得当前的系统日期
select getdate()
--将制定的数值添加到指定的日期部分后的日期
select dateadd(mm,5,01/01/90)
select dateadd(dd,5,01/01/90)
select dateadd(yy,5,01/01/90)
--两个日期相差的月份
select datediff(mm,'01/01/20','01/05/20')
--年的差距
select datediff(yy,'01/01/20','05/01/20')
--日期的差距
select datediff(dd,'01/01/20','01/01/25')
--返回的是星期几
select datename(dw,'01/01/2000')
--返回日期指定日期部分的整数形式--返回日期
select datepart(day,'01/15/2000')


-------------------------------数学函数-------------------------

--绝对值函数
select abs(-43)
--返回大于或等于所给数自表达式的最大整数
--向上取整
select ceiling(43.5)
--取小于或等于指定表达式的最大整数
--向下取整
select floor(43.5)
--去数值表达式的幂值
select power(5,2)
--四舍五入
select round(43.543,1)
--对于正数返回+1，对于负数返回-1,对于0则返回0
select sign(-43)
--取浮点数表达式的平方根
select sqrt(9)

------------------------------系统函数----------------------

--用来转变数据类型
select convert(varchar(5),12345) 
--返回当前用户的名字
select current_user
--返回当前用户登录的计算机名称
select Host_name()
--返回当前所登录的用户名称
select System_User
--从给定的用户Id返回用户名
select User_name(1)
--返回用于指定表达式的字节数
select datalength('中国A盟')

-------------------------------聚集函数-------------------

select * from fun
--求和Sum
select sum(Sun) from fun
--求平均值
select avg(sun) from fun
--求总个数
select count(*) from fun
--求最大值
select max(sun) from fun
--求最小值
select min(sun) from fun 
create table fun
(
    Sun int
)
insert into fun values(1)
insert into fun values(2)
insert into fun values(3)
insert into fun values(4)
insert into fun values(5)
insert into fun values(6)