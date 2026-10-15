USE [Hospital_Management_System];
GO

CREATE OR ALTER TRIGGER dbo.TR_BedAssignment_NoOverlap
ON dbo.Bed_Assignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Serialize checks, including concurrent transactions.
    DECLARE @RowCount BIGINT;

    SELECT @RowCount = COUNT_BIG(*)
    FROM dbo.Bed_Assignment WITH (TABLOCKX, HOLDLOCK);

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        INNER JOIN dbo.Bed_Assignment AS b
            ON b.Bed_Assignment_ID <> i.Bed_Assignment_ID
           AND (
                b.Bed_ID = i.Bed_ID
                OR b.Admission_ID = i.Admission_ID
           )
        WHERE
            (
                b.Assigned_To IS NULL
                OR i.Assigned_From < b.Assigned_To
            )
            AND
            (
                i.Assigned_To IS NULL
                OR b.Assigned_From < i.Assigned_To
            )
    )
    BEGIN
        THROW 50002,
            'Overlapping bed or admission assignment is not allowed.',
            1;
    END;
END;
GO

SELECT
    name AS Trigger_Name,
    is_disabled AS Is_Disabled
FROM sys.triggers
WHERE object_id =
    OBJECT_ID(N'dbo.TR_BedAssignment_NoOverlap');