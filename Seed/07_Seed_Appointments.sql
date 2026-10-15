USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50160, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Appointment)
        THROW 50161, 'Appointments already exist.', 1;

    DECLARE @Visits TABLE
    (
        Appointment_ID INT,
        First_Name VARCHAR(50),
        Last_Name VARCHAR(50),
        Doctor_ID INT,
        Visit_Time TIME(0),
        Reason VARCHAR(300)
    );

    INSERT INTO @Visits
    VALUES
        (1, 'Mariam', 'Noori', 2, '09:00',
         'General medical consultation'),

        (2, 'Abdul Basir', 'Karimi', 2, '09:30',
         'Routine follow-up consultation'),

        (3, 'Sahar', 'Ahmadi', 1, '10:00',
         'Follow-up after emergency assessment');

    IF EXISTS
    (
        SELECT 1
        FROM @Visits AS v
        WHERE (
            SELECT COUNT(*)
            FROM dbo.Patient AS p
            WHERE p.Patient_First_Name = v.First_Name
              AND p.Patient_Last_Name = v.Last_Name
        ) <> 1
        OR NOT EXISTS
        (
            SELECT 1
            FROM dbo.Doctor AS d
            WHERE d.Doctor_ID = v.Doctor_ID
        )
    )
        THROW 50162, 'Required patient or doctor is missing or duplicated.', 1;

    INSERT INTO dbo.Appointment
    (
        Appointment_ID,
        Patient_ID,
        Doctor_ID,
        Appointment_Date,
        Appointment_Time,
        Appointment_Reason,
        Appointment_Status
    )
    SELECT
        v.Appointment_ID,
        p.Patient_ID,
        v.Doctor_ID,
        '20261016',
        v.Visit_Time,
        v.Reason,
        'Scheduled'
    FROM @Visits AS v
    JOIN dbo.Patient AS p
        ON p.Patient_First_Name = v.First_Name
       AND p.Patient_Last_Name = v.Last_Name;

    COMMIT TRANSACTION;

    SELECT
        a.Appointment_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        e.Employee_Name AS Doctor_Name,
        a.Appointment_Date,
        a.Appointment_Time,
        a.Appointment_Status
    FROM dbo.Appointment AS a
    JOIN dbo.Patient AS p
        ON p.Patient_ID = a.Patient_ID
    JOIN dbo.Doctor AS d
        ON d.Doctor_ID = a.Doctor_ID
    JOIN dbo.Employee AS e
        ON e.Employee_ID = d.Employee_ID
    ORDER BY a.Appointment_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;