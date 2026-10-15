USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    ALTER TABLE dbo.Department
    ADD Hospital_ID INT NOT NULL;

    ALTER TABLE dbo.Department WITH CHECK
    ADD CONSTRAINT FK_Department_Hospital
        FOREIGN KEY (Hospital_ID)
        REFERENCES dbo.Hospital (Hospital_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;