;WITH
OBJB AS(
	SELECT
		schema_id, 
		object_id,
		object_name = name,
		object_type = type_desc
	FROM sys.objects
	WHERE type IN('U ','S ','V ','IT')
	UNION ALL
	-- ���� Services Broker ��Ϣ���У�Ӧʹ�� sys.internal_tables �е� object_id �� sys.dm_db_partition_stats ����
	SELECT 
		ITB.schema_id,
		ITB.object_id,
		object_name = O.name,
		type_desc = O.type_desc	
	FROM sys.objects O
		INNER JOIN sys.internal_tables ITB
			ON O.object_id = ITB.parent_id
	WHERE O.type = 'SQ'
		AND ITB.internal_type = 201
),
OBJ AS(
	SELECT 
		OBJB.object_id,
		OBJB.object_type,
		schema_name = SCH.name,
		OBJB.object_name
	FROM OBJB
		INNER JOIN sys.schemas SCH
			ON OBJB.schema_id = SCH.schema_id
),
PS AS(
	-- �˲��ּ����ռ����Ϣ
	SELECT 
		object_id,
		reserved_pages = SUM(reserved_page_count),
		used_pages = SUM(used_page_count),
		pages = SUM(
			CASE
				WHEN index_id > 1 THEN lob_used_page_count + row_overflow_used_page_count
				ELSE in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count
			END),
		row_count = SUM (
			CASE
				WHEN index_id < 2 THEN row_count
				ELSE 0
			END)
	FROM sys.dm_db_partition_stats PS
	GROUP BY object_id
),
ITPS AS(
	-- �˲��ּ������ XML INDEX �� FULLTEXT INDEXE �Ŀռ���Ϣ(����еĻ�)
	SELECT
		object_id = ITB.parent_id,
		reserved_pages = SUM(reserved_page_count),
		used_pages = SUM(used_page_count)
	FROM sys.dm_db_partition_stats P
		INNER JOIN sys.internal_tables ITB
			ON P.object_id = ITB.object_id
	WHERE ITB.internal_type IN(202, 204)
	GROUP BY ITB.parent_id
),
SIZE AS(
	-- �˲��ֺϲ����еĿռ���Ϣ
	SELECT
		PS.object_id,
		reserved_pages = PS.reserved_pages + ISNULL(ITPS.reserved_pages, 0),
		used_pages = PS.used_pages + ISNULL(ITPS.used_pages, 0),
		PS.pages,
		PS.row_count
	FROM PS
		LEFT JOIN ITPS
			ON PS.object_id = ITPS.object_id
)
-- ��ʾ���յĿռ�ͳ�ƽ��
-- ��ǰ���ͳ���У��ռ�ͳ����ҳΪ��λ, 8K/ҳ,���յ�ͳ�ƽ�ҳ��*8���õ�KBΪ��λ�Ŀռ��С
SELECT
	OBJ.object_type,
	OBJ.schema_name,
	OBJ.object_name,
	SIZE.row_count,
	reserved = SIZE.reserved_pages * 8,
	data = SIZE.pages * 8,
	index_size = CASE
					WHEN SIZE.used_pages > SIZE.pages
						THEN SIZE.used_pages - SIZE.pages
					ELSE 0
				END * 8,
	unused = CASE
				WHEN SIZE.reserved_pages > SIZE.used_pages
					THEN SIZE.reserved_pages - SIZE.used_pages
				ELSE 0
			END * 8
FROM OBJ
	INNER JOIN SIZE
		ON OBJ.object_id = SIZE.object_id
ORDER BY object_type, schema_name, object_name
