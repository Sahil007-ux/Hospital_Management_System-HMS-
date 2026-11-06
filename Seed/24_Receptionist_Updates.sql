USE Hospital_Management_System;
GO

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
(25, N'Ahmad Zia', 'Male', '0701000025',
 'ahmad.zia@gmail.com', 22000, N'Kabul', N'Kabul'),

(26, N'Maryam Sultani', 'Female', '0701000026',
 'maryam.sultani@gmail.com', 23000, N'Herat', N'Herat'),

(27, N'Bilal Naseri', 'Male', '0701000027',
 'bilal.naseri@gmail.com', 21000, N'Kabul', N'Kabul'),

(28, N'Shazia Ahmadi', 'Female', '0701000028',
 'shazia.ahmadi@gmail.com', 23000, N'Kabul', N'Kabul'),

(29, N'Wali Rahman', 'Male', '0701000029',
 'wali.rahman@gmail.com', 22000, N'Balkh', N'Mazar-e-Sharif'),

(30, N'Razia Mohammadi', 'Female', '0701000030',
 'razia.mohammadi@gmail.com', 24000, N'Kabul', N'Kabul'),

(31, N'Farhad Azizi', 'Male', '0701000031',
 'farhad.azizi@gmail.com', 22000, N'Herat', N'Herat'),

(32, N'Samira Safi', 'Female', '0701000032',
 'samira.safi@gmail.com', 23000, N'Kabul', N'Kabul'),

(33, N'Jawad Karimi', 'Male', '0701000033',
 'jawad.karimi@gmail.com', 21000, N'Kabul', N'Kabul');
GO



-- =============================================
-- Add 9 new Receptionists
-- =============================================

INSERT INTO dbo.Receptionist
(
    Receptionist_ID,
    Employee_ID,
    Receptionist_Desk_Number,
    Receptionist_Shift
)
VALUES
(2, 25, 'Desk-02', N'Day'),
(3, 26, 'Desk-03', N'Night'),
(4, 27, 'Desk-04', N'Day'),
(5, 28, 'Desk-05', N'Night'),
(6, 29, 'Desk-06', N'Day'),
(7, 30, 'Desk-07', N'Night'),
(8, 31, 'Desk-08', N'Day'),
(9, 32, 'Desk-09', N'Night'),
(10, 33, 'Desk-10', N'Day');
GO