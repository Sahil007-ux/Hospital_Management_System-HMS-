USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50040, 'Use a session without an open transaction.', 1;

DECLARE @PatientID INT;
DECLARE @ServiceID INT;
DECLARE @BillItemID INT;
DECLARE @BillID INT = -300001;
DECLARE @TestingReduction BIT = 0;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bills WITH (UPDLOCK, HOLDLOCK)
        WHERE Bill_ID = @BillID
    )
        THROW 50041, 'Test Bill_ID already exists.', 1;

    INSERT INTO dbo.Patient
    (
        Patient_First_Name,
        Patient_Last_Name
    )
    VALUES ('TEST', 'BillReduction');

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
        3000
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
        @BillID,
        @ServiceID,
        N'Test item',
        '2026-10-15T10:00:00',
        1,
        3000
    );

    SET @BillItemID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Payment
    (
        Bill_ID,
        Payment_Date,
        Payment_Amount,
        Payment_Method
    )
    VALUES
    (
        @BillID,
        '2026-10-15T11:00:00',
        2000,
        'Cash'
    );

    SET @TestingReduction = 1;

    -- Must fail: bill total would be below payments.
    UPDATE dbo.Bill_Item
    SET Bill_Item_Unit_Price = 1500
    WHERE Bill_Item_ID = @BillItemID;

    THROW 50042,
        'FAIL: Invalid bill reduction was accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingReduction = 1 AND @ErrorNumber = 50013
    BEGIN
        SELECT
            'PASS: Bill reduction rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Trigger_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;