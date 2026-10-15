USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50170, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Medical_Record)
        THROW 50171, 'Medical records already exist.', 1;

    DECLARE @Records TABLE
    (
        Record_ID INT,
        Admission_ID INT,
        Doctor_ID INT,
        Diagnoses NVARCHAR(500),
        Treatment NVARCHAR(1000),
        Notes NVARCHAR(1000)
    );

    INSERT INTO @Records
    VALUES
        (1, 1, 1,
         N'Abdominal pain under evaluation',
         N'Inpatient observation and diagnostic evaluation',
         N'Initial assessment completed'),

        (2, 2, 2,
         N'Fever under evaluation',
         N'Inpatient monitoring and laboratory evaluation',
         N'Further assessment pending'),

        (3, 3, 3,
         N'Abdominal symptoms requiring surgical evaluation',
         N'Surgical consultation and diagnostic evaluation',
         N'No procedure recorded at this stage');

    IF EXISTS
    (
        SELECT 1
        FROM @Records AS r
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.Admission AS a
            WHERE a.Admission_ID = r.Admission_ID
        )
        OR NOT EXISTS
        (
            SELECT 1
            FROM dbo.Doctor AS d
            WHERE d.Doctor_ID = r.Doctor_ID
        )
    )
        THROW 50172, 'Required admission or doctor is missing.', 1;

    INSERT INTO dbo.Medical_Record
    (
        Medical_Record_ID,
        Patient_ID,
        Doctor_ID,
        Medical_Record_Date,
        Medical_Record_Diagnoses,
        Medical_Record_Treatment,
        Medical_Record_Notes
    )
    SELECT
        r.Record_ID,
        a.Patient_ID,
        r.Doctor_ID,
        CONVERT(DATE, a.Admission_Date),
        r.Diagnoses,
        r.Treatment,
        r.Notes
    FROM @Records AS r
    JOIN dbo.Admission AS a
        ON a.Admission_ID = r.Admission_ID;

    COMMIT TRANSACTION;

    SELECT
        mr.Medical_Record_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        e.Employee_Name AS Doctor_Name,
        mr.Medical_Record_Date,
        mr.Medical_Record_Diagnoses,
        mr.Medical_Record_Treatment
    FROM dbo.Medical_Record AS mr
    JOIN dbo.Patient AS p
        ON p.Patient_ID = mr.Patient_ID
    JOIN dbo.Doctor AS d
        ON d.Doctor_ID = mr.Doctor_ID
    JOIN dbo.Employee AS e
        ON e.Employee_ID = d.Employee_ID
    ORDER BY mr.Medical_Record_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;