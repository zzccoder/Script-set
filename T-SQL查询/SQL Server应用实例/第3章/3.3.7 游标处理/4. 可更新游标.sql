CREATE TABLE #(
	id int, a int)
INSERT #(
	id, a)
SELECT 1,1 UNION ALL
SELECT 2,2 UNION ALL
SELECT 3,2

--��������Լ��
--ALTER TABLE # ADD UNIQUE(id)				--Ωһ��(Լ��)���ṩRID��ǩ
--CREATE INDEX IDX_a ON #(a)				--a���ϵ���ͨ����,�����ṩRID��ǩ
--CREATE CLUSTERED INDEX IDX_id_1 ON #(id)	--id���ϵľۼ�����,�����ṩȺ������ǩ
--CREATE INDEX IDX_id_2 ON #(id)			--id���ϵ���ͨ����,�α�Ķ�������޷�ʹ�ø�������                                                       ����RID��ǩ
--CREATE INDEX IDX_a_id ON #(a,id)			--a�к�id�е�����ͨ����,�����ṩRID��ǩ

--�α괦��
DECLARE CUR_tb CURSOR LOCAL TYPE_WARNING
FOR
SELECT id 
FROM # 
ORDER BY a

DECLARE @id int
OPEN CUR_tb
FETCH CUR_tb INTO @id
WHILE @@FETCH_STATUS = 0
BEGIN
	UPDATE # SET 
		a = a - @id / 2
	WHERE CURRENT OF CUR_tb

	FETCH CUR_tb INTO @id
END
CLOSE CUR_tb
DEALLOCATE CUR_tb
SELECT * FROM #
DROP TABLE #
