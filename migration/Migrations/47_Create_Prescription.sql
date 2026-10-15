USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50210, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.Prescription', N'U') IS NOT NULL
        THROW 50211, 'Prescription table already exists.', 1;

    CREATE TABLE dbo.Prescription
    (
        Prescription_ID INT IDENTITY(1,1) NOT NULL,

        Medical_Record_ID INT NOT NULL,

        Prescription_Date DATETIME2(0) NOT NULL,

        Prescription_Notes NVARCHAR(1000) NULL,

        CONSTRAINT PK_Prescription
            PRIMARY KEY (Prescription_ID),

        CONSTRAINT FK_Prescription_MedicalRecord
            FOREIGN KEY (Medical_Record_ID)
            REFERENCES dbo.Medical_Record (Medical_Record_ID)
    );

    CREATE INDEX IX_Prescription_MedicalRecord
        ON dbo.Prescription (Medical_Record_ID);

    COMMIT TRANSACTION;

    SELECT
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'Prescription'
    ORDER BY ORDINAL_POSITION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;