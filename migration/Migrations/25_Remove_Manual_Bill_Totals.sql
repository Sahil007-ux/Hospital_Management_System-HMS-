USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.vw_Bill_Summary', N'V') IS NULL
        THROW 50010, 'Create vw_Bill_Summary first.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bills WITH (TABLOCKX, HOLDLOCK)
    )
        THROW 50011,
            'Bills contains data. Reconcile totals before removing columns.',
            1;

    ALTER TABLE dbo.Bills
    DROP COLUMN Bill_Amount, Bill_Payment_Status;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO