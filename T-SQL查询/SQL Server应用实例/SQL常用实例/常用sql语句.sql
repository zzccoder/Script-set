declare @MACHINE_NAME nvarchar(50)
declare @PARTS_SN nvarchar(50)
declare @goog_number nvarchar(50)
declare @PERSON_NUMBER nvarchar(50) 

select @MACHINE_NAME=classname, @PARTS_SN=title from dbo.T_Article_Article where id = 7

select @MACHINE_NAME
select @PARTS_SN


select convert(varchar(8),getdate(),112)

select CONVERT(VARCHAR(10),GETDATE(),120)


--����һ����Χ���������
select floor(rand()*6);


--��ѯ�ظ����ݵļ��ֲ�ͬ�ķ���
--����һ
select id from T_Required where [Name] in (select [Name] from T_Required group by [Name] having(count(*)>1))
--������
select * from T_Required  as a where exists  
(select 0 from T_Required as b where a.Name=b.Name and a.Name1=b.Name1 group by b.Name,b.Name1 having count(*)>1)
--������
delete T_Required where ID not in 
(select min(ID) from T_Required group by [Name],Name1, Name2, Name3)

--�������
select dateadd(day, -1, substring(cast(getdate() as varchar) , 1,10));

--���ڼӼ�
select DATEADD (month , -1, getdate() );


--����
select datepart(wk, getdate());
select * from �� where datepart(wk, ʱ���ֶ�) = datepart(wk, getdate()) 


--���·ݵķ���ͳ��
select '���µļ�¼��', 
	datepart(month, substring(cast(CircleCreatDate as varchar) , 1,10)), 
	count(1) 
from dbo.Circle 
group by 
	datepart(month, substring(cast(CircleCreatDate as varchar) , 1,10));

--����ͳ��ÿ�����ƽ������
select GroupId,sum(Score)/count(1) FROM dbo.Score group by GroupId order by sum(Score)/count(1) asc

--
insert into dbo.T_System_User
	(UserName, UserPass, CreateTime, UserType)
select UserName, UserPass, CreateTime, UserType from dbo.T_System_User


update T_System_User set UserName = UserName + CAST( UserId AS nvarchar)

--��ҳsql���
--һҳ5��
--��Ҫ��ڶ�ҳ2(6 - 10)
--3(11-15)
--4(4-1*5)
select top 5 * from dbo.T_System_User where
 UserId not in 
( select top 0 UserId from T_System_User order by CreateTime desc) 
order by CreateTime desc
