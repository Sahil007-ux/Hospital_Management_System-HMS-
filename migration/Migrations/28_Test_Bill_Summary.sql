USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @PatientID INT;
    DECLARE @ServiceID INT;
    DECLARE @BillID INT = -280001;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bills WITH (UPDLOCK, HOLDLOCK)
        WHERE Bill_ID = @BillID
    )
        THROW 50020, 'Test Bill_ID already exists.', 1;

    INSERT INTO dbo.Patient
    (
        Patient_First_Name,
        Patient_Last_Name
    )
    VALUES ('TEST', 'Billing');

    SET @PatientID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Service
    (
        Service_Code,
        Service_Name,
        Service_Default_Price
    )
    VALUES
    (
        'T' + LEFT(CONVERT(VARCHAR(36), NEWID()), 29),
        N'Test service',
        500
    );

    SET @ServiceID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Bills
    (
        Bill_ID,
        Patient_ID,
        Admission_ID,
        Bill_Date
    )
    VALUES
    (
        @BillID,
        @PatientID,
        NULL,
        '2026-10-15'
    );

    INSERT INTO dbo.Bill_Item
    (
        Bill_ID,
        Service_ID,
        Bill_Item_Description,
        Bill_Item_Service_Date,
        Bill_Item_Quantity,
        Bill_Item_Unit_Price
    )
    VALUES
    (
        @BillID, @ServiceID,
        N'Test item A', '2026-10-15T10:00:00',
        1, 500
    ),
    (
        @BillID, @ServiceID,
        N'Test item B', '2026-10-15T10:00:00',
        5, 500
    );

    INSERT INTO dbo.Payment
    (
        Bill_ID,
        Payment_Date,
        Payment_Amount,
        Payment_Method
    )
    VALUES
        (@BillID, '2026-10-15T11:00:00', 400, 'Cash'),
        (@BillID, '2026-10-15T12:00:00', 600, 'Cash');

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.vw_Bill_Summary
        WHERE Bill_ID = @BillID
          AND Bill_Total = 3000
          AND Bill_Paid_Amount = 1000
          AND Bill_Balance = 2000
          AND Bill_Payment_Status = 'PartiallyPaid'
    )
        THROW 50021, 'FAIL: Bill summary is incorrect.', 1;

    SELECT
        Bill_Total,
        Bill_Paid_Amount,
        Bill_Balance,
        Bill_Payment_Status
    FROM dbo.vw_Bill_Summary
    WHERE Bill_ID = @BillID;

    ROLLBACK TRANSACTION;

    SELECT
        'PASS: Summary correct; test rows rolled back.'
        AS Test_Result;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;