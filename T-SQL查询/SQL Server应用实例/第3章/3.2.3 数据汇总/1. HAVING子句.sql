-- 1. �ڲ�����GROUP BY�Ӿ���ʹ��WHERE��HAVING
SELECT 
	cnt = COUNT(object_id)
FROM sys.objects
WHERE object_id < 10
HAVING COUNT(object_id) <> 10

-- 2. �ڰ���GROUP BY�Ӿ���ʹ��WHERE��HAVING
SELECT 
	object_id,
	cnt = COUNT(*)
FROM sys.columns
WHERE OBJECTPROPERTY(object_id, 'IsTable') = 1
GROUP BY object_id
HAVING COUNT(*) > 10