USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50110, 'Use a session without an open transaction.', 1;

DECLARE @HospitalID INT;
DECLARE @PatientID INT;
DECLARE @BedID INT;
DECLARE @TestID INT = -370001;
DECLARE @TestingDates BIT = 0;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1 FROM dbo.Department WITH (UPDLOCK, HOLDLOCK)
        WHERE Department_ID = @TestID
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Rooms WITH (UPDLOCK, HOLDLOCK)
        WHERE Room_ID = @TestID OR Room_Number = 'TEST37'
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Admission WITH (UPDLOCK, HOLDLOCK)
        WHERE Admission_ID = @TestID
    )
        THROW 50111, 'Test identifiers already exist.', 1;

    INSERT INTO dbo.Hospital
        (Hospital_Name, Hospital_License_Number)
    VALUES
        (N'Test Hospital', CONVERT(VARCHAR(36), NEWID()));

    SET @HospitalID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Department
        (Department_ID, Department_Name, Hospital_ID)
    VALUES
        (@TestID, 'Test Department', @HospitalID);

    INSERT INTO dbo.Rooms
    (
        Room_ID, Room_Number, Room_Floor_Number,
        Room_Daily_Charge, Room_Type,
        Room_Availability_Status, Room_Capacity,
        Department_ID
    )
    VALUES
    (
        @TestID, 'TEST37', 1, 500,
        N'General', N'Available', 1, @TestID
    );

    INSERT INTO dbo.Bed
        (Room_ID, Bed_Number, Bed_Is_Active)
    VALUES
        (@TestID, N'A', 1);

    SET @BedID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES
        ('TEST', 'AdmissionDates');

    SET @PatientID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Admission
    (
        Admission_ID, Patient_ID,
        Admission_Date, Admission_Discharge_Date,
        Admission_Reason
    )
    VALUES
    (
        @TestID, @PatientID,
        '2026-10-15T08:00:00',
        '2026-10-15T18:00:00',
        N'Test admission'
    );

    SET @TestingDates = 1;

    -- Must fail: assignment starts before admission.
    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID, Bed_ID,
        Bed_Assignment_Start, Bed_Assignment_End
    )
    VALUES
    (
        @TestID, @BedID,
        '2026-10-15T07:00:00',
        '2026-10-15T10:00:00'
    );

    THROW 50112,
        'FAIL: Assignment before admission was accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingDates = 1 AND @ErrorNumber = 50003
    BEGIN
        SELECT
            'PASS: Assignment before admission rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Trigger_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;