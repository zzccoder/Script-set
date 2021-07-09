--page 是页数 在sql server2005中可以使用ROW_NUMBER() OVER 达到分页 数据量大约110万行
select * from
	( select ROW_NUMBER() OVER( ORDER BY r.id ) AS RowNumber,c.cha_name,RTRIM(content) as content 
			from dbo.Resource r inner join dbo.character c 
			on r.cha_id = c.cha_id) T 
			where RowNumber between (" + page + "-1)*100+1 and " + page + "*100 order by 1 


--万不得已，请不要使用 top，除非性能高