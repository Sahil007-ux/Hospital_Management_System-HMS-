USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50190, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Service)
        THROW 50191, 'Services already exist.', 1;

    INSERT INTO dbo.Service
    (
        Service_Code,
        Service_Name,
        Service_Default_Price,
        Service_Is_Active
    )
    VALUES
        ('CONS-GEN', N'General Consultation',       500, 1),
        ('CONS-SUR', N'Surgical Consultation',     1000, 1),
        ('LAB-CBC',  N'Complete Blood Count',       400, 1),
        ('IMG-US',   N'Abdominal Ultrasound',       800, 1),
        ('BED-ER',   N'Emergency Room Daily Stay', 1000, 1),
        ('BED-IM',   N'Internal Medicine Daily Stay', 1500, 1),
        ('BED-SU',   N'Surgery Room Daily Stay',   2000, 1);

    COMMIT TRANSACTION;

    SELECT
        Service_ID,
        Service_Code,
        Service_Name,
        Service_Default_Price,
        'AFN' AS Currency,
        Service_Is_Active
    FROM dbo.Service
    ORDER BY Service_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;