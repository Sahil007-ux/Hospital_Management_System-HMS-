-- REFERENCE ONLY. Included in _Master_Query.sql; do not run twice.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO
CREATE TABLE [dbo].[Prescription_Item](
	[Prescription_Item_ID] [int] IDENTITY(1,1) NOT NULL,
	[Prescription_ID] [int] NOT NULL,
	[Medicine_ID] [int] NOT NULL,
	[Prescription_Item_Dose] [nvarchar](100) NOT NULL,
	[Prescription_Item_Route] [nvarchar](50) NOT NULL,
	[Prescription_Item_Frequency] [nvarchar](100) NOT NULL,
	[Prescription_Item_Duration_Days] [int] NOT NULL,
	[Prescription_Item_Quantity] [decimal](10, 2) NOT NULL,
	[Prescription_Item_Quantity_Unit] [nvarchar](30) NOT NULL,
	[Prescription_Item_Instructions] [nvarchar](500) NULL,
 CONSTRAINT [PK_Prescription_Item] PRIMARY KEY CLUSTERED 
(
	[Prescription_Item_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Index [IX_PrescriptionItem_Medicine]    Script Date: 10/15/2026 10:25:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_PrescriptionItem_Medicine] ON [dbo].[Prescription_Item]
(
	[Medicine_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [IX_PrescriptionItem_Prescription]    Script Date: 10/15/2026 10:25:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_PrescriptionItem_Prescription] ON [dbo].[Prescription_Item]
(
	[Prescription_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionItem_Medicine] FOREIGN KEY([Medicine_ID])
REFERENCES [dbo].[Medicine] ([Medicine_ID])
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [FK_PrescriptionItem_Medicine]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [FK_PrescriptionItem_Prescription] FOREIGN KEY([Prescription_ID])
REFERENCES [dbo].[Prescription] ([Prescription_ID])
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [FK_PrescriptionItem_Prescription]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_Dose] CHECK  ((len(ltrim(rtrim([Prescription_Item_Dose])))>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_Dose]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_Duration] CHECK  (([Prescription_Item_Duration_Days]>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_Duration]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_Frequency] CHECK  ((len(ltrim(rtrim([Prescription_Item_Frequency])))>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_Frequency]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_Quantity] CHECK  (([Prescription_Item_Quantity]>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_Quantity]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_QuantityUnit] CHECK  ((len(ltrim(rtrim([Prescription_Item_Quantity_Unit])))>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_QuantityUnit]
GO

ALTER TABLE [dbo].[Prescription_Item]  WITH CHECK ADD  CONSTRAINT [CK_PrescriptionItem_Route] CHECK  ((len(ltrim(rtrim([Prescription_Item_Route])))>(0)))
GO

ALTER TABLE [dbo].[Prescription_Item] CHECK CONSTRAINT [CK_PrescriptionItem_Route]
GO
