-- SEED DATA: 10+ rows per table, Afghan names. Run AFTER _Master_Query.sql.
-- FRESH EMPTY DATABASE ONLY (identity columns must start at 1). Select the database in SSMS first.
-- Employee has 30 rows because Doctor, Nurse and Receptionist each need 10 unique employees.
-- Single batch inside one transaction: any error rolls everything back.
SET NOCOUNT ON;
SET XACT_ABORT ON;

IF EXISTS (SELECT 1 FROM dbo.Hospital)
    THROW 50100, 'Seed aborted: database already contains data. Use a fresh empty database.', 1;

BEGIN TRANSACTION;

-- 1. Hospital (identity 1-10)
INSERT INTO dbo.Hospital (Hospital_Name, Hospital_Type, Hospital_Bed_Capacity, Hospital_Contact_Number, Hospital_Email, Hospital_Address, Hospital_License_Number) VALUES
(N'Ariana Central Hospital',            N'General',   300, '+93 20 210 0001', 'info@arianacentral.af',  N'Shahr-e-Naw, Kabul',          'AFG-MOH-KBL-0001'),
(N'Herat Regional Medical Center',      N'Regional',  250, '+93 40 220 0002', 'info@heratmedical.af',   N'Fourth District, Herat',      'AFG-MOH-HRT-0002'),
(N'Balkh Teaching Hospital',            N'Teaching',  400, '+93 50 230 0003', 'info@balkhteaching.af',  N'Mazar-i-Sharif, Balkh',       'AFG-MOH-BLK-0003'),
(N'Kandahar Family Hospital',           N'General',   200, '+93 30 240 0004', 'info@kandaharfamily.af', N'Mirwais Mina, Kandahar',      'AFG-MOH-KDH-0004'),
(N'Nangarhar Specialty Hospital',       N'Specialty', 180, '+93 60 250 0005', 'info@nangarharspec.af',  N'Jalalabad City, Nangarhar',   'AFG-MOH-NGR-0005'),
(N'Kunduz City Hospital',               N'General',   150, '+93 26 260 0006', 'info@kunduzcity.af',     N'Central Bazaar, Kunduz',      'AFG-MOH-KDZ-0006'),
(N'Ghazni Community Hospital',          N'Community', 120, '+93 70 270 0007', 'info@ghaznicommunity.af',N'Ghazni City, Ghazni',         'AFG-MOH-GHZ-0007'),
(N'Bamyan Valley Hospital',             N'Community',  80, '+93 79 280 0008', 'info@bamyanvalley.af',   N'Bamyan City, Bamyan',         'AFG-MOH-BMY-0008'),
(N'Khost Maternity and Children Hospital', N'Specialty',100,'+93 77 290 0009','info@khostmaternity.af', N'Khost City, Khost',          'AFG-MOH-KHT-0009'),
(N'Faryab Provincial Hospital',         N'Provincial',160, '+93 75 300 0010', 'info@faryabprov.af',     N'Maimana, Faryab',             'AFG-MOH-FRB-0010');

-- 2. Department (one per hospital)
INSERT INTO dbo.Department (Department_ID, Department_Name, Department_Location, Hospital_ID) VALUES
(1,  'Cardiology',               'Block A, Floor 1', 1),
(2,  'Neurology',                'Block A, Floor 2', 2),
(3,  'Orthopedics',              'Block B, Floor 1', 3),
(4,  'Pediatrics',               'Block B, Floor 2', 4),
(5,  'Gynecology and Obstetrics','Block C, Floor 1', 5),
(6,  'General Surgery',          'Block C, Floor 2', 6),
(7,  'Internal Medicine',        'Block D, Floor 1', 7),
(8,  'Emergency',                'Ground Floor',     8),
(9,  'Radiology',                'Block D, Floor 2', 9),
(10, 'Ophthalmology',            'Block E, Floor 1', 10);

-- 3. Employee (1-10 doctors, 11-20 nurses, 21-30 receptionists)
INSERT INTO dbo.Employee (Employee_ID, Employee_Name, Employee_Gender, Employee_Phone, Employee_Email, Employee_Salary, Employee_State, Employee_City) VALUES
(1,  N'Ahmad Zia Rahimi',        'Male',   '+93 700 100 001', 'ahmadzia.rahimi@hms.af',     150000.00, N'Kabul',     N'Kabul'),
(2,  N'Fatima Noori',            'Female', '+93 700 100 002', 'fatima.noori@hms.af',        140000.00, N'Herat',     N'Herat'),
(3,  N'Mohammad Naseer Sadiqi',  'Male',   '+93 700 100 003', 'naseer.sadiqi@hms.af',       135000.00, N'Balkh',     N'Mazar-i-Sharif'),
(4,  N'Zarghona Karimi',         'Female', '+93 700 100 004', 'zarghona.karimi@hms.af',     130000.00, N'Kandahar',  N'Kandahar'),
(5,  N'Abdul Wahid Stanikzai',   'Male',   '+93 700 100 005', 'wahid.stanikzai@hms.af',     145000.00, N'Nangarhar', N'Jalalabad'),
(6,  N'Mariam Ahmadzai',         'Female', '+93 700 100 006', 'mariam.ahmadzai@hms.af',     138000.00, N'Kunduz',    N'Kunduz'),
(7,  N'Hamid Safi',              'Male',   '+93 700 100 007', 'hamid.safi@hms.af',          125000.00, N'Ghazni',    N'Ghazni'),
(8,  N'Shukria Mohmand',         'Female', '+93 700 100 008', 'shukria.mohmand@hms.af',     128000.00, N'Bamyan',    N'Bamyan'),
(9,  N'Rahmatullah Popal',       'Male',   '+93 700 100 009', 'rahmatullah.popal@hms.af',   132000.00, N'Khost',     N'Khost'),
(10, N'Laila Sultani',           'Female', '+93 700 100 010', 'laila.sultani@hms.af',       136000.00, N'Faryab',    N'Maimana'),
(11, N'Parwana Yousufi',         'Female', '+93 700 200 011', 'parwana.yousufi@hms.af',      38000.00, N'Kabul',     N'Kabul'),
(12, N'Nilofar Hashimi',         'Female', '+93 700 200 012', 'nilofar.hashimi@hms.af',      36000.00, N'Herat',     N'Herat'),
(13, N'Sakina Rezaie',           'Female', '+93 700 200 013', 'sakina.rezaie@hms.af',        35000.00, N'Balkh',     N'Mazar-i-Sharif'),
(14, N'Gul Bibi Wardak',         'Female', '+93 700 200 014', 'gulbibi.wardak@hms.af',       34000.00, N'Kandahar',  N'Kandahar'),
(15, N'Masooma Taheri',          'Female', '+93 700 200 015', 'masooma.taheri@hms.af',       37000.00, N'Nangarhar', N'Jalalabad'),
(16, N'Khadija Amiri',           'Female', '+93 700 200 016', 'khadija.amiri@hms.af',        33000.00, N'Kunduz',    N'Kunduz'),
(17, N'Basir Ahmad Faizi',       'Male',   '+93 700 200 017', 'basir.faizi@hms.af',          32000.00, N'Ghazni',    N'Ghazni'),
(18, N'Najiba Habibi',           'Female', '+93 700 200 018', 'najiba.habibi@hms.af',        35500.00, N'Bamyan',    N'Bamyan'),
(19, N'Sayed Jawad Mousavi',     'Male',   '+93 700 200 019', 'jawad.mousavi@hms.af',        31000.00, N'Khost',     N'Khost'),
(20, N'Roqia Sharifi',           'Female', '+93 700 200 020', 'roqia.sharifi@hms.af',        34500.00, N'Faryab',    N'Maimana'),
(21, N'Farhad Nasiri',           'Male',   '+93 700 300 021', 'farhad.nasiri@hms.af',        22000.00, N'Kabul',     N'Kabul'),
(22, N'Sima Qaderi',             'Female', '+93 700 300 022', 'sima.qaderi@hms.af',          21000.00, N'Herat',     N'Herat'),
(23, N'Qais Azizi',              'Male',   '+93 700 300 023', 'qais.azizi@hms.af',           20500.00, N'Balkh',     N'Mazar-i-Sharif'),
(24, N'Mahbooba Hotak',          'Female', '+93 700 300 024', 'mahbooba.hotak@hms.af',       21500.00, N'Kandahar',  N'Kandahar'),
(25, N'Javid Ahmadi',            'Male',   '+93 700 300 025', 'javid.ahmadi@hms.af',         20000.00, N'Nangarhar', N'Jalalabad'),
(26, N'Tahmina Kohistani',       'Female', '+93 700 300 026', 'tahmina.kohistani@hms.af',    19500.00, N'Parwan',    N'Charikar'),
(27, N'Sohrab Alokozai',         'Male',   '+93 700 300 027', 'sohrab.alokozai@hms.af',      19000.00, N'Ghazni',    N'Ghazni'),
(28, N'Zainab Durrani',          'Female', '+93 700 300 028', 'zainab.durrani@hms.af',       22500.00, N'Bamyan',    N'Bamyan'),
(29, N'Nasrullah Mangal',        'Male',   '+93 700 300 029', 'nasrullah.mangal@hms.af',     18500.00, N'Khost',     N'Khost'),
(30, N'Wahida Tokhi',            'Female', '+93 700 300 030', 'wahida.tokhi@hms.af',         20500.00, N'Badakhshan',N'Faizabad');

-- 4. Doctor (Doctor_Department column was removed; department comes from Department_ID)
INSERT INTO dbo.Doctor (Doctor_ID, Employee_ID, Department_ID, Doctor_Specialization, Doctor_Qualification) VALUES
(1,  1,  1,  'Cardiologist',         'MBBS, MD Cardiology'),
(2,  2,  2,  'Neurologist',          'MBBS, MD Neurology'),
(3,  3,  3,  'Orthopedic Surgeon',   'MBBS, MS Orthopedics'),
(4,  4,  4,  'Pediatrician',         'MBBS, DCH'),
(5,  5,  5,  'Gynecologist',         'MBBS, MS Obstetrics and Gynecology'),
(6,  6,  6,  'General Surgeon',      'MBBS, MS General Surgery'),
(7,  7,  7,  'Internist',            'MBBS, MD Internal Medicine'),
(8,  8,  8,  'Emergency Physician',  'MBBS, Diploma in Emergency Medicine'),
(9,  9,  9,  'Radiologist',          'MBBS, MD Radiology'),
(10, 10, 10, 'Ophthalmologist',      'MBBS, MS Ophthalmology');

-- 5. Nurse
INSERT INTO dbo.Nurse (Nurse_ID, Employee_ID, Nurse_Qualification, Nurse_Shift, Department_ID) VALUES
(1,  11, N'BSc Nursing',          N'Morning', 1),
(2,  12, N'BSc Nursing',          N'Evening', 2),
(3,  13, N'Diploma in Nursing',   N'Night',   3),
(4,  14, N'Diploma in Nursing',   N'Morning', 4),
(5,  15, N'BSc Nursing',          N'Evening', 5),
(6,  16, N'Diploma in Nursing',   N'Night',   6),
(7,  17, N'Diploma in Nursing',   N'Morning', 7),
(8,  18, N'BSc Nursing',          N'Evening', 8),
(9,  19, N'Diploma in Nursing',   N'Night',   9),
(10, 20, N'BSc Nursing',          N'Morning', 10);

-- 6. Receptionist
INSERT INTO dbo.Receptionist (Receptionist_ID, Employee_ID, Receptionist_Desk_Number, Receptionist_Shift) VALUES
(1,  21, 'D-01', N'Morning'),
(2,  22, 'D-02', N'Evening'),
(3,  23, 'D-03', N'Morning'),
(4,  24, 'D-04', N'Evening'),
(5,  25, 'D-05', N'Night'),
(6,  26, 'D-06', N'Morning'),
(7,  27, 'D-07', N'Evening'),
(8,  28, 'D-08', N'Morning'),
(9,  29, 'D-09', N'Night'),
(10, 30, 'D-10', N'Evening');

-- 7. Patient (identity 1-10; Patient_Age column was removed, derive from date of birth)
INSERT INTO dbo.Patient (Patient_First_Name, Patient_Last_Name, Patient_Gender, Patient_Date_Of_Birth, Patient_Phone, Patient_Address, Patient_Blood_Group) VALUES
('Abdul Rahman',  'Yusufzai', 'Male',   '1978-03-14', '+93 788 400 001', 'Karte Seh, Kabul',            'O+'),
('Bibi Aisha',    'Sultani',  'Female', '1990-07-22', '+93 788 400 002', 'Shahr-e-Naw, Kabul',          'A+'),
('Mohammad Karim','Ghafari',  'Male',   '1965-11-02', '+93 788 400 003', 'Fourth District, Herat',      'B+'),
('Shabnam',       'Rahimi',   'Female', '2001-05-19', '+93 788 400 004', 'Mazar-i-Sharif, Balkh',       'AB+'),
('Nasir Ahmad',   'Safi',     'Male',   '1985-09-30', '+93 788 400 005', 'Mirwais Mina, Kandahar',      'O-'),
('Zahra',         'Hussaini', 'Female', '1972-01-08', '+93 788 400 006', 'Dasht-e-Barchi, Kabul',       'A-'),
('Ismail',        'Khogyani', 'Male',   '2015-12-25', '+93 788 400 007', 'Jalalabad City, Nangarhar',   'B-'),
('Rabia',         'Wardak',   'Female', '1998-04-11', '+93 788 400 008', 'Kunduz City, Kunduz',         'O+'),
('Sayed Ali',     'Mousavi',  'Male',   '1958-06-17', '+93 788 400 009', 'Bamyan City, Bamyan',         'AB-'),
('Mina',          'Faizi',    'Female', '2010-08-03', '+93 788 400 010', 'Maimana, Faryab',             'A+');

-- 8. Appointment
INSERT INTO dbo.Appointment (Appointment_ID, Patient_ID, Doctor_ID, Appointment_Date, Appointment_Time, Appointment_Reason, Appointment_Status) VALUES
(1,  1,  1,  '2026-01-03', '09:00', 'Chest pain and shortness of breath',  'Completed'),
(2,  2,  2,  '2026-01-10', '10:30', 'Recurring migraine headaches',        'Completed'),
(3,  3,  3,  '2026-01-31', '11:15', 'Knee pain after a fall',              'Completed'),
(4,  4,  4,  '2026-02-08', '08:45', 'Fever and cough',                     'Completed'),
(5,  5,  5,  '2026-02-27', '13:00', 'Routine antenatal check-up',          'Completed'),
(6,  6,  6,  '2026-03-18', '14:30', 'Abdominal pain, surgical review',     'Completed'),
(7,  7,  7,  '2026-11-20', '09:30', 'Follow-up for diabetes management',   'Scheduled'),
(8,  8,  8,  '2026-11-21', '16:00', 'Minor injury follow-up',              'Scheduled'),
(9,  9,  9,  '2026-11-22', '10:00', 'Chest X-ray review',                  'Scheduled'),
(10, 10, 10, '2026-11-18', '12:00', 'Blurred vision check',                'Cancelled');

-- 9. Rooms
INSERT INTO dbo.Rooms (Room_ID, Room_Number, Room_Floor_Number, Room_Daily_Charge, Room_Type, Room_Availability_Status, Room_Capacity, Department_ID) VALUES
(1,  '101', 1, 1500.00, N'General Ward', N'Available', 1, 1),
(2,  '102', 1, 1500.00, N'General Ward', N'Available', 1, 2),
(3,  '201', 2, 3500.00, N'Private',      N'Available', 1, 3),
(4,  '202', 2, 1500.00, N'General Ward', N'Available', 1, 4),
(5,  '203', 2, 1500.00, N'General Ward', N'Available', 1, 5),
(6,  '301', 3, 3500.00, N'Private',      N'Occupied',  1, 6),
(7,  '302', 3, 1500.00, N'General Ward', N'Occupied',  1, 7),
(8,  '303', 3, 1500.00, N'General Ward', N'Occupied',  1, 8),
(9,  '401', 4, 5000.00, N'ICU',          N'Occupied',  1, 9),
(10, '402', 4, 5000.00, N'ICU',          N'Occupied',  1, 10);

-- 10. Bed (identity 1-10, one per room; Bed_Is_Active defaults to 1)
INSERT INTO dbo.Bed (Room_ID, Bed_Number) VALUES
(1, N'B1'), (2, N'B1'), (3, N'B1'), (4, N'B1'), (5, N'B1'),
(6, N'B1'), (7, N'B1'), (8, N'B1'), (9, N'B1'), (10, N'B1');

-- 11. Admission (1-5 discharged, 6-10 still admitted)
INSERT INTO dbo.Admission (Admission_ID, Patient_ID, Admission_Date, Admission_Discharge_Date, Admission_Reason) VALUES
(1,  1,  '2026-01-05T08:30:00', '2026-01-10T12:00:00', N'Acute coronary syndrome'),
(2,  2,  '2026-01-12T09:00:00', '2026-01-16T11:00:00', N'Severe migraine with neurological observation'),
(3,  3,  '2026-02-02T14:00:00', '2026-02-05T10:00:00', N'Knee fracture requiring surgery'),
(4,  4,  '2026-02-10T07:45:00', '2026-02-14T13:00:00', N'Pneumonia'),
(5,  5,  '2026-03-01T10:15:00', '2026-03-02T09:00:00', N'Normal delivery and postnatal care'),
(6,  6,  '2026-03-20T16:00:00', NULL,                  N'Acute appendicitis'),
(7,  7,  '2026-04-02T11:30:00', NULL,                  N'Uncontrolled diabetes'),
(8,  8,  '2026-04-08T06:20:00', NULL,                  N'Road traffic injury'),
(9,  9,  '2026-04-15T13:10:00', NULL,                  N'Respiratory distress'),
(10, 10, '2026-04-22T18:00:00', NULL,                  N'Eye trauma');

-- 12. Bed_Assignment (identity 1-10; same window as the admission, open while still admitted)
INSERT INTO dbo.Bed_Assignment (Admission_ID, Bed_ID, Bed_Assignment_Start, Bed_Assignment_End) VALUES
(1,  1,  '2026-01-05T08:30:00', '2026-01-10T12:00:00'),
(2,  2,  '2026-01-12T09:00:00', '2026-01-16T11:00:00'),
(3,  3,  '2026-02-02T14:00:00', '2026-02-05T10:00:00'),
(4,  4,  '2026-02-10T07:45:00', '2026-02-14T13:00:00'),
(5,  5,  '2026-03-01T10:15:00', '2026-03-02T09:00:00'),
(6,  6,  '2026-03-20T16:00:00', NULL),
(7,  7,  '2026-04-02T11:30:00', NULL),
(8,  8,  '2026-04-08T06:20:00', NULL),
(9,  9,  '2026-04-15T13:10:00', NULL),
(10, 10, '2026-04-22T18:00:00', NULL);

-- 13. Nurse_Assignment (identity 1-10)
INSERT INTO dbo.Nurse_Assignment (Nurse_ID, Admission_ID, Nurse_Assignment_Start, Nurse_Assignment_End) VALUES
(1,  1,  '2026-01-05T08:30:00', '2026-01-10T12:00:00'),
(2,  2,  '2026-01-12T09:00:00', '2026-01-16T11:00:00'),
(3,  3,  '2026-02-02T14:00:00', '2026-02-05T10:00:00'),
(4,  4,  '2026-02-10T07:45:00', '2026-02-14T13:00:00'),
(5,  5,  '2026-03-01T10:15:00', '2026-03-02T09:00:00'),
(6,  6,  '2026-03-20T16:00:00', NULL),
(7,  7,  '2026-04-02T11:30:00', NULL),
(8,  8,  '2026-04-08T06:20:00', NULL),
(9,  9,  '2026-04-15T13:10:00', NULL),
(10, 10, '2026-04-22T18:00:00', NULL);

-- 14. Medical_Record
INSERT INTO dbo.Medical_Record (Medical_Record_ID, Patient_ID, Doctor_ID, Medical_Record_Date, Medical_Record_Diagnoses, Medical_Record_Treatment, Medical_Record_Notes) VALUES
(1,  1,  1,  '2026-01-05', N'Unstable angina',               N'Aspirin, beta blocker, bed rest',            N'ECG monitored every 4 hours'),
(2,  2,  2,  '2026-01-12', N'Chronic migraine',              N'Analgesics and rest in a dark room',         N'Advised to avoid known triggers'),
(3,  3,  3,  '2026-02-02', N'Fractured patella',             N'Surgical fixation and physiotherapy',        N'Non-weight bearing for 6 weeks'),
(4,  4,  4,  '2026-02-10', N'Community-acquired pneumonia',  N'Antibiotics and oxygen support',             N'Chest X-ray repeated before discharge'),
(5,  5,  5,  '2026-03-01', N'Full-term pregnancy, delivered',N'Normal vaginal delivery',                    N'Mother and baby stable'),
(6,  6,  6,  '2026-03-20', N'Acute appendicitis',            N'Appendectomy',                               N'Post-operative recovery ongoing'),
(7,  7,  7,  '2026-04-02', N'Type 1 diabetes, poor control', N'Insulin adjustment and dietary plan',        N'Blood glucose checked four times daily'),
(8,  8,  8,  '2026-04-08', N'Multiple soft-tissue injuries', N'Wound care and pain relief',                 N'Tetanus booster given'),
(9,  9,  9,  '2026-04-15', N'Acute bronchitis with hypoxia', N'Oxygen, nebulization, antibiotics',          N'Under ICU observation'),
(10, 10, 10, '2026-04-22', N'Corneal abrasion',              N'Antibiotic eye drops and eye patch',         N'Review in 48 hours');

-- 15. Medicine (identity 1-10; Medicine_Is_Active defaults to 1)
INSERT INTO dbo.Medicine (Medicine_Code, Medicine_Name, Medicine_Strength, Medicine_Form) VALUES
('MED-PARA500', N'Paracetamol',    N'500 mg',   N'Tablet'),
('MED-AMOX500', N'Amoxicillin',    N'500 mg',   N'Capsule'),
('MED-IBUP400', N'Ibuprofen',      N'400 mg',   N'Tablet'),
('MED-OMEP020', N'Omeprazole',     N'20 mg',    N'Capsule'),
('MED-METF500', N'Metformin',      N'500 mg',   N'Tablet'),
('MED-AMLO005', N'Amlodipine',     N'5 mg',     N'Tablet'),
('MED-SALB100', N'Salbutamol',     N'100 mcg',  N'Inhaler'),
('MED-CETI010', N'Cetirizine',     N'10 mg',    N'Tablet'),
('MED-CIPR500', N'Ciprofloxacin',  N'500 mg',   N'Tablet'),
('MED-ORS001',  N'Oral Rehydration Salts', N'20.5 g', N'Sachet');

-- 16. Prescription (identity 1-10, one per medical record)
INSERT INTO dbo.Prescription (Medical_Record_ID, Prescription_Date, Prescription_Notes) VALUES
(1,  '2026-01-05T09:30:00', N'Cardiac medication, monitor blood pressure'),
(2,  '2026-01-12T10:00:00', N'Take at onset of headache'),
(3,  '2026-02-02T16:00:00', N'Post-operative pain control'),
(4,  '2026-02-10T09:00:00', N'Complete the full antibiotic course'),
(5,  '2026-03-01T12:00:00', N'Postnatal medication'),
(6,  '2026-03-20T18:00:00', N'Post-operative care'),
(7,  '2026-04-02T13:00:00', N'Take with meals'),
(8,  '2026-04-08T08:00:00', N'Pain relief as needed'),
(9,  '2026-04-15T14:30:00', N'Use inhaler before meals'),
(10, '2026-04-22T19:30:00', N'Antibiotic for infection prevention');

-- 17. Prescription_Item (identity 1-10, one per prescription)
INSERT INTO dbo.Prescription_Item (Prescription_ID, Medicine_ID, Prescription_Item_Dose, Prescription_Item_Route, Prescription_Item_Frequency, Prescription_Item_Duration_Days, Prescription_Item_Quantity, Prescription_Item_Quantity_Unit, Prescription_Item_Instructions) VALUES
(1,  6,  N'5 mg',     N'Oral',       N'Once daily',        30, 30.00, N'tablets',  N'Take in the morning'),
(2,  3,  N'400 mg',   N'Oral',       N'Every 8 hours',      5, 15.00, N'tablets',  N'Take after food'),
(3,  1,  N'500 mg',   N'Oral',       N'Every 6 hours',      7, 28.00, N'tablets',  N'Do not exceed 4 doses per day'),
(4,  2,  N'500 mg',   N'Oral',       N'Every 8 hours',      7, 21.00, N'capsules', N'Finish the full course'),
(5,  1,  N'500 mg',   N'Oral',       N'Every 8 hours',      3,  9.00, N'tablets',  N'Take with water'),
(6,  9,  N'500 mg',   N'Oral',       N'Twice daily',        7, 14.00, N'tablets',  N'Take after meals'),
(7,  5,  N'500 mg',   N'Oral',       N'Twice daily',       30, 60.00, N'tablets',  N'Take with meals'),
(8,  3,  N'400 mg',   N'Oral',       N'Every 8 hours',      3,  9.00, N'tablets',  N'Take after food'),
(9,  7,  N'2 puffs',  N'Inhalation', N'Three times daily', 10,  1.00, N'inhaler',  N'Rinse mouth after use'),
(10, 2,  N'500 mg',   N'Oral',       N'Every 8 hours',      5, 15.00, N'capsules', N'Take after food');

-- 18. Service (identity 1-10; Service_Is_Active defaults to 1)
INSERT INTO dbo.Service (Service_Code, Service_Name, Service_Default_Price) VALUES
('CONS-GEN',  N'General Consultation',     500.00),
('CONS-SPEC', N'Specialist Consultation', 1000.00),
('LAB-CBC',   N'Complete Blood Count',     300.00),
('XRAY-CHEST',N'Chest X-Ray',              800.00),
('US-ABD',    N'Abdominal Ultrasound',    1200.00),
('ECG',       N'Electrocardiogram',        600.00),
('SURG-APP',  N'Appendectomy',           25000.00),
('ROOM-GEN',  N'General Ward Daily Stay', 1500.00),
('ROOM-PVT',  N'Private Room Daily Stay', 3500.00),
('PHYSIO',    N'Physiotherapy Session',    700.00);

-- 19. Bills (1-6 linked to admissions, 7-10 outpatient)
INSERT INTO dbo.Bills (Bill_ID, Patient_ID, Admission_ID, Bill_Date) VALUES
(1,  1,  1,    '2026-01-10'),
(2,  2,  2,    '2026-01-16'),
(3,  3,  3,    '2026-02-05'),
(4,  4,  4,    '2026-02-14'),
(5,  5,  5,    '2026-03-02'),
(6,  6,  6,    '2026-03-25'),
(7,  7,  NULL, '2026-04-03'),
(8,  8,  NULL, '2026-04-09'),
(9,  9,  NULL, '2026-04-16'),
(10, 10, NULL, '2026-04-23');

-- 20. Bill_Item (identity 1-10; Line_Total is computed)
INSERT INTO dbo.Bill_Item (Bill_ID, Service_ID, Bill_Item_Description, Bill_Item_Service_Date, Bill_Item_Quantity, Bill_Item_Unit_Price) VALUES
(1,  8,  N'General ward stay, 5 days',        '2026-01-10T12:00:00', 5.00,  1500.00),
(2,  7,  N'Appendectomy procedure',           '2026-01-14T10:00:00', 1.00, 25000.00),
(3,  9,  N'Private room stay, 3 days',        '2026-02-05T10:00:00', 3.00,  3500.00),
(4,  8,  N'General ward stay, 4 days',        '2026-02-14T13:00:00', 4.00,  1500.00),
(5,  5,  N'Abdominal ultrasound',             '2026-03-01T11:00:00', 1.00,  1200.00),
(6,  9,  N'Private room stay, 2 days',        '2026-03-22T16:00:00', 2.00,  3500.00),
(7,  1,  N'General consultation',             '2026-04-03T09:00:00', 1.00,   500.00),
(8,  2,  N'Specialist consultation',          '2026-04-09T10:00:00', 1.00,  1000.00),
(9,  3,  N'Complete blood count, two tests',  '2026-04-16T11:00:00', 2.00,   300.00),
(10, 4,  N'Chest X-ray',                      '2026-04-23T12:00:00', 1.00,   800.00);

-- 21. Payment (identity 1-10; none exceeds its bill total)
INSERT INTO dbo.Payment (Bill_ID, Payment_Date, Payment_Amount, Payment_Method, Payment_Reference_Number, Payment_Notes) VALUES
(1,  '2026-01-10T12:30:00',  7500.00, 'Cash',         NULL,          N'Paid in full at discharge'),
(2,  '2026-01-16T11:30:00', 15000.00, 'Card',         'CARD-100201', N'Partial payment, balance pending'),
(3,  '2026-02-05T10:30:00',  5000.00, 'BankTransfer', 'BT-300302',   N'Installment 1'),
(4,  '2026-02-14T13:30:00',  6000.00, 'MobileMoney',  'MM-400403',   N'Paid in full'),
(5,  '2026-03-02T09:30:00',   600.00, 'Cash',         NULL,          N'Partial payment'),
(6,  '2026-03-25T15:00:00',  7000.00, 'Card',         'CARD-600605', N'Paid in full'),
(7,  '2026-04-03T09:30:00',   500.00, 'Cash',         NULL,          N'Paid in full'),
(8,  '2026-04-09T10:30:00',   400.00, 'Cash',         NULL,          N'Partial payment'),
(9,  '2026-04-16T11:30:00',   600.00, 'MobileMoney',  'MM-900909',   N'Paid in full'),
(10, '2026-04-23T12:30:00',   300.00, 'Cash',         NULL,          N'Partial payment');

-- 22. Test_Report
INSERT INTO dbo.Test_Report (Test_Report_ID, Patient_ID, Doctor_ID, Test_Report_Date, Test_Report_Type, Test_Report_Result) VALUES
(1,  1,  1,  '2026-01-05', N'ECG',                  N'ST-segment depression in leads V4-V6'),
(2,  2,  2,  '2026-01-12', N'MRI Brain',            N'No structural abnormality detected'),
(3,  3,  3,  '2026-02-02', N'X-Ray Knee',           N'Transverse fracture of the patella'),
(4,  4,  4,  '2026-02-10', N'Chest X-Ray',          N'Right lower lobe consolidation'),
(5,  5,  5,  '2026-02-27', N'Obstetric Ultrasound', N'Single live fetus, normal presentation'),
(6,  6,  6,  '2026-03-20', N'Abdominal Ultrasound', N'Inflamed appendix, no perforation'),
(7,  7,  7,  '2026-04-02', N'HbA1c',                N'HbA1c 10.2 percent'),
(8,  8,  8,  '2026-04-08', N'X-Ray Left Forearm',   N'No fracture identified'),
(9,  9,  9,  '2026-04-15', N'Chest CT Scan',        N'Bronchial wall thickening, no mass'),
(10, 10, 10, '2026-04-22', N'Slit-Lamp Examination',N'Corneal epithelial defect, 2 mm');

COMMIT TRANSACTION;

-- Row-count check
SELECT 'Hospital' AS Table_Name, COUNT(*) AS Row_Count FROM dbo.Hospital UNION ALL
SELECT 'Department', COUNT(*) FROM dbo.Department UNION ALL
SELECT 'Employee', COUNT(*) FROM dbo.Employee UNION ALL
SELECT 'Doctor', COUNT(*) FROM dbo.Doctor UNION ALL
SELECT 'Nurse', COUNT(*) FROM dbo.Nurse UNION ALL
SELECT 'Receptionist', COUNT(*) FROM dbo.Receptionist UNION ALL
SELECT 'Patient', COUNT(*) FROM dbo.Patient UNION ALL
SELECT 'Appointment', COUNT(*) FROM dbo.Appointment UNION ALL
SELECT 'Rooms', COUNT(*) FROM dbo.Rooms UNION ALL
SELECT 'Bed', COUNT(*) FROM dbo.Bed UNION ALL
SELECT 'Admission', COUNT(*) FROM dbo.Admission UNION ALL
SELECT 'Bed_Assignment', COUNT(*) FROM dbo.Bed_Assignment UNION ALL
SELECT 'Nurse_Assignment', COUNT(*) FROM dbo.Nurse_Assignment UNION ALL
SELECT 'Medical_Record', COUNT(*) FROM dbo.Medical_Record UNION ALL
SELECT 'Medicine', COUNT(*) FROM dbo.Medicine UNION ALL
SELECT 'Prescription', COUNT(*) FROM dbo.Prescription UNION ALL
SELECT 'Prescription_Item', COUNT(*) FROM dbo.Prescription_Item UNION ALL
SELECT 'Service', COUNT(*) FROM dbo.Service UNION ALL
SELECT 'Bills', COUNT(*) FROM dbo.Bills UNION ALL
SELECT 'Bill_Item', COUNT(*) FROM dbo.Bill_Item UNION ALL
SELECT 'Payment', COUNT(*) FROM dbo.Payment UNION ALL
SELECT 'Test_Report', COUNT(*) FROM dbo.Test_Report;
