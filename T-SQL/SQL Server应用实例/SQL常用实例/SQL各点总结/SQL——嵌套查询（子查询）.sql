select * from course
select * from student
select * from score

--外面的查询叫做父查询，里面的叫做子查询

--查看年龄比Tom大的同学
select * from student where age > (select age from student where sname='Tom')


--修改年龄比Merry大的同学的年龄为29岁
update student set age=29 where age >(select age from student where sname='Merry')

-------------------------------------------------------------------------------------
--将一张表的数据全部复制到一张新表中
/*
select 列名
into 新表  --不存在
from 旧表名
*/
--将学生姓名和年龄插入到通讯录表中（通讯录不存在）
select sname,age 
into tongxunlu
from student

select * from tongxunlu

--将数据复制到一张已经存在的表中
/*
insert into 表名(字段名)  --存在
select 列名 
from 旧表名
*/
insert into tongxunlu(sname,age)
select sname,age 
from student

--一次插入多行
insert into tongxunlu(sname,age)
select 'a',1 union
select 'b',2 union
select 'c',3
---------------------------------------------------------------------
--查看比Jim成绩高的同学(了解)
--a 查看Jim的成绩
select score from score where sid =(select sid  from student where sname='Jim')
--b 根据成绩查看比Jim高的学号
select sid from score where score >(select score from score where sid =(select sid  from student where sname='Jim'))
--c 根据学号查看学生信息
select * from student where sid in 
(select sid from score where score>(select score from score where sid =(select sid  from student where sname='Jim')))

----所有的子查询都可以用表连接来进行替换
--查看参加考试的学生信息
select * from student where sid in (select sid from score)
--<=>
select distinct sname from student inner join score
on student.sid=score.sid

--查看没有参加考试的学生信息
select * from student where sid  not in (select sid from score)
--<=>
select sname from student left join score
on student.sid=score.sid
where score is null

--下面这个例子子查询不能替换表连接
select * from student  --5
select * from score  --6

--内连接 =   --6
select * from student inner join score
on student.sid=score.sid

--可以替换为

select * from student where sid in(select sid from score)

--内连接 <>   -- =5*6-6=24
select * from student inner join score
on student.sid<>score.sid

--不能用嵌套查询替换

----------------------------------------------------
select * from student  --5
select * from score  --6

--查看不及格的学生
select sname from student inner join score on student.sid=score.sid where score<60

select sname from student where sid in(select sid from score where score<60)


--可能包括没参加考试的同学，也可能没查询出补考通过而第一次不及格的同学
select sname from student where sid  not in(select sid from score where score>=60)