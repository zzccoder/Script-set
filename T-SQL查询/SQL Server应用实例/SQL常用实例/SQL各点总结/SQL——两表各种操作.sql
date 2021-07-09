use BD_1110A
--�γ̡�ѧ�����ɼ�
create table course       ---�����γ̱�
(
	cid int identity primary key,
	cname varchar(20)
)

create table student     ----����ѧ����
(
	sid int identity primary key,
	sname varchar(20) not null,
	sex char(2) check (sex='��' or sex='Ů'),
	age int check(age between 0 and 100)
)

create table score     ----�����ɼ���
(
	id int identity primary key,
	sid int foreign key references student(sid),
	cid int foreign key references course(cid),
	score int check(score between 0 and 100)
)

insert into course values('java'),('sql'),('javascript'),('jquery')
select * from course

select * from student
insert into student values('Tom','��',23),('Merry','Ů',25),('Jim','��',28),('Kate','Ů',19),('John','��',25),('ͬѧ','��','20')

select * from score
insert into score values(1,2,85)
insert into score values(1,1,65)
insert into score values(2,2,45)
insert into score values(2,2,65)
insert into score values(4,3,85)
insert into score values(3,3,73)

select * from student where sid  in (select cid from score)
--�鿴ѧ�ţ�ѧ���������ɼ� 
select student.sid,sname,score
from student inner join score
on student.sid = score.sid

--�鿴�γ̱��,ѧ���ɼ����γ�����
select course.cid,score,course.cname
from course inner join score
on course.cid=score.cid
 

--�鿴ѧ���������γ����ƣ����Գɼ�
select student.sname,course.cname,score
from student inner join score
on student.sid=score.sid
inner join course
on score.cid=score.cid


--�鿴Ůͬѧ�Ŀ��Գɼ���ѧ������
select student.sex,student.sname,score
from student inner join score
on student.sid=score.sid
where sex='Ů'


--�鿴û�μӿ��Ե�ѧ������
select student.sname,score
from student left join score
on student.sid=score.sid
where score is null


--�鿴������25�����ϵ�ѧ�����Գɼ�

select student.sname,student.age,score
from student inner join score
on student.sid=score.sid
where student.age>25

--�鿴û�п��ԵĿ�Ŀ����
select course.cname,score
from course left join score
on course.cid = score.cid
where score is null

--�鿴��ͬѧ��ѧ�����������Կ�Ŀ�����Գɼ�
select student.sex,course.cname,score
from student inner join score
on student.sid= score.sid
inner join course
on score.cid=course.cid

--�鿴�μ�java���Ե�ѧ���������ɼ�
select course.cname,score
from course inner join score
on course.cid=score.cid	
where course.cname='java'


--�鿴Tom�Ŀ��Գɼ������Կ�Ŀ
select student.sname,score,course.cname
from student inner join score
on student.sid=score.sid
inner join course
on score.cid=course.cid
where student.sname='Tom'

--������
select sname,age
into tongxuelu
from student