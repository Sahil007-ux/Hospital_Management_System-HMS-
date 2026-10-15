USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50230, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Medicine)
        THROW 50231, 'Medicines already exist.', 1;

    INSERT INTO dbo.Medicine
    (
        Medicine_Code,
        Medicine_Name,
        Medicine_Strength,
        Medicine_Form,
        Medicine_Is_Active
    )
    VALUES
        ('PARA-500-TAB', N'Paracetamol',
         N'500 mg', N'Tablet', 1),

        ('PARA-120-SUS', N'Paracetamol',
         N'120 mg/5 mL', N'Oral Suspension', 1),

        ('AMOX-500-CAP', N'Amoxicillin',
         N'500 mg', N'Capsule', 1),

        ('OMEP-20-CAP', N'Omeprazole',
         N'20 mg', N'Capsule', 1),

        ('CET-10-TAB', N'Cetirizine',
         N'10 mg', N'Tablet', 1);

    COMMIT TRANSACTION;

    SELECT
        Medicine_ID,
        Medicine_Code,
        Medicine_Name,
        Medicine_Strength,
        Medicine_Form,
        Medicine_Is_Active
    FROM dbo.Medicine
    ORDER BY Medicine_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;