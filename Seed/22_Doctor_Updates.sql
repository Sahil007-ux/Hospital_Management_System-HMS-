USE Hospital_Management_System;
GO

-- Add 7 new employees for doctors

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
(11, N'Nasir Ahmad', 'Male', '0701000011',
 'nasir.ahmad@gmail.com', 45000, N'Kabul', N'Kabul'),
(12, N'Soraya Hamidi', 'Female', '0701000012',
 'soraya.hamidi@gmail.com', 45000, N'Kabul', N'Kabul'),
(13, N'Wahidullah Azimi', 'Male', '0701000013',
 'wahid.azimi@gmail.com', 50000, N'Kabul', N'Kabul'),
(14, N'Mina Sediqi', 'Female', '0701000014',
 'mina.sediqi@gmail.com', 42000, N'Herat', N'Herat'),
(15, N'Faridullah Noori', 'Male', '0701000015',
 'farid.noori@gmail.com', 55000, N'Kabul', N'Kabul'),
(16, N'Shafiqa Rahman', 'Female', '0701000016',
 'shafiqa.rahman@gmail.com', 40000, N'Kabul', N'Kabul'),
(17, N'Haroon Safi', 'Male', '0701000017',
 'haroon.safi@gmail.com', 42000, N'Balkh', N'Mazar-e-Sharif');
GO

-- Add 7 doctors

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
(4, 11, 1, 'Emergency Medicine', 'MD', 'Emergency'),
(5, 12, 2, 'Internal Medicine', 'MD', 'Internal Medicine'),
(6, 13, 3, 'General Surgery', 'MS', 'Surgery'),
(7, 14, 4, 'Pediatrics', 'MD', 'Pediatrics'),
(8, 15, 5, 'Critical Care Medicine', 'MD', 'Intensive Care Unit'),
(9, 16, 6, 'Radiology', 'MD', 'Radiology'),
(10, 17, 7, 'Clinical Pathology', 'MD', 'Laboratory');
GO