USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50220, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.Prescription_Item', N'U') IS NOT NULL
        THROW 50221, 'Prescription_Item already exists.', 1;

    CREATE TABLE dbo.Prescription_Item
    (
        Prescription_Item_ID INT IDENTITY(1,1) NOT NULL,
        Prescription_ID INT NOT NULL,
        Medicine_ID INT NOT NULL,

        Prescription_Item_Dose NVARCHAR(100) NOT NULL,
        Prescription_Item_Route NVARCHAR(50) NOT NULL,
        Prescription_Item_Frequency NVARCHAR(100) NOT NULL,
        Prescription_Item_Duration_Days INT NOT NULL,
        Prescription_Item_Quantity DECIMAL(10,2) NOT NULL,
        Prescription_Item_Quantity_Unit NVARCHAR(30) NOT NULL,
        Prescription_Item_Instructions NVARCHAR(500) NULL,

        CONSTRAINT PK_Prescription_Item
            PRIMARY KEY (Prescription_Item_ID),

        CONSTRAINT FK_PrescriptionItem_Prescription
            FOREIGN KEY (Prescription_ID)
            REFERENCES dbo.Prescription (Prescription_ID),

        CONSTRAINT FK_PrescriptionItem_Medicine
            FOREIGN KEY (Medicine_ID)
            REFERENCES dbo.Medicine (Medicine_ID),

        CONSTRAINT CK_PrescriptionItem_Duration
            CHECK (Prescription_Item_Duration_Days > 0),

        CONSTRAINT CK_PrescriptionItem_Quantity
            CHECK (Prescription_Item_Quantity > 0),

        CONSTRAINT CK_PrescriptionItem_Dose
            CHECK (
                LEN(LTRIM(RTRIM(Prescription_Item_Dose))) > 0
            ),

        CONSTRAINT CK_PrescriptionItem_Route
            CHECK (
                LEN(LTRIM(RTRIM(Prescription_Item_Route))) > 0
            ),

        CONSTRAINT CK_PrescriptionItem_Frequency
            CHECK (
                LEN(LTRIM(RTRIM(Prescription_Item_Frequency))) > 0
            ),

        CONSTRAINT CK_PrescriptionItem_QuantityUnit
            CHECK (
                LEN(LTRIM(RTRIM(Prescription_Item_Quantity_Unit))) > 0
            )
    );

    CREATE INDEX IX_PrescriptionItem_Prescription
        ON dbo.Prescription_Item (Prescription_ID);

    CREATE INDEX IX_PrescriptionItem_Medicine
        ON dbo.Prescription_Item (Medicine_ID);

    COMMIT TRANSACTION;

    SELECT
        COLUMN_NAME,
        DATA_TYPE,
        CHARACTER_MAXIMUM_LENGTH,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo'
      AND TABLE_NAME = 'Prescription_Item'
    ORDER BY ORDINAL_POSITION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;