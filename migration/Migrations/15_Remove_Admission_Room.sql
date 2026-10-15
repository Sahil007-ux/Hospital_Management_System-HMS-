USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (
        SELECT 1
        FROM dbo.Admission WITH (TABLOCKX, HOLDLOCK)
    )
    BEGIN
        THROW 50001,
            'Admission contains data. Migrate room assignments first.',
            1;
    END;

    ALTER TABLE dbo.Admission
    DROP CONSTRAINT FK_Addmission_Room;

    ALTER TABLE dbo.Admission
    DROP COLUMN Room_ID;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;