USE [Hospital_Management_System];
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Allow the pair to be referenced by a composite FK.
    ALTER TABLE dbo.Admission
    ADD CONSTRAINT UQ_Admission_ID_Patient
        UNIQUE (Admission_ID, Patient_ID);

    -- Validate both the admission and its patient together.
    ALTER TABLE dbo.Bills WITH CHECK
    ADD CONSTRAINT FK_Bills_Admission_Patient
        FOREIGN KEY (Admission_ID, Patient_ID)
        REFERENCES dbo.Admission
            (Admission_ID, Patient_ID);

    -- The composite FK replaces the old admission-only FK.
    ALTER TABLE dbo.Bills
    DROP CONSTRAINT FK_Bills_Addmission;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO

SELECT
    name AS Constraint_Name,
    is_disabled AS Is_Disabled,
    is_not_trusted AS Is_Not_Trusted
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID(N'dbo.Bills')
  AND name = N'FK_Bills_Admission_Patient';