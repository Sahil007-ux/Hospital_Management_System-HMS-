USE Hospital_Management_System;
GO

SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

IF @@TRANCOUNT <> 0
    THROW 50250, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Bills)
       OR EXISTS (SELECT 1 FROM dbo.Bill_Item)
        THROW 50251, 'Billing data already exists.', 1;

    IF (
        SELECT COUNT(*)
        FROM dbo.Admission
        WHERE Admission_ID IN (1, 2, 3)
    ) <> 3
        THROW 50252, 'Required admissions are missing.', 1;

    DECLARE @Items TABLE
    (
        Bill_ID INT,
        Service_Code VARCHAR(30),
        Service_Time DATETIME2(0)
    );

    INSERT INTO @Items
    VALUES
        (1, 'CONS-GEN', '2026-10-15T08:30:00'),
        (1, 'LAB-CBC',  '2026-10-15T09:30:00'),
        (2, 'CONS-GEN', '2026-10-15T09:30:00'),
        (2, 'LAB-CBC',  '2026-10-15T10:30:00'),
        (3, 'CONS-SUR', '2026-10-15T10:30:00'),
        (3, 'IMG-US',   '2026-10-15T12:00:00');

    IF EXISTS
    (
        SELECT 1
        FROM @Items AS i
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.Service AS s
            WHERE s.Service_Code = i.Service_Code
              AND s.Service_Is_Active = 1
        )
    )
        THROW 50253, 'Required active service is missing.', 1;

    INSERT INTO dbo.Bills
        (Bill_ID, Patient_ID, Admission_ID, Bill_Date)
    SELECT
        Admission_ID,
        Patient_ID,
        Admission_ID,
        '20261015'
    FROM dbo.Admission
    WHERE Admission_ID IN (1, 2, 3);

    INSERT INTO dbo.Bill_Item
    (
        Bill_ID,
        Service_ID,
        Bill_Item_Description,
        Bill_Item_Service_Date,
        Bill_Item_Quantity,
        Bill_Item_Unit_Price
    )
    SELECT
        i.Bill_ID,
        s.Service_ID,
        s.Service_Name,
        i.Service_Time,
        1,
        s.Service_Default_Price
    FROM @Items AS i
    JOIN dbo.Service AS s
        ON s.Service_Code = i.Service_Code;

    COMMIT TRANSACTION;

    SELECT
        bs.Bill_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        bs.Bill_Total,
        bs.Bill_Paid_Amount,
        bs.Bill_Balance,
        bs.Bill_Payment_Status
    FROM dbo.vw_Bill_Summary AS bs
    JOIN dbo.Patient AS p
        ON p.Patient_ID = bs.Patient_ID
    ORDER BY bs.Bill_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;