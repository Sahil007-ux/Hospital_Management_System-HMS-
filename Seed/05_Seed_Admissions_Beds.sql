USE Hospital_Management_System;
GO

SET XACT_ABORT ON;
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;

IF @@TRANCOUNT <> 0
    THROW 50140, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Admission)
       OR EXISTS (SELECT 1 FROM dbo.Bed_Assignment)
        THROW 50141, 'Admission data already exists.', 1;

    DECLARE @Cases TABLE
    (
        Admission_ID INT,
        First_Name VARCHAR(50),
        Last_Name VARCHAR(50),
        Room_Number VARCHAR(10),
        Admission_Time DATETIME2(0),
        Reason NVARCHAR(500)
    );

    INSERT INTO @Cases
    VALUES
        (1, 'Ahmad Wali', 'Safi', 'ER-01',
         '2026-10-15T08:00:00', N'Observation after abdominal pain'),

        (2, 'Laila', 'Rahimi', 'IM-01',
         '2026-10-15T09:00:00', N'Fever requiring inpatient observation'),

        (3, 'Mohammad Nasir', 'Azizi', 'SU-01',
         '2026-10-15T10:00:00', N'Admission for surgical evaluation');

    -- Each case must match exactly one patient and one active bed.
    IF EXISTS
    (
        SELECT 1
        FROM @Cases AS c
        WHERE (
            SELECT COUNT(*)
            FROM dbo.Patient AS p
            WHERE p.Patient_First_Name = c.First_Name
              AND p.Patient_Last_Name = c.Last_Name
        ) <> 1
        OR (
            SELECT COUNT(*)
            FROM dbo.Bed AS b
            JOIN dbo.Rooms AS r ON r.Room_ID = b.Room_ID
            WHERE r.Room_Number = c.Room_Number
              AND b.Bed_Number = N'B-01'
              AND b.Bed_Is_Active = 1
        ) <> 1
    )
        THROW 50142, 'Required patient or active bed is missing or duplicated.', 1;

    INSERT INTO dbo.Admission
    (
        Admission_ID,
        Patient_ID,
        Admission_Date,
        Admission_Discharge_Date,
        Admission_Reason
    )
    SELECT
        c.Admission_ID,
        p.Patient_ID,
        c.Admission_Time,
        NULL,
        c.Reason
    FROM @Cases AS c
    JOIN dbo.Patient AS p
        ON p.Patient_First_Name = c.First_Name
       AND p.Patient_Last_Name = c.Last_Name;

    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID,
        Bed_ID,
        Bed_Assignment_Start,
        Bed_Assignment_End
    )
    SELECT
        c.Admission_ID,
        b.Bed_ID,
        c.Admission_Time,
        NULL
    FROM @Cases AS c
    JOIN dbo.Rooms AS r
        ON r.Room_Number = c.Room_Number
    JOIN dbo.Bed AS b
        ON b.Room_ID = r.Room_ID
       AND b.Bed_Number = N'B-01';

    UPDATE dbo.Rooms
    SET Room_Availability_Status = N'Partially Occupied'
    WHERE Room_Number IN ('ER-01', 'IM-01', 'SU-01');

    COMMIT TRANSACTION;

    SELECT
        a.Admission_ID,
        p.Patient_First_Name,
        p.Patient_Last_Name,
        r.Room_Number,
        b.Bed_Number,
        a.Admission_Date,
        a.Admission_Discharge_Date
    FROM dbo.Admission AS a
    JOIN dbo.Patient AS p ON p.Patient_ID = a.Patient_ID
    JOIN dbo.Bed_Assignment AS ba
        ON ba.Admission_ID = a.Admission_ID
    JOIN dbo.Bed AS b ON b.Bed_ID = ba.Bed_ID
    JOIN dbo.Rooms AS r ON r.Room_ID = b.Room_ID
    ORDER BY a.Admission_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;