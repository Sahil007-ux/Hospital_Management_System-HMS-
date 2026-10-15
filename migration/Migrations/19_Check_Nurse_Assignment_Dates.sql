USE [Hospital_Management_System];
GO

CREATE OR ALTER TRIGGER dbo.TR_NurseAssignment_AdmissionDates
ON dbo.Nurse_Assignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS n
        INNER JOIN dbo.Admission AS a WITH (UPDLOCK, HOLDLOCK)
            ON a.Admission_ID = n.Admission_ID
        WHERE
            n.Assigned_From < a.Admission_Date
            OR
            (
                a.Discharge_Date IS NOT NULL
                AND
                (
                    n.Assigned_To IS NULL
                    OR n.Assigned_To > a.Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50005,
            'Nurse assignment must be within the admission period.',
            1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_Admission_NurseAssignmentDates
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
        INNER JOIN dbo.Nurse_Assignment AS n WITH (UPDLOCK, HOLDLOCK)
            ON n.Admission_ID = a.Admission_ID
        WHERE
            n.Assigned_From < a.Admission_Date
            OR
            (
                a.Discharge_Date IS NOT NULL
                AND
                (
                    n.Assigned_To IS NULL
                    OR n.Assigned_To > a.Discharge_Date
                )
            )
    )
    BEGIN
        THROW 50006,
            'Admission dates conflict with existing nurse assignments.',
            1;
    END;
END;
GO

SELECT name AS Trigger_Name, is_disabled AS Is_Disabled
FROM sys.triggers
WHERE name IN
(
    N'TR_NurseAssignment_AdmissionDates',
    N'TR_Admission_NurseAssignmentDates'
);