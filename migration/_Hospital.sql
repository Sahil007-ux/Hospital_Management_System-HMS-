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
CREATE TABLE [dbo].[Hospital](
	[Hospital_ID] [int] IDENTITY(1,1) NOT NULL,
	[Hospital_Name] [nvarchar](150) NOT NULL,
	[Hospital_Type] [nvarchar](50) NULL,
	[Hospital_Bed_Capacity] [int] NULL,
	[Hospital_Contact_Number] [varchar](20) NULL,
	[Hospital_Email] [varchar](100) NULL,
	[Hospital_Address] [nvarchar](260) NULL,
	[Hospital_License_Number] [varchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Hospital_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
