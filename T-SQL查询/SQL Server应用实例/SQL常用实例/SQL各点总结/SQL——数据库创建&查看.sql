use master
if exists(select * from sysdatabases where name='BD_1110A')
 drop database BD_1110A
 --����һ������һ����Ҫ�����ļ���һ����Ҫ�����ļ���һ����־�ļ�
Go
 create database DBResource
 on
 (
	name='DBResource',
	filename='G:\DBResource.mdf', ----��Ҫ�ļ�
	size=3mb,
	maxsize=unlimited,
	filegrowth=10%
 ),
 (
	name='DBResource_ndf',
	filename='G:\DBResource.ndf',  ---��Ҫ�ļ�
	size=3mb,
	maxsize=unlimited,
	filegrowth=10%
  )

 log on
 (
	name='DBResourceLog',
	filename='G:\DBResource.ldf',   ---��־�ļ�
	size=1mb,
	maxsize=10mb,
	filegrowth=1
 )
 go  --����������ı�־
 
 
 ---------�鿴�������ݿ����Ϣ
exec sp_helpdb
exec sp_databases   ----���ַ�������


--�鿴ָ�����ݿ���Ϣ
exec sp_helpdb DB_1110A  --(�������Ҫ�鿴�����ݿ�)


----�鿴�����ļ�����Ϣ(�ڵ�ǰ(user)���ݿ���)
use [user]
exec sp_helpfile 

exec sp_helpfilegroup------�鿴�ļ�����Ϣ

exec sp_renamedb 'DB_1110A','1110'----�޸����ݿ������

-----------ɾ�����ݿ�
drop database DB_1110A


