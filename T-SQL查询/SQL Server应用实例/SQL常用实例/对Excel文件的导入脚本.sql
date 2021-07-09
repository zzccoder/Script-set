--打开执行脚本的权限
EXEC sp_configure 'show advanced options', 1 
GO 
RECONFIGURE 
GO 
EXEC sp_configure 'Ad Hoc Distributed Queries', 1 
GO 
RECONFIGURE 
GO 


--判断excel中的数据在t_cardStorage表中是否已经存在
select * from t_cardStorage where tc_cardNO in (
select cast(tc_cardNO as nvarchar(50)) as tc_cardNO 
FROM OpenRowSet( 'Microsoft.Jet.OLEDB.4.0','EXCEL 8.0;HDR=YES;IMEX=1; DATABASE=D:\3.23.xls',[T2$])
where tc_cardNO is not null)



--将excel中的数据插入到t_cardStorage表中
insert t_cardStorage(tc_cardNO, tc_cardPass, tc_productID)
select cast(tc_cardNO as nvarchar(50)) as tc_cardNO, cast(tc_cardPass as nvarchar(50)) as tc_cardPass, tc_productID 
FROM OpenRowSet( 'Microsoft.Jet.OLEDB.4.0','EXCEL 8.0;HDR=YES;IMEX=1; DATABASE=D:\3.23.xls',[T2$])
where tc_cardNO is not null