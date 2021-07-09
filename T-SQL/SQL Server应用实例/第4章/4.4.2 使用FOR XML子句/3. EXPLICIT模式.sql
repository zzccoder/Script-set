WITH
TB AS(
	SELECT 
		tag = 1, parent = 0,
		name, create_date, modify_date,
		object_id
	FROM sys.tables
),
COL AS(
	SELECT 
		tag = 2, parent = 1,
		name, max_length, precision, scale,
		user_type_id, object_id
	FROM sys.columns C
	WHERE EXISTS(
			SELECT * FROM TB
			WHERE object_id = C.object_id)
),
TYP AS(
	SELECT 
		tag = 3, parent = COL.tag,
		T.name,
		COL.object_id, column_name = COL.name
	FROM sys.types T, COL
	WHERE T.user_type_id = COL.user_type_id
)
SELECT
	tag, parent,
	[Table!1!!element] = name,
	[Table!1!create_date] = create_date,
	[Table!1!modify_date] = modify_date,
	[Column!2!!element] = NULL,
	[Column!2!max_length] = NULL,
	[Column!2!precision] = NULL,
	[Column!2!scale] = NULL,
	[Type!3!!element] = NULL,
	[Table!1!!hide] = object_id,
	[Column!2!!hide] = NULL
FROM TB
UNION ALL
SELECT
	tag, parent,
	[Table!1!!element] = NULL,
	[Table!1!create_date] = NULL,
	[Table!1!modify_date] = NULL,
	[Column!2!!element] = name,
	[Column!2!max_length] = max_length,
	[Column!2!precision] = precision,
	[Column!2!scale] = scale,
	[Type!3!!element] = NULL,
	[Table!1!!hide] = object_id,
	[Column!2!!hide] = name
FROM COL
UNION ALL
SELECT
	tag, parent,
	[Table!1!!element] = NULL,
	[Table!1!create_date] = NULL,
	[Table!1!modify_date] = NULL,
	[Column!2!!element] = NULL,
	[Column!2!max_length] = NULL,
	[Column!2!precision] = NULL,
	[Column!2!scale] = NULL,
	[Type!3!!element] = name,
	[Table!1!!hide] = object_id,
	[Column!2!!hide] = column_name
FROM TYP
ORDER BY [Table!1!!hide], [Column!2!!hide],tag
FOR XML EXPLICIT

