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
CREATE TABLE [dbo].[Bed_Assignment](
	[Bed_Assignment_ID] [int] IDENTITY(1,1) NOT NULL,
	[Admission_ID] [int] NOT NULL,
	[Bed_ID] [int] NOT NULL,
	[Bed_Assignment_Start] [datetime2](0) NOT NULL,
	[Bed_Assignment_End] [datetime2](0) NULL,
 CONSTRAINT [PK_Bed_Assignment] PRIMARY KEY CLUSTERED 
(
	[Bed_Assignment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
