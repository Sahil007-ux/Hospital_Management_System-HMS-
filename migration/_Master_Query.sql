-- FINAL SCHEMA 2026-10-15: 22 tables, 27 foreign keys, 9 triggers, 1 view.
-- FRESH EMPTY DATABASE ONLY. Select a new empty database in SSMS first.
-- Do not execute on the existing Hospital_Management_System database.
-- No seed data. Do not replay historical migrations after this file.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO
/****** Object:  Table [dbo].[Bill_Item]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Payment]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Bills]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[Bill_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Admission_ID] [int] NULL,
	[Bill_Date] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Bill_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_Bill_Summary]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[vw_Bill_Summary]
AS
WITH ItemTotals AS
(
    SELECT
        Bill_ID,
        SUM(Bill_Item_Line_Total) AS Bill_Total
    FROM dbo.Bill_Item
    GROUP BY Bill_ID
),
PaymentTotals AS
(
    SELECT
        Bill_ID,
        SUM(Payment_Amount) AS Bill_Paid_Amount
    FROM dbo.Payment
    GROUP BY Bill_ID
)
SELECT
    b.Bill_ID,
    b.Patient_ID,
    b.Admission_ID,
    b.Bill_Date,

    ISNULL(i.Bill_Total, 0) AS Bill_Total,
    ISNULL(p.Bill_Paid_Amount, 0) AS Bill_Paid_Amount,

    ISNULL(i.Bill_Total, 0)
        - ISNULL(p.Bill_Paid_Amount, 0)
        AS Bill_Balance,

    CASE
        WHEN ISNULL(p.Bill_Paid_Amount, 0)
             > ISNULL(i.Bill_Total, 0)
            THEN 'Overpaid'

        WHEN ISNULL(i.Bill_Total, 0) = 0
            THEN 'NoCharge'

        WHEN ISNULL(p.Bill_Paid_Amount, 0) = 0
            THEN 'Unpaid'

        WHEN p.Bill_Paid_Amount < i.Bill_Total
            THEN 'PartiallyPaid'

        ELSE 'Paid'
    END AS Bill_Payment_Status

FROM dbo.Bills AS b
LEFT JOIN ItemTotals AS i
    ON i.Bill_ID = b.Bill_ID
LEFT JOIN PaymentTotals AS p
    ON p.Bill_ID = b.Bill_ID;
GO
/****** Object:  Table [dbo].[Admission]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Admission](
	[Admission_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Admission_Date] [datetime2](0) NOT NULL,
	[Admission_Discharge_Date] [datetime2](0) NULL,
	[Admission_Reason] [nvarchar](500) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Admission_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Admission_ID_Patient] UNIQUE NONCLUSTERED 
(
	[Admission_ID] ASC,
	[Patient_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointment](
	[Appointment_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Doctor_ID] [int] NOT NULL,
	[Appointment_Date] [date] NULL,
	[Appointment_Time] [time](7) NULL,
	[Appointment_Reason] [varchar](300) NULL,
	[Appointment_Status] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Appointment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bed]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bed](
	[Bed_ID] [int] IDENTITY(1,1) NOT NULL,
	[Room_ID] [int] NOT NULL,
	[Bed_Number] [nvarchar](20) NOT NULL,
	[Bed_Is_Active] [bit] NOT NULL,
 CONSTRAINT [PK_Bed] PRIMARY KEY CLUSTERED 
(
	[Bed_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Bed_Room_Number] UNIQUE NONCLUSTERED 
(
	[Room_ID] ASC,
	[Bed_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bed_Assignment]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Department]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Department_ID] [int] NOT NULL,
	[Department_Name] [varchar](100) NOT NULL,
	[Department_Location] [varchar](100) NULL,
	[Hospital_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Department_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[Doctor_ID] [int] NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Department_ID] [int] NOT NULL,
	[Doctor_Specialization] [varchar](100) NOT NULL,
	[Doctor_Qualification] [varchar](100) NOT NULL,
	[Doctor_Department] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Doctor_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Hospital]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Medical_Record]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Medicine]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Nurse]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nurse](
	[Nurse_ID] [int] NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Nurse_Qualification] [nvarchar](100) NOT NULL,
	[Nurse_Shift] [nvarchar](20) NOT NULL,
	[Department_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Nurse_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Nurse_Assignment]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Nurse_Assignment](
	[Nurse_Assignment_ID] [int] IDENTITY(1,1) NOT NULL,
	[Nurse_ID] [int] NOT NULL,
	[Admission_ID] [int] NOT NULL,
	[Nurse_Assignment_Start] [datetime2](0) NOT NULL,
	[Nurse_Assignment_End] [datetime2](0) NULL,
 CONSTRAINT [PK_Nurse_Assignment] PRIMARY KEY CLUSTERED 
(
	[Nurse_Assignment_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[Patient_ID] [int] IDENTITY(1,1) NOT NULL,
	[Patient_First_Name] [varchar](50) NOT NULL,
	[Patient_Last_Name] [varchar](50) NOT NULL,
	[Patient_Gender] [char](7) NULL,
	[Patient_Age] [int] NULL,
	[Patient_Date_Of_Birth] [date] NULL,
	[Patient_Phone] [varchar](20) NULL,
	[Patient_Address] [varchar](50) NULL,
	[Patient_Blood_Group] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[Patient_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[Prescription_ID] [int] IDENTITY(1,1) NOT NULL,
	[Medical_Record_ID] [int] NOT NULL,
	[Prescription_Date] [datetime2](0) NOT NULL,
	[Prescription_Notes] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED 
(
	[Prescription_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription_Item]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[Receptionist]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receptionist](
	[Receptionist_ID] [int] NOT NULL,
	[Employee_ID] [int] NOT NULL,
	[Receptionist_Desk_Number] [varchar](20) NOT NULL,
	[Receptionist_Shift] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Receptionist_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Receptionist_Employee] UNIQUE NONCLUSTERED 
(
	[Employee_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[Room_ID] [int] NOT NULL,
	[Room_Number] [varchar](10) NOT NULL,
	[Room_Floor_Number] [int] NOT NULL,
	[Room_Daily_Charge] [decimal](12, 2) NOT NULL,
	[Room_Type] [nvarchar](50) NOT NULL,
	[Room_Availability_Status] [nvarchar](20) NOT NULL,
	[Room_Capacity] [int] NOT NULL,
	[Department_ID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Room_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Room_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Service]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Service](
	[Service_ID] [int] IDENTITY(1,1) NOT NULL,
	[Service_Code] [varchar](30) NOT NULL,
	[Service_Name] [nvarchar](150) NOT NULL,
	[Service_Default_Price] [decimal](12, 2) NOT NULL,
	[Service_Is_Active] [bit] NOT NULL,
 CONSTRAINT [PK_Service] PRIMARY KEY CLUSTERED 
(
	[Service_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Service_Code] UNIQUE NONCLUSTERED 
(
	[Service_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Test_Report]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Test_Report](
	[Test_Report_ID] [int] NOT NULL,
	[Patient_ID] [int] NOT NULL,
	[Doctor_ID] [int] NOT NULL,
	[Test_Report_Date] [date] NOT NULL,
	[Test_Report_Type] [nvarchar](100) NOT NULL,
	[Test_Report_Result] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Test_Report_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [UX_BedAssignment_OpenAdmission]    Script Date: 10/15/2026 10:25:13 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_BedAssignment_OpenAdmission] ON [dbo].[Bed_Assignment]
(
	[Admission_ID] ASC
)
WHERE ([Bed_Assignment_End] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UX_BedAssignment_OpenBed]    Script Date: 10/15/2026 10:25:13 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [UX_BedAssignment_OpenBed] ON [dbo].[Bed_Assignment]
(
	[Bed_ID] ASC
)
WHERE ([Bed_Assignment_End] IS NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Prescription_MedicalRecord]    Script Date: 10/15/2026 10:25:13 PM ******/
CREATE NONCLUSTERED INDEX [IX_Prescription_MedicalRecord] ON [dbo].[Prescription]
(
	[Medical_Record_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
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
ALTER TABLE [dbo].[Bed] ADD  CONSTRAINT [DF_Bed_IsActive]  DEFAULT ((1)) FOR [Bed_Is_Active]
GO
ALTER TABLE [dbo].[Medicine] ADD  CONSTRAINT [DF_Medicine_IsActive]  DEFAULT ((1)) FOR [Medicine_Is_Active]
GO
ALTER TABLE [dbo].[Service] ADD  CONSTRAINT [DF_Service_IsActive]  DEFAULT ((1)) FOR [Service_Is_Active]
GO
ALTER TABLE [dbo].[Admission]  WITH CHECK ADD  CONSTRAINT [FK_Addmission_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Admission] CHECK CONSTRAINT [FK_Addmission_Patient]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Doctor]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [FK_Appointment_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [FK_Appointment_Patient]
GO
ALTER TABLE [dbo].[Bed]  WITH CHECK ADD  CONSTRAINT [FK_Bed_Room] FOREIGN KEY([Room_ID])
REFERENCES [dbo].[Rooms] ([Room_ID])
GO
ALTER TABLE [dbo].[Bed] CHECK CONSTRAINT [FK_Bed_Room]
GO
ALTER TABLE [dbo].[Bed_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_BedAssignment_Admission] FOREIGN KEY([Admission_ID])
REFERENCES [dbo].[Admission] ([Admission_ID])
GO
ALTER TABLE [dbo].[Bed_Assignment] CHECK CONSTRAINT [FK_BedAssignment_Admission]
GO
ALTER TABLE [dbo].[Bed_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_BedAssignment_Bed] FOREIGN KEY([Bed_ID])
REFERENCES [dbo].[Bed] ([Bed_ID])
GO
ALTER TABLE [dbo].[Bed_Assignment] CHECK CONSTRAINT [FK_BedAssignment_Bed]
GO
ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [FK_BillItem_Bill] FOREIGN KEY([Bill_ID])
REFERENCES [dbo].[Bills] ([Bill_ID])
GO
ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [FK_BillItem_Bill]
GO
ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [FK_BillItem_Service] FOREIGN KEY([Service_ID])
REFERENCES [dbo].[Service] ([Service_ID])
GO
ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [FK_BillItem_Service]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Admission_Patient] FOREIGN KEY([Admission_ID], [Patient_ID])
REFERENCES [dbo].[Admission] ([Admission_ID], [Patient_ID])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Admission_Patient]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Patient]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_Department_Hospital] FOREIGN KEY([Hospital_ID])
REFERENCES [dbo].[Hospital] ([Hospital_ID])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_Department_Hospital]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Department]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Doctor_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Doctor_Employee]
GO
ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD  CONSTRAINT [FK_MedicalRecord_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Medical_Record] CHECK CONSTRAINT [FK_MedicalRecord_Doctor]
GO
ALTER TABLE [dbo].[Medical_Record]  WITH CHECK ADD  CONSTRAINT [FK_MedicalRecord_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Medical_Record] CHECK CONSTRAINT [FK_MedicalRecord_Patient]
GO
ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO
ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Department]
GO
ALTER TABLE [dbo].[Nurse]  WITH CHECK ADD  CONSTRAINT [FK_Nurse_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO
ALTER TABLE [dbo].[Nurse] CHECK CONSTRAINT [FK_Nurse_Employee]
GO
ALTER TABLE [dbo].[Nurse_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_NurseAssignment_Admission] FOREIGN KEY([Admission_ID])
REFERENCES [dbo].[Admission] ([Admission_ID])
GO
ALTER TABLE [dbo].[Nurse_Assignment] CHECK CONSTRAINT [FK_NurseAssignment_Admission]
GO
ALTER TABLE [dbo].[Nurse_Assignment]  WITH CHECK ADD  CONSTRAINT [FK_NurseAssignment_Nurse] FOREIGN KEY([Nurse_ID])
REFERENCES [dbo].[Nurse] ([Nurse_ID])
GO
ALTER TABLE [dbo].[Nurse_Assignment] CHECK CONSTRAINT [FK_NurseAssignment_Nurse]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [FK_Payment_Bill] FOREIGN KEY([Bill_ID])
REFERENCES [dbo].[Bills] ([Bill_ID])
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [FK_Payment_Bill]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [FK_Prescription_MedicalRecord] FOREIGN KEY([Medical_Record_ID])
REFERENCES [dbo].[Medical_Record] ([Medical_Record_ID])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [FK_Prescription_MedicalRecord]
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
ALTER TABLE [dbo].[Receptionist]  WITH CHECK ADD  CONSTRAINT [FK_Receptionist_Employee] FOREIGN KEY([Employee_ID])
REFERENCES [dbo].[Employee] ([Employee_ID])
GO
ALTER TABLE [dbo].[Receptionist] CHECK CONSTRAINT [FK_Receptionist_Employee]
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [FK_Rooms_Department] FOREIGN KEY([Department_ID])
REFERENCES [dbo].[Department] ([Department_ID])
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [FK_Rooms_Department]
GO
ALTER TABLE [dbo].[Test_Report]  WITH CHECK ADD  CONSTRAINT [FK_TestReport_Doctor] FOREIGN KEY([Doctor_ID])
REFERENCES [dbo].[Doctor] ([Doctor_ID])
GO
ALTER TABLE [dbo].[Test_Report] CHECK CONSTRAINT [FK_TestReport_Doctor]
GO
ALTER TABLE [dbo].[Test_Report]  WITH CHECK ADD  CONSTRAINT [FK_TestReport_Patient] FOREIGN KEY([Patient_ID])
REFERENCES [dbo].[Patient] ([Patient_ID])
GO
ALTER TABLE [dbo].[Test_Report] CHECK CONSTRAINT [FK_TestReport_Patient]
GO
ALTER TABLE [dbo].[Admission]  WITH CHECK ADD  CONSTRAINT [CK_Admission_Dates] CHECK  (([Admission_Discharge_Date] IS NULL OR [Admission_Discharge_Date]>=[Admission_Date]))
GO
ALTER TABLE [dbo].[Admission] CHECK CONSTRAINT [CK_Admission_Dates]
GO
ALTER TABLE [dbo].[Bed_Assignment]  WITH CHECK ADD  CONSTRAINT [CK_Bed_Assignment_Dates] CHECK  (([Bed_Assignment_End] IS NULL OR [Bed_Assignment_End]>[Bed_Assignment_Start]))
GO
ALTER TABLE [dbo].[Bed_Assignment] CHECK CONSTRAINT [CK_Bed_Assignment_Dates]
GO
ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [CK_BillItem_Quantity] CHECK  (([Bill_Item_Quantity]>(0)))
GO
ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [CK_BillItem_Quantity]
GO
ALTER TABLE [dbo].[Bill_Item]  WITH CHECK ADD  CONSTRAINT [CK_BillItem_UnitPrice] CHECK  (([Bill_Item_Unit_Price]>=(0)))
GO
ALTER TABLE [dbo].[Bill_Item] CHECK CONSTRAINT [CK_BillItem_UnitPrice]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [chk1_Gender] CHECK  (([Employee_Gender]='Female' OR [Employee_Gender]='Male'))
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [chk1_Gender]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [CK_Employee_Salary] CHECK  (([Employee_Salary]>=(0)))
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [CK_Employee_Salary]
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
ALTER TABLE [dbo].[Nurse_Assignment]  WITH CHECK ADD  CONSTRAINT [CK_Nurse_Assignment_Dates] CHECK  (([Nurse_Assignment_End] IS NULL OR [Nurse_Assignment_End]>[Nurse_Assignment_Start]))
GO
ALTER TABLE [dbo].[Nurse_Assignment] CHECK CONSTRAINT [CK_Nurse_Assignment_Dates]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [chk_Gender] CHECK  (([Patient_Gender]='Female' OR [Patient_Gender]='Male'))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [chk_Gender]
GO
ALTER TABLE [dbo].[Patient]  WITH CHECK ADD  CONSTRAINT [CK__Patient__Blood_G__49C3F6B7] CHECK  (([Patient_Blood_Group]='O-' OR [Patient_Blood_Group]='O+' OR [Patient_Blood_Group]='AB-' OR [Patient_Blood_Group]='AB+' OR [Patient_Blood_Group]='B-' OR [Patient_Blood_Group]='B+' OR [Patient_Blood_Group]='A-' OR [Patient_Blood_Group]='A+'))
GO
ALTER TABLE [dbo].[Patient] CHECK CONSTRAINT [CK__Patient__Blood_G__49C3F6B7]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [CK_Payment_Amount] CHECK  (([Payment_Amount]>(0)))
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [CK_Payment_Amount]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [CK_Payment_Method] CHECK  (([Payment_Method]='MobileMoney' OR [Payment_Method]='BankTransfer' OR [Payment_Method]='Card' OR [Payment_Method]='Cash'))
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [CK_Payment_Method]
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
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [CK_Rooms_Capacity] CHECK  (([Room_Capacity]>(0)))
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [CK_Rooms_Capacity]
GO
ALTER TABLE [dbo].[Rooms]  WITH CHECK ADD  CONSTRAINT [CK_Rooms_DailyCharge] CHECK  (([Room_Daily_Charge]>=(0)))
GO
ALTER TABLE [dbo].[Rooms] CHECK CONSTRAINT [CK_Rooms_DailyCharge]
GO
ALTER TABLE [dbo].[Service]  WITH CHECK ADD  CONSTRAINT [CK_Service_DefaultPrice] CHECK  (([Service_Default_Price]>=(0)))
GO
ALTER TABLE [dbo].[Service] CHECK CONSTRAINT [CK_Service_DefaultPrice]
GO
/****** Object:  Trigger [dbo].[TR_Admission_BedAssignmentDates]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[TR_Admission_BedAssignmentDates]
ON [dbo].[Admission]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS a
        INNER JOIN dbo.Bed_Assignment AS b WITH (UPDLOCK, HOLDLOCK)
            ON b.Admission_ID = a.Admission_ID
        WHERE
            b.Bed_Assignment_Start < a.Admission_Date
            OR
            (
                a.Admission_Discharge_Date IS NOT NULL
                AND
                (
                    b.Bed_Assignment_End IS NULL
                    OR b.Bed_Assignment_End > a.Admission_Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50004,
            'Admission dates conflict with existing bed assignments.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Admission] ENABLE TRIGGER [TR_Admission_BedAssignmentDates]
GO
/****** Object:  Trigger [dbo].[TR_Admission_NurseAssignmentDates]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[TR_Admission_NurseAssignmentDates]
ON [dbo].[Admission]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS a
        INNER JOIN dbo.Nurse_Assignment AS n WITH (UPDLOCK, HOLDLOCK)
            ON n.Admission_ID = a.Admission_ID
        WHERE
            n.Nurse_Assignment_Start < a.Admission_Date
            OR
            (
                a.Admission_Discharge_Date IS NOT NULL
                AND
                (
                    n.Nurse_Assignment_End IS NULL
                    OR n.Nurse_Assignment_End > a.Admission_Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50006,
            'Admission dates conflict with existing nurse assignments.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Admission] ENABLE TRIGGER [TR_Admission_NurseAssignmentDates]
GO
/****** Object:  Trigger [dbo].[TR_Bed_PreventDeactivateAssigned]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_Bed_PreventDeactivateAssigned]
ON [dbo].[Bed]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(Bed_Is_Active)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS b
        INNER JOIN dbo.Bed_Assignment AS a
            WITH (READCOMMITTEDLOCK)
            ON a.Bed_ID = b.Bed_ID
        WHERE b.Bed_Is_Active = 0
          AND a.Bed_Assignment_End IS NULL
    )
    BEGIN
        THROW 50015,
            'Close the open assignment before deactivating the bed.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Bed] ENABLE TRIGGER [TR_Bed_PreventDeactivateAssigned]
GO
/****** Object:  Trigger [dbo].[TR_BedAssignment_ActiveBed]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_BedAssignment_ActiveBed]
ON [dbo].[Bed_Assignment]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Check new assignments, bed changes and reopened assignments.
    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        LEFT JOIN deleted AS d
            ON d.Bed_Assignment_ID = i.Bed_Assignment_ID
        INNER JOIN dbo.Bed AS b WITH (UPDLOCK, HOLDLOCK)
            ON b.Bed_ID = i.Bed_ID
        WHERE b.Bed_Is_Active = 0
          AND
          (
              d.Bed_Assignment_ID IS NULL
              OR i.Bed_ID <> d.Bed_ID
              OR
              (
                  d.Bed_Assignment_End IS NOT NULL
                  AND i.Bed_Assignment_End IS NULL
              )
          )
    )
    BEGIN
        THROW 50014,
            'An inactive bed cannot receive a new or reopened assignment.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Bed_Assignment] ENABLE TRIGGER [TR_BedAssignment_ActiveBed]
GO
/****** Object:  Trigger [dbo].[TR_BedAssignment_AdmissionDates]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[TR_BedAssignment_AdmissionDates]
ON [dbo].[Bed_Assignment]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.Admission AS a WITH (UPDLOCK, HOLDLOCK)
            ON a.Admission_ID = i.Admission_ID
        WHERE
            i.Bed_Assignment_Start < a.Admission_Date
            OR
            (
                a.Admission_Discharge_Date IS NOT NULL
                AND
                (
                    i.Bed_Assignment_End IS NULL
                    OR i.Bed_Assignment_End > a.Admission_Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50003,
            'Bed assignment must be within the admission period.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Bed_Assignment] ENABLE TRIGGER [TR_BedAssignment_AdmissionDates]
GO
/****** Object:  Trigger [dbo].[TR_BedAssignment_NoOverlap]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[TR_BedAssignment_NoOverlap]
ON [dbo].[Bed_Assignment]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Serialize checks, including concurrent transactions.
    DECLARE @RowCount BIGINT;

    SELECT @RowCount = COUNT_BIG(*)
    FROM dbo.Bed_Assignment WITH (TABLOCKX, HOLDLOCK);

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.Bed_Assignment AS b
            ON b.Bed_Assignment_ID <> i.Bed_Assignment_ID
           AND (
                b.Bed_ID = i.Bed_ID
                OR b.Admission_ID = i.Admission_ID
           )
        WHERE
            (
                b.Bed_Assignment_End IS NULL
                OR i.Bed_Assignment_Start < b.Bed_Assignment_End
            )
            AND
            (
                i.Bed_Assignment_End IS NULL
                OR b.Bed_Assignment_Start < i.Bed_Assignment_End
            )
    )
    BEGIN
        THROW 50002,
            'Overlapping bed or admission assignment is not allowed.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Bed_Assignment] ENABLE TRIGGER [TR_BedAssignment_NoOverlap]
GO
/****** Object:  Trigger [dbo].[TR_BillItem_NoOverpayment]    Script Date: 10/15/2026 10:25:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_BillItem_NoOverpayment]
ON [dbo].[Bill_Item]
AFTER UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM deleted)
        RETURN;

    DECLARE @LockedBills BIGINT;

    SELECT @LockedBills = COUNT_BIG(*)
    FROM dbo.Bills AS b WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN
    (
        SELECT Bill_ID FROM inserted
        UNION
        SELECT Bill_ID FROM deleted
    ) AS affected
        ON affected.Bill_ID = b.Bill_ID;

    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT Bill_ID FROM inserted
            UNION
            SELECT Bill_ID FROM deleted
        ) AS affected
        OUTER APPLY
        (
            SELECT SUM(p.Payment_Amount) AS Paid_Amount
            FROM dbo.Payment AS p WITH (READCOMMITTEDLOCK)
            WHERE p.Bill_ID = affected.Bill_ID
        ) AS payments
        OUTER APPLY
        (
            SELECT SUM(i.Bill_Item_Line_Total) AS Total_Amount
            FROM dbo.Bill_Item AS i WITH (READCOMMITTEDLOCK)
            WHERE i.Bill_ID = affected.Bill_ID
        ) AS items
        WHERE ISNULL(payments.Paid_Amount, 0)
            > ISNULL(items.Total_Amount, 0)
    )
    BEGIN
        THROW 50013,
            'Bill changes would make payments exceed the bill total.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Bill_Item] ENABLE TRIGGER [TR_BillItem_NoOverpayment]
GO
/****** Object:  Trigger [dbo].[TR_NurseAssignment_AdmissionDates]    Script Date: 10/15/2026 10:25:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[TR_NurseAssignment_AdmissionDates]
ON [dbo].[Nurse_Assignment]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS n
        INNER JOIN dbo.Admission AS a WITH (UPDLOCK, HOLDLOCK)
            ON a.Admission_ID = n.Admission_ID
        WHERE
            n.Nurse_Assignment_Start < a.Admission_Date
            OR
            (
                a.Admission_Discharge_Date IS NOT NULL
                AND
                (
                    n.Nurse_Assignment_End IS NULL
                    OR n.Nurse_Assignment_End > a.Admission_Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50005,
            'Nurse assignment must be within the admission period.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Nurse_Assignment] ENABLE TRIGGER [TR_NurseAssignment_AdmissionDates]
GO
/****** Object:  Trigger [dbo].[TR_Payment_NoOverpayment]    Script Date: 10/15/2026 10:25:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[TR_Payment_NoOverpayment]
ON [dbo].[Payment]
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Lock affected bills until the transaction ends.
    DECLARE @LockedBills BIGINT;

    SELECT @LockedBills = COUNT_BIG(*)
    FROM dbo.Bills AS b WITH (UPDLOCK, HOLDLOCK)
    INNER JOIN
    (
        SELECT Bill_ID FROM inserted
        UNION
        SELECT Bill_ID FROM deleted
    ) AS affected
        ON affected.Bill_ID = b.Bill_ID;

    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT Bill_ID FROM inserted
            UNION
            SELECT Bill_ID FROM deleted
        ) AS affected
        OUTER APPLY
        (
            SELECT SUM(p.Payment_Amount) AS Paid_Amount
            FROM dbo.Payment AS p WITH (READCOMMITTEDLOCK)
            WHERE p.Bill_ID = affected.Bill_ID
        ) AS payments
        OUTER APPLY
        (
            SELECT SUM(i.Bill_Item_Line_Total) AS Total_Amount
            FROM dbo.Bill_Item AS i WITH (READCOMMITTEDLOCK)
            WHERE i.Bill_ID = affected.Bill_ID
        ) AS items
        WHERE ISNULL(payments.Paid_Amount, 0)
            > ISNULL(items.Total_Amount, 0)
    )
    BEGIN
        THROW 50012,
            'Total payments cannot exceed the bill total.',
            1;
    END;
END;
GO
ALTER TABLE [dbo].[Payment] ENABLE TRIGGER [TR_Payment_NoOverpayment]
GO
