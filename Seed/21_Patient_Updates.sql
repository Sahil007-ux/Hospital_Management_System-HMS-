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
( 'Omid', 'Ahmadi', 'Male', 32, '1994-02-14', '0701000027', 'Kabul', 'A+'),
( 'Farzana', 'Safi', 'Female', 29, '1997-06-20', '0701000028', 'Herat', 'B+'),
('Nasir', 'Rahimi', 'Male', 45, '1981-01-09', '0701000029', 'Kabul', 'O+'),
( 'Shabnam', 'Karimi', 'Female', 24, '2002-08-11', '0701000030', 'Mazar-e-Sharif', 'AB+');
GO