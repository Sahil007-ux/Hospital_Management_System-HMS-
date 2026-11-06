USE Hospital_Management_System;
GO

-- =============================================
-- Add 7 new employees for Nurse department
-- =============================================

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
(18, N'Nasrin Ahmadi', 'Female', '0701000018',
 'nasrin.ahmadi@gmail.com', 28000, N'Kabul', N'Kabul'),

(19, N'Abdul Hadi', 'Male', '0701000019',
 'abdul.hadi@gmail.com', 27000, N'Herat', N'Herat'),

(20, N'Marzia Noori', 'Female', '0701000020',
 'marzia.noori@gmail.com', 29000, N'Kabul', N'Kabul'),

(21, N'Fawad Rahimi', 'Male', '0701000021',
 'fawad.rahimi@gmail.com', 26000, N'Balkh', N'Mazar-e-Sharif'),

(22, N'Sahar Karimi', 'Female', '0701000022',
 'sahar.karimi@gmail.com', 30000, N'Kabul', N'Kabul'),

(23, N'Jamaluddin Safi', 'Male', '0701000023',
 'jamal.safi@gmail.com', 27500, N'Herat', N'Herat'),

(24, N'Roya Sediqi', 'Female', '0701000024',
 'roya.sediqi@gmail.com', 28500, N'Kabul', N'Kabul');
GO

-- =============================================
-- Add 7 new Nurses
-- =============================================

INSERT INTO dbo.Nurse
(
    Nurse_ID,
    Employee_ID,
    Nurse_Qualification,
    Nurse_Shift,
    Department_ID
)
VALUES
(4, 18, N'Bachelor of Nursing', N'Day', 1),
(5, 19, N'Bachelor of Nursing', N'Night', 2),
(6, 20, N'Master of Nursing', N'Day', 4),
(7, 21, N'Bachelor of Nursing', N'Night', 5),
(8, 22, N'Bachelor of Nursing', N'Day', 3),
(9, 23, N'Master of Nursing', N'Night', 1),
(10, 24, N'Bachelor of Nursing', N'Day', 4);
GO