select * from course
select * from student
select * from score

--����Ĳ�ѯ��������ѯ������Ľ����Ӳ�ѯ

--�鿴�����Tom���ͬѧ
select * from student where age > (select age from student where sname='Tom')


--�޸������Merry���ͬѧ������Ϊ29��
update student set age=29 where age >(select age from student where sname='Merry')

-------------------------------------------------------------------------------------
--��һ�ű������ȫ�����Ƶ�һ���±���
/*
select ����
into �±�  --������
from �ɱ���
*/
--��ѧ��������������뵽ͨѶ¼���У�ͨѶ¼�����ڣ�
select sname,age 
into tongxunlu
from student

select * from tongxunlu

--�����ݸ��Ƶ�һ���Ѿ����ڵı���
/*
insert into ����(�ֶ���)  --����
select ���� 
from �ɱ���
*/
insert into tongxunlu(sname,age)
select sname,age 
from student

--һ�β������
insert into tongxunlu(sname,age)
select 'a',1 union
select 'b',2 union
select 'c',3
---------------------------------------------------------------------
--�鿴��Jim�ɼ��ߵ�ͬѧ(�˽�)
--a �鿴Jim�ĳɼ�
select score from score where sid =(select sid  from student where sname='Jim')
--b ���ݳɼ��鿴��Jim�ߵ�ѧ��
select sid from score where score >(select score from score where sid =(select sid  from student where sname='Jim'))
--c ����ѧ�Ų鿴ѧ����Ϣ
select * from student where sid in 
(select sid from score where score>(select score from score where sid =(select sid  from student where sname='Jim')))

----���е��Ӳ�ѯ�������ñ������������滻
--�鿴�μӿ��Ե�ѧ����Ϣ
select * from student where sid in (select sid from score)
--<=>
select distinct sname from student inner join score
on student.sid=score.sid

--�鿴û�вμӿ��Ե�ѧ����Ϣ
select * from student where sid  not in (select sid from score)
--<=>
select sname from student left join score
on student.sid=score.sid
where score is null

--������������Ӳ�ѯ�����滻������
select * from student  --5
select * from score  --6

--������ =   --6
select * from student inner join score
on student.sid=score.sid

--�����滻Ϊ

select * from student where sid in(select sid from score)

--������ <>   -- =5*6-6=24
select * from student inner join score
on student.sid<>score.sid

--������Ƕ�ײ�ѯ�滻

----------------------------------------------------
select * from student  --5
select * from score  --6

--�鿴�������ѧ��
select sname from student inner join score on student.sid=score.sid where score<60

select sname from student where sid in(select sid from score where score<60)


--���ܰ���û�μӿ��Ե�ͬѧ��Ҳ����û��ѯ������ͨ������һ�β������ͬѧ
select sname from student where sid  not in(select sid from score where score>=60)