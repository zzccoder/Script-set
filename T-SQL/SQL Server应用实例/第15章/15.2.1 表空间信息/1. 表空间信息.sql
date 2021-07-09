;WITH
TB AS(
	SELECT
		TB.object_id,
		schema_name = SCH.name,
		table_name = TB.name
	FROM sys.tables TB
		INNER JOIN sys.schemas SCH
			ON TB.schema_id = SCH.schema_id
	WHERE is_ms_shipped = 0    -- ��������ʾ����ѯ�������ڲ� SQL Server �����������
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
	TB.schema_name,
	TB.table_name,
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
FROM TB
	INNER JOIN SIZE
		ON TB.object_id = SIZE.object_id
ORDER BY schema_name, table_name
