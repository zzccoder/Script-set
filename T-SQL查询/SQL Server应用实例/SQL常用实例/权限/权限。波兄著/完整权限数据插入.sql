use ExtentOfPower
Go
insert into [user] values('1','admin'),('2','��̲�'),('3','����'),('4','�Ӻ�');
----------���û����������
Go
insert into rols values('1','������'),('2','��Ա'),('3','��ͨ�û�'),('4','�ο�');
------------�Խ�ɫ�������
Go
insert into rols_user values('1','1'),('1','2'),('2','3'),('3','4')
----------�Խ�ɫ�û���ϵ���������
Go
insert into FunctionGroup values('1','����'),('2','ɾ��'),('3','�޸�'),('4','�鿴');
-----------------�Թ�������������
Go
insert into module Values('1','����ҳ��','0','www.baidu.com/application/index.axps','1'),
							('2','Ȩ�޹���','0','www.baidu.com/application/index.axps','1'),
							('3','�û�ҳ��','1','www.baidu.com/application/index.axps','1');
-----------------��UIҳ����������
Go
insert into ButtonAll Values('1','���','www.baidu.com/application/index.axps','1','1'),
							('2','ɾ��','www.baidu.com/application/index.axps','1','2'),
							('3','�鿴','www.baidu.com/application/index.axps','1','3')
-----------------��button���������
Go
insert into role_power values('1','1'),('1','2'),('1','3'),('1','4');
--------------��role_power�����������

select * from [user]
select * from rols
select * from rols_user
select * from module
select * from FunctionGroup
select * from ButtonAll
select * from role_power

drop table [user]
drop table rols
drop table rols_user
drop table module
drop table FunctionGroup
drop table ButtonAll
drop table role_power

Go
-------------��ʾ��admin���û������п��Բ�����ҳ��-------

select * from module where FunctionGroupId in
(
select FunctionGroupId from role_power where RolsId =
(select Rolsid from rols_user where userId=
(select userId from [user] where UserName='admin')) 
)

Go
---------------------��ʾ��admin���û������п��Բ�����button
select * from ButtonAll where FunctionGroupId in
(
	select FunctionGroupId from role_power where RolsId =
(select Rolsid from rols_user where userId=
(select userId from [user] where UserName='admin')) 
)