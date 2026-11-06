USE Hospital_Management_System;
GO

INSERT INTO dbo.Prescription
(
    Medical_Record_ID,
    Prescription_Date,
    Prescription_Notes
)
VALUES
(1, '2026-10-15 11:30:00', N'Demonstration prescription for abdominal pain case'),
(3, '2026-10-15 12:00:00', N'Demonstration prescription for surgical evaluation'),
(4, '2026-11-04 12:00:00', N'Demonstration prescription for pediatric fever case'),
(5, '2026-11-04 13:00:00', N'Demonstration prescription for internal medicine case'),
(6, '2026-11-04 14:00:00', N'Demonstration prescription for pediatric infection case'),
(7, '2026-11-05 10:00:00', N'Demonstration prescription for general medical case'),
(8, '2026-11-05 11:00:00', N'Demonstration prescription for pediatric condition'),
(9, '2026-11-05 12:00:00', N'Demonstration prescription for internal medicine case'),
(10, '2026-11-05 13:00:00', N'Demonstration prescription for pediatric observation');
GO

SELECT *
FROM dbo.Prescription
ORDER BY Prescription_ID;