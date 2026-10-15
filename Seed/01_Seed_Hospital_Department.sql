USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50100, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Rooms)
        THROW 50101, 'Rooms already exist. Stop and review.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Hospital
        WHERE Hospital_License_Number <> 'DEMO-HMS-001'
    )
        THROW 50102, 'Unexpected hospital data exists.', 1;

    DELETE d
    FROM dbo.Department AS d
    JOIN dbo.Hospital AS h
        ON h.Hospital_ID = d.Hospital_ID
    WHERE h.Hospital_License_Number = 'DEMO-HMS-001';

    DELETE FROM dbo.Hospital
    WHERE Hospital_License_Number = 'DEMO-HMS-001';

    -- Public hospital details; license and departments are demo data.
    INSERT INTO dbo.Hospital
    (
        Hospital_Name,
        Hospital_Type,
        Hospital_Bed_Capacity,
        Hospital_Contact_Number,
        Hospital_Email,
        Hospital_Address,
        Hospital_License_Number
    )
    VALUES
    (
        N'French Medical Institute for Mothers and Children',
        N'General',
        NULL,
        '+93791070000',
        'information@fmic.org.af',
        N'Kabul University Road, Aliabad, Kabul, Afghanistan',
        'DEMO-FMIC-001'
    );

    DECLARE @Hospital_ID INT =
        CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Department
    (
        Department_ID,
        Department_Name,
        Department_Location,
        Hospital_ID
    )
    VALUES
        (1, 'Emergency',         'Ground Floor', @Hospital_ID),
        (2, 'Internal Medicine', 'First Floor',  @Hospital_ID),
        (3, 'Surgery',           'Second Floor', @Hospital_ID);

    COMMIT TRANSACTION;

    SELECT * FROM dbo.Hospital;
    SELECT * FROM dbo.Department ORDER BY Department_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;