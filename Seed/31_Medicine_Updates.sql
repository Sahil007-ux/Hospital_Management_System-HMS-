USE Hospital_Management_System;
GO

INSERT INTO dbo.Medicine
(
    Medicine_Code,
    Medicine_Name,
    Medicine_Strength,
    Medicine_Form,
    Medicine_Is_Active
)
VALUES
('IBU-400-TAB', N'Ibuprofen', N'400 mg', N'Tablet', 1),
('AZI-250-TAB', N'Azithromycin', N'250 mg', N'Tablet', 1),
('MET-500-TAB', N'Metformin', N'500 mg', N'Tablet', 1),
('ORS-SACHET', N'Oral Rehydration Salts', N'Standard', N'Sachet', 1),
('SAL-100-ML', N'Normal Saline', N'0.9%', N'Infusion', 1);
GO