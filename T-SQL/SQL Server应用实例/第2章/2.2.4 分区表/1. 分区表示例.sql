-- 进行演示操作前, 先备份, 以便可以在演示完成后, 恢复到原始状态
USE master
-- 备份
BACKUP DATABASE AdventureWorks
	TO DISK = 'AdventureWorks.bak'
	WITH FORMAT

---- 恢复
--RESTORE DATABASE AdventureWorks
--	FROM DISK = 'AdventureWorks.bak'
--	WITH REPLACE
GO

--=========================================
-- 转换为分区表
--=========================================
USE AdventureWorks
GO

-- 1. 创建分区函数
--    a. 适用于存储历史存档记录的分区表的分区函数
DECLARE @dt datetime
SET @dt = '20020101'
CREATE PARTITION FUNCTION PF_HistoryArchive(datetime)
AS RANGE RIGHT
FOR VALUES(
	@dt, 
	DATEADD(Year, 1, @dt))

--    b. 适用于存储历史记录的分区表的分区函数
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

-- 2. 创建分区架构
--    a. 适用于存储历史存档记录的分区表的分区架构
CREATE PARTITION SCHEME PS_HistoryArchive
AS PARTITION PF_HistoryArchive
TO([PRIMARY], [PRIMARY], [PRIMARY])

--    b. 适用于存储历史记录的分区表的分区架构
CREATE PARTITION SCHEME PS_History
AS PARTITION PF_History
TO([PRIMARY], [PRIMARY], 
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY],
	[PRIMARY], [PRIMARY], [PRIMARY])
GO

-- 3. 删除索引
--    a. 删除存储历史存档记录的表中的索引
DROP INDEX Production.TransactionHistoryArchive.IX_TransactionHistoryArchive_ProductID
DROP INDEX Production.TransactionHistoryArchive.IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID

--    b. 删除存储历史记录的表中的索引
DROP INDEX Production.TransactionHistory.IX_TransactionHistory_ProductID
DROP INDEX Production.TransactionHistory.IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID
GO

-- 4. 转换为分区表
--    a. 将存储历史存档记录的表转换为分区表
ALTER TABLE Production.TransactionHistoryArchive
	DROP CONSTRAINT PK_TransactionHistoryArchive_TransactionID
	WITH(
		MOVE TO PS_HistoryArchive(TransactionDate))

--    b.将存储历史记录的表转换为分区表
ALTER TABLE Production.TransactionHistory
	DROP CONSTRAINT PK_TransactionHistory_TransactionID
	WITH(
		MOVE TO PS_History(TransactionDate))
GO

-- 5. 恢复主键
--    a. 恢复存储历史存档记录的分区表的主键
ALTER TABLE Production.TransactionHistoryArchive
	ADD CONSTRAINT PK_TransactionHistoryArchive_TransactionID
		PRIMARY KEY CLUSTERED(
			TransactionID,
			TransactionDate)

--    b. 恢复存储历史记录的分区表的主键
ALTER TABLE Production.TransactionHistory
	ADD CONSTRAINT PK_TransactionHistory_TransactionID
		PRIMARY KEY CLUSTERED(
			TransactionID,
			TransactionDate)
GO

-- 6. 恢复索引
--    a. 恢复存储历史存档记录的分区表的索引
CREATE INDEX IX_TransactionHistoryArchive_ProductID 
	ON Production.TransactionHistoryArchive(
		ProductID)

CREATE INDEX IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID
	ON Production.TransactionHistoryArchive(
		ReferenceOrderID,
		ReferenceOrderLineID)

--    b. 恢复存储历史记录的分区表的索引
CREATE INDEX IX_TransactionHistory_ProductID 
	ON Production.TransactionHistory(
		ProductID)

CREATE INDEX IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID
	ON Production.TransactionHistory(
		ReferenceOrderID,
		ReferenceOrderLineID)
GO

-- 7. 查看分区表的相关信息
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
-- 移动分区表数据
--=========================================
-- 1. 为存储历史存档记录的分区表增加分区, 并接受从历史记录分区表移动过来的数据
--    a. 修改分区架构, 增加用以接受新分区的文件组
ALTER PARTITION SCHEME PS_HistoryArchive
NEXT USED [PRIMARY]

--    b. 修改分区函数, 增加分区用以接受从历史记录分区表移动过来的数据
DECLARE @dt datetime
SET @dt = '20030901'
ALTER PARTITION FUNCTION PF_HistoryArchive()
SPLIT RANGE(@dt)

--    c. 将历史记录表中的过期数据移动到历史存档记录表中
ALTER TABLE Production.TransactionHistory
	SWITCH PARTITION 2
		TO Production.TransactionHistoryArchive PARTITION $PARTITION.PF_HistoryArchive(@dt)

--    d. 将接受到的数据与原来的分区合并
ALTER PARTITION FUNCTION PF_HistoryArchive()
MERGE RANGE(@dt)
GO

-- 2. 将存储历史记录的分区表中不包含数据的分区删除, 并增加新的分区以接受新数据
--    a. 合并不包含数据的分区
DECLARE @dt datetime
SET @dt = '20030901'
ALTER PARTITION FUNCTION PF_History()
MERGE RANGE(@dt)

--    b.  修改分区架构, 增加用以接受新分区的文件组
ALTER PARTITION SCHEME PS_History
NEXT USED [PRIMARY]

--    c. 修改分区函数, 增加分区用以接受新数据
SET @dt = '20041001'
ALTER PARTITION FUNCTION PF_History()
SPLIT RANGE(@dt)
GO


--=========================================
-- 清除历史存档记录中的过期数据
--=========================================
-- 1. 创建用于保存过期的历史存档数据的表
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

-- 2. 将数据从历史存档记录分区表移动到第1步创建的表中
ALTER TABLE Production.TransactionHistoryArchive
	SWITCH PARTITION 1
		TO Production.TransactionHistoryArchive_2001_temp

-- 3. 删除不再包含数据的分区
DECLARE @dt datetime
SET @dt = '20020101'
ALTER PARTITION FUNCTION PF_HistoryArchive()
MERGE RANGE(@dt)

-- 4. 修改分区架构, 增加用以接受新分区的文件组
ALTER PARTITION SCHEME PS_HistoryArchive
NEXT USED [PRIMARY]

-- 5. 修改分区函数, 增加分区用以接受新数据
SET @dt = '20040101'
ALTER PARTITION FUNCTION PF_HistoryArchive()
SPLIT RANGE(@dt)
