DECLARE 
	@Distributor_server sysname,
	@Distribution_database sysname
EXEC sp_helpdistributor
	@Distributor_server OUTPUT,
	@Distribution_database OUTPUT

SELECT
	分发服务器 = @Distributor_server,
	分发数据库 = @Distribution_database
