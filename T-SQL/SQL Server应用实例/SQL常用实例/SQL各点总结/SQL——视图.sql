--视图：view 虚拟的表，视图中的数据全部来源自基表（源表）。
---我们可以对视图进行增删改查的操作，但是相当于操作基表的数据。
---视图可以是一张表的部分字段，也可以是多张表的多个字段
select * from student
select * from score

--创建视图语法：
/*
create view 视图名称
as
	select 语句
go
*/
use BD_1110A
Go
create view v1

as
	select sname,age from student
	
select * from v1

update v1 set age=12 where sname='张三'

select * from v1
select * from student
select * from score

insert into v1 values('a',23)

delete from v1 where sname='张三'

create view v2
as
	select student.sid,sname,age,score
	from student inner join score 
	on student.sid=score.sid
	
select * from v2

--修改视图
alter view 视图名称
as	
	select 语句

alter view v2
as 
	select student.sid,sname,age,score,email
	from student inner join score 
	on student.sid=score.sid

--删除视图
drop view 视图名称

drop view v2


