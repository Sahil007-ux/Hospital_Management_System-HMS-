USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50240, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Prescription)
       OR EXISTS (SELECT 1 FROM dbo.Prescription_Item)
        THROW 50241, 'Prescriptions already exist.', 1;

    IF NOT EXISTS
    (
        SELECT 1
        FROM dbo.Medical_Record
        WHERE Medical_Record_ID = 2
    )
        THROW 50242, 'Required medical record is missing.', 1;

    DECLARE @Medicine_ID INT;

    SELECT @Medicine_ID = Medicine_ID
    FROM dbo.Medicine
    WHERE Medicine_Code = 'PARA-500-TAB'
      AND Medicine_Is_Active = 1;

    IF @Medicine_ID IS NULL
        THROW 50243, 'Required active medicine is missing.', 1;

    INSERT INTO dbo.Prescription
    (
        Medical_Record_ID,
        Prescription_Date,
        Prescription_Notes
    )
    VALUES
    (
        2,
        '2026-10-15T11:00:00',
        N'Synthetic prescription for database demonstration only'
    );

    DECLARE @Prescription_ID INT =
        CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Prescription_Item
    (
        Prescription_ID,
        Medicine_ID,
        Prescription_Item_Dose,
        Prescription_Item_Route,
        Prescription_Item_Frequency,
        Prescription_Item_Duration_Days,
        Prescription_Item_Quantity,
        Prescription_Item_Quantity_Unit,
        Prescription_Item_Instructions
    )
    VALUES
    (
        @Prescription_ID,
        @Medicine_ID,
        N'1 tablet',
        N'Oral',
        N'Every 8 hours',
        2,
        6,
        N'Tablet',
        N'Training data only; not for clinical use'
    );

    COMMIT TRANSACTION;

    SELECT
        pr.Prescription_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        e.Employee_Name AS Doctor_Name,
        m.Medicine_Name,
        m.Medicine_Strength,
        pi.Prescription_Item_Dose,
        pi.Prescription_Item_Route,
        pi.Prescription_Item_Frequency,
        pi.Prescription_Item_Duration_Days,
        pi.Prescription_Item_Quantity,
        pi.Prescription_Item_Quantity_Unit
    FROM dbo.Prescription AS pr
    JOIN dbo.Medical_Record AS mr
        ON mr.Medical_Record_ID = pr.Medical_Record_ID
    JOIN dbo.Patient AS p
        ON p.Patient_ID = mr.Patient_ID
    JOIN dbo.Doctor AS d
        ON d.Doctor_ID = mr.Doctor_ID
    JOIN dbo.Employee AS e
        ON e.Employee_ID = d.Employee_ID
    JOIN dbo.Prescription_Item AS pi
        ON pi.Prescription_ID = pr.Prescription_ID
    JOIN dbo.Medicine AS m
        ON m.Medicine_ID = pi.Medicine_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;