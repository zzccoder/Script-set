use BD_1110A         ----Ҫʹ�õ����ݿ�
if exists(select * from sysobjects where name='[user]')  --���[user]���Ƿ����,�������ɾ�����˱�
	drop table [user]      -----ɾ����
	
create table [user]   ----������,��Ϊuser��sql���ǹؼ�����������Ҫ���������Ÿ�������
(
	id int identity(1,1) primary key,
	name nvarchar(10) not null,      ----------�ǿ�Լ��
	sex char(4) check(sex='��' or sex='Ů') default '��',----���Լ������Χ,Ĭ��Ϊ'��'
	age int check(age>=0 and age<=100),    
	phone char(15) unique       -----ΨһԼ�� 
)

Go
--������
create table info  
(
  --identity(1,1)�����У����ӣ������� primary key ����Լ��
  stuNo int identity(1,1) primary key, 
  stuName varchar (20)	not null,
  
  --check()���Լ�� check (���� lick ����) 
  StuEmail varchar(20) check(stuEmail like '%@%' ) not null,
  
  -- not null �ǿ�
  stuID numeric(18,0) unique check(len(stuID)=18)not null,
  
  --check()���Լ�� check (����=���� �� ����=����)  or��and 
  stuSex char(2) check(stuSex='��' or stuSex='Ů') not null,
  
   --unique  ΨһԼ�� check (len(����)=11)   
  stuTel char(11) unique check(len(stuTel)=11) not null,
  
  --check()���Լ�� check (����>=���� �� ����<=����)
  stuAge int check(stuAge>='0' or stuAge<='100') not null,
  
  -- default()  Ĭ��Լ�� default('Ĭ��ֵ')
  stuAddress varchar(50) default('��������') 
)

Go
--�鿴goods�������Ϣ
exec sp_help [user]

------------�޸ı�ṹ
--����һ��
alter table [user]
add aa varchar(20)
--�޸�һ��
alter table [user]
alter column aa int
--ɾ��һ��
alter table [user]
drop column aa
Go ---��������

/*
1 ��������
   1.1 �﷨
	insert [into] ���� [(�ֶ���)] values (ֵ)
   1.2 һ�β����������
	 a һ�β����������
		insert [into] ���� [(�ֶ���)] values (ֵ),(ֵ),(ֵ)...
		
		insert [into] ���� [(�ֶ���)] 
		select ֵ union
		select ֵ union
		select ֵ
		
	b ��һ�ű��е����ݲ��뵽�����ڵı���
		select ����
		into �±���   --������ 
		from �ɱ���
				
	c ��һ�ű��е����ݸ�ֵ�����ڵı���
		insert [into] �±��� [(�ֶ���)]
		select ����
		from �ɱ���
		
2 �޸�����
	update ���� set �ֶ�1=ֵ1[,�ֶ�2=ֵ2,....] [where ����]
	
3 ɾ������
	delete [from] ���� [where ����]
4 ��ѯ����
	select ���� from ����
	[where ����]
	[group by ������]
	[having ��������]
	[order by ������[asc|desc]]
	˵����
		����ǰ����Էţ�	
			����������top n 
					  top n percent
			ȥ���ظ��distinct
*/
insert into [user] values('��̲�','��','20','18210480488'),
                         ('������','��','20','12332112311')------ ��������
                         
select * from [user]   ---�鿴[user]��

--ģ����ѯ
--ͨ�����like
/*
		%��0�������ַ�
		_��һ���ַ�
		[]:�ڷ�Χ�ڵ�һ���ַ�
		[^]�����ڷ�Χ�ڵ�һ���ַ�
*/

select * from [user] where name like '��%'  ---ģ����ѯ

update [user] set sex='Ů' where id='3';  ---�޸ı���Ϣ

delete from [user] where id=1;           ---ɾ��
--ɾ������ɾ���ӱ���ɾ������



