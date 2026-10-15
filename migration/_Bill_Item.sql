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
CREATE TABLE [dbo].[Bill_Item](
	[Bill_Item_ID] [int] IDENTITY(1,1) NOT NULL,
	[Bill_ID] [int] NOT NULL,
	[Service_ID] [int] NOT NULL,
	[Bill_Item_Description] [nvarchar](250) NOT NULL,
	[Bill_Item_Service_Date] [datetime2](0) NOT NULL,
	[Bill_Item_Quantity] [decimal](10, 2) NOT NULL,
	[Bill_Item_Unit_Price] [decimal](12, 2) NOT NULL,
	[Bill_Item_Line_Total]  AS (CONVERT([decimal](22,2),[Bill_Item_Quantity]*[Bill_Item_Unit_Price])) PERSISTED,
 CONSTRAINT [PK_Bill_Item] PRIMARY KEY CLUSTERED 
(
	[Bill_Item_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
