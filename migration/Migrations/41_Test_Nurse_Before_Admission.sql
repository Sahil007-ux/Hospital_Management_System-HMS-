USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50150, 'Use a session without an open transaction.', 1;

DECLARE @TestID INT = -410001;
DECLARE @HospitalID INT;
DECLARE @PatientID INT;
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
        SELECT 1 FROM dbo.Employee WITH (UPDLOCK, HOLDLOCK)
        WHERE Employee_ID = @TestID
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Nurse WITH (UPDLOCK, HOLDLOCK)
        WHERE Nurse_ID = @TestID
    )
    OR EXISTS
    (
        SELECT 1 FROM dbo.Admission WITH (UPDLOCK, HOLDLOCK)
        WHERE Admission_ID = @TestID
    )
        THROW 50151, 'Test identifiers already exist.', 1;

    INSERT INTO dbo.Hospital
        (Hospital_Name, Hospital_License_Number)
    VALUES
        (N'Test Hospital', CONVERT(VARCHAR(36), NEWID()));

    SET @HospitalID = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Department
        (Department_ID, Department_Name, Hospital_ID)
    VALUES
        (@TestID, 'Test Department', @HospitalID);

    INSERT INTO dbo.Employee
        (Employee_ID, Employee_Name, Employee_Salary)
    VALUES
        (@TestID, N'Test Nurse', 20000);

    INSERT INTO dbo.Nurse
    (
        Nurse_ID,
        Employee_ID,
        Nurse_Qualification,
        Nurse_Shift,
        Department_ID
    )
    VALUES
    (
        @TestID,
        @TestID,
        N'Diploma',
        N'Day',
        @TestID
    );

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES
        ('TEST', 'NurseDates');

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
        @TestID,
        @PatientID,
        '2026-10-15T08:00:00',
        '2026-10-15T18:00:00',
        N'Test admission'
    );

    SET @TestingDates = 1;

    -- Must fail: nurse assignment starts before admission.
    INSERT INTO dbo.Nurse_Assignment
    (
        Nurse_ID,
        Admission_ID,
        Nurse_Assignment_Start,
        Nurse_Assignment_End
    )
    VALUES
    (
        @TestID,
        @TestID,
        '2026-10-15T07:00:00',
        '2026-10-15T10:00:00'
    );

    THROW 50152,
        'FAIL: Nurse assignment before admission was accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingDates = 1 AND @ErrorNumber = 50005
    BEGIN
        SELECT
            'PASS: Nurse assignment before admission rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Trigger_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;