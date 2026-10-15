USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50150, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Nurse_Assignment)
        THROW 50151, 'Nurse assignments already exist.', 1;

    DECLARE @Assignments TABLE
    (
        Admission_ID INT,
        Nurse_ID INT,
        Start_Time DATETIME2(0)
    );

    INSERT INTO @Assignments
    VALUES
        (1, 1, '2026-10-15T08:00:00'),
        (2, 2, '2026-10-15T09:00:00'),
        (3, 3, '2026-10-15T20:00:00');

    IF EXISTS
    (
        SELECT 1
        FROM @Assignments AS x
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM dbo.Admission AS a
            WHERE a.Admission_ID = x.Admission_ID
        )
        OR NOT EXISTS
        (
            SELECT 1
            FROM dbo.Nurse AS n
            WHERE n.Nurse_ID = x.Nurse_ID
        )
    )
        THROW 50152, 'Required admission or nurse is missing.', 1;

    INSERT INTO dbo.Nurse_Assignment
    (
        Nurse_ID,
        Admission_ID,
        Nurse_Assignment_Start,
        Nurse_Assignment_End
    )
    SELECT
        Nurse_ID,
        Admission_ID,
        Start_Time,
        NULL
    FROM @Assignments;

    COMMIT TRANSACTION;

    SELECT
        na.Admission_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        e.Employee_Name AS Nurse_Name,
        n.Nurse_Shift,
        na.Nurse_Assignment_Start,
        na.Nurse_Assignment_End
    FROM dbo.Nurse_Assignment AS na
    JOIN dbo.Nurse AS n
        ON n.Nurse_ID = na.Nurse_ID
    JOIN dbo.Employee AS e
        ON e.Employee_ID = n.Employee_ID
    JOIN dbo.Admission AS a
        ON a.Admission_ID = na.Admission_ID
    JOIN dbo.Patient AS p
        ON p.Patient_ID = a.Patient_ID
    ORDER BY na.Admission_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;