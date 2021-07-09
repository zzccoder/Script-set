create database Fragmentary

create table dataPage
(
   Id int primary key identity,
   fieldFirst nvarchar(10),
   fieldSecond nvarchar(10),
   fieldThirdly nvarchar(10),
)


insert into dataPage values('aa','aa','aa')
insert into dataPage values('aa','aa','aa')
insert into dataPage values('aa','aa','aa')

use Fragmentary
Go
CREATE PROCEDURE [dbo].[GetRecordByPage]
	@tblName      varchar(255),       -- 表名
	@fldName      varchar(255),       -- 主键字段名
	@OrderfldName	  varchar(255)='',   -- 排序字段
	@PageSize     int = 10,           -- 页尺寸
	@PageIndex    int = 1,            -- 页码
	@OrderType    bit = 0,            -- 设置排序类型, 非值则降序(0为desc降序 1为asc升序)
	@IsReCount    bit = 0,            -- 返回记录总数, 非值则返回(1为返回)
	@strWhere     varchar(1000) = ''  -- 查询条件(注意: 不要加where)( and Price>2000)
AS

declare @strSQL   varchar(6000)       -- 主语句
declare @strTmp   varchar(100)        -- 临时变量
declare @strOrder varchar(400)        -- 排序类型

--判断你是否提供了，排序字段
if(@OrderfldName!='')
begin
	if(@OrderType!=0)
	begin
		--拼接字符串
		set @strOrder=' order by ['+@OrderfldName+'] asc'
	end
	else
	begin
		set @strOrder=' order by ['+@OrderfldName+'] desc'
	end
end
else
begin
	set @strOrder=' '
end


--是否求记录数
if(@IsReCount!=0)
begin
	--是否有条件
	if(@strWhere!='')
	begin
		set @strTmp='select Count(1) from ['+@tblName+'] where 1=1 '+ @strWhere
	end
	else
		set @strTmp='select Count(1) from ['+@tblName+'] where 1=1 '
end
else
	--求第10到第20条数据
set @strTmp=' '
if(@IsReCount=0)
begin
set @strSQl='Select top '+str(@PageSize)+' * from ['+@tblName+'] where ['
    +@fldName+'] not in (select top '+str((@PageIndex-1)*@PageSize)+' ['
    +@fldName+'] from ['+@tblName+'] where 1=1 '
    + @strWhere+@strOrder+') '+@strWhere+@strOrder+';'
end
else
begin
	set @strSQl = @strTmp
end

--print (@strSQL)

execute(@strSQL)
GO