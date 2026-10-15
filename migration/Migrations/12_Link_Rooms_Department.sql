USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    ALTER TABLE dbo.Rooms
    ADD Department_ID INT NOT NULL;

    ALTER TABLE dbo.Rooms WITH CHECK
    ADD CONSTRAINT FK_Rooms_Department
        FOREIGN KEY (Department_ID)
        REFERENCES dbo.Department (Department_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;