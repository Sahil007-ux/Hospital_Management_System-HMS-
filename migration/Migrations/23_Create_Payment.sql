USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.Payment
    (
        Payment_ID INT IDENTITY(1,1) NOT NULL,
        Bill_ID INT NOT NULL,
        Payment_Date DATETIME2(0) NOT NULL,
        Payment_Amount DECIMAL(22,2) NOT NULL,
        Payment_Method VARCHAR(20) NOT NULL,
        Payment_Reference_Number NVARCHAR(100) NULL,
        Payment_Notes NVARCHAR(500) NULL,

        CONSTRAINT PK_Payment
            PRIMARY KEY (Payment_ID),

        CONSTRAINT CK_Payment_Amount
            CHECK (Payment_Amount > 0),

        CONSTRAINT CK_Payment_Method
            CHECK
            (
                Payment_Method IN
                ('Cash', 'Card', 'BankTransfer', 'MobileMoney')
            )
    );

    ALTER TABLE dbo.Payment WITH CHECK
    ADD CONSTRAINT FK_Payment_Bill
        FOREIGN KEY (Bill_ID)
        REFERENCES dbo.Bills (Bill_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;