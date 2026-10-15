USE Hospital_Management_System;
GO

SET XACT_ABORT ON;

IF @@TRANCOUNT <> 0
    THROW 50120, 'Close the existing transaction first.', 1;

BEGIN TRY
    BEGIN TRANSACTION;

    IF EXISTS (SELECT 1 FROM dbo.Employee)
       OR EXISTS (SELECT 1 FROM dbo.Doctor)
       OR EXISTS (SELECT 1 FROM dbo.Nurse)
       OR EXISTS (SELECT 1 FROM dbo.Receptionist)
        THROW 50121, 'Staff tables already contain data.', 1;

    IF (
        SELECT COUNT(*)
        FROM dbo.Department AS d
        JOIN dbo.Hospital AS h
            ON h.Hospital_ID = d.Hospital_ID
        WHERE h.Hospital_License_Number = 'DEMO-FMIC-001'
          AND d.Department_ID IN (1, 2, 3)
    ) <> 3
        THROW 50122, 'Complete FMIC seed 01 first.', 1;

    INSERT INTO dbo.Employee
    (
        Employee_ID,
        Employee_Name,
        Employee_Gender,
        Employee_Phone,
        Employee_Email,
        Employee_Salary,
        Employee_State,
        Employee_City
    )
    VALUES
        (1, N'Ahmad Farid Ahmadi', 'Male',
         NULL, 'ahmad.farid@example.com', 65000, N'Kabul', N'Kabul'),

        (2, N'Maryam Rahimi', 'Female',
         NULL, 'maryam.rahimi@example.com', 70000, N'Kabul', N'Kabul'),

        (3, N'Khalid Azizi', 'Male',
         NULL, 'khalid.azizi@example.com', 80000, N'Kabul', N'Kabul'),

        (4, N'Fatima Noori', 'Female',
         NULL, 'fatima.noori@example.com', 25000, N'Kabul', N'Kabul'),

        (5, N'Abdul Rahman Safi', 'Male',
         NULL, 'rahman.safi@example.com', 25000, N'Kabul', N'Kabul'),

        (6, N'Zahra Karimi', 'Female',
         NULL, 'zahra.karimi@example.com', 28000, N'Kabul', N'Kabul'),

        (7, N'Omid Sharifi', 'Male',
         NULL, 'omid.sharifi@example.com', 20000, N'Kabul', N'Kabul');

    INSERT INTO dbo.Doctor
    (
        Doctor_ID,
        Employee_ID,
        Department_ID,
        Doctor_Specialization,
        Doctor_Qualification,
        Doctor_Department
    )
    VALUES
        (1, 1, 1, 'Emergency Medicine', 'MD', 'Emergency'),
        (2, 2, 2, 'Internal Medicine', 'MD', 'Internal Medicine'),
        (3, 3, 3, 'General Surgery', 'MD', 'Surgery');

    INSERT INTO dbo.Nurse
    (
        Nurse_ID,
        Employee_ID,
        Nurse_Qualification,
        Nurse_Shift,
        Department_ID
    )
    VALUES
        (1, 4, N'Bachelor of Nursing', N'Day', 1),
        (2, 5, N'Bachelor of Nursing', N'Day', 2),
        (3, 6, N'Bachelor of Nursing', N'Night', 3);

    INSERT INTO dbo.Receptionist
    (
        Receptionist_ID,
        Employee_ID,
        Receptionist_Desk_Number,
        Receptionist_Shift
    )
    VALUES
        (1, 7, 'R-01', N'Day');

    COMMIT TRANSACTION;

    SELECT Employee_ID, Employee_Name, Employee_Salary
    FROM dbo.Employee
    ORDER BY Employee_ID;

    SELECT * FROM dbo.Doctor ORDER BY Doctor_ID;
    SELECT * FROM dbo.Nurse ORDER BY Nurse_ID;
    SELECT * FROM dbo.Receptionist ORDER BY Receptionist_ID;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;