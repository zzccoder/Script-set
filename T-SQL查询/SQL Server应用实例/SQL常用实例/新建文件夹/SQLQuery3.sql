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
	@tblName      varchar(255),       -- ����
	@fldName      varchar(255),       -- �����ֶ���
	@OrderfldName	  varchar(255)='',   -- �����ֶ�
	@PageSize     int = 10,           -- ҳ�ߴ�
	@PageIndex    int = 1,            -- ҳ��
	@OrderType    bit = 0,            -- ������������, ��ֵ����(0Ϊdesc���� 1Ϊasc����)
	@IsReCount    bit = 0,            -- ���ؼ�¼����, ��ֵ�򷵻�(1Ϊ����)
	@strWhere     varchar(1000) = ''  -- ��ѯ����(ע��: ��Ҫ��where)( and Price>2000)
AS

declare @strSQL   varchar(6000)       -- �����
declare @strTmp   varchar(100)        -- ��ʱ����
declare @strOrder varchar(400)        -- ��������

--�ж����Ƿ��ṩ�ˣ������ֶ�
if(@OrderfldName!='')
begin
	if(@OrderType!=0)
	begin
		--ƴ���ַ���
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


--�Ƿ����¼��
if(@IsReCount!=0)
begin
	--�Ƿ�������
	if(@strWhere!='')
	begin
		set @strTmp='select Count(1) from ['+@tblName+'] where 1=1 '+ @strWhere
	end
	else
		set @strTmp='select Count(1) from ['+@tblName+'] where 1=1 '
end
else
	--���10����20������
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