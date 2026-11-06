
USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Step 1: End Bed Assignments
    UPDATE dbo.Bed_Assignment
    SET Bed_Assignment_End =
        CASE Admission_ID
            WHEN 1 THEN '2026-10-18T12:00:00'
            WHEN 2 THEN '2026-10-19T12:00:00'
            WHEN 3 THEN '2026-10-20T12:00:00'
        END
    WHERE Admission_ID IN (1, 2, 3)
      AND Bed_Assignment_End IS NULL;

    IF @@ROWCOUNT <> 3
        THROW 50001, 'Bed assignment update failed.', 1;

    -- Step 2: End Nurse Assignments
    UPDATE dbo.Nurse_Assignment
    SET Nurse_Assignment_End =
        CASE Admission_ID
            WHEN 1 THEN '2026-10-18T12:00:00'
            WHEN 2 THEN '2026-10-19T12:00:00'
            WHEN 3 THEN '2026-10-20T12:00:00'
        END
    WHERE Admission_ID IN (1, 2, 3)
      AND Nurse_Assignment_End IS NULL;

    IF @@ROWCOUNT <> 3
        THROW 50002, 'Nurse assignment update failed.', 1;

    -- Step 3: Set Admission Discharge Dates
    UPDATE dbo.Admission
    SET Admission_Discharge_Date =
        CASE Admission_ID
            WHEN 1 THEN '2026-10-18T12:00:00'
            WHEN 2 THEN '2026-10-19T12:00:00'
            WHEN 3 THEN '2026-10-20T12:00:00'
        END
    WHERE Admission_ID IN (1, 2, 3)
      AND Admission_Discharge_Date IS NULL;

    IF @@ROWCOUNT <> 3
        THROW 50003, 'Admission update failed.', 1;

    COMMIT TRANSACTION;

    PRINT 'All updates completed successfully.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
GO
