USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

-- Run this test without an existing transaction.
IF @@TRANCOUNT <> 0
    THROW 50030, 'Use a session without an open transaction.', 1;

DECLARE @PatientID INT;
DECLARE @ServiceID INT;
DECLARE @BillID INT = -290001;
DECLARE @TestingOverpayment BIT = 0;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bills WITH (UPDLOCK, HOLDLOCK)
        WHERE Bill_ID = @BillID
    )
        THROW 50031, 'Test Bill_ID already exists.', 1;

    INSERT INTO dbo.Patient
    (
        Patient_First_Name,
        Patient_Last_Name
    )
    VALUES ('TEST', 'Overpayment');

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
        1000,
        'Cash'
    );

    SET @TestingOverpayment = 1;

    -- This payment must be rejected.
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
        '2026-10-15T12:00:00',
        2500,
        'Cash'
    );

    -- Reaching here means the trigger did not reject it.
    THROW 50032,
        'FAIL: Excess payment was accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingOverpayment = 1 AND @ErrorNumber = 50012
    BEGIN
        SELECT
            'PASS: Excess payment rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Trigger_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;