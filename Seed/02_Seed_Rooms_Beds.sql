USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50110, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Rooms)
       OR EXISTS (SELECT 1 FROM dbo.Bed)
        THROW 50111, 'Rooms or Bed already contains data.', 1;

    IF (
        SELECT COUNT(*)
        FROM dbo.Department AS d
        JOIN dbo.Hospital AS h
            ON h.Hospital_ID = d.Hospital_ID
        WHERE h.Hospital_License_Number = 'DEMO-FMIC-001'
          AND d.Department_ID IN (1, 2, 3)
    ) <> 3
        THROW 50112, 'Complete FMIC seed 01 first.', 1;

    INSERT INTO dbo.Rooms
    (
        Room_ID,
        Room_Number,
        Room_Floor_Number,
        Room_Daily_Charge,
        Room_Type,
        Room_Availability_Status,
        Room_Capacity,
        Department_ID
    )
    VALUES
        (1, 'ER-01', 0, 1000, N'General', N'Available', 2, 1),
        (2, 'IM-01', 1, 1500, N'General', N'Available', 2, 2),
        (3, 'SU-01', 2, 2000, N'General', N'Available', 2, 3);

    INSERT INTO dbo.Bed
        (Room_ID, Bed_Number, Bed_Is_Active)
    VALUES
        (1, N'B-01', 1),
        (1, N'B-02', 1),
        (2, N'B-01', 1),
        (2, N'B-02', 1),
        (3, N'B-01', 1),
        (3, N'B-02', 1);

    COMMIT TRANSACTION;

    SELECT * FROM dbo.Rooms ORDER BY Room_ID;

    SELECT * FROM dbo.Bed
    ORDER BY Room_ID, Bed_Number;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;