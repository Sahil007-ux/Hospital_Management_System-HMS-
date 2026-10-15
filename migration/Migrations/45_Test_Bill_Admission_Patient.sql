USE [Hospital_Management_System];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50180, 'Use a session without an open transaction.', 1;

DECLARE @PatientA INT;
DECLARE @PatientB INT;
DECLARE @AdmissionID INT = -450001;
DECLARE @TestingMismatch BIT = 0;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Admission WITH (UPDLOCK, HOLDLOCK)
        WHERE Admission_ID = @AdmissionID
    )
    OR EXISTS
    (
        SELECT 1
        FROM dbo.Bills WITH (UPDLOCK, HOLDLOCK)
        WHERE Bill_ID IN (-450001, -450002, -450003)
    )
        THROW 50181, 'Test identifiers already exist.', 1;

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES
        ('TEST', 'BillPatientA');

    SET @PatientA = CONVERT(INT, SCOPE_IDENTITY());

    INSERT INTO dbo.Patient
        (Patient_First_Name, Patient_Last_Name)
    VALUES
        ('TEST', 'BillPatientB');

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
        @AdmissionID,
        @PatientA,
        '2026-10-15T08:00:00',
        '2026-10-15T18:00:00',
        N'Test admission for patient A'
    );

    -- Valid: patient A with patient A's admission.
    INSERT INTO dbo.Bills
        (Bill_ID, Patient_ID, Admission_ID, Bill_Date)
    VALUES
        (-450001, @PatientA, @AdmissionID, '2026-10-15');

    -- Valid: outpatient bill without an admission.
    INSERT INTO dbo.Bills
        (Bill_ID, Patient_ID, Admission_ID, Bill_Date)
    VALUES
        (-450002, @PatientB, NULL, '2026-10-15');

    IF
    (
        SELECT COUNT(*)
        FROM dbo.Bills
        WHERE Bill_ID IN (-450001, -450002)
    ) <> 2
        THROW 50182, 'FAIL: Valid bills were not created.', 1;

    SET @TestingMismatch = 1;

    -- Must fail: patient B with patient A's admission.
    INSERT INTO dbo.Bills
        (Bill_ID, Patient_ID, Admission_ID, Bill_Date)
    VALUES
        (-450003, @PatientB, @AdmissionID, '2026-10-15');

    THROW 50183,
        'FAIL: A bill with the wrong admission patient was accepted.',
        1;
END TRY
BEGIN CATCH
    DECLARE @ErrorNumber INT = ERROR_NUMBER();
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    IF @TestingMismatch = 1
       AND @ErrorNumber = 547
       AND CHARINDEX(
           N'FK_Bills_Admission_Patient',
           @ErrorMessage
       ) > 0
    BEGIN
        SELECT
            'PASS: Valid bills accepted; wrong patient rejected; test rows rolled back.'
                AS Test_Result,
            @ErrorNumber AS Expected_Error,
            @ErrorMessage AS Constraint_Message;
    END
    ELSE
    BEGIN
        THROW;
    END;
END CATCH;