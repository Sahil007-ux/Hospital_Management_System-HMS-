USE Hospital_Management_System;
GO

INSERT INTO dbo.Prescription_Item
(
    Prescription_ID,
    Medicine_ID,
    Prescription_Item_Dose,
    Prescription_Item_Route,
    Prescription_Item_Frequency,
    Prescription_Item_Duration_Days,
    Prescription_Item_Quantity,
    Prescription_Item_Quantity_Unit,
    Prescription_Item_Instructions
)
VALUES
(2, 1, N'500 mg', N'Oral', N'Twice daily', 3, 6, N'Tablets',
 N'Paracetamol tablet for abdominal pain management.'),

(3, 3, N'500 mg', N'Oral', N'Three times daily', 5, 15, N'Capsules',
 N'Amoxicillin capsule recorded in the patient prescription.'),

(4, 2, N'120 mg/5 mL', N'Oral', N'Twice daily', 3, 1, N'Bottle',
 N'Paracetamol oral suspension for pediatric care.'),

(5, 4, N'20 mg', N'Oral', N'Once daily', 7, 7, N'Capsules',
 N'Omeprazole capsule recorded in the patient prescription.'),

(6, 5, N'10 mg', N'Oral', N'Once daily', 3, 3, N'Tablets',
 N'Cetirizine tablet recorded in the patient prescription.'),

(7, 6, N'400 mg', N'Oral', N'Twice daily', 3, 6, N'Tablets',
 N'Ibuprofen tablet recorded in the patient prescription.'),

(8, 7, N'250 mg', N'Oral', N'Once daily', 3, 3, N'Tablets',
 N'Azithromycin tablet recorded in the patient prescription.'),

(9, 8, N'500 mg', N'Oral', N'Twice daily', 7, 14, N'Tablets',
 N'Metformin tablet recorded in the patient prescription.'),

(10, 9, N'1 sachet', N'Oral', N'After each loose stool', 2, 4, N'Sachets',
 N'Oral rehydration salts recorded in the patient prescription.');
GO

SELECT *
FROM dbo.Prescription_Item
ORDER BY Prescription_Item_ID;