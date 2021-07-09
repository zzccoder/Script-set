use BD_1110A
--课程、学生、成绩
create table course       ---创建课程表
(
	cid int identity primary key,
	cname varchar(20)
)

create table student     ----创建学生表
(
	sid int identity primary key,
	sname varchar(20) not null,
	sex char(2) check (sex='男' or sex='女'),
	age int check(age between 0 and 100)
)

create table score     ----创建成绩表
(
	id int identity primary key,
	sid int foreign key references student(sid),
	cid int foreign key references course(cid),
	score int check(score between 0 and 100)
)

insert into course values('java'),('sql'),('javascript'),('jquery')
select * from course

select * from student
insert into student values('Tom','男',23),('Merry','女',25),('Jim','男',28),('Kate','女',19),('John','男',25),('同学','男','20')

select * from score
insert into score values(1,2,85)
insert into score values(1,1,65)
insert into score values(2,2,45)
insert into score values(2,2,65)
insert into score values(4,3,85)
insert into score values(3,3,73)

select * from student where sid  in (select cid from score)
--查看学号，学生姓名，成绩 
select student.sid,sname,score
from student inner join score
on student.sid = score.sid

--查看课程编号,学生成绩，课程名称
select course.cid,score,course.cname
from course inner join score
on course.cid=score.cid
 

--查看学生姓名，课程名称，考试成绩
select student.sname,course.cname,score
from student inner join score
on student.sid=score.sid
inner join course
on score.cid=score.cid


--查看女同学的考试成绩和学生姓名
select student.sex,student.sname,score
from student inner join score
on student.sid=score.sid
where sex='女'


--查看没参加考试的学生姓名
select student.sname,score
from student left join score
on student.sid=score.sid
where score is null


--查看年龄在25岁以上的学生考试成绩

select student.sname,student.age,score
from student inner join score
on student.sid=score.sid
where student.age>25

--查看没有考试的科目名称
select course.cname,score
from course left join score
on course.cid = score.cid
where score is null

--查看男同学的学生姓名，考试科目，考试成绩
select student.sex,course.cname,score
from student inner join score
on student.sid= score.sid
inner join course
on score.cid=course.cid

--查看参加java考试的学生姓名，成绩
select course.cname,score
from course inner join score
on course.cid=score.cid	
where course.cname='java'


--查看Tom的考试成绩及考试科目
select student.sname,score,course.cname
from student inner join score
on student.sid=score.sid
inner join course
on score.cid=course.cid
where student.sname='Tom'

--创建表
select sname,age
into tongxuelu
from student