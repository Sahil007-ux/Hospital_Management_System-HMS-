-- REFERENCE ONLY. Included in _Master_Query.sql; do not run twice.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO
CREATE TABLE [dbo].[Medicine](
	[Medicine_ID] [int] IDENTITY(1,1) NOT NULL,
	[Medicine_Code] [varchar](30) NOT NULL,
	[Medicine_Name] [nvarchar](150) NOT NULL,
	[Medicine_Strength] [nvarchar](100) NOT NULL,
	[Medicine_Form] [nvarchar](50) NOT NULL,
	[Medicine_Is_Active] [bit] NOT NULL,
 CONSTRAINT [PK_Medicine] PRIMARY KEY CLUSTERED 
(
	[Medicine_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Medicine_Code] UNIQUE NONCLUSTERED 
(
	[Medicine_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Medicine] ADD  CONSTRAINT [DF_Medicine_IsActive]  DEFAULT ((1)) FOR [Medicine_Is_Active]
GO

ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [CK_Medicine_Code_NotBlank] CHECK  ((len(ltrim(rtrim([Medicine_Code])))>(0)))
GO

ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [CK_Medicine_Code_NotBlank]
GO

ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [CK_Medicine_Form_NotBlank] CHECK  ((len(ltrim(rtrim([Medicine_Form])))>(0)))
GO

ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [CK_Medicine_Form_NotBlank]
GO

ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [CK_Medicine_Name_NotBlank] CHECK  ((len(ltrim(rtrim([Medicine_Name])))>(0)))
GO

ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [CK_Medicine_Name_NotBlank]
GO

ALTER TABLE [dbo].[Medicine]  WITH CHECK ADD  CONSTRAINT [CK_Medicine_Strength_NotBlank] CHECK  ((len(ltrim(rtrim([Medicine_Strength])))>(0)))
GO

ALTER TABLE [dbo].[Medicine] CHECK CONSTRAINT [CK_Medicine_Strength_NotBlank]
GO
