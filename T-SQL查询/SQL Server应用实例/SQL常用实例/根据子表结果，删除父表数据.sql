declare @count int;
select @count = count(1) from T_Article_Article1 where ClassId='0101000000';
select @count = @count + count(1) from T_Article_Article2 where ClassId='0101000000';
if(@count > 0)
begin 
	print @count;
	print '����ɾ��';
end
else
begin
	print '����ɾ��';
end