ALTER proc [dbo].[Usp_MixselectCommercer]
@RegCode nvarchar(50)='',
@Name nvarchar(50)=''

as

declare @strSQL   nvarchar(4000)      -- Ö÷Óï¾ä

begin
	set @strSQL = 'select * from Commercers where 1=1 ';
	if @Name !=''
	begin
	set @strSQL = @strSQL + ' and [name] like ''%'+@Name+'%''';
	end
	
	if @RegCode !=''
	begin
	set @strSQL = @strSQL + ' and [RegCode] like ''%'+@RegCode+'%''';
	end
	print (@strSQL)
	EXEC sp_ExecuteSql @strSql 
end