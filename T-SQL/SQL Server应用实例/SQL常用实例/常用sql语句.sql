declare @MACHINE_NAME nvarchar(50)
declare @PARTS_SN nvarchar(50)
declare @goog_number nvarchar(50)
declare @PERSON_NUMBER nvarchar(50) 

select @MACHINE_NAME=classname, @PARTS_SN=title from dbo.T_Article_Article where id = 7

select @MACHINE_NAME
select @PARTS_SN


select convert(varchar(8),getdate(),112)

select CONVERT(VARCHAR(10),GETDATE(),120)


--产生一定范围的随机整数
select floor(rand()*6);


--查询重复数据的几种不同的方法
--方法一
select id from T_Required where [Name] in (select [Name] from T_Required group by [Name] having(count(*)>1))
--方法二
select * from T_Required  as a where exists  
(select 0 from T_Required as b where a.Name=b.Name and a.Name1=b.Name1 group by b.Name,b.Name1 having count(*)>1)
--方法三
delete T_Required where ID not in 
(select min(ID) from T_Required group by [Name],Name1, Name2, Name3)

--求短日期
select dateadd(day, -1, substring(cast(getdate() as varchar) , 1,10));

--日期加减
select DATEADD (month , -1, getdate() );


--求本周
select datepart(wk, getdate());
select * from 表 where datepart(wk, 时间字段) = datepart(wk, getdate()) 


--求月份的分组统计
select '当月的记录数', 
	datepart(month, substring(cast(CircleCreatDate as varchar) , 1,10)), 
	count(1) 
from dbo.Circle 
group by 
	datepart(month, substring(cast(CircleCreatDate as varchar) , 1,10));

--分组统计每个班的平均分数
select GroupId,sum(Score)/count(1) FROM dbo.Score group by GroupId order by sum(Score)/count(1) asc

--
insert into dbo.T_System_User
	(UserName, UserPass, CreateTime, UserType)
select UserName, UserPass, CreateTime, UserType from dbo.T_System_User


update T_System_User set UserName = UserName + CAST( UserId AS nvarchar)

--分页sql语句
--一页5条
--我要求第二页2(6 - 10)
--3(11-15)
--4(4-1*5)
select top 5 * from dbo.T_System_User where
 UserId not in 
( select top 0 UserId from T_System_User order by CreateTime desc) 
order by CreateTime desc
