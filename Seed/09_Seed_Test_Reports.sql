USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50180, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Test_Report)
        THROW 50181, 'Test reports already exist.', 1;

    IF (
        SELECT COUNT(*)
        FROM dbo.Medical_Record
        WHERE Medical_Record_ID IN (1, 2, 3)
    ) <> 3
        THROW 50182, 'Complete seed 08 first.', 1;

    DECLARE @Tests TABLE
    (
        Report_ID INT,
        Record_ID INT,
        Test_Type NVARCHAR(100),
        Result NVARCHAR(1000)
    );

    INSERT INTO @Tests
    VALUES
        (1, 1, N'Complete Blood Count',
         N'WBC: 8.2 x10^9/L; Hemoglobin: 14.1 g/dL; Platelets: 250 x10^9/L'),

        (2, 2, N'Complete Blood Count',
         N'WBC: 11.5 x10^9/L; Hemoglobin: 12.8 g/dL; Platelets: 280 x10^9/L'),

        (3, 3, N'Abdominal Ultrasound',
         N'No free abdominal fluid identified; further clinical evaluation advised');

    INSERT INTO dbo.Test_Report
    (
        Test_Report_ID,
        Patient_ID,
        Doctor_ID,
        Test_Report_Date,
        Test_Report_Type,
        Test_Report_Result
    )
    SELECT
        t.Report_ID,
        mr.Patient_ID,
        mr.Doctor_ID,
        mr.Medical_Record_Date,
        t.Test_Type,
        t.Result
    FROM @Tests AS t
    JOIN dbo.Medical_Record AS mr
        ON mr.Medical_Record_ID = t.Record_ID;

    COMMIT TRANSACTION;

    SELECT
        tr.Test_Report_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        e.Employee_Name AS Doctor_Name,
        tr.Test_Report_Date,
        tr.Test_Report_Type,
        tr.Test_Report_Result
    FROM dbo.Test_Report AS tr
    JOIN dbo.Patient AS p
        ON p.Patient_ID = tr.Patient_ID
    JOIN dbo.Doctor AS d
        ON d.Doctor_ID = tr.Doctor_ID
    JOIN dbo.Employee AS e
        ON e.Employee_ID = d.Employee_ID
    ORDER BY tr.Test_Report_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;