--查询当前连接的实例名
select @@servername


--察看任何数据库属性
sp_helpdb master

 

--设置单用户模式，同时立即断开所有用户
alter database Northwind set single_user with rollback immediate


--恢复正常
alter database Northwind set multi_user

 

--察看数据库属性
sp_helpdb


--察看数据库恢复模式
select databasepropertyex('Northwind','recovery')


--设置自动创建统计
alter database Northwind set auto_create_statistics on/off


--设置自动更新统计
alter database Northwind set auto_update_statistics on/off


--查看作业列表
select * from msdb..sysjobs


--查看作业详细信息
exec msdb..sp_help_job @job_name = 'HQCRM-CrmNew-CrmNew_2Dimension-NANJINGCRM-216'


--修改作业信息
exec msdb..sp_update_job @job_id = 0x4CA27521C9033C48954E7BFC6B965395, @enabled = 1


--察看服务器角色
exec sp_helpsrvrolemember


--添加服务器角色
exec sp_addsrvrolemember 'member_name','sysadmin'


--删除服务器角色
exec sp_dropsrvrolemember 'member_name','sysadmin'


--察看数据库角色
exec sp_helprole


--添加数据库角色
exec sp_addrole 'role_name'


--删除数据库角色
exec sp_droprole 'role_name'


--查看用户信息
exec sp_helpuser


--注意删除guest帐户
use dbname
go
exec sp_dropuser guest

 

--修改对象拥有者
exec sp_changeobjectowner 'old_onwer.table_name', 'new_owner'

 

--查看BUILTIN\Administrators帐号
exec master..xp_logininfo 'BUILTIN\Administrators', 'members'


--修改默认数据库
exec sp_defaultdb 'login', 'defaultdb'


--创建新的登陆
exec sp_addlogin @loginame = 'esProgram',@passwd = 'h1J2P97vfdlK34',@defdb = 'career'

 

--更改登陆数据库访问权限
use <dbname>
exec sp_grantdbaccess @loginame ='esProgram',@name_in_db = 'esProgram'

 

--把角色db_appuser添加用户帐号中
use <dbname>
exec sp_addrolemember @rolename = 'db_appuser',@membername = 'esProgram'


--预测增长
use master
/* Procedure for 8.0 server */
create proc usp_databases
as
set nocount on
declare @name sysname
declare @SQL nvarchar(600)
/* Use temporary table to sum up database size w/o using group by */
create table #databases (
      DATABASE_NAME sysname NOT NULL,
      size int NOT NULL)
declare c1 cursor for 
   select name from master.dbo.sysdatabases
    where has_dbaccess(name) = 1 -- Only look at databases to which we have access
open c1
fetch c1 into @name
while @@fetch_status >= 0
begin
   select @SQL = 'insert into #databases
     select N'''+ @name + ''', sum(size) from '
     + QuoteName(@name) + '.dbo.sysfiles'
   /* Insert row for each database */
   execute (@SQL)
   fetch c1 into @name
end
deallocate c1
select 
   DATABASE_NAME,
   DATABASE_SIZE = size*8,/* Convert from 8192 byte pages to K */
   RUN_DT=GETDATE()
from #databases
order by 1
GO

create table DatabaseSizeReport
(Database_Name Varchar(32),
Database_Size int, 
CreateDt datetime)

insert into DatabaseSizeReport exec usp_databases

select * from DatabaseSizeReport


--快捷方式
ALT-F1   sp_help
CTRL-1   sp_who
CTRL-2   sp_lock


--查看对象空间
exec sp_spaceused <db_name>/<table_name>


--察看文件是否存在
exec xp_fileexist "c:\test.txt"


--察看文件详细信息
exec master..xp_getfiledetails "c:\test.txt"

 

--查看系统出错日志
set nocount on --执行一个查询或者是存储过程是要保证这个是开的。可以提高速度
create table #sunying_error_lg
(errortext varchar(500),
continuerow int)
insert into #sunying_error_lg exec master..xp_readerrorlog
select * from #sunying_error_lg
drop table #sunying_error_lg

 

--获得dbcc命令的完整列表
dbcc help('?')

 

--检测数据库损坏情况
alter database <dbname> set single_user with rollback immediate
dbcc checkdb (<dbname>,repair_fast)


--数据库损坏处理步骤
1.检查SQL SERVER和Windows NT错误日志，看是否能找出问题所在。例如，可能硬盘驱动器已满。
2.以单用户模式启动SQL Server。
3.用@dbname参数执行sp_resetstatus(比如，sp_resetstatus @dbname="pubs")。来使数据库摆脱损坏状态
4.以单用户模式重新启动SQL Server。
5.如果数据库仍处于置疑状态，可将它重设回正常模式，并试着用下面命令转储置疑的数据库的事务：dump transaction Northwind with no_log
6.再次以单用户模式启动SQL Server，如果数据库出现了，可对其进行详细的DBCC检查(checkdb,checkalloc,等等)
7.运行一些随机查询，看看是否会遇到问题。
8.如果没有问题出现，可停止并重新启动SQL Server，然后将数据库投入生产应用。

 

--将数据库置于紧急模式
sp_configure 'allow updates',1
reconfigure with override
go
update master..sysdatabases set status=-32768 where name='pubs'
go
sp_configure 'allow updates',0
reconfigure with override
go


--当数据库处于这种模式时,你只能从中读取数据。
--查看日志空间
dbcc sqlperf(logspace)


--查看高速缓存命中率
dbcc sqlperf(lrustats)


--查看活动事务(open transaction)
dbcc opentran


--如果有事务是活动的比如(SPID:54 UID:1)，还有看这个事务打开了多久了。如果有人忘了，可以用
--kill 54
--来干掉他

--查看用户使用set命令的全部内容
dbcc useroptions


--比如可以查看set nocount on
--系统函数
app_name()函数返回当前从SQL Server请求数据的应用程序名称。
get_date()函数返回SQL Server上的当前时间。
host_name()函数确定是哪台工作站正在连接到SQL Server。
system_user函数提供正在连接的用户的登陆名
db_name()告诉你连接是哪个数据库


--@@identity标识列
drop table sunying_test
create table sunying_test (aid int identity,val varchar(500))
insert into sunying_test (val) select 'abc' --@@identity为1
insert into sunying_test (val) select 'abc' --@@identity为2
insert into sunying_test (val) select 'abc' --@@identity为3
select * from sunying_test
select @@identity


--在不同连接里查@@identity她返回null
select @@identity


--和@@identity相同，不同点即使停止SQL Server并且重新建立连接，这个命令仍然会返回正确的值
select ident_current('<table_name>')


--查看I/O，执行计划
set statistics io on
select count(*) from sunying_test


--断开一个数据库的所有用户
sp_who
create procedure usp_killusers @dbname varchar(50) as
set nocount on
declare @strSQL varchar(255)
print 'Killing Users'
print '---------------------'
create table #tmpUsers(
spid int,
eid int,
status varchar(30),
loginname varchar(50),
hostname varchar(50),
blk int,
dbname varchar(50),
cmd varchar(30))
insert into #tmpUsers exec sp_who
declare logincursor cursor
read_only
for select spid,dbname from #tmpUsers where dbname=@dbname
declare @spid varchar(10)
declare @dbname2 varchar(40)
open logincursor
fetch next from logincursor into @spid,@dbname2
while (@@fetch_status<>-1)
begin
if (@@fetch_status<>-2)
begin
    print 'Killing '+@spid
    set @strSQL='KILL '+@spid
    exec (@strSQL)
end
fetch next from logincursor into @spid,@dbname2
end
close logincursor
deallocate logincursor
drop table #tmpUsers
print 'Done'
go

usp_killusers 'crmnew'


--top的使用
select top n * from <tablename> --返回表中前n行记录
select top n percent * from <tablename> --返回表中最前面的n%行记录

 

--优化索引的充满度,她对索引的性能影响很大
dbcc showcontig (T_Contract_Pdt)
/* --执行以后显示如下
DBCC SHOWCONTIG 正在扫描 'T_Contract_Pdt' 表...
表: 'T_Contract_Pdt'（124071728）；索引 ID: 1，数据库 ID: 7
已执行 TABLE 级别的扫描。
- 扫描页数.....................................: 95
- 扫描扩展盘区数...............................: 14
- 扩展盘区开关数...............................: 40
- 每个扩展盘区上的平均页数.....................: 6.8
- 扫描密度［最佳值:实际值］....................: 29.27%［12:41］这个值不能低应该尽可能接近100%,低了说明有碎片
- 逻辑扫描碎片.................................: 18.95% --这个值高意味着表中存在很多碎片
- 扩展盘区扫描碎片.............................: 57.14% --这个值高意味着表中存在很多碎片
- 每页上的平均可用字节数.......................: 1800.2
- 平均页密度（完整）...........................: 77.76% --这个值是关键，系统默认是98%,这个值低的话说明有大量的插入操作。最好控制在85%-98%
DBCC 执行完毕。如果 DBCC 输出了错误信息，请与系统管理员联系。
*/


--解决碎片问题，重建索引
dbcc dbreindex (<table_name>,'<index_name>',<fill factor>)
dbcc dbreindex (T_Contract_Pdt)
dbcc showcontig (T_Contract_Pdt)


/* --执行以后显示如下
DBCC SHOWCONTIG 正在扫描 'T_Contract_Pdt' 表...
表: 'T_Contract_Pdt'（124071728）；索引 ID: 1，数据库 ID: 7
已执行 TABLE 级别的扫描。
- 扫描页数.....................................: 75
- 扫描扩展盘区数...............................: 10
- 扩展盘区开关数...............................: 9
- 每个扩展盘区上的平均页数.....................: 7.5
- 扫描密度［最佳值:实际值］....................: 100.00%［10:10］
- 逻辑扫描碎片.................................: 0.00%
- 扩展盘区扫描碎片.............................: 0.00%
- 每页上的平均可用字节数.......................: 121.3
- 平均页密度（完整）...........................: 98.50%
DBCC 执行完毕。如果 DBCC 输出了错误信息，请与系统管理员联系。
*/


--重建索引开销很大。可以用整理索引碎片来代替,但最彻底最好的方式是重建索引
dbcc indexdefrag (<db_name>,<table_name>,<index_name>)


--backupset表提供有关备份的详细信息
select * from msdb..backupset

 

--查看登陆用户
select * from master..syslogins


--查看用户信息
select * from Northwind..sysusers


--sysusers和syslogins表的sid相对应，但在还原或者附加数据库可能出现不一致的现象，可以使用比如：
sp_change_users_login 'report'


--查看不匹配的用户
sp_change_users_login 'auto_fix', <username>


--纠正这个用户名，如果这个用户登陆不存在的话会创建他。也可以用Update_One参数修复如下
sp_change_users_login 'update_one', <username>,<loginname>


--恢复损坏的master库
1.使用\Program Files\Microsoft SQL Server\80\Tools\Binn目录下的rebuildm.exe文件重建master数据库。重建master数据库可以使用你的数据库文件完整无缺。记得把数据文件和日志文件备份到其他地方。
2.使用-m参数启动SQL Server，这样可以以单用户模式重新启动SQL Server。
3.从最近一次已知最好的备份来还原master数据库。
4.核实master数据库是不是已经成功还原，确认所有数据库都已恢复正常并运行。从最近一次已知最好的备份来还原msdb数据库。
5.以普通模式停止和启动SQL Server
6.向生产用户开放数据库

 

--重建其他数据库。
\Program Files\Microsoft SQL Server\MSSQL\Install\
instmsdb.sql--msdb数据库
instnwnd.sql--Northwind数据库
instpubs.sql--pubs数据库
--注意重建msdb以后，作业，DTS包和其他关键信息将会丢失。重建以后要还原她

--查看执行计划
set statistics profile on
select * from course_info
set statistics profile off
--在查询分析器里选择查询--显示执行计划,显示服务器跟踪，显示客户统计
--暂停服务器后已经连接的客户机连接不受影响，可以继续执行，但拒绝新的客户机连接请求。建议DBA在实际管理中，先选择暂停，然后在选择关闭

--SQL SERVER2000推荐使用动态分配内存的方法，实例会在Windows操作系统的调度下动态获得内存。选中SQL Server保留物理内存复选框指定为SQLSERVER保留与内存设置相等的物理内存空间，这样操作系统不能使用为SQL SERVER保留的内存空间。在最小查询内存文本框里可以设置分配给每个用户执行查询的最小内存，默认为1024KB
--如果SQL SERVER服务器非常重要，要确定足够的内存来运行，可以选指定固定大小的内存。配置了固定内存并不表明一开始SQLSERVER2000服务器就占用设置的内存，而是随着需要内存的增加不断增加，最后只能使用最多的内存。

--索引填充因子假如设置为60%那么就规定了在向索引页面中插入索引数据时最多可以占用的页面空间是(60%*8KB=4.8KB)。剩下的约40%(40%*8KB=3.2KB)的空间保留供索引的数据更新使用。如果更新后索引数据超出了原有索引页面的存储空间后，SQL SERVER2000会自动将原索引页面大致一半的数据迁移到新的页面中，称为页的分裂。页的分裂操作将会导致系统性能的严重下降。
--什么是恢复间隔，默认是0这表示用于快速恢复的自动设置，表示由SQLSERVER2000自动决定什么时间生成检查点。
--什么是检查点,如果系统崩溃进行恢复时，需要从头到尾扫描日志文件的内容，执行重做或者回滚的操作。如果没有检查点，每次恢复都要从头开始扫描，这对于大容量的日志文件来说，会导致恢复的时间比较长。有了检查点，就可以从距离发生故障点最近的检查点开始做起就可以了。可以大大减少恢复的时间。
--恢复间隔其实就是检查点发生频率的参数


--手动执行检查点
checkpoint;


--查询服务器当前运行参数
select * from master..sysconfigures

--服务器出错日志默认路径
C:\Program Files\Microsoft SQL Server\MSSQL\LOG

--master库是最重要的数据库存储系统信息，磁盘空间，文件分配和使用，系统级的配置参数，所有的登陆帐户信息，初始化信息和其他数据库信息等。
--msdb库是SQLSERVER代理服务使用的数据库。为报警，作业，任务调度和记录操作员操作提供存储空间。
--tempdb库是临时数据库，她为所有临时表，临时存储过程以及其他的临时操作提供空间。每次重起改数据库里的信息就是丢失。
--model库是存储了所有用户数据库和tempdb数据库的模板。
--启动
1.启动master库
2.启动model库
3.启动msdb库
4.清除tempdb库
5.启动tempdb库
--DBCC（data base consistency checker）,数据库控制台命令，也称数据库一致性检查是SQLSERVER2000提供的一类特殊的命令，用于执行特殊的数据库管理操作


--查询所有的DBCC命令
dbcc help('?')
--查询指定DBCC命令的语法说明
dbcc help('checkalloc')
--返回当前连接的活动设置
dbcc traceon(3604)
go
dbcc useroptions
go
--检查指定数据库的磁盘空间分配结构的一致性
dbcc checkalloc('Northwind',repair_allow_data_loss|repair_fast|repair_rebuild)
repair_allow_data_loss:完成所有的修复，有可能会导致一些数据丢失
repair_fast:进行小的，不耗时的修复操作，不会有丢失数据
repair_rebuild:完成所有的修复，包括较长时间的修复比如重建索引

 

--检查数据库中系统表内及系统表间的一致性
dbcc checkcatalog('Northwind')


--用于检查指定表上的约束完整性
use Northwind
go
dbcc checkconstraints('Customers')
go


--检查指定数据库中的所有对象的分配和结构完整性
dbcc checkdb('Northwind')


--检查指定表或索引视图的数据，索引及text,ntext和image页的完整性
use Northwind
go
dbcc checktable('Customers')
go


--检查指定表的当前标识值
use pubs
go
dbcc checkident(jobs,noreseed|reseed new_reseed_value)


--回收alter table drop column语句删除可变长度列或text列后的存储空间,注意不能对系统表或临时表执行该操作
dbcc cleantable('Northwind','Customers')
--重建指定数据库中一个或多个索引
--create index语句比较优点
--1.允许动态重建表的索引或为表定义的所有索引
--2.允许重建强制PRIMARY KEY或者UNIQUE约束的索引，而不必除去并重新创建些约束。
--3.允许使用一条语句重建表的所有索引，这比多个DROP INDEX和CREATE INDEX语句进行编码容易。
--4.可以优化SQL Server数据库的性能
--注意不能在系统表使用dbcc dbreindex
dbcc dbreindex('Northwind..Customers')
go
--通常怀疑sp_spaceused所返回的值不正确时使用,对表和聚集索引中sysindexes表的rows,used,reserved和dpages列进行更正。
dbcc updateusage('pubs','authors')
go
--对表或视图上的索引和非聚集索引进行碎片整理
--上面已经说过了碎片影响性能已经处理方法，这里就不在重复
dbcc indexdefrag(Northwind,Orders,CustomersOrders)
go

--将表驻留在内存中，和将表从内存中撤消。注意dbcc pintable适用于小表，使用时不要把大表驻留内存。这样会严重影响性能
use Northwind
set @db_id=db_id('Northwind')
set @tb1_id=object_id('Northwind..Customers')
dbcc pintable(@db_id,@tb1_id)
dbcc unpintable(@db_id,@tb1_id)

--收缩数据库，不会把物理文件大小进行收缩，对使用空间进行收缩，物理大小的收缩用dbcc shrinkfile
--Northwind数据库中的文件有10%的可以空间，
dbcc shrinkdatabase(Northwind,10)

--收缩物理文件大小
use Northwind
sp_helpfile
dbcc shrinkfile(1,1000M)
--用于从缓冲池中删除所有内容，即将内存中的所有数据库有的数据全部清除
--可以用于性能测试，在不重起的情况下，清一下内存，在考察SQL语句的性能时就能得到SQL语句执行的物理IO执行情况
dbcc dropcleanbuffers
--在内存中卸载指定的扩展存储过程动态连接库(DLL)
--1.查询已经装载的DLL
sp_helextendedroc
go
--2.从内存中释放系统存储过程xp_sendmail的DLL
dbcc xp_sendmail(free)
go
--显示用户最后执行的语句，比较实用^_^
--1.显示用户连接的进程ID（SPID）
exec sp_who
--2.显示语句
dbcc inputbuffer(spid)
--查询某个数据库执行时间最久的事务，对调优很有用^_^
dbcc opentran('master')
--显示指定表上指定目标的当前分布统计信息，主要是索引的统计信息
use pubs
dbcc show_statistics(authors,UPKCL_auidind)
go

--显示指定表的数据和索引的碎片信息这个上面已经提过了
use <db_name>
dbcc showcontig(<table_name>)
go
--返回多中有用的统计信息
--1.统计事务日志信息
dbcc sqlperf(logspace)
--2.统计线程管理信息
dbcc sqlperf(umsstats)
num user:当前UMS调度器使用的SQL Server线程数。
num runnable:实际上正在运行的SQL Server线程数。
num workers:线程池的大小，也就是实际上的工作者数量。
idle workers:当前空闲的工作者数量。
cntxt switches:在运行的线程间进行的上下文切换数。
cntxt switches(idle):空闲的线程间进行的上下文切换数。
--3.统计资源等待类型信息
dbcc sqlperf(waitstats)
--4.统计I/O资源消耗信息
dbcc sqlperf(iostats)
--5.统计先读信息
dbcc sqlperf(rastats)
--6.统计每个线程的资源消耗信息
dbcc sqlperf(threads)
--显示内存的统计信息,内存的细分信息
dbcc cachestats
dbcc memorystatus
--显示游标的统计信息
dbcc cursorstats

--显示缓存中先读和预先准备的SQL语句
dbcc sqlmgrstats
Memory Used(8k pages):如果内存页面数量很大，该值表示一些用户连接先读了许多Transact-SQL语句。
Number CSql Objects:缓存中的Transact-SQL语句总的数量
Number False Hits:到内存中去查找已经缓存的Transact-SQL语句而没有命中的值。该值应该尽可能低

--用于清除内存中的某个数据库的存储过程缓存内容
declear @intDBID integer
set @intDBID=(select dbid from master..sysdatabases where name='TESTDB01')
dbcc flushprocindb(@intDBID)
go
--显示缓冲区的头部信息的页面信息
dbcc traceon(3604)
go
dbcc buffer(master,'sysobjects',2)
go
--显示数据库的结构信息
dbcc traceon(3604)
go
dbcc dbinfo(master)
go
--显示管理数据库的表（数据字典）信息
dbcc traceon(3604)
go
dbcc dbtable(master)
go
--查看某个索引使用的页面信息
dbcc traceon(3604)
go
dbcc ind(master,sysobjects,0)
go

--查看某个数据库使用的事务日志信息
dbcc traceon(3604)
go
dbcc log(crmnew,-1)
go

--显示过程缓冲池
dbcc traceon(3604)
go
dbcc procbuf(master,'sp_help',1,0)
go

--用于输出某个页面的每行指向的页面号
dbcc traceon(3604)
go
declare @dbid int,@objectid int
select @dbid=DB_ID('master')
select @objectid=object_id('sysobjects')
dbcc prtipage(@dbid,@objectid,1,0)
go
--显示当前连接到服务器的进程
dbcc traceon(3604)
go
dbcc pss(ADMINISTRATOR,54,1)
go
--显示当前服务器资源情况
dbcc traceon(3604)
go
dbcc resource
go

--用于查看数据页面的结构
dbcc traceon(3604)
go
declare @dbid int,@objectid int
select @dbid=DB_ID('master')
select @objectid=object_id('sysdatabases')
dbcc tab(@dbid,@objectid)
go

--查询SQL语句的读写代价
set statistics io on
go
select count(1) from Northwind..employees
go
set statistics io off
go

（所影响的行数为 1 行）
表 'Employees'。扫描计数 1，逻辑读 1 次，物理读 0 次，预读 0 次。

--查询SQL语句的执行时间
set statistics time on
go
select count(1) from Northwind..employees
go
set statistics time off
go

SQL Server 执行时间: 
   CPU 时间 = 0 毫秒，耗费时间 = 0 毫秒。
SQL Server 分析和编译时间: 
   CPU 时间 = 0 毫秒，耗费时间 = 0 毫秒。
（所影响的行数为 1 行）

SQL Server 执行时间: 
   CPU 时间 = 0 毫秒，耗费时间 = 0 毫秒。
SQL Server 分析和编译时间: 
   CPU 时间 = 0 毫秒，耗费时间 = 0 毫秒。

--查询SQL语句的执行计划
set showplan_text on
go
select count(1) from Northwind..employees
go
set showplan_text off
go
|--Compute Scalar(DEFINE:([Expr1002]=Convert([Expr1003])))
       |--Stream Aggregate(DEFINE:([Expr1003]=Count(*)))
            |--Index Scan(OBJECT:([Northwind].[dbo].[Employees].[PostalCode]))

--更加详细的执行计划
set showplan_all on
go
select count(1) from Northwind..employees
go
set showplan_all off
go
EstimateIO和EstimeCPU是主要的评估SQL语句的执行代价的标准

--成批SQL语句的执行时间
create table #save_time(start_time datetime not null)
insert #save_time values(getdate())
go
--批处理的脚本
select * from Northwind..customers
go
select * from Northwind..products
go
--批处理语句结束
select 'SQL语句的执行时间(ms)'=datediff(ms,start_time,getdate()) from #save_time
drop table #save_time
go
--密码文件保存在哪里？
select * from master..sysxlogins

--事务操作
begin tran <事务名>
update t_a set val='123'
commit tran <事务名>
或者rollback tran <事务名>