USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50200, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.Medicine', N'U') IS NOT NULL
        THROW 50201, 'Medicine table already exists.', 1;

    CREATE TABLE dbo.Medicine
    (
        Medicine_ID INT IDENTITY(1,1) NOT NULL,
        Medicine_Code VARCHAR(30) NOT NULL,
        Medicine_Name NVARCHAR(150) NOT NULL,
        Medicine_Strength NVARCHAR(100) NOT NULL,
        Medicine_Form NVARCHAR(50) NOT NULL,
        Medicine_Is_Active BIT NOT NULL
            CONSTRAINT DF_Medicine_IsActive DEFAULT (1),

        CONSTRAINT PK_Medicine
            PRIMARY KEY (Medicine_ID),

        CONSTRAINT UQ_Medicine_Code
            UNIQUE (Medicine_Code),

        CONSTRAINT CK_Medicine_Code_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Medicine_Code))) > 0),

        CONSTRAINT CK_Medicine_Name_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Medicine_Name))) > 0),

        CONSTRAINT CK_Medicine_Strength_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Medicine_Strength))) > 0),

        CONSTRAINT CK_Medicine_Form_NotBlank
            CHECK (LEN(LTRIM(RTRIM(Medicine_Form))) > 0)
    );

    COMMIT TRANSACTION;

    SELECT
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'Medicine'
    ORDER BY ORDINAL_POSITION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;