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
CREATE TABLE [dbo].[Payment](
	[Payment_ID] [int] IDENTITY(1,1) NOT NULL,
	[Bill_ID] [int] NOT NULL,
	[Payment_Date] [datetime2](0) NOT NULL,
	[Payment_Amount] [decimal](22, 2) NOT NULL,
	[Payment_Method] [varchar](20) NOT NULL,
	[Payment_Reference_Number] [nvarchar](100) NULL,
	[Payment_Notes] [nvarchar](500) NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[Payment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
