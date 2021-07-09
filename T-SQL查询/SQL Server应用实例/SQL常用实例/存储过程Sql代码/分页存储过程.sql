use [user]
/****** Object:  StoredProcedure [dbo].[UP_GetRecordByPage]    Script Date: 01/01/2007 00:50:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UP_GetRecordByPage]
	@tblName      varchar(255),       -- ����
	@fldName      varchar(255),       -- �����ֶ���
	@OrderfldName	  varchar(255)='',   -- �����ֶ�
	@PageSize     int = 10,           -- ҳ�ߴ�
	@PageIndex    int = 1,            -- ҳ��
	@OrderType    bit = 0,            -- ������������, ��ֵ����(0Ϊdesc���� 1Ϊasc����)
	@IsReCount    bit = 0,            -- ���ؼ�¼����, ��ֵ�򷵻�(1Ϊ����)
	@strWhere     varchar(max) = ''  -- ��ѯ����(ע��: ��Ҫ��where)( and Price>2000)
AS

declare @strSQL   varchar(max)       -- �����
declare @strTmp   varchar(max)        -- ��ʱ����
declare @strOrder varchar(max)        -- ��������

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


--ɾ��
---drop procedure [dbo].[UP_GetRecordByPage]