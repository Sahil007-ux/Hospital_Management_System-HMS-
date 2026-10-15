USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    ALTER TABLE dbo.Admission
    DROP CONSTRAINT CK_Admission_Dates;

    ALTER TABLE dbo.Admission
    ALTER COLUMN Admission_Date DATETIME2(0) NOT NULL;

    ALTER TABLE dbo.Admission
    ALTER COLUMN Discharge_Date DATETIME2(0) NULL;

    ALTER TABLE dbo.Admission WITH CHECK
    ADD CONSTRAINT CK_Admission_Dates
        CHECK (
            Discharge_Date IS NULL
            OR Discharge_Date >= Admission_Date
        );

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;