USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50070, 'Use a session without an open transaction.', 1;

DECLARE @HospitalID INT;
DECLARE @PatientA INT;
DECLARE @PatientB INT;
DECLARE @BedID INT;
DECLARE @TestID INT = -340001;
DECLARE @AdmissionB INT = -340002;
DECLARE @TestingOverlap BIT = 0;

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
        WHERE Room_ID = @TestID OR Room_Number = 'TEST34'
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Admission WITH (UPDLOCK, HOLDLOCK)
        WHERE Admission_ID IN (@TestID, @AdmissionB)
    )
        THROW 50071, 'Test identifiers already exist.', 1;

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
        @TestID, 'TEST34', 1, 500,
        N'General', N'Available', 1, @TestID
    );

    INSERT INTO dbo.Bed (Room_ID, Bed_Number)
    VALUES (@TestID, N'A');

    SET @BedID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES ('TEST', 'PatientA');

    SET @PatientA = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES ('TEST', 'PatientB');

    SET @PatientB = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Admission
    (
        Admission_ID, Patient_ID,
        Admission_Date, Admission_Discharge_Date,
        Admission_Reason
    )
    VALUES
    (
        @TestID, @PatientA,
        '2026-10-15T08:00:00',
        '2026-10-15T18:00:00',
        N'Test admission A'
    ),
    (
        @AdmissionB, @PatientB,
        '2026-10-15T08:00:00',
        '2026-10-15T18:00:00',
        N'Test admission B'
    );

    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID, Bed_ID,
        Bed_Assignment_Start, Bed_Assignment_End
    )
    VALUES
    (
        @TestID, @BedID,
        '2026-10-15T08:00:00',
        '2026-10-15T12:00:00'
    );

    SET @TestingOverlap = 1;

    -- Must fail: bed A is assigned to patient A until 12.
    INSERT INTO dbo.Bed_Assignment
    (
        Admission_ID, Bed_ID,
        Bed_Assignment_Start, Bed_Assignment_End
    )
    VALUES
    (
        @AdmissionB, @BedID,
        '2026-10-15T10:00:00',
        '2026-10-15T14:00:00'
    );

    THROW 50072,
        'FAIL: Overlapping bed assignments were accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingOverlap = 1 AND @ErrorNumber = 50002
    BEGIN
        SELECT
            'PASS: Bed overlap rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Trigger_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;