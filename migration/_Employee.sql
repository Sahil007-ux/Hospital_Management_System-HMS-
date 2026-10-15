-- REFERENCE FRAGMENT ONLY. Use _Master_Query.sql for complete installation.
-- Keys, indexes, defaults, checks and triggers are included in the master.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO
CREATE TABLE [dbo].[Employee](
	[Employee_ID] [int] NOT NULL,
	[Employee_Name] [nvarchar](100) NOT NULL,
	[Employee_Gender] [char](7) NULL,
	[Employee_Phone] [varchar](20) NULL,
	[Employee_Email] [varchar](254) NULL,
	[Employee_Salary] [decimal](12, 2) NOT NULL,
	[Employee_State] [nvarchar](50) NULL,
	[Employee_City] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
