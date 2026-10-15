USE [Hospital_Management_System];
GO

CREATE OR ALTER TRIGGER dbo.TR_BedAssignment_AdmissionDates
ON dbo.Bed_Assignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.Admission AS a WITH (UPDLOCK, HOLDLOCK)
            ON a.Admission_ID = i.Admission_ID
        WHERE
            i.Assigned_From < a.Admission_Date
            OR
            (
                a.Discharge_Date IS NOT NULL
                AND
                (
                    i.Assigned_To IS NULL
                    OR i.Assigned_To > a.Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50003,
            'Bed assignment must be within the admission period.',
            1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_Admission_BedAssignmentDates
ON dbo.Admission
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS a
        INNER JOIN dbo.Bed_Assignment AS b WITH (UPDLOCK, HOLDLOCK)
            ON b.Admission_ID = a.Admission_ID
        WHERE
            b.Assigned_From < a.Admission_Date
            OR
            (
                a.Discharge_Date IS NOT NULL
                AND
                (
                    b.Assigned_To IS NULL
                    OR b.Assigned_To > a.Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50004,
            'Admission dates conflict with existing bed assignments.',
            1;
    END;
END;
GO

SELECT name AS Trigger_Name, is_disabled AS Is_Disabled
FROM sys.triggers
WHERE name IN
(
    N'TR_BedAssignment_AdmissionDates',
    N'TR_Admission_BedAssignmentDates'
);