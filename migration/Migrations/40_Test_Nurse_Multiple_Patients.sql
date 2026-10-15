USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50140, 'Use a session without an open transaction.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @TestID INT = -400001;
    DECLARE @AdmissionB INT = -400002;
    DECLARE @HospitalID INT;
    DECLARE @PatientA INT;
    DECLARE @PatientB INT;

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
        WHERE Admission_ID IN (@TestID, @AdmissionB)
    )
        THROW 50141, 'Test identifiers already exist.', 1;

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
    (
        Employee_ID,
        Employee_Name,
        Employee_Salary
    )
    VALUES
    (
        @TestID,
        N'Test Nurse',
        20000
    );

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
    VALUES ('TEST', 'NursePatientA');

    SET @PatientA = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES ('TEST', 'NursePatientB');

    SET @PatientB = CONVERT(INT, SCOPE_IDENTITY());

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

    -- The same nurse cares for two patients from 09:00 to 12:00.
    INSERT INTO dbo.Nurse_Assignment
    (
        Nurse_ID,
        Admission_ID,
        Nurse_Assignment_Start,
        Nurse_Assignment_End
    )
    VALUES
    (
        @TestID, @TestID,
        '2026-10-15T09:00:00',
        '2026-10-15T12:00:00'
    ),
    (
        @TestID, @AdmissionB,
        '2026-10-15T09:00:00',
        '2026-10-15T12:00:00'
    );

    IF
    (
        SELECT COUNT(*)
        FROM dbo.Nurse_Assignment
        WHERE Nurse_ID = @TestID
          AND Admission_ID IN (@TestID, @AdmissionB)
    ) <> 2
        THROW 50142, 'FAIL: Expected two nurse assignments.', 1;

    SELECT
        Nurse_ID,
        Admission_ID,
        Nurse_Assignment_Start,
        Nurse_Assignment_End
    FROM dbo.Nurse_Assignment
    WHERE Nurse_ID = @TestID
      AND Admission_ID IN (@TestID, @AdmissionB);

    ROLLBACK TRANSACTION;

    SELECT
        'PASS: One nurse assigned to two patients; test rows rolled back.'
            AS Test_Result;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;