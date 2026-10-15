USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.Bed
    (
        Bed_ID INT IDENTITY(1,1) NOT NULL,
        Room_ID INT NOT NULL,
        Bed_Number NVARCHAR(20) NOT NULL,
        Is_Active BIT NOT NULL
            CONSTRAINT DF_Bed_IsActive DEFAULT (1),

        CONSTRAINT PK_Bed
            PRIMARY KEY (Bed_ID),

        CONSTRAINT UQ_Bed_Room_Number
            UNIQUE (Room_ID, Bed_Number)
    );

    ALTER TABLE dbo.Bed WITH CHECK
    ADD CONSTRAINT FK_Bed_Room
        FOREIGN KEY (Room_ID)
        REFERENCES dbo.Rooms (Room_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;