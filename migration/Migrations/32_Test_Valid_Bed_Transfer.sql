USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50050, 'Use a session without an open transaction.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @HospitalID INT;
    DECLARE @PatientID INT;
    DECLARE @BedA INT;
    DECLARE @BedB INT;
    DECLARE @AssignmentA INT;
    DECLARE @AssignmentB INT;

    DECLARE @DepartmentID INT = -320001;
    DECLARE @RoomID INT = -320001;
    DECLARE @AdmissionID INT = -320001;

    IF EXISTS
    (
        SELECT 1 FROM dbo.Department WITH (UPDLOCK, HOLDLOCK)
        WHERE Department_ID = @DepartmentID
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Rooms WITH (UPDLOCK, HOLDLOCK)
        WHERE Room_ID = @RoomID OR Room_Number = 'TEST32'
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Admission WITH (UPDLOCK, HOLDLOCK)
        WHERE Admission_ID = @AdmissionID
    )
        THROW 50051, 'Test identifiers already exist.', 1;

    INSERT INTO dbo.Hospital
        (Hospital_Name, Hospital_License_Number)
    VALUES
        (N'Test Hospital', CONVERT(VARCHAR(36), NEWID()));

    SET @HospitalID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Department
        (Department_ID, Department_Name, Hospital_ID)
    VALUES
        (@DepartmentID, 'Test Department', @HospitalID);

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
    (
        @RoomID, 'TEST32', 1, 500,
        N'General', N'Available', 2, @DepartmentID
    );

    INSERT INTO dbo.Bed (Room_ID, Bed_Number)
    VALUES (@RoomID, N'A');

    SET @BedA = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Bed (Room_ID, Bed_Number)
    VALUES (@RoomID, N'B');

    SET @BedB = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES
        ('TEST', 'BedTransfer');

    SET @PatientID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Admission
    (
        Admission_ID,
        Patient_ID,
        Admission_Date,
        Admission_Discharge_Date,
        Admission_Reason
    )
    VALUES
    (
        @AdmissionID,
        @PatientID,
        '2026-10-15T08:00:00',
        NULL,
        N'Test admission'
    );

    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID,
        Bed_ID,
        Bed_Assignment_Start,
        Bed_Assignment_End
    )
    VALUES
    (
        @AdmissionID, @BedA,
        '2026-10-15T08:00:00', NULL
    );

    SET @AssignmentA = CONVERT(INT, SCOPE_IDENTITY());

    -- Close the first assignment before transferring.
    UPDATE dbo.Bed_Assignment
    SET Bed_Assignment_End = '2026-10-15T12:00:00'
    WHERE Bed_Assignment_ID = @AssignmentA;

    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID,
        Bed_ID,
        Bed_Assignment_Start,
        Bed_Assignment_End
    )
    VALUES
    (
        @AdmissionID, @BedB,
        '2026-10-15T12:00:00', NULL
    );

    SET @AssignmentB = CONVERT(INT, SCOPE_IDENTITY());

    -- Close the second assignment before discharge.
    UPDATE dbo.Bed_Assignment
    SET Bed_Assignment_End = '2026-10-15T16:00:00'
    WHERE Bed_Assignment_ID = @AssignmentB;

    UPDATE dbo.Admission
    SET Admission_Discharge_Date = '2026-10-15T16:00:00'
    WHERE Admission_ID = @AdmissionID;

    IF
    (
        SELECT COUNT(*)
        FROM dbo.Bed_Assignment
        WHERE Admission_ID = @AdmissionID
    ) <> 2
        THROW 50052, 'FAIL: Expected two assignments.', 1;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Bed_Assignment
        WHERE Admission_ID = @AdmissionID
          AND Bed_Assignment_End IS NULL
    )
        THROW 50053, 'FAIL: An assignment is still open.', 1;

    SELECT
        b.Bed_Number,
        a.Bed_Assignment_Start,
        a.Bed_Assignment_End
    FROM dbo.Bed_Assignment AS a
    INNER JOIN dbo.Bed AS b
        ON b.Bed_ID = a.Bed_ID
    WHERE a.Admission_ID = @AdmissionID
    ORDER BY a.Bed_Assignment_Start;

    ROLLBACK TRANSACTION;

    SELECT
        'PASS: Transfer and discharge accepted; test rows rolled back.'
            AS Test_Result;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;