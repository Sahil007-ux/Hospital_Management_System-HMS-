USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    CREATE TABLE dbo.Bed_Assignment
    (
        Bed_Assignment_ID INT IDENTITY(1,1) NOT NULL,
        Admission_ID INT NOT NULL,
        Bed_ID INT NOT NULL,
        Assigned_From DATETIME2(0) NOT NULL,
        Assigned_To DATETIME2(0) NULL,

        CONSTRAINT PK_Bed_Assignment
            PRIMARY KEY (Bed_Assignment_ID),

        CONSTRAINT CK_Bed_Assignment_Dates
            CHECK (
                Assigned_To IS NULL
                OR Assigned_To > Assigned_From
            )
    );

    ALTER TABLE dbo.Bed_Assignment WITH CHECK
    ADD CONSTRAINT FK_BedAssignment_Admission
        FOREIGN KEY (Admission_ID)
        REFERENCES dbo.Admission (Admission_ID);

    ALTER TABLE dbo.Bed_Assignment WITH CHECK
    ADD CONSTRAINT FK_BedAssignment_Bed
        FOREIGN KEY (Bed_ID)
        REFERENCES dbo.Bed (Bed_ID);

    CREATE UNIQUE INDEX UX_BedAssignment_OpenBed
        ON dbo.Bed_Assignment (Bed_ID)
        WHERE Assigned_To IS NULL;

    CREATE UNIQUE INDEX UX_BedAssignment_OpenAdmission
        ON dbo.Bed_Assignment (Admission_ID)
        WHERE Assigned_To IS NULL;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;