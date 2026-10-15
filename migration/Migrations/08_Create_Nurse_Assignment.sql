USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.Nurse_Assignment
    (
        Nurse_Assignment_ID INT IDENTITY(1,1) NOT NULL,
        Nurse_ID INT NOT NULL,
        Admission_ID INT NOT NULL,
        Assigned_From DATETIME2(0) NOT NULL,
        Assigned_To DATETIME2(0) NULL,

        CONSTRAINT PK_Nurse_Assignment
            PRIMARY KEY (Nurse_Assignment_ID),

        CONSTRAINT CK_Nurse_Assignment_Dates
            CHECK (
                Assigned_To IS NULL
                OR Assigned_To > Assigned_From
            )
    );

    ALTER TABLE dbo.Nurse_Assignment WITH CHECK
    ADD CONSTRAINT FK_NurseAssignment_Nurse
        FOREIGN KEY (Nurse_ID)
        REFERENCES dbo.Nurse (Nurse_ID);

    ALTER TABLE dbo.Nurse_Assignment WITH CHECK
    ADD CONSTRAINT FK_NurseAssignment_Admission
        FOREIGN KEY (Admission_ID)
        REFERENCES dbo.Admission (Admission_ID);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;