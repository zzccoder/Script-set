
/****** 对象:  Table [dbo].[T_Manage_Groups]    脚本日期: 07/29/2011 11:19:25 ******/
use [user]
Go
CREATE TABLE [dbo].[T_Manage_Groups](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Describe] [nvarchar](100) NULL,
 CONSTRAINT [PK_T_Manage_Groups] PRIMARY KEY CLUSTERED  
(
	[GroupId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** 对象:  Table [dbo].[T_Manage_Modules]    脚本日期: 07/29/2011 11:19:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Manage_Modules](
	[ModuleId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ParentId] [int] NOT NULL
) ON [PRIMARY]

GO
/****** 对象:  Table [dbo].[T_Manage_User]    脚本日期: 07/29/2011 11:19:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[T_Manage_User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[GroupId] [int] NULL,
	[GroupName] [nvarchar](50) NULL,
	[LoginName] [varchar](30) NULL,
	[Password] [char](32) NULL,
	[QQ] [varchar](30) NULL,
	[MSN] [nvarchar](50) NULL,
	[Telephone] [nvarchar](15) NULL,
	[Email] [nvarchar](50) NULL,
	[Remark] [nvarchar](max) NULL,
	[State] [char](1) NULL,
	[LastLoginDate] [datetime] NULL,
	[LastLoginIP] [nvarchar](15) NULL,
	[ModifyDate] [datetime] NULL,
	[RegDate] [datetime] NULL,
 CONSTRAINT [PK_T_Manage_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** 对象:  Table [dbo].[T_Manager_Popedom]    脚本日期: 07/29/2011 11:19:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_Manager_Popedom](
	[PopedomId] [int] NOT NULL,
	[UserId] [int] NULL,
	[ModuleId] [int] NULL
) ON [PRIMARY]
