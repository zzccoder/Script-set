--page ��ҳ�� ��sql server2005�п���ʹ��ROW_NUMBER() OVER �ﵽ��ҳ ��������Լ110����
select * from
	( select ROW_NUMBER() OVER( ORDER BY r.id ) AS RowNumber,c.cha_name,RTRIM(content) as content 
			from dbo.Resource r inner join dbo.character c 
			on r.cha_id = c.cha_id) T 
			where RowNumber between (" + page + "-1)*100+1 and " + page + "*100 order by 1 


--�򲻵��ѣ��벻Ҫʹ�� top���������ܸ�