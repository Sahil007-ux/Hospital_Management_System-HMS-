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
    THROW 50260, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Payment)
        THROW 50261, 'Payments already exist.', 1;

    IF (
        SELECT COUNT(*)
        FROM dbo.vw_Bill_Summary
        WHERE (Bill_ID = 1 AND Bill_Total = 900)
           OR (Bill_ID = 2 AND Bill_Total = 900)
           OR (Bill_ID = 3 AND Bill_Total = 1800)
    ) <> 3
        THROW 50262, 'Expected bills or totals are missing.', 1;

    INSERT INTO dbo.Payment
    (
        Bill_ID,
        Payment_Date,
        Payment_Amount,
        Payment_Method,
        Payment_Reference_Number,
        Payment_Notes
    )
    VALUES
        (1, '2026-10-15T14:00:00', 900, 'Cash',
         N'RCPT-20261015-001', N'Full payment'),

        (2, '2026-10-15T14:30:00', 400, 'Cash',
         N'RCPT-20261015-002', N'Partial payment');

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