--��ͼ��view ����ı���ͼ�е�����ȫ����Դ�Ի���Դ����
---���ǿ��Զ���ͼ������ɾ�Ĳ�Ĳ����������൱�ڲ�����������ݡ�
---��ͼ������һ�ű�Ĳ����ֶΣ�Ҳ�����Ƕ��ű�Ķ���ֶ�
select * from student
select * from score

--������ͼ�﷨��
/*
create view ��ͼ����
as
	select ���
go
*/
use BD_1110A
Go
create view v1

as
	select sname,age from student
	
select * from v1

update v1 set age=12 where sname='����'

select * from v1
select * from student
select * from score

insert into v1 values('a',23)

delete from v1 where sname='����'

create view v2
as
	select student.sid,sname,age,score
	from student inner join score 
	on student.sid=score.sid
	
select * from v2

--�޸���ͼ
alter view ��ͼ����
as	
	select ���

alter view v2
as 
	select student.sid,sname,age,score,email
	from student inner join score 
	on student.sid=score.sid

--ɾ����ͼ
drop view ��ͼ����

drop view v2


