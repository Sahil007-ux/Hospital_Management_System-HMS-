USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.Bill_Item
    (
        Bill_Item_ID INT IDENTITY(1,1) NOT NULL,
        Bill_ID INT NOT NULL,
        Service_ID INT NOT NULL,
        Service_Description NVARCHAR(250) NOT NULL,
        Service_Date DATETIME2(0) NOT NULL,
        Quantity DECIMAL(10,2) NOT NULL,
        Unit_Price DECIMAL(12,2) NOT NULL,

        Line_Total AS
            CAST(Quantity * Unit_Price AS DECIMAL(22,2))
            PERSISTED,

        CONSTRAINT PK_Bill_Item
            PRIMARY KEY (Bill_Item_ID),

        CONSTRAINT CK_BillItem_Quantity
            CHECK (Quantity > 0),

        CONSTRAINT CK_BillItem_UnitPrice
            CHECK (Unit_Price >= 0)
    );

    ALTER TABLE dbo.Bill_Item WITH CHECK
    ADD CONSTRAINT FK_BillItem_Bill
        FOREIGN KEY (Bill_ID)
        REFERENCES dbo.Bills (Bill_ID);

    ALTER TABLE dbo.Bill_Item WITH CHECK
    ADD CONSTRAINT FK_BillItem_Service
        FOREIGN KEY (Service_ID)
        REFERENCES dbo.Service (Service_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;