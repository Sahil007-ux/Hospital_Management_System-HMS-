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
CREATE TABLE [dbo].[Medical_Record](
	[Medical_Record_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Doctor_ID] [int] NOT NULL,
	[Medical_Record_Date] [date] NOT NULL,
	[Medical_Record_Diagnoses] [nvarchar](500) NOT NULL,
	[Medical_Record_Treatment] [nvarchar](1000) NULL,
	[Medical_Record_Notes] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Medical_Record_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
