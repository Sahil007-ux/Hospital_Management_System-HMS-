USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50130, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Patient)
        THROW 50131, 'Patient already contains data.', 1;

    INSERT INTO dbo.Patient
    (
        Patient_First_Name,
        Patient_Last_Name,
        Patient_Gender,
        Patient_Age,
        Patient_Date_Of_Birth,
        Patient_Phone,
        Patient_Address,
        Patient_Blood_Group
    )
    VALUES
        ('Ahmad Wali', 'Safi', 'Male', 35,
         '19910315', NULL, 'Khair Khana, Kabul', 'A+'),

        ('Laila', 'Rahimi', 'Female', 28,
         '19980722', NULL, 'Karte Se, Kabul', 'B+'),

        ('Mohammad Nasir', 'Azizi', 'Male', 42,
         '19840210', NULL, 'Ahmad Shah Baba Mina, Kabul', 'O+'),

        ('Mariam', 'Noori', 'Female', 19,
         '20070505', NULL, 'Dasht-e-Barchi, Kabul', 'AB+'),

        ('Abdul Basir', 'Karimi', 'Male', 60,
         '19660912', NULL, 'Aliabad, Kabul', 'O-'),

        ('Sahar', 'Ahmadi', 'Female', 10,
         '20160118', NULL, 'Shahr-e-Naw, Kabul', 'A-');

    COMMIT TRANSACTION;

    SELECT
        Patient_ID,
        Patient_First_Name,
        Patient_Last_Name,
        Patient_Gender,
        Patient_Age,
        Patient_Date_Of_Birth,
        Patient_Address,
        Patient_Blood_Group
    FROM dbo.Patient
    ORDER BY Patient_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;