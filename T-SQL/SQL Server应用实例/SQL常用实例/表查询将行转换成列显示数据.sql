create database lianxi

use lianxi

create table score(
	id int primary key identity(1,1),
	name nvarchar(10),
	[object] nvarchar(10),
	mark int
)

insert into score values
('����','����',80),('����','��ѧ',90),('����','Ӣ��',85),
('����','����',83),('����','��ѧ',95),('����','Ӣ��',89)

select * from score

select 
	a.name, 
	(select b.mark from score as b where b.name = a.name and b.object = '����' ) as ���� 
from 
	score as a 
group by name 

select score.name as ���� ,
����=SUM(case score.object when '����' then mark end),
��ѧ=SUM(case score.object when '��ѧ' then mark end),
Ӣ��=SUM(case score.object when 'Ӣ��' then mark end)
from score  GROUP by name

select score.name as ����,score.object ���� insert t1 from score
where score.object='����'
select ����=score.name,��ѧ=score.object insert t2 from score
where score.object='��ѧ'
select ����=score.name,Ӣ��=score.object insert t3 from score
where score.object='Ӣ��'