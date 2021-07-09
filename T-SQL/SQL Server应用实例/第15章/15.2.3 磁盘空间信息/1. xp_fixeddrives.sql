-- 默认查询硬盘驱动器
EXEC master.dbo.xp_fixeddrives 

-- 查询移动设备(例如U盘)
EXEC master.dbo.xp_fixeddrives 2

-- 查询大量存储设备(CD-ROM，DVD等)
EXEC master.dbo.xp_fixeddrives 3

-- 查询硬盘驱动器
EXEC master.dbo.xp_fixeddrives 4
