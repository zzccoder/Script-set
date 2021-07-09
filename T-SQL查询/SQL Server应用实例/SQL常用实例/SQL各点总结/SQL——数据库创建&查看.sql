use master
if exists(select * from sysdatabases where name='BD_1110A')
 drop database BD_1110A
 --创建一个包含一个主要数据文件，一个次要数据文件，一个日志文件
Go
 create database DBResource
 on
 (
	name='DBResource',
	filename='G:\DBResource.mdf', ----主要文件
	size=3mb,
	maxsize=unlimited,
	filegrowth=10%
 ),
 (
	name='DBResource_ndf',
	filename='G:\DBResource.ndf',  ---次要文件
	size=3mb,
	maxsize=unlimited,
	filegrowth=10%
  )

 log on
 (
	name='DBResourceLog',
	filename='G:\DBResource.ldf',   ---日志文件
	size=1mb,
	maxsize=10mb,
	filegrowth=1
 )
 go  --批处理结束的标志
 
 
 ---------查看所有数据库的信息
exec sp_helpdb
exec sp_databases   ----两种方法均可


--查看指定数据库信息
exec sp_helpdb DB_1110A  --(这里插入要查看的数据库)


----查看数据文件的信息(在当前(user)数据库下)
use [user]
exec sp_helpfile 

exec sp_helpfilegroup------查看文件组信息

exec sp_renamedb 'DB_1110A','1110'----修改数据库的名称

-----------删除数据库
drop database DB_1110A


