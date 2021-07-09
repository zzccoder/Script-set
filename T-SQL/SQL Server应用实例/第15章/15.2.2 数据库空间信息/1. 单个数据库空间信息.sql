;WITH
DB AS(
	-- 此部分查询数据文件和日志文件空间信息
	SELECT
		datafile_size = SUM(
			CASE
				WHEN type = 1 THEN 0
				ELSE size
			END),
		logfile_size = SUM(
			CASE
				WHEN type = 1 THEN size
				ELSE 0
			END),
		file_size = SUM(size)
	FROM sys.database_files
),
DATA AS(
	-- 此部分查询数据库中对象的空间使用信息
	SELECT
		reserved_pages = SUM(AU.total_pages),
		used_pages = SUM(AU.used_pages),
		pages = SUM(
			CASE
				-- xml index nodes 和 fulltext catalog map 只应包含在索引部分
				WHEN ITB.internal_type IN (202,204) THEN 0
				WHEN AU.type <> 1 THEN AU.used_pages
				WHEN P.index_id < 2 THEN AU.data_pages
				Else 0
			END)
	FROM sys.partitions P
		INNER JOIN sys.allocation_units AU
			ON P.partition_id = AU.container_id
		LEFT JOIN sys.internal_tables ITB
			ON P.object_id = ITB.object_id
),
SIZE AS(
	SELECT 
		database_space = CONVERT(decimal(15, 2),
				DB.file_size * 8 / 1024.),
		unallocated_space = CONVERT(decimal(15, 2),
			CASE
				WHEN DB.datafile_size >= DATA.reserved_pages
					THEN (DB.datafile_size - DATA.reserved_pages) * 8 / 1024.
				ELSE 0
			END),
		reserved_space = CONVERT(decimal(15, 2),
				DATA.reserved_pages * 8 / 1024),
		datafile_size = CONVERT(decimal(15, 2),
				DB.datafile_size * 8 / 1024.),
		logfile_size = CONVERT(decimal(15, 2),
				DB.logfile_size * 8 / 1024.),
		data_size = CONVERT(decimal(15, 2),
				DATA.pages * 8 / 1024),
		index_size = CONVERT(decimal(15, 2),
				(DATA.used_pages - DATA.pages) * 8 / 1024),
		unused_size = CONVERT(decimal(15, 2),
				(DATA.reserved_pages - DATA.used_pages) * 8 / 1024)
	FROM DB, DATA
)
SELECT 
	database_name = DB_NAME(),
	*
FROM SIZE
