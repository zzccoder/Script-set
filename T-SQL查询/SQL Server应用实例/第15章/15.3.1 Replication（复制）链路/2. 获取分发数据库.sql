DECLARE 
	@Distributor_server sysname,
	@Distribution_database sysname
EXEC sp_helpdistributor
	@Distributor_server OUTPUT,
	@Distribution_database OUTPUT

SELECT
	�ַ������� = @Distributor_server,
	�ַ����ݿ� = @Distribution_database
