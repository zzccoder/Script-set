-- ������ʾ����ǰ, �ȱ���, �Ա��������ʾ��ɺ�, �ָ���ԭʼ״̬
USE master
-- ����
BACKUP DATABASE AdventureWorks
	TO DISK = 'AdventureWorks.bak'
	WITH FORMAT

---- �ָ�
--RESTORE DATABASE AdventureWorks
--	FROM DISK = 'AdventureWorks.bak'
--	WITH REPLACE
GO

--=========================================
-- ת��Ϊ������
--=========================================
USE AdventureWorks
GO

-- 1. ������������
--    a. �����ڴ洢��ʷ�浵��¼�ķ�����ķ�������
DECLARE @dt datetime
SET @dt = '20020101'
CREATE PARTITION FUNCTION PF_HistoryArchive(datetime)
AS RANGE RIGHT
FOR VALUES(
	@dt, 
	DATEADD(Year, 1, @dt))

--    b. �����ڴ洢��ʷ��¼�ķ�����ķ�������
--DECLARE @dt datetime
SET @dt = '20030901'
CREATE PARTITION FUNCTION PF_History(datetime)
AS RANGE RIGHT
FOR VALUES(
	@dt, 
	DATEADD(Month, 1, @dt), DATEADD(Month, 2, @dt), DATEADD(Month, 3, @dt),
	DATEADD(Month, 4, @dt), DATEADD(Month, 5, @dt), DATEADD(Month, 6, @dt),
	DATEADD(Month, 7, @dt), DATEADD(Month, 8, @dt), DATEADD(Month, 9, @dt),
	DATEADD(Month, 10, @dt), DATEADD(Month, 11, @dt), DATEADD(Month, 12, @dt))
GO

-- 2. ���������ܹ�
--    a. �����ڴ洢��ʷ�浵��¼�ķ�����ķ����ܹ�
CREATE PARTITION SCHEME PS_HistoryArchive
AS PARTITION PF_HistoryArchive
TO([PRIMARY], [PRIMARY], [PRIMARY])

--    b. �����ڴ洢��ʷ��¼�ķ�����ķ����ܹ�
CREATE PARTITION SCHEME PS_History
AS PARTITION PF_History
TO([PRIMARY], [PRIMARY], 
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY])
GO

-- 3. ɾ������
--    a. ɾ���洢��ʷ�浵��¼�ı��е�����
DROP INDEX Production.TransactionHistoryArchive.IX_TransactionHistoryArchive_ProductID
DROP INDEX Production.TransactionHistoryArchive.IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID

--    b. ɾ���洢��ʷ��¼�ı��е�����
DROP INDEX Production.TransactionHistory.IX_TransactionHistory_ProductID
DROP INDEX Production.TransactionHistory.IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID
GO

-- 4. ת��Ϊ������
--    a. ���洢��ʷ�浵��¼�ı�ת��Ϊ������
ALTER TABLE Production.TransactionHistoryArchive
	DROP CONSTRAINT PK_TransactionHistoryArchive_TransactionID
	WITH(
		MOVE TO PS_HistoryArchive(TransactionDate))

--    b.���洢��ʷ��¼�ı�ת��Ϊ������
ALTER TABLE Production.TransactionHistory
	DROP CONSTRAINT PK_TransactionHistory_TransactionID
	WITH(
		MOVE TO PS_History(TransactionDate))
GO

-- 5. �ָ�����
--    a. �ָ��洢��ʷ�浵��¼�ķ����������
ALTER TABLE Production.TransactionHistoryArchive
	ADD CONSTRAINT PK_TransactionHistoryArchive_TransactionID
		PRIMARY KEY CLUSTERED(
			TransactionID,
			TransactionDate)

--    b. �ָ��洢��ʷ��¼�ķ����������
ALTER TABLE Production.TransactionHistory
	ADD CONSTRAINT PK_TransactionHistory_TransactionID
		PRIMARY KEY CLUSTERED(
			TransactionID,
			TransactionDate)
GO

-- 6. �ָ�����
--    a. �ָ��洢��ʷ�浵��¼�ķ����������
CREATE INDEX IX_TransactionHistoryArchive_ProductID 
	ON Production.TransactionHistoryArchive(
		ProductID)

CREATE INDEX IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID
	ON Production.TransactionHistoryArchive(
		ReferenceOrderID,
		ReferenceOrderLineID)

--    b. �ָ��洢��ʷ��¼�ķ����������
CREATE INDEX IX_TransactionHistory_ProductID 
	ON Production.TransactionHistory(
		ProductID)

CREATE INDEX IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID
	ON Production.TransactionHistory(
		ReferenceOrderID,
		ReferenceOrderLineID)
GO

-- 7. �鿴������������Ϣ
SELECT
	SchemaName = S.name,
	TableName = TB.name,
	PartitionScheme = PS.name,
	PartitionFunction = PF.name,
	PartitionFunctionRangeType = CASE
			WHEN boundary_value_on_right = 0 THEN 'LEFT'
			ELSE 'RIGHT' END,
	PartitionFunctionFanout = PF.fanout,
	SchemaID = S.schema_id,
	ObjectID = TB.object_id,
	PartitionSchemeID = PS.data_space_id,
	PartitionFunctionID = PS.function_id
FROM sys.schemas S
	INNER JOIN sys.tables TB
		ON S.schema_id = TB.schema_id
	INNER JOIN sys.indexes IDX
		on TB.object_id = IDX.object_id
			AND IDX.index_id < 2
	INNER JOIN sys.partition_schemes PS
		ON PS.data_space_id = IDX.data_space_id
	INNER JOIN sys.partition_functions PF
		ON PS.function_id = PF.function_id
GO

--=========================================
-- �ƶ�����������
--=========================================
-- 1. Ϊ�洢��ʷ�浵��¼�ķ��������ӷ���, �����ܴ���ʷ��¼�������ƶ�����������
--    a. �޸ķ����ܹ�, �������Խ����·������ļ���
ALTER PARTITION SCHEME PS_HistoryArchive
NEXT USED [PRIMARY]

--    b. �޸ķ�������, ���ӷ������Խ��ܴ���ʷ��¼�������ƶ�����������
DECLARE @dt datetime
SET @dt = '20030901'
ALTER PARTITION FUNCTION PF_HistoryArchive()
SPLIT RANGE(@dt)

--    c. ����ʷ��¼���еĹ��������ƶ�����ʷ�浵��¼����
ALTER TABLE Production.TransactionHistory
	SWITCH PARTITION 2
		TO Production.TransactionHistoryArchive PARTITION $PARTITION.PF_HistoryArchive(@dt)

--    d. �����ܵ���������ԭ���ķ����ϲ�
ALTER PARTITION FUNCTION PF_HistoryArchive()
MERGE RANGE(@dt)
GO

-- 2. ���洢��ʷ��¼�ķ������в��������ݵķ���ɾ��, �������µķ����Խ���������
--    a. �ϲ����������ݵķ���
DECLARE @dt datetime
SET @dt = '20030901'
ALTER PARTITION FUNCTION PF_History()
MERGE RANGE(@dt)

--    b.  �޸ķ����ܹ�, �������Խ����·������ļ���
ALTER PARTITION SCHEME PS_History
NEXT USED [PRIMARY]

--    c. �޸ķ�������, ���ӷ������Խ���������
SET @dt = '20041001'
ALTER PARTITION FUNCTION PF_History()
SPLIT RANGE(@dt)
GO


--=========================================
-- �����ʷ�浵��¼�еĹ�������
--=========================================
-- 1. �������ڱ�����ڵ���ʷ�浵���ݵı�
CREATE TABLE Production.TransactionHistoryArchive_2001_temp(
	TransactionID int NOT NULL,
	ProductID int NOT NULL,
	ReferenceOrderID int NOT NULL,
	ReferenceOrderLineID int NOT NULL
		DEFAULT ((0)),
	TransactionDate datetime NOT NULL
		DEFAULT (GETDATE()),
	TransactionType nchar(1) NOT NULL,
	Quantity int NOT NULL,
	ActualCost money NOT NULL,
	ModifiedDate datetime NOT NULL
		DEFAULT (GETDATE()),
	CONSTRAINT PK_TransactionHistoryArchive_2001_temp_TransactionID
		PRIMARY KEY CLUSTERED(
			TransactionID,
			TransactionDate)
)

-- 2. �����ݴ���ʷ�浵��¼�������ƶ�����1�������ı���
ALTER TABLE Production.TransactionHistoryArchive
	SWITCH PARTITION 1
		TO Production.TransactionHistoryArchive_2001_temp

-- 3. ɾ�����ٰ������ݵķ���
DECLARE @dt datetime
SET @dt = '20020101'
ALTER PARTITION FUNCTION PF_HistoryArchive()
MERGE RANGE(@dt)

-- 4. �޸ķ����ܹ�, �������Խ����·������ļ���
ALTER PARTITION SCHEME PS_HistoryArchive
NEXT USED [PRIMARY]

-- 5. �޸ķ�������, ���ӷ������Խ���������
SET @dt = '20040101'
ALTER PARTITION FUNCTION PF_HistoryArchive()
SPLIT RANGE(@dt)
