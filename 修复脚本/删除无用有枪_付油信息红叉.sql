--找到加油结算记录表，这个记录的主键id
select * from cr_checked where gascode is null
--然后执行删除 
delete from cr_checked where id=@id 

--delete from cr_checked gascode is null
