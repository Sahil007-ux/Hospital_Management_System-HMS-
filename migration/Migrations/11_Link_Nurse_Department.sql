USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    ALTER TABLE dbo.Nurse
    ADD Department_ID INT NOT NULL;

    ALTER TABLE dbo.Nurse WITH CHECK
    ADD CONSTRAINT FK_Nurse_Department
        FOREIGN KEY (Department_ID)
        REFERENCES dbo.Department (Department_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;