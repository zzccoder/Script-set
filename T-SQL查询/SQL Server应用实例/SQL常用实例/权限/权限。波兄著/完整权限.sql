use ExtentOfPower
Go
if exists(select * from sysobjects where name='[user]')
	drop table [user]
create table [user]  ---�û���
(
	id int identity primary key, ---  ��������Id
	userId int not null,      -----�û�Id
	UserName nvarchar(40) not null,   ---�û�����	
)	
if exists(select * from sysobjects where name='rols')
	drop table rols
create table rols     ---��ɫ��
(
	id int identity primary key, -----��������Id
	rolsId int not null,
	RolsName nvarchar(50) not null
)
if exists(select * from sysobjects where name='rols_user')
	drop table rols_user
	create table rols_user     ---�û���ɫ��ϵ��
	(
		id int identity primary key, -----���������ID
		RolsId int not null,   ---��ɫId
		userId int not null  ---�û�Id
	) 
if exists(select * from sysobjects where name='FunctionGroup')
	drop table FunctionGroup
	create table FunctionGroup   ---�������
	(
		id int Identity primary key,
		FunctionGroupId int not null,
		FunctionGroupName nvarchar(50) not null
	)
if exists(select * from sysobjects where name='module') 
	drop table module              ----ҳ���
	create table module
	(
		id int identity primary key,
		moduleId int not null,
		moduleName nvarchar(50) null,		
		parentId int default(0),
		moduleAddress nvarchar(50) not null,
		FunctionGroupId int not null
		
	)
if exists(select * from sysobjects where name='ButtonAll')
		drop table ButtonAll     -----ȫ����Button
		create table ButtonAll
		(
			id int identity primary key,
			buttonId int not null,
			buttonName nvarchar(50) not null,
			buttonAddress nvarchar(60) not null,
			ButtonEnabled int default(1) not null,			
			FunctionGroupId int not null						
		)
if exists(select * from sysobjects where name='role_power')	
		drop table role_power    ----Ȩ�޷���
		create table role_power
		(
			id int identity primary key ,
			RolsId int not null,			
			FunctionGroupId int not null
		)
			

	
	-------------------------------------------------������-----------------
	