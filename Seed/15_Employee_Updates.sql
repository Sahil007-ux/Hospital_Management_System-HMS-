
USE Hospital_Management_System;
GO

-- =============================================
-- Employee Updates
-- Add 3 new employees (ID 8, 9, 10)
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
(8, N'Bilal Ahmad', 'Male', '0701000008',
 'bilal.ahmadi@yahoo.com', 30000, N'Kabul', N'Kabul'),

(9, N'Laila Mohammadi', 'Female', '0701000009',
 'laila@gmail.com', 32000, N'Herat', N'Herat'),

(10, N'Samiullah Hakimi', 'Male', '0701000010',
 'samiullah.hakimi@gmail.com', 28000, N'Kabul', N'Kabul');
GO

-- =============================================
-- Update phone numbers and email addresses
-- for existing employees (ID 1 to 7)
-- =============================================

UPDATE dbo.Employee
SET
    Employee_Phone = CASE Employee_ID
        WHEN 1 THEN '0701000001'
        WHEN 2 THEN '0701000002'
        WHEN 3 THEN '0701000003'
        WHEN 4 THEN '0701000004'
        WHEN 5 THEN '0701000005'
        WHEN 6 THEN '0701000006'
        WHEN 7 THEN '0701000007'
    END,

    Employee_Email = CASE Employee_ID
        WHEN 1 THEN 'ahmad.farid@gmail.com'
        WHEN 2 THEN 'maryam.rahimi@gmail.com'
        WHEN 3 THEN 'khalid.azizi@yahoo.com'
        WHEN 4 THEN 'fatima.noori@yahoo.com'
        WHEN 5 THEN 'rahman.safi@gmail.com'
        WHEN 6 THEN 'zahra.karimi@hotmail.com'
        WHEN 7 THEN 'omid.sharifi@gmail.com'
    END
WHERE Employee_ID BETWEEN 1 AND 7;
GO
