-- 全局临时表的可见性和可用性演示

-- 1. 连接A创建名为##tb的临时表
CREATE TABLE ##tb(
	id int)
GO


-- 2. 连接B可以直接访问连接A创建的##tb的临时表

----如果连接B试图建立##tb的临时表,则会收到错误信息,并且建立不成功
--CREATE TABLE ##tb(
--	id int)

BEGIN TRAN
	INSERT ##tb(
		id)
	VALUES(
		1)
	WAITFOR DELAY '00:05:00'
COMMIT TRAN
GO

-- 3. 断开连接A,保留连接B. 然后在连接C中引用连接A创建的临时表##tb
SELECT * FROM ##tb WITH(NOLOCK)
