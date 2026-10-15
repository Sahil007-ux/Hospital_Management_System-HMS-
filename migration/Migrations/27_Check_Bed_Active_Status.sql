USE [Hospital_Management_System];
GO

CREATE OR ALTER TRIGGER dbo.TR_BedAssignment_ActiveBed
ON dbo.Bed_Assignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM inserted)
        RETURN;

    -- Check new assignments, bed changes and reopened assignments.
    IF EXISTS
    (
        SELECT 1
        FROM inserted AS i
        LEFT JOIN deleted AS d
            ON d.Bed_Assignment_ID = i.Bed_Assignment_ID
        INNER JOIN dbo.Bed AS b WITH (UPDLOCK, HOLDLOCK)
            ON b.Bed_ID = i.Bed_ID
        WHERE b.Bed_Is_Active = 0
          AND
          (
              d.Bed_Assignment_ID IS NULL
              OR i.Bed_ID <> d.Bed_ID
              OR
              (
                  d.Bed_Assignment_End IS NOT NULL
                  AND i.Bed_Assignment_End IS NULL
              )
          )
    )
    BEGIN
        THROW 50014,
            'An inactive bed cannot receive a new or reopened assignment.',
            1;
    END;
END;
GO

CREATE OR ALTER TRIGGER dbo.TR_Bed_PreventDeactivateAssigned
ON dbo.Bed
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT UPDATE(Bed_Is_Active)
        RETURN;

    IF EXISTS
    (
        SELECT 1
        FROM inserted AS b
        INNER JOIN dbo.Bed_Assignment AS a
            WITH (READCOMMITTEDLOCK)
            ON a.Bed_ID = b.Bed_ID
        WHERE b.Bed_Is_Active = 0
          AND a.Bed_Assignment_End IS NULL
    )
    BEGIN
        THROW 50015,
            'Close the open assignment before deactivating the bed.',
            1;
    END;
END;
GO

SELECT
    name AS Trigger_Name,
    is_disabled AS Is_Disabled
FROM sys.triggers
WHERE name IN
(
    N'TR_BedAssignment_ActiveBed',
    N'TR_Bed_PreventDeactivateAssigned'
)
AND parent_id IN
(
    OBJECT_ID(N'dbo.Bed'),
    OBJECT_ID(N'dbo.Bed_Assignment')
);